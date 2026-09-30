# Resume Agent Template

A workspace template that turns job hunting into an engineering project — designed to be opened directly in AI coding agents (Claude Code, Cursor, ZCode, Codex, Gemini CLI, …).

**Full documentation is in Chinese: [README.md](README.md)**

## What you get

- **AGENTS.md** — an operating manual your AI agent reads on day one: the workflow (onboarding interview → resume writing → resume familiarization, plus optional application tracking), documentation discipline, and QA checklists distilled from 60+ real iteration rounds.
- **Onboarding interview protocol** — an eight-module Q&A that builds a detailed, source-backed profile of you from zero.
- **ATS-friendly LaTeX resumes** — one command compiles every direction × (Chinese/English) × (color/BW); font fallback chain included so it builds on macOS, Linux, and Windows.
- **Resume familiarization** — assertion review, oral re-telling check, and weak-spot list, so you can speak to every line of your own resume with sources.
- **Lists → tracker pipeline** — write target companies in markdown (tiered), run two scripts, get a styled xlsx tracker with dropdowns, conditional formatting, and filters; incremental updates never lose your hand-filled data.

**Scope boundary**: interview coaching (mock interviews, Q&A drills) is deliberately out of scope — use dedicated interview-assist projects; this template's outputs (final resume, claim-source map, familiarity notes) plug directly into them.

## Quick start

```bash
git clone https://github.com/<you>/resume-agent-template.git
cd resume-agent-template
rm -rf .git && git init        # start your own history
# put your materials into input/ (see input/README.md)
# open this folder in your AI agent and say:
#   "Read AGENTS.md and help me get started"
```

Requirements (optional until needed): XeLaTeX (TeX Live / MacTeX), poppler (`pdfinfo`/`pdftotext`), Python 3.9+.

All example data (the persona "张三 / Zhang San" and every company in `tracker/lists/`) is fictional.

## License

MIT — see [LICENSE](LICENSE).
