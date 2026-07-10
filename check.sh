#!/usr/bin/env bash
# =============================================================
# w02_git — check.sh
# Self-check script. Run on your own machine anytime.
# Writes results/results.log
# =============================================================
# No set -e — this script handles errors intentionally

RESULTS="results"
LOG="$RESULTS/results.log"
REPO="repo"
BARE="origin-bare"
CHALLENGE="repo_challenge"

PASS=0
FAIL=0
TOTAL=12

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ── Guard ────────────────────────────────────────────────────
if [ ! -f ".initialized" ]; then
  echo -e "${RED}❌ Lab not initialized. Run: bash init.sh${NC}"
  exit 1
fi

mkdir -p "$RESULTS"
> "$LOG"

echo "=============================================="
echo "  w02_git — Self Check"
echo "=============================================="
echo ""

# ── Helpers ──────────────────────────────────────────────────
record() {
  local task=$1 status=$2 msg=$3
  echo "${task}:${status}" >> "$LOG"
  if [ "$status" = "PASS" ]; then
    echo -e "${GREEN}✅ $task PASS${NC} — $msg"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}❌ $task FAIL${NC} — $msg"
    FAIL=$((FAIL + 1))
  fi
}

section() {
  echo ""
  echo -e "${CYAN}── $1 ──${NC}"
}

result_file() { tr -d '\r' < "$RESULTS/$1" 2>/dev/null; }

# Search across ALL refs (not just current HEAD) so a task's commit
# stays checkable even after later tasks add more commits on top.
commit_hash() { # commit_hash <repo-dir> <exact message>
  git -C "$1" log --all --grep="$2" -F --format=%H | tail -1
}
file_at() { # file_at <repo-dir> <hash> <path>
  git -C "$1" show "$2:$3" 2>/dev/null
}
parent_count() { # parent_count <repo-dir> <hash>
  git -C "$1" log -1 --format=%P "$2" 2>/dev/null | wc -w | tr -d '[:space:]'
}

# ════════════════════════════════════════════════════════════
section "Section 1 — Reading History"

# Task 1: git log --oneline shows the 3 provided commits, newest first
if [ -f "$RESULTS/task1.txt" ]; then
  content="$RESULTS/task1.txt"
  l1=$(grep -n "Update README$" "$content" | head -1 | cut -d: -f1)
  l2=$(grep -n "Add data file$" "$content" | head -1 | cut -d: -f1)
  l3=$(grep -n "Initial commit$" "$content" | head -1 | cut -d: -f1)
  if [ -n "$l1" ] && [ -n "$l2" ] && [ -n "$l3" ] && [ "$l1" -lt "$l2" ] && [ "$l2" -lt "$l3" ]; then
    record "task1" "PASS" "All 3 provided commits present, newest first"
  else
    record "task1" "FAIL" "Expected 3 lines (newest first): Update README, Add data file, Initial commit — run: git -C repo log --oneline"
  fi
else
  record "task1" "FAIL" "results/task1.txt missing"
fi

# ════════════════════════════════════════════════════════════
section "Section 2 — Your First Commit and Undo"

# Task 2: create hello.txt and commit it (checked by content only —
# task 3 amends this commit, so its original message won't be
# reachable in history anymore by the time you check everything).
if [ -f "$RESULTS/task2.txt" ] && grep -q "Add hello file" "$RESULTS/task2.txt"; then
  record "task2" "PASS" "Commit recorded: Add hello file"
else
  record "task2" "FAIL" "results/task2.txt missing or doesn't mention 'Add hello file' — see Section 2.1"
fi

# Task 3: amend the message to "Add hello file (Week 2 lab)"
if [ -f "$RESULTS/task3.txt" ] && grep -q "Add hello file (Week 2 lab)" "$RESULTS/task3.txt"; then
  hash=$(commit_hash "$REPO" "Add hello file (Week 2 lab)")
  if [ -n "$hash" ] && [ "$(file_at "$REPO" "$hash" hello.txt)" = "Hello, Git!" ]; then
    record "task3" "PASS" "Commit message amended and hello.txt content intact"
  else
    record "task3" "FAIL" "Amended commit not found in repo/ history, or hello.txt content changed"
  fi
else
  record "task3" "FAIL" "results/task3.txt missing or doesn't show the amended message — see Section 2.2"
fi

# ════════════════════════════════════════════════════════════
section "Section 3 — Branching"

# Task 4: create feature/greeting, add greeting.txt, commit
if [ -f "$RESULTS/task4.txt" ] && grep -q "Add greeting on feature branch" "$RESULTS/task4.txt"; then
  hash=$(commit_hash "$REPO" "Add greeting on feature branch")
  if [ -n "$hash" ] && [ "$(file_at "$REPO" "$hash" greeting.txt)" = "Hi from a branch!" ]; then
    record "task4" "PASS" "feature/greeting commit found with correct content"
  else
    record "task4" "FAIL" "Commit not found in repo/ history, or greeting.txt content wrong"
  fi
else
  record "task4" "FAIL" "results/task4.txt missing or doesn't mention the commit message — see Section 3.1"
fi

# Task 5: switch back to main
if [ -f "$RESULTS/task5.txt" ] && [ "$(result_file task5.txt)" = "main" ]; then
  record "task5" "PASS" "Confirmed back on main"
else
  record "task5" "FAIL" "results/task5.txt should contain exactly 'main' — run: git branch --show-current > results/task5.txt"
fi

# ════════════════════════════════════════════════════════════
section "Section 4 — Merging"

# Task 6: --no-ff merge of feature/greeting into main
if [ -f "$RESULTS/task6.txt" ] && grep -q "Merge feature/greeting" "$RESULTS/task6.txt" \
   && grep -q "Add greeting on feature branch" "$RESULTS/task6.txt"; then
  hash=$(commit_hash "$REPO" "Merge feature/greeting")
  parents=$(parent_count "$REPO" "$hash")
  if [ -n "$hash" ] && [ "$parents" = "2" ]; then
    record "task6" "PASS" "Real merge commit found with 2 parents"
  else
    record "task6" "FAIL" "Merge commit missing or not a real merge (did you use --no-ff?)"
  fi
else
  record "task6" "FAIL" "results/task6.txt missing or incomplete — see Section 4.1"
fi

# Task 7: resolve the guaranteed feature/conflict merge conflict
if [ -f "$RESULTS/task7.txt" ] && grep -q "Merge feature/conflict" "$RESULTS/task7.txt"; then
  hash=$(commit_hash "$REPO" "Merge feature/conflict")
  parents=$(parent_count "$REPO" "$hash")
  readme=$(file_at "$REPO" "$hash" README.md)
  leftover=$(git -C "$REPO" grep -l '<<<<<<<' "$(git -C "$REPO" rev-parse main)" 2>/dev/null)
  if [ -n "$hash" ] && [ "$parents" = "2" ] && echo "$readme" | grep -q "MERGED: combined both README updates" && [ -z "$leftover" ]; then
    record "task7" "PASS" "Conflict resolved cleanly, marker present, no leftover conflict markers"
  else
    record "task7" "FAIL" "Conflict merge missing, not a real merge, marker missing, or conflict markers left behind"
  fi
else
  record "task7" "FAIL" "results/task7.txt missing or doesn't mention the merge — see Section 4.2"
fi

# ════════════════════════════════════════════════════════════
section "Section 5 — Remote Collaboration"

mains_synced() { [ "$(git -C "$REPO" rev-parse main 2>/dev/null)" = "$(git -C "$BARE" rev-parse main 2>/dev/null)" ]; }

# Task 8: add origin, push
if [ -f "$RESULTS/task8.txt" ] && grep -q "origin" "$RESULTS/task8.txt" && grep -q "origin-bare" "$RESULTS/task8.txt"; then
  if mains_synced; then
    record "task8" "PASS" "origin remote configured and main pushed"
  else
    record "task8" "FAIL" "repo/ main and origin-bare/ main are not in sync — did the push succeed?"
  fi
else
  record "task8" "FAIL" "results/task8.txt missing or doesn't show origin/origin-bare — see Section 5.1"
fi

# Task 9: simulate a teammate, then pull
if [ -f "$RESULTS/task9.txt" ] && grep -q "Add teammate note 1" "$RESULTS/task9.txt"; then
  if commit_hash "$REPO" "Add teammate note 1" > /dev/null && [ -n "$(commit_hash "$REPO" "Add teammate note 1")" ] && mains_synced; then
    record "task9" "PASS" "Teammate's commit pulled in, repo fully synced with origin"
  else
    record "task9" "FAIL" "Teammate commit not found locally, or repo/origin main are out of sync"
  fi
else
  record "task9" "FAIL" "results/task9.txt missing or doesn't mention teammate note 1 — see Section 5.2"
fi

# ════════════════════════════════════════════════════════════
section "Challenge Tasks"

# Challenge A: recover a commit lost to git reset --hard, via reflog
if [ -f "$RESULTS/challengeA.txt" ] && grep -q "Recoverable commit" "$RESULTS/challengeA.txt"; then
  hash=$(commit_hash "$REPO" "Recoverable commit")
  if [ -n "$hash" ] && [ "$(file_at "$REPO" "$hash" temp_work.txt)" = "important work" ]; then
    record "challengeA" "PASS" "Lost commit successfully recovered via reflog"
  else
    record "challengeA" "FAIL" "Recovered commit not found, or temp_work.txt content wrong"
  fi
else
  record "challengeA" "FAIL" "results/challengeA.txt missing or doesn't mention the recovered commit"
fi

# Challenge B: resolve a 3-file conflict in repo_challenge/
if [ -f "$RESULTS/challengeB.txt" ] && grep -q "Merge feature/challenge" "$RESULTS/challengeB.txt"; then
  hash=$(commit_hash "$CHALLENGE" "Merge feature/challenge")
  parents=$(parent_count "$CHALLENGE" "$hash")
  leftover=$(git -C "$CHALLENGE" grep -l '<<<<<<<' "$(git -C "$CHALLENGE" rev-parse main)" 2>/dev/null)
  files_ok=true
  for f in alpha.txt beta.txt gamma.txt; do
    [ -n "$(file_at "$CHALLENGE" "$(git -C "$CHALLENGE" rev-parse main)" "$f")" ] || files_ok=false
  done
  if [ -n "$hash" ] && [ "$parents" = "2" ] && [ -z "$leftover" ] && $files_ok; then
    record "challengeB" "PASS" "All 3 conflicts resolved cleanly"
  else
    record "challengeB" "FAIL" "Merge missing, conflict markers left behind, or a file is empty/missing"
  fi
else
  record "challengeB" "FAIL" "results/challengeB.txt missing or doesn't mention the merge"
fi

# Challenge C: push/pull race — local commit + concurrent teammate commit
if [ -f "$RESULTS/challengeC.txt" ] && grep -q "Add teammate note 2" "$RESULTS/challengeC.txt" \
   && grep -q "Add feature note" "$RESULTS/challengeC.txt"; then
  if [ -n "$(commit_hash "$REPO" "Add teammate note 2")" ] && [ -n "$(commit_hash "$REPO" "Add feature note")" ] && mains_synced; then
    record "challengeC" "PASS" "Both sides' commits present, repo fully synced with origin"
  else
    record "challengeC" "FAIL" "One side's commit is missing, or repo/origin main are out of sync"
  fi
else
  record "challengeC" "FAIL" "results/challengeC.txt missing or doesn't mention both commits"
fi

# ════════════════════════════════════════════════════════════
echo ""
echo "=============================================="
echo -e "  Score: ${GREEN}${PASS}${NC} / ${TOTAL}   |   ${RED}${FAIL}${NC} failed"
echo "=============================================="
echo ""
echo "📄 Log: $LOG"
echo ""

if [ "$FAIL" -eq 0 ]; then
  echo -e "${GREEN}🎉 All tasks passed! Run: bash submit.sh${NC}"
else
  echo -e "${YELLOW}⚠️  Fix failing tasks, then run bash check.sh again.${NC}"
  echo ""
  echo "Stuck? Re-read the relevant section in TASKS.md."
fi
