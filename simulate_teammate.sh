#!/usr/bin/env bash
# =============================================================
# w02_git — simulate_teammate.sh
# Pushes one new commit straight into origin-bare/, as if a
# teammate had pushed while you were working. Safe to run more
# than once — each call adds a distinctly-numbered commit.
# =============================================================

set -e

BARE="origin-bare"
COUNTER=".teammate_counter"

if [ ! -d "$BARE" ]; then
  echo "❌ origin-bare/ not found. Run: bash init.sh"
  exit 1
fi

N=1
[ -f "$COUNTER" ] && N=$(( $(cat "$COUNTER") + 1 ))
echo "$N" > "$COUNTER"

TMP=$(mktemp -d)
git clone -q "$BARE" "$TMP"
(
  cd "$TMP"
  git config user.name "Teammate Bot"
  git config user.email "teammate@204203.local"
  echo "Note $N from a teammate." > "teammate_note_$N.txt"
  git add "teammate_note_$N.txt"
  git commit -q -m "Add teammate note $N"
  git push -q origin main
)
rm -rf "$TMP"

echo "✅ Simulated teammate push: 'Add teammate note $N'"
