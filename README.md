# w02_git — Git as a Time Machine and Collaboration Tool

**Course:** 204203 Computer Science Technology
**Week:** 2
**Theme:** *"Every mistake is one commit away from undone."*

---

## What You Will Learn

| Section | Skills |
|---------|--------|
| 1 — Reading History | `git log --oneline`, reading commit order |
| 2 — Commit & Undo | `git add`, `git commit`, `git commit --amend` |
| 3 — Branching | `git switch -c`, isolated work, `git branch --show-current` |
| 4 — Merging | `git merge --no-ff`, resolving a real merge conflict |
| 5 — Remote Collaboration | `git remote add`, `git push`, `git pull` |
| Challenge | `git reflog` recovery, a bigger 3-file conflict, a push/pull race |

---

## Getting Started

You can do this lab two ways: entirely in the browser with a **GitHub Codespace**, or on **your VM** from `w00_setup` over SSH. Pick one track below — Steps 3 onward are identical either way.

| | Codespace | VM |
|---|---|---|
| Where the terminal runs | Browser | Your VM (`10.110.x.x`), connected from the lab machine |
| How you get the code | Click **Use this template** on GitHub | `git clone` by hand |
| Setup time | ~1 minute | ~2 minutes |
| Requires | Nothing extra | `w00_setup` already completed (SSH key, `gh auth login`, git identity) |

> ⚠️ **Two machines, if you use the VM track:** the lab machine is shared and stores nothing. Your VM is where your SSH key, `gh` login, and code live. You connect lab machine → VM with a password every session, same as `w00_setup`.

---

### Track A — GitHub Codespace

#### A1 — Create Your Repo from the Template

This repository is a **template** inside the **204203-2026** organization.
You must create your own copy — do not work directly in the template.

1. Make sure you are logged into GitHub and have joined **204203-2026**
   *(you did this in w00_setup — if not, ask your instructor)*
2. Click the green **Use this template** button at the top of this page
3. Click **Create a new repository**
4. Under **Owner** — select **204203-2026** (not your personal account)
5. Set the repository name to `w02_git-STUDENTID`
   Replace `STUDENTID` with your 9-digit student ID
   Example: `w02_git-640123456`
6. Set visibility to **Private**
7. Click **Create repository**

Your repo will be at:
`https://github.com/204203-2026/w02_git-640123456`

> ⚠️ Owner must be **204203-2026**, not your personal account.
> Wrong owner = instructor cannot see your submission = no grade.

---

#### A2 — Open in GitHub Codespace

1. Go to your newly created repo
2. Click the green **Code** button
3. Click the **Codespaces** tab
4. Click **Create codespace on main**
5. Wait 30–60 seconds for the environment to load

A full Ubuntu Linux terminal opens in your browser — no installation needed.

> 💡 If you do not see the terminal: **View → Terminal** or press `` Ctrl+` ``

Skip to **Step 3 — Set Up the Lab Environment** below.

---

### Track B — Your VM

Do this from the lab machine, connected to your VM — the same setup as `w00_setup`.

#### B1 — Connect to Your VM

From a terminal on the lab machine:

```bash
ssh user6805xxxxx@10.110.x.x
```

Replace `user6805xxxxx` and `10.110.x.x` with your own username and VM IP. Enter your password when prompted.

Confirm you are on the VM — your prompt should read `user6805xxxxx@user6805xxxxx:~$`.

---

#### B2 — Clone the Template

Confirm GitHub CLI is still using HTTPS (outbound SSH may be blocked on the lab network):

```bash
gh auth status
# Git operations protocol: https
```

Clone the **template repository** into a folder named after your own submission repo. Replace `6805xxxxx` with your student ID:

```bash
git clone https://github.com/204203-2026/w02_git.git w02_git-6805xxxxx
cd w02_git-6805xxxxx
```

---

#### B3 — Detach from the Template's Git History

The clone still points at the template's history and remote. Remove it and start fresh:

```bash
rm -rf .git
git init
git branch -M main
```

This folder is now a plain directory with no Git history — you are about to make it your own repository.

---

#### B4 — Create Your Own Repository on GitHub

Check whether your submission repo already exists:

```bash
gh repo view 204203-2026/w02_git-6805xxxxx
```

If you see repository info, it already exists — continue to B5.

If you see `repository not found`, create it:

```bash
gh repo create 204203-2026/w02_git-6805xxxxx --private
```

> ⚠️ Owner must be **204203-2026**, not your personal account.
> Do not add a README, `.gitignore`, or license — this local folder already has everything.

---

#### B5 — Add the Remote and Push

Point this local folder at your new GitHub repository:

```bash
git remote add origin https://github.com/204203-2026/w02_git-6805xxxxx.git
git remote -v   # confirm origin points at YOUR repo, not the template
```

Since this repo ships a GitHub Actions workflow, refresh your token scope so the push isn't rejected:

```bash
gh auth refresh -h github.com -s workflow
```

Commit and push the starting files:

```bash
git add .
git commit -m "Start w02_git"
git push -u origin main
```

You now have your own copy of the lab, pushed to GitHub, with a normal terminal open on your VM.

---

### Step 3 — Set Up the Lab Environment

Run this once in the terminal:

```bash
bash init.sh
```

This creates `repo/` (your practice Git repository), `origin-bare/` (a simulated GitHub remote, fully offline), and `repo_challenge/` (used only in the Challenge section).

> 💡 `repo/`, `origin-bare/`, and `repo_challenge/` are **not** the repo you're reading this README in — they're a separate, self-contained playground you operate on for every task in this lab. `cd repo` before running the Git commands in `TASKS.md`.

---

### Step 4 — Follow the Lab Tasks

Open `TASKS.md` and work through each section in order.
Every section explains the concept, shows examples, then asks you to save a result.

---

### Step 5 — Check Your Work

Run at any time to see your current score:

```bash
bash check.sh
```

You can run this as many times as you want. It shows PASS or FAIL per task
and tells you exactly what went wrong if something fails.

---

### Step 6 — Submit

When you are ready:

```bash
bash submit.sh
```

This validates your results, commits, and pushes to GitHub.
GitHub Actions then runs automatically — check the **Actions tab** in your repo to confirm.

---

## File Structure

```
w02_git/
├── README.md              ← you are here
├── TASKS.md                ← lab instructions (follow this)
├── init.sh                 ← run once to set up repo/, origin-bare/, repo_challenge/
├── simulate_teammate.sh    ← run when TASKS.md tells you to ("a teammate pushed")
├── check.sh                 ← run anytime to check your answers
├── submit.sh                 ← run when ready to submit
├── repo/                    ← created by init.sh — your practice repo, do not delete
├── origin-bare/             ← created by init.sh — simulated GitHub remote
├── repo_challenge/          ← created by init.sh — used only in the Challenge section
└── results/                 ← your answers go here — created by init.sh
    ├── task1.txt … task9.txt
    ├── challengeA.txt, challengeB.txt, challengeC.txt
    └── results.log          ← written by check.sh — do not edit manually
```

`repo/`, `origin-bare/`, and `repo_challenge/` are **not committed** — they're your local scratch playground (see `.gitignore`). Only `results/` is graded and pushed.

---

## Task Summary

| Task | Section | Command(s) Used | Save to |
|------|---------|-----------------|---------|
| 1 | 1.1 | `git log --oneline` | `results/task1.txt` |
| 2 | 2.1 | `git add`, `git commit -m` | `results/task2.txt` |
| 3 | 2.2 | `git commit --amend` | `results/task3.txt` |
| 4 | 3.1 | `git switch -c` | `results/task4.txt` |
| 5 | 3.2 | `git branch --show-current` | `results/task5.txt` |
| 6 | 4.1 | `git merge --no-ff` | `results/task6.txt` |
| 7 | 4.2 | resolve a real merge conflict | `results/task7.txt` |
| 8 | 5.1 | `git remote add`, `git push` | `results/task8.txt` |
| 9 | 5.2 | `git pull` | `results/task9.txt` |
| Challenge A | 6 | `git reflog` recovery | `results/challengeA.txt` |
| Challenge B | 6 | 3-file conflict resolution | `results/challengeB.txt` |
| Challenge C | 6 | push/pull race | `results/challengeC.txt` |

---

## Common Mistakes

**Task 6 — merge happened silently, no merge commit**
If `main` hasn't diverged since you branched, a plain `git merge` "fast-forwards" and creates no merge commit at all. Use `git merge --no-ff` to force one — the grader checks for it.

**Task 7 — conflict markers left in the file**
After resolving `<<<<<<<` / `=======` / `>>>>>>>` by hand, make sure you deleted all three markers and kept your required `MERGED: combined both README updates` line before `git add`-ing the file.

**Task 8/9 — push or pull "fails" with no error shown**
`origin-bare/` is a local folder, not the internet — a typo in the path (`../origin-bare`) is the most common cause of "it didn't work."

**Challenge C — pushing before pulling**
If `simulate_teammate.sh` ran after your last pull, your push will be rejected. `git pull` first, resolve anything that conflicts, *then* push.

**Submitting before checking**
`submit.sh` requires `results.log` to exist.
Always run `bash check.sh` before `bash submit.sh`.

---

## Grading

`check.sh` runs on your machine and writes `results/results.log`, checking both the text you saved *and* your actual repo/ history (commit messages, file contents, merge topology).

`submit.sh` pushes `results/` to GitHub. GitHub Actions **cannot** see `repo/` (it's gitignored, local-only) — it re-verifies the same required text patterns in your `results/*.txt` files instead.

Your score in the Actions tab is the official grade.

---

## Getting Help

```bash
git log --oneline --all --graph   # see every branch and commit at once
git status                        # what does Git think is going on right now?
```

If `check.sh` says FAIL, read the message carefully — it tells you
which file is missing, what pattern was expected, or what your repo's
actual history shows instead.
