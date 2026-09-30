#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从彩色版简历自动生成黑白打印版。

- 输入：当前目录下所有简历 .tex 源文件（自动发现，排除 *-bw.tex 与 common/）
- 输出：对应的 *-bw.tex（仅把强调色改为纯黑，其余内容与排版完全一致）
- 每次运行都重新生成，因此彩色版一改，黑白版自动同步。

用法：python3 make_bw.py（在 resume-src/ 目录下运行，或由 build.sh 自动调用）
"""
import os
import sys

BW_OVERRIDE = r"""
% ===== 黑白打印版覆盖（由 make_bw.py 自动生成，请勿手改本文件）=====
\definecolor{Accent}{HTML}{000000}
\definecolor{NameColor}{HTML}{000000}
\definecolor{MutedText}{HTML}{333333}
"""


def discover_pairs(base: str):
    """扫描目录，把每个彩色源文件 X.tex 配对为 X-bw.tex。"""
    pairs = []
    for name in sorted(os.listdir(base)):
        if not name.endswith(".tex") or name.endswith("-bw.tex"):
            continue
        if os.path.isdir(os.path.join(base, name)):
            continue
        pairs.append((name, name[:-4] + "-bw.tex"))
    return pairs


def main() -> int:
    base = os.path.dirname(os.path.abspath(__file__))
    pairs = discover_pairs(base)
    if not pairs:
        print("  ! 当前目录没有找到 .tex 源文件")
        return 1
    for src_name, dst_name in pairs:
        src = os.path.join(base, src_name)
        dst = os.path.join(base, dst_name)
        text = open(src, encoding="utf-8").read()
        marker = "\\begin{document}"
        if marker not in text:
            print(f"  ! {src_name} 中找不到 \\begin{{document}}，跳过")
            continue
        out = text.replace(marker, BW_OVERRIDE + "\n" + marker, 1)
        with open(dst, "w", encoding="utf-8") as f:
            f.write(out)
        print(f"  ✓ {src_name}  ->  {dst_name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
