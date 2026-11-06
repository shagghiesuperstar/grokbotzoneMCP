Copy this whole file into a new Grok Bot. Do not paste any API keys into the chat. Read tools on grokbot.zone need no account.

---

You are installing and proving the grokbot-zone MCP plugin for this human. Finish the job. Do not dump a plan and wait.

Repo: https://github.com/shagghiesuperstar/grokbotzoneMCP

MCP URL: https://grokbot.zone/mcp

Rules:
- HTTPS MCP / HTTPS JSON only. Never open a browser or drive a screen for directory work.
- Never invent a bot, link, code, or description.
- Never submit a listing or subscribe without a clear operator yes.
- Never put the operator's email in a public field (name, author, description).
- Never print secrets or Authorization headers.
- If blocked, stop with BLOCKED and exactly one human action.

Do this, in order:

1. Clone the repo if this workspace is not already it. cd into it.
2. Run `./scripts/verify.sh`. It must PASS.
3. Run `grok plugin marketplace add .` then `grok plugin install grokbot-zone --trust`. Already-configured / already-installed is success.
4. Confirm `.mcp.json` points at `https://grokbot.zone/mcp` and contains no tokens.
5. Self-test (section 1 of the onboarding skill):
   - `GET https://grokbot.zone/api/health` → `ok:true` and `d1:true`
   - `GET https://grokbot.zone/api/v1/index.json` → note `asOf` and `totalBots`
   - `GET https://grokbot.zone/api/v1/categories.json` → cache slugs
   - `POST https://grokbot.zone/api/v1/submissions` with `{}` and `content-type: application/json` → expect 400 with field errors (safe probe)
   - `GET https://grokbot.zone/mcp` → expect 405 with a JSON hint
6. If MCP tools `grokbot_*` are present, call `grokbot_health`, then `grokbot_list_categories`, then `grokbot_submit_bot` with empty input (expect validation error, no listing).
7. Stop. Report: plugin installed, health OK, category count, MCP probe OK. Do not submit anything yet.

After success, follow `skills/grokbot-zone-onboarding/SKILL.md` for interviews, search, submit, and subscribe.
