#!/bin/bash
# Injects workflow enforcement reminder on every user prompt
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"WORKFLOW ENFORCEMENT — before responding, check if any of these skills apply and invoke them with the Skill tool:\n1. Planning → invoke superpowers:writing-plans, then plan-ceo-review / plan-eng-review\n2. Implementing code → invoke superpowers:test-driven-development (tests first)\n3. Code just written/edited → invoke superpowers:requesting-code-review\n4. About to claim done → invoke superpowers:verification-before-completion"}}
EOF
