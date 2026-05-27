#!/bin/bash
# Stop hook: blocks stop if uncommitted code changes exist, enforces code review
# Uses a marker file to avoid infinite loop after review is done

MARKER="/tmp/claude-review-done-$(echo -n "$PWD" | md5 -q)"

# If review was already completed this round, allow stop and clean up
if [ -f "$MARKER" ]; then
  rm -f "$MARKER"
  echo '{"continue":true}'
  exit 0
fi

# Check for uncommitted git changes (tracked + untracked)
CHANGES=$(git status --porcelain 2>/dev/null)

if [ -n "$CHANGES" ]; then
  cat <<EOF
{"decision":"block","stopReason":"Code changes detected — code review required","hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"CODE REVIEW ENFORCEMENT: Uncommitted code changes detected. You MUST: 1) Invoke superpowers:requesting-code-review skill via the Skill tool. 2) After review completes, run: touch $MARKER 3) Then you may stop. Do NOT stop without completing the code review."}}
EOF
else
  echo '{"continue":true}'
fi
