# AGENTS.md —— AI Agent 操作手册

> **任何 AI Agent（Claude Code / Cursor / Codex / ZCode / Gemini CLI 等）进入本工作区，先读完本文件。**
> 你的任务：帮用户**从 0 写出简历**，并**熟悉自己的简历**（每条能亲口讲清、有出处）；
> 投递清单与追踪表是附带的记录工具。**面试辅助不在本项目范围内**（见 §2 范围边界）。
> 同时维持本工作区的文档与版本纪律。

---

## 0. 冷启动流程（第一次对话必做）

1. 读本文件（你正在做）
2. 读 `memory/MEMORY.md`——**它是项目当前状态的唯一真相源**
   - 若不存在（新用户）：**先执行冷启动访谈**——按 `templates/onboarding.md` 的协议
     分模块问答（基本盘 → 教育 → 经历深挖 → 技能 → 求职红线 → 方向 → 资产 → 时间线），
     边问边填 MEMORY.md 对应节 + `memory/claim-source-map.md`；
     没问到的节标 `⏳ 待访谈`，下轮从第一个 ⏳ 继续
3. 扫一眼 `input/` 里已有哪些素材（见目录职责）
4. 向用户复述：当前阶段、下一步待办（从 MEMORY.md §6 取），确认后开工

**每次新会话都从第 2 步开始。** MEMORY.md 一份文件就足够交接。

---

## 1. 目录职责

| 目录 | 是什么 | Agent 可以写吗 |
|---|---|---|
| `input/` | 用户的**原始素材**：初版简历、成绩单、证书扫描、目标 JD 等 | 可新增文件，**不修改用户放的文件** |
| `memory/` | 项目状态：`MEMORY.md`（快照，唯一真相源）+ `YYYY-MM-DD.md`（当日日志） | ✅ 核心职责 |
| `resume-src/` | 简历 LaTeX 源：`common/` 类文件、`<track>.tex` / `<track>-zh.tex`、构建脚本 | ✅ 按需修改 |
| `tracker/` | 投递清单流水线：`lists/*.md`（清单=真相源）→ 抽取器 → xlsx 生成器 | ✅ 按需修改 |
| `templates/` | 模板与协议：冷启动访谈（onboarding）、熟悉简历（resume-familiarization）、断言出处对照表、CHANGELOG、会话记录（复制/照着执行） | ❌ 不改本体 |
| `docs/` | 方法论与踩坑清单（只读参考） | ❌ |
| 会话日志 | `memory/session-log.md`（流水，只追加） | ✅ 核心职责 |

**边界**：用户个人信息只进 `input/` 和 `memory/`；`templates/` 与 `docs/` 是公共资产，别把个人信息写进去。

---

## 2. 完整工作流（项目生命周期）

```
① 收素材        用户把初版简历/成绩单/证书放进 input/（或直接粘贴给你）
      ↓
② 建档案        新用户：冷启动访谈一次问全（templates/onboarding.md，核心是经历五问）
      ↓          补档：对着 input/ 素材逐条核实 MEMORY.md §2
      ↓          断言出处对照表：从 templates/claim-source-map.template.md 复制到 memory/
③ 定方向        MEMORY.md §4：求职方向清单（1-4 个），每个方向一份简历
      ↓
④ 做简历        复制 resume-src/example-{zh,en}.tex 改写 → bash build.sh 编译 → 逐份查页数
      ↓
⑤ 熟悉简历      按 templates/resume-familiarization.md：断言过堂 → 口述对照 → 弱项清单
      ↓          （主线到此为止；⑥-⑧ 是附带的投递记录工具）
⑥ 列清单        每个方向写 tracker/lists/<方向>.md（梯队制：一二三梯队/需确认/建议放弃）
      ↓
⑦ 建追踪表      cd tracker && python3 extract_tracker_data.py && python3 build.py
      ↓          （增量更新：重跑不丢 xlsx 里手填的投递日期/进展；--rebuild 才全量重做）
⑧ 投递期        用户在 xlsx 自行记录投递与进展；阶段变化回写 MEMORY.md
```

不要求一次走完。用户在哪个阶段，就从 MEMORY.md §6 的待办继续。

**范围边界**：本项目做「从 0 写简历 + 熟悉自己的简历」，附带投递记录工具。
**不做面试辅助**——模拟面试、追问演练、面试话术与手册生成等，请明确告知用户并
推荐专门的面试辅助项目；本项目的产出（定稿简历、断言出处对照表、熟悉记录）
可直接作为那些项目的输入，用户带走即可。

---

## 3. 文档分层模型（信息架构）

| 层 | 文件 | 性质 | 何时写 |
|---|---|---|---|
| 入口 | `README.md` | 项目是什么 | 结构变化时 |
| 快照 ★ | `memory/MEMORY.md` | **当前状态**，可覆盖更新 | 状态变化时 |
| 流水 | `memory/session-log.md` + `memory/YYYY-MM-DD.md` | 历史，**只追加不覆盖** | 每轮对话结束 |

**三条纪律**：

1. **快照可覆盖，流水只能追加。** MEMORY.md 写「现在是什么样」，会话记录写「怎么变成这样的」。
2. **同一事实只在一处定义。** 权威数字（GPA、薪资底线、截止日期）只在 MEMORY.md 定义，其他文件引用而不复制。
3. **改完交付物回写源。** 改了 xlsx 里能改清单解决的事 → 改清单重跑；改了简历结论 → 回写 MEMORY.md。

---

## 4. 版本纪律（git）

- **一轮对话结束 = 一次提交**，message 格式：`第 N 轮：<主题>`（N 从 CHANGELOG/日志续接）
- 里程碑（如「简历定稿」「投递完成」）打 tag：`git tag v0.x-<里程碑名>`
- 每轮结束时在 `memory/session-log.md` **追加**一节，固定五块结构：
  **本轮诉求 / 结论 / 改动文件 / 待用户决策 / 下一步**（见 `templates/session-log.template.md`）
- 同步更新 `memory/CHANGELOG.md` 的轮次索引（一行一轮）

---

## 5. 诚信红线（不可违反）

1. **不编造事实。** 简历及一切交付物中的每一条经历、数字、头衔必须有出处：用户的原始素材或用户口头确认。
2. **断言要有出处对照。** 简历里每个关键数字（GPA、规模、提升百分比）登记进断言出处对照表，六列：断言 | 出处文件 | 原文摘录 | 可信度 | 处理决定 | 影响哪些交付物。
3. **发现事实错误必须全局排查。** 修正一处事实（如 GPA 口径）后，扫描所有引用它的交付物——修正不会自动传播。
4. 拿不准的写「待核实」，不要替用户猜。

---

## 6. 硬约束（踩过坑的技术规则）

1. **改完必须重编译检查页数。** 中文版比英文版「吃」版面（CJK 字符宽），**逐份**查页数，不能只看一个版本。
2. **PDF 文本层检查。** 用 `pdftotext <file> - | head` 确认数字能提取出来；若字体导致文本丢失（Carlito+XeTeX 曾发生），导言区加 `\XeTeXgenerateactualtext=1`。
3. **编译日志查 Overfull hbox。** `grep -c "Overfull" *.log`，简历里任何越界横线都会在 ATS 解析时出问题。
4. **改数字前全文检索该数字。** 同一数字常分三处出现（指标卡/正文结论/表名），漏一处就不一致。
5. **PDF 元数据要审。** `pdfinfo` 检查 Author/Title 无乱码、无旧姓名；黑白版颜色要真的脱色（不是看起来灰）。
6. **黑白版不手改。** `*-bw.tex` 由 `make_bw.py` 自动生成，改彩色版后重新生成即可。

详见 `docs/lessons.md`。

---

## 7. 常用命令

```bash
# 编译全部简历（每个方向 中/英 × 彩色/黑白）并检查页数
cd resume-src && bash build.sh
# 自定义输出文件名中的姓名：
NAME_ZH="李四" NAME_EN="Li_Si" bash build.sh

# 重建投递追踪表（增量更新：沿用 xlsx 里手填的投递日期/进展与现场记录）
cd tracker
python3 extract_tracker_data.py && python3 build.py
# 要全量重做（忽略旧表过程数据）：python3 build.py --rebuild

# 单份快速编译（调试用）
cd resume-src && xelatex example-zh.tex

# 切换字体预设：改 tex 源文件首行，如 \documentclass[times]{common/resume-zh}
# 可选：modern(默认，用系统字体) / texlive / times / palatino（三者跨平台渲染一致），详见 README「字体」

# PDF 体检三件套
pdfinfo <file>.pdf                    # 页数 + 元数据
pdftotext <file>.pdf - | head -30     # 文本层是否可提取
```

依赖：XeLaTeX（TeX Live / MacTeX）、poppler（pdfinfo/pdftotext，可选）、Python 3.9+。
字体已做回退链（macOS 原生字体 → TeX Live 自带字体），Linux/Windows 可直接编译。

---

## 8. 每轮收尾清单（对话结束前逐项过）

- [ ] 交付物改了 → 回写源（MEMORY.md / 清单）
- [ ] MEMORY.md §6 待办已更新（做完的划掉，新发现的问题加上）
- [ ] `memory/session-log.md` 追加本轮五块结构
- [ ] `memory/CHANGELOG.md` 加一行索引
- [ ] 有里程碑 → 打 tag
- [ ] `git add -A && git commit -m "第 N 轮：<主题>"`
- [ ] 向用户报告：改了什么、待决策什么、下一步是什么
