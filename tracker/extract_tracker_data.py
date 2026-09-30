#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从 lists/ 目录下的投递清单（markdown）自动抽取目标企业数据，生成 tracker_data.py。

为什么要这么做：追踪表有上百行数据，手写极易出错且无法随清单同步更新。
清单是「唯一真相源」，追踪表由它派生——改完清单重跑本脚本即可。

清单格式约定（见 lists/data-analytics.md 示例）：
  - 一份清单一个 .md 文件；`# 一级标题` = 方向名（也成为工作表名）
  - `### 三级标题` = 梯队名（第一梯队 / 第二梯队 / …，或「需确认」「建议放弃」）
  - 表格首列为「企业」（或「机构」，或「类别 | 企业」两列式）

用法：
    python3 extract_tracker_data.py
输出：
    同目录下的 tracker_data.py（勿手改）
"""
import re
from pathlib import Path

LIST_DIR = Path(__file__).resolve().parent / "lists"

TIER_PATTERNS = [
    (r"第一梯队", "第一梯队"),
    (r"第二梯队", "第二梯队"),
    (r"第三梯队", "第三梯队"),
    (r"需.*确认|需现场问", "需确认"),
    (r"建议降级|建议放弃|建议划掉|不建议", "建议放弃"),
]


def split_cells(line: str):
    return [c.strip() for c in line.strip().strip("|").split("|")]


def plain(s: str) -> str:
    return s.replace("**", "").strip()


def normalize_tier(heading: str) -> str:
    for pattern, label in TIER_PATTERNS:
        if re.search(pattern, heading):
            return label
    return heading[:16] if heading else "—"


def is_table_header(lines, i):
    return (lines[i].strip().startswith("|")
            and i + 1 < len(lines)
            and bool(lines[i + 1].strip())
            and set(lines[i + 1].strip()) <= set("|-: "))


def _salary(d):
    """薪资列兼容多种表头；若另有独立的「核实状态」列则并入。"""
    base = plain(d.get("薪资（核实状态）") or d.get("薪资") or d.get("待遇") or "待核实")
    status = plain(d.get("核实状态", ""))
    if status and "核实" not in base:
        base = f"{base}（{status}）"
    return base


def list_name(lines, fallback: str) -> str:
    for line in lines:
        if line.startswith("# "):
            return line[2:].strip().split("·")[0].strip()
    return fallback


def extract(md: Path):
    lines = md.read_text(encoding="utf-8").split("\n")
    name = list_name(lines, md.stem)
    rows, heading = [], ""
    for i, line in enumerate(lines):
        if line.startswith("### "):
            heading = line[4:].strip()
        if not is_table_header(lines, i):
            continue
        hdr = split_cells(line)
        # 目标企业表：首列是「企业」，或首列是「类别」且次列是「企业」
        if hdr[0] == "企业":
            company_key = "企业"
        elif hdr[0] == "机构":
            company_key = "机构"
        elif len(hdr) > 1 and hdr[0] == "类别" and hdr[1] == "企业":
            company_key = "企业"
        else:
            continue
        # 排除薪资对照类表格（首列同样可能叫「企业」或「机构」）
        if any(k in hdr for k in ("薪资（元/月 × 薪数）", "折合月薪", "年薪区间")):
            continue
        j = i + 2
        while j < len(lines) and lines[j].strip().startswith("|"):
            d = dict(zip(hdr, split_cells(lines[j])))
            company = plain(d.get(company_key, ""))
            if not company or company.startswith("（"):
                j += 1
                continue
            note = plain(d.get("备注") or d.get("关键事实")
                         or d.get("权衡点") or d.get("放弃理由") or "")
            rows.append({
                "tier": normalize_tier(heading),
                "company": company,
                "wlb": plain(d.get("WLB", "待核实")) or "待核实",
                "role": plain(d.get("岗位方向") or d.get("岗位 / 方向")
                              or d.get("岗位") or "—"),
                "location": plain(d.get("地点", "")) or "—",
                "salary": _salary(d),
                "note": note,
            })
            j += 1
    return name, rows


def main():
    md_files = sorted(LIST_DIR.glob("*.md"))
    if not md_files:
        raise SystemExit(f"在 {LIST_DIR} 下没有找到清单 .md 文件")
    data = {}
    for md in md_files:
        name, rows = extract(md)
        if rows:
            data[name] = rows
    if not data:
        raise SystemExit("清单里没有解析到任何目标企业表格，请检查清单格式")
    lines = [
        "# -*- coding: utf-8 -*-",
        '"""',
        "本文件由 extract_tracker_data.py 从 lists/ 清单自动生成。",
        "⚠️ 不要手改——改完清单后重跑 extract_tracker_data.py 即可同步。",
        '"""',
        "",
        "DATA = {",
    ]
    for name, rows in data.items():
        lines.append(f'  # ---------- {name}（{len(rows)} 条） ----------')
        lines.append(f'  "{name}": [')
        for r in rows:
            lines.append(
                f'    {{"tier": "{r["tier"]}", "company": "{r["company"]}", '
                f'"wlb": "{r["wlb"]}", "role": "{r["role"]}", '
                f'"location": "{r["location"]}", "salary": "{r["salary"]}", '
                f'"note": "{r["note"]}"}},')
        lines.append("  ],")
    lines.append("}")
    out = Path(__file__).resolve().parent / "tracker_data.py"
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    total = sum(len(v) for v in data.values())
    print(f"已生成 {out.name}（{len(data)} 份清单，{total} 条目标）")
    for name, rows in data.items():
        tiers = {}
        for r in rows:
            tiers[r["tier"]] = tiers.get(r["tier"], 0) + 1
        print(f"  {name:<14} {len(rows):>3} 条  {tiers}")


if __name__ == "__main__":
    main()
