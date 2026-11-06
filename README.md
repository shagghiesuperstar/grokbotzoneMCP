# GrokBot Zone MCP plugin

This plugin connects a Grok Bot to [grokbot.zone](https://grokbot.zone/) over HTTPS MCP so it can search, browse, and (with your yes) list public Grok bot listings.

It does not host bots, does not ship secrets, and never submits or subscribes without a clear operator yes.

## MCP URL

```
https://grokbot.zone/mcp
```

Transport: Streamable HTTP (JSON). `POST` only — `GET /mcp` returns 405 with a JSON hint when the server is up. Server card: `https://grokbot.zone/mcp/server-card`.

Read tools need no account. Submit and subscribe use the same limits as the site forms.

## Connect

### Option A — install this plugin

From a clone of this repo:

```bash
grok plugin marketplace add .
grok plugin install grokbot-zone --trust
```

That loads `.mcp.json`, which points at `https://grokbot.zone/mcp`.

### Option B — paste into a Grok Bot

Paste the entire file `AGENT_INSTALL.md` into a new Grok Bot and let it finish the self-test.

### Option C — raw MCP config

```json
{
  "mcpServers": {
    "grokbot-zone": {
      "type": "http",
      "url": "https://grokbot.zone/mcp"
    }
  }
}
```

In Hermes, add the same URL under `mcp_servers` with the official `hermes mcp` command (see current docs at https://hermes-agent.nousresearch.com/docs/).

## Prove it works

1. Health: `GET https://grokbot.zone/api/health` → `ok:true`, `d1:true`
2. MCP probe: `GET https://grokbot.zone/mcp` → 405 with a JSON hint
3. Call `grokbot_health`, then `grokbot_list_categories`
4. Call `grokbot_submit_bot` with empty input → expect a validation error (no listing created)

Or run `./scripts/verify.sh` from this repo.

## Tools (connector contract v1)

| Tool | What it does |
| --- | --- |
| `grokbot_health` | Worker and database check |
| `grokbot_list_categories` | Every category slug, label, and count |
| `grokbot_get_category` | Bots in one category |
| `grokbot_search` | Up to 5 bots scored on name and description |
| `grokbot_trending` | Ordered bot ids, optional category |
| `grokbot_get_bot` | One bot record |
| `grokbot_check_listed` | Whether a link or code is already listed |
| `grokbot_submit_bot` | Queue a listing (needs operator yes + receipt email) |
| `grokbot_subscribe` | Double opt-in update emails |

Full agent playbook: `skills/grokbot-zone-onboarding/SKILL.md` (same content as `https://grokbot.zone/.well-known/agent-skills/grokbot-zone-onboarding/SKILL.md`).

## What it will not do

- Will not open a browser or drive a screen — HTTPS JSON / MCP only
- Will not invent a bot, link, code, or description
- Will not submit or subscribe without a clear yes
- Will not put the operator's email in a public field
- Will not ship tokens or secrets in git

## License

MIT
