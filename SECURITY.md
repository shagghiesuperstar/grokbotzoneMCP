# Security

## Threat model

This plugin talks to a public directory over HTTPS. Read tools are unauthenticated. Writes (submit, subscribe) are rate-limited and require an operator-provided email for receipts / double opt-in.

## Rules

- No secrets in this repo. `.mcp.json` is a public URL only.
- Do not put bearer tokens, OAuth codes, or personal emails in git, chat logs that will be published, or public bot fields.
- Submit only after the operator confirms the exact record. Duplicate-check first (`grokbot_check_listed` or `/api/v1/codes.json`).
- `company_website` on REST submits is a honeypot — send empty. Prefer the MCP tool for submits when available (server sets honeypot + elapsed).
- Do not hammer the site: one submit per bot; at most one retry after 415 or 429.
- Listing is free. The directory lists and links; it never runs, hosts, or copies a bot.

## Optional higher write ceiling

A bearer that raises write rate limits starts at `https://grokbot.zone/.well-known/oauth-protected-resource` (flow in `/auth.md` on the site). Do not commit that bearer.
