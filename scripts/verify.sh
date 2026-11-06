#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

command -v python3 >/dev/null || fail "python3 required"
command -v curl >/dev/null || fail "curl required"

# Manifests
python3 - <<'PY' || fail "plugin.json invalid"
import json
from pathlib import Path
p = json.loads(Path("plugin.json").read_text())
assert p.get("name") == "grokbot-zone", p
assert p.get("version"), p
print("plugin.json ok", p["name"], p["version"])
PY

python3 - <<'PY' || fail ".mcp.json invalid or has secrets"
import json, re
from pathlib import Path
raw = Path(".mcp.json").read_text()
assert not re.search(r"(?i)(api[_-]?key|secret|token|bearer|password)\s*[\"']?\s*[:=]", raw), "possible secret in .mcp.json"
cfg = json.loads(raw)
url = cfg["mcpServers"]["grokbot-zone"]["url"]
assert url == "https://grokbot.zone/mcp", url
print(".mcp.json ok", url)
PY

python3 - <<'PY' || fail "marketplace.json invalid"
import json
from pathlib import Path
m = json.loads(Path(".grok-plugin/marketplace.json").read_text())
assert m["plugins"][0]["name"] == "grokbot-zone"
print("marketplace.json ok")
PY

[[ -f skills/grokbot-zone-onboarding/SKILL.md ]] || fail "missing onboarding skill"
[[ -f README.md ]] || fail "missing README.md"
grep -q 'https://grokbot.zone/mcp' README.md || fail "README missing MCP URL"

# Live probes (read-only / safe)
code=$(curl -sS -o /tmp/gbz-health.json -w '%{http_code}' https://grokbot.zone/api/health)
[[ "$code" == "200" ]] || fail "health HTTP $code"
python3 - <<'PY' || fail "health payload"
import json
from pathlib import Path
h = json.loads(Path("/tmp/gbz-health.json").read_text())
assert h.get("ok") is True and h.get("d1") is True, h
print("health ok")
PY

code=$(curl -sS -o /tmp/gbz-mcp.txt -w '%{http_code}' https://grokbot.zone/mcp)
[[ "$code" == "405" ]] || fail "MCP GET expected 405, got $code"
pass "MCP probe 405"

code=$(curl -sS -o /tmp/gbz-submit.json -w '%{http_code}' \
  -H 'content-type: application/json' \
  -d '{}' https://grokbot.zone/api/v1/submissions)
[[ "$code" == "400" ]] || fail "submit probe expected 400, got $code"
pass "submit safe probe 400"

# No secrets in tree
if grep -RInE '(api[_-]?key|secret|bearer |Authorization:|ghp_|github_pat_|sk-)[a-zA-Z0-9._-]{8,}' \
  --exclude-dir=.git --exclude='*.md' . 2>/dev/null | grep -v 'scripts/verify.sh'; then
  fail "possible secret string in tree"
fi

pass "all checks"
