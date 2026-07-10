#!/usr/bin/env bash
# =============================================================
# w02_git — submit.sh
# Validates results then pushes to GitHub
# =============================================================

LOG="results/results.log"
REQUIRED=("task1" "task2" "task3" "task4" "task5" "task6" "task7" "task8" "task9" "challengeA" "challengeB" "challengeC")
TOTAL=${#REQUIRED[@]}

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=============================================="
echo "  w02_git — Submit"
echo "=============================================="
echo ""

# Guard 1: log must exist
if [ ! -f "$LOG" ]; then
  echo -e "${RED}❌ results/results.log not found.${NC}"
  echo "   Run: bash check.sh first."
  exit 1
fi

# Guard 2: all tasks present
echo "Validating results.log..."
MISSING=0
PASS_COUNT=0

for task in "${REQUIRED[@]}"; do
  if ! grep -q "^${task}:" "$LOG"; then
    echo -e "  ${RED}Missing: $task${NC}"
    MISSING=$((MISSING + 1))
  else
    status=$(grep "^${task}:" "$LOG" | cut -d: -f2)
    if [ "$status" = "PASS" ]; then
      echo -e "  ${GREEN}✅ $task: PASS${NC}"
      PASS_COUNT=$((PASS_COUNT + 1))
    else
      echo -e "  ${YELLOW}⚠️  $task: FAIL${NC}"
    fi
  fi
done

echo ""

if [ "$MISSING" -gt 0 ]; then
  echo -e "${RED}❌ Blocked: $MISSING task(s) missing. Run bash check.sh first.${NC}"
  exit 1
fi

# Guard 3: warn on partial score
if [ "$PASS_COUNT" -lt "$TOTAL" ]; then
  FAIL_COUNT=$((TOTAL - PASS_COUNT))
  echo -e "${YELLOW}⚠️  $FAIL_COUNT task(s) still failing.${NC}"
  read -r -p "Submit anyway? (y/N): " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }
fi

# Guard 4: must be in a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${RED}❌ Not inside a Git repository. Clone from GitHub first.${NC}"
  exit 1
fi

# Commit and push
echo ""
echo "📦 Preparing submission..."
git add results/ 2>/dev/null || true

if git diff --cached --quiet; then
  echo -e "${YELLOW}ℹ️  No changes — already up to date.${NC}"
else
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  git commit -m "w02_git submission — Score: ${PASS_COUNT}/${TOTAL} — ${TIMESTAMP}"
  echo -e "${GREEN}✅ Committed.${NC}"
fi

echo "⬆️  Pushing to GitHub..."
git push

echo ""
echo -e "${GREEN}🎉 Submitted! Score: ${PASS_COUNT} / ${TOTAL}${NC}"
echo "   Check the Actions tab in your GitHub repository."
