# resume-agent-template

配合 AI Agent（Claude Code、Cursor、ZCode、Codex 等）使用的简历工作区。放一份素材进来，Agent 会先做一轮访谈帮你建档，然后写简历、编译成多版本 PDF，最后陪你把简历上的每一条过到自己能讲清楚为止。附带一套投递记录工具，用不用随意。

面试模拟不在范围内，这类需求建议直接用专门的面试项目。这个仓库的产出（简历、断言出处对照表、熟悉记录）可以作为它们的输入。

英文简介见 [README.en.md](README.en.md)。

## 开始

```bash
git clone https://github.com/Syumikeshi/resume-agent-template.git
cd resume-agent-template
rm -rf .git && git init    # 让历史从你自己的项目开始
```

1. 把材料放进 `input/`：现有简历（什么格式都行）、成绩单、证书。没有现成简历，照着 `input/initial-resume.template.md` 的结构写一份就行。
2. 用 Agent 打开这个目录，说「读 AGENTS.md，然后帮我开始」。接下来它会引导你。

编译简历需要 XeLaTeX（TeX Live / MacTeX）和 poppler（提供 `pdfinfo`、`pdftotext`）；追踪表需要 Python 3.9+（openpyxl 缺了会自动装）。这些没装也能开工，到编译那一步再装。

## 目录

```
AGENTS.md          Agent 的操作手册，整个项目的核心
CLAUDE.md          Claude Code 的入口，指向 AGENTS.md
input/             你的原始素材
memory/            MEMORY.md（项目状态）和会话日志
resume-src/        简历 LaTeX 源文件和编译脚本
tracker/           投递清单和追踪表生成脚本
templates/         访谈协议、熟悉简历协议、各类文档模板
docs/              方法论和踩坑记录
```

示例数据都是虚构的：`resume-src/example-*.tex` 里的人物、`tracker/lists/` 里的公司，换成你自己的内容。

## 字体

LaTeX 类文件内置四个字体预设，在 `.tex` 源文件的 documentclass 行选择：

```latex
\documentclass[times]{common/resume-zh}   % 中文简历，Times 风
\documentclass[palatino]{common/resume}   % 英文简历，Palatino 风
```

| 预设 | 西文 | 中文 | 说明 |
|---|---|---|---|
| `modern`（默认） | Avenir Next | PingFang SC | 用系统字体；非 macOS 自动回退到下面这套 |
| `texlive` | TeX Gyre Heros | FandolSong | Helvetica 风；跨平台渲染完全一致 |
| `times` | TeX Gyre Termes | FandolSong | Times 风，传统正式 |
| `palatino` | TeX Gyre Pagella | FandolSong | Palatino 风，人文衬线 |

后三个预设的字体全部随 TeX Live 安装，不用额外装字体，macOS / Linux / Windows 编译出的 PDF 字体完全相同。预设只换字体、不动版式；换预设后记得逐份检查页数——不同字体字宽不同。

## 更多

工作流、文档纪律、每轮一提交这些约定都在 `AGENTS.md` 里；背后的方法论和踩过的坑在 `docs/methodology.md` 和 `docs/lessons.md`。

## 许可

MIT。使用前请自行确认产出符合目标市场的简历惯例。
