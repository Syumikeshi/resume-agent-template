# resume-agent-template

A resume workspace meant to be driven by AI agents (Claude Code, Cursor, ZCode, Codex, ...). You drop your materials in; the agent runs an onboarding interview to build your profile, writes the resume, compiles multiple PDF versions, and then walks you through every line of it until you can speak to each one yourself. An application-tracking tool is included — use it or don't.

Interview simulation is out of scope; use a dedicated interview-assist project for that. This repo's outputs (final resume, claim-source map, familiarity notes) plug directly into those tools.

The full documentation is in Chinese: [README.md](README.md)

## Getting started

```bash
git clone https://github.com/Syumikeshi/resume-agent-template.git
cd resume-agent-template
rm -rf .git && git init    # start your own history
```

1. Put your materials into `input/`: an existing resume (any format), transcript, certificates. No resume yet? Follow the structure of `input/initial-resume.template.md`.
2. Open the folder in your agent and say: "Read AGENTS.md and help me get started."

Building resumes requires XeLaTeX (TeX Live / MacTeX) and poppler (`pdfinfo`, `pdftotext`); the tracker needs Python 3.9+ (openpyxl installs itself if missing). None of these are needed to get started.

## Layout

```
AGENTS.md          operating manual for agents — the core of the project
CLAUDE.md          Claude Code entry point, points to AGENTS.md
input/             your raw materials
memory/            MEMORY.md (project state) and session logs
resume-src/        resume LaTeX sources and build scripts
tracker/           application lists and the tracker generator
templates/         interview protocol, familiarization protocol, doc templates
docs/              methodology and lessons learned (Chinese)
```

All sample data is fictional: the persona in `resume-src/example-*.tex` and the companies in `tracker/lists/`. Replace them with your own.

## Fonts

The LaTeX classes ship four font presets, selected on the documentclass line of each source file:

```latex
\documentclass[times]{common/resume-zh}   % Chinese resume, Times look
\documentclass[palatino]{common/resume}   % English resume, Palatino look
```

| Preset | Latin | CJK | Notes |
|---|---|---|---|
| `modern` (default) | Avenir Next | PingFang SC | system fonts; non-macOS falls back to the texlive set |
| `texlive` | TeX Gyre Heros | FandolSong | Helvetica look; identical rendering on every platform |
| `times` | TeX Gyre Termes | FandolSong | Times look |
| `palatino` | TeX Gyre Pagella | FandolSong | Palatino look |

The last three ship with TeX Live, so users install nothing, and the embedded fonts are identical across macOS, Linux, and Windows. A preset changes only fonts, not layout; after switching, re-check the page count of every file — fonts differ in metrics.

## Further reading

The conventions (workflow, documentation discipline, one commit per session) live in `AGENTS.md`; the reasoning and the pitfalls behind them are in `docs/methodology.md` and `docs/lessons.md`.

## License

MIT. Verify that the output meets resume conventions in your target market before using it.
