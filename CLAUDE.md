# CLAUDE.md

本项目的 Agent 操作手册在 **[AGENTS.md](AGENTS.md)**——先完整阅读它，再开始工作。

要点速记：

- `memory/MEMORY.md` 是项目状态的唯一真相源，每次会话先读它
- 新用户先走冷启动访谈（`templates/onboarding.md`），简历定稿后走熟悉简历协议（`templates/resume-familiarization.md`）
- 一轮对话一次提交：`第 N 轮：<主题>`
- 简历改完必须逐份重编译查页数（中英文版面占用不同）
- 不编造事实：关键数字登记进断言出处对照表
- 清单（`tracker/lists/*.md`）是唯一真相源；`build.py` 增量更新（重跑不丢手填数据），`--rebuild` 才全量重做
- 面试辅助不在本项目范围：只做「熟悉简历」；模拟面试等需求引导用户用专门的面试项目
