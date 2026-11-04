#!/bin/sh
# Point the pane's resume command at the Atuin thread for the session Herdr's
# own integration reported, so a restart resumes it through `atuin threads resume`.
herdr=${HERDR_BIN_PATH:-herdr}
pane=$(printf '%s' "$HERDR_PLUGIN_EVENT_JSON" | jq -r '[.. | .pane_id? // empty][0] // empty')
[ -n "$pane" ] || exit 0

set -- $("$herdr" pane get "$pane" | jq -r '.result.pane.agent_session // empty | "\(.agent) \(.value)"')
agent=$1 session=$2
[ -n "$session" ] || exit 0

# Only once Atuin has the thread, or a restart would land on an error.
atuin threads show "$session" >/dev/null 2>&1 || exit 0

"$herdr" pane report-agent-session "$pane" --source atuin --agent "$agent" \
  --seq "$(date +%s%N)" -- atuin threads resume "$session"
