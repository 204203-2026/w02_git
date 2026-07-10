#!/usr/bin/env bash
# =============================================================
# w02_git — init.sh
# Sets up repo/, origin-bare/, and repo_challenge/ for the Git lab
# Run once: bash init.sh
# =============================================================

set -e

REPO="repo"
BARE="origin-bare"
CHALLENGE="repo_challenge"

# ── Guard: don't run twice ────────────────────────────────────
if [ -f ".initialized" ]; then
  echo "⚠️  Lab already initialized."
  echo "   To reset: rm -rf repo/ origin-bare/ repo_challenge/ results/ .initialized .teammate_counter && bash init.sh"
  exit 0
fi

echo "🚀 Initializing w02_git — Git Fundamentals..."

mkdir -p "results"

export GIT_AUTHOR_NAME="Lab Bot"
export GIT_AUTHOR_EMAIL="lab@204203.local"
export GIT_COMMITTER_NAME="Lab Bot"
export GIT_COMMITTER_EMAIL="lab@204203.local"

commit_at() {
  # commit_at "2024-01-01T09:00:00" -m "message"
  local when=$1; shift
  GIT_AUTHOR_DATE="$when" GIT_COMMITTER_DATE="$when" git commit -q "$@"
}

# ── repo/ — the main practice repo ────────────────────────────
rm -rf "$REPO"
git init -q -b main "$REPO"
(
  cd "$REPO"

  echo "# Week 2 Git Lab" > README.md
  git add README.md
  commit_at "2024-01-01T09:00:00" -m "Initial commit"

  printf '%s\n' \
    "line 1: alpha" "line 2: bravo" "line 3: charlie" "line 4: delta" \
    "line 5: echo" "line 6: foxtrot" "line 7: golf" "line 8: hotel" \
    "line 9: india" "line 10: juliet" "line 11: kilo" "line 12: lima" \
    "line 13: mike" "line 14: november" "line 15: oscar" "line 16: papa" \
    "line 17: quebec" "line 18: romeo" "line 19: sierra" "line 20: tango" > data.txt
  git add data.txt
  commit_at "2024-01-01T09:01:00" -m "Add data file"

  # Branch off here — BEFORE main's next README edit — so the same line
  # (the title) diverges on both sides and merging them later is a
  # guaranteed, reproducible conflict.
  git branch feature/conflict

  printf '%s\n' "# Week 2 Git Lab — Fundamentals" "" "See data.txt for sample data." > README.md
  git add README.md
  commit_at "2024-01-01T09:02:00" -m "Update README"

  git switch -q feature/conflict
  printf '%s\n' "# Week 2 Git Lab (feature branch)" > README.md
  git add README.md
  commit_at "2024-01-01T09:03:00" -m "Update README from feature branch"

  git switch -q main
)

# ── origin-bare/ — stands in for "GitHub", holds main only ───
rm -rf "$BARE"
git init -q --bare "$BARE"
git -C "$REPO" push -q "$(pwd)/$BARE" main

# ── repo_challenge/ — richer 3-file conflict for the Challenge track ─
rm -rf "$CHALLENGE"
git init -q -b main "$CHALLENGE"
(
  cd "$CHALLENGE"

  echo "alpha: original" > alpha.txt
  echo "beta: original" > beta.txt
  echo "gamma: original" > gamma.txt
  git add alpha.txt beta.txt gamma.txt
  commit_at "2024-01-01T09:00:00" -m "Initial commit"

  git branch feature/challenge

  echo "alpha: updated on main" > alpha.txt
  echo "beta: updated on main" > beta.txt
  echo "gamma: updated on main" > gamma.txt
  git add alpha.txt beta.txt gamma.txt
  commit_at "2024-01-01T09:01:00" -m "Update alpha, beta, gamma on main"

  git switch -q feature/challenge
  echo "alpha: updated on feature" > alpha.txt
  echo "beta: updated on feature" > beta.txt
  echo "gamma: updated on feature" > gamma.txt
  git add alpha.txt beta.txt gamma.txt
  commit_at "2024-01-01T09:02:00" -m "Update alpha, beta, gamma on feature"

  git switch -q main
)

# ── Mark initialized ─────────────────────────────────────────
date > ".initialized"

echo ""
echo "✅ Lab environment ready!"
echo ""
echo "📂 repo/            — your working repo (3 commits + feature/conflict branch)"
echo "📂 origin-bare/      — your simulated GitHub remote"
echo "📂 repo_challenge/   — separate repo for the Challenge merge task"
echo ""
echo "👉 Open TASKS.md and start the lab."
echo "   Run: bash check.sh   to check your answers"
echo "   Run: bash submit.sh  to submit"
