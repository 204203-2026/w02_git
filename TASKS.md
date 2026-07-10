# w02_git — Git as a Time Machine and Collaboration Tool

**Course:** 204203 Computer Science Technology
**Theme:** *"Every mistake is one commit away from undone."*

> **Setup:** run `bash init.sh` before starting.
> **Check anytime:** run `bash check.sh`
> **Submit:** run `bash submit.sh`

All lab work happens inside the `repo/` folder created by `init.sh` (with
`origin-bare/` standing in for "GitHub" and `repo_challenge/` used only in
the Challenge section). All your answers go into the `results/` folder at
the lab root — so most commands end with `> ../results/taskN.txt`.

---

## Section 1 — Reading History

`init.sh` already built `repo/` with three commits for you. Before touching
anything, learn to read what's already there.

### 1.1 `git log --oneline`

1. Move into the practice repo:

```bash
cd repo
```

2. See the commit history, newest first:

```bash
git log --oneline
```

Each line is one commit: a short hash, then its message. Reading top to
bottom is reading backward through time.

3. Save it:

```bash
git log --oneline > ../results/task1.txt
```

---

## Section 2 — Your First Commit and Undo

### 2.1 Add and Commit

1. Create a new file:

```bash
echo 'Hello, Git!' > hello.txt
```

2. Check what Git thinks changed:

```bash
git status
```

3. Stage it, then commit it:

```bash
git add hello.txt
git commit -m "Add hello file"
```
4. View the new commit:

```bash
git log --oneline 
```

5. Save the new commit:

```bash
git log --oneline -1 > ../results/task2.txt
```

---

### 2.2 Amend a Commit Message

Realized your last commit message could be better? You don't need a new
commit — you can rewrite the most recent one.

1. Fix the message:

```bash
git commit --amend -m "Add hello file (Week 2 lab)"
```

2. View the result of amended commit:

```bash
git log --oneline 
```

3. Save the amended result:

```bash
git log --oneline -1 > ../results/task3.txt
```

> 💡 `--amend` replaces the last commit entirely — it does not create a
> second one. Never amend a commit you've already pushed and shared.

---

## Section 3 — Branching

### 3.1 Create a Branch and Work on It

1. Create and switch to a new branch in one step:

```bash
git switch -c feature/greeting
```
2. Check the active branch:

```bash
git branch
```
3. Add a file that only exists on this branch:

```bash
echo 'Hi from a branch!' > greeting.txt
git add greeting.txt
git commit -m "Add greeting on feature branch"
```

4. Save the branch's history:

```bash
git log --oneline feature/greeting > ../results/task4.txt
```

---

### 3.2 Switch Back and Confirm Isolation

1. Go back to `main`:

```bash
git switch main
```

2. Notice `greeting.txt` is gone from view — it only exists on
   `feature/greeting`. Confirm which branch you're on now:

```bash
git branch --show-current > ../results/task5.txt
```

---

## Section 4 — Merging

### 4.1 A Clean Merge

1. Merge `feature/greeting` into `main`. Use `--no-ff` so Git always
   creates a merge commit, even though this one *could* fast-forward —
   that keeps the fact that a branch existed visible in the log:

```bash
git merge --no-ff feature/greeting -m "Merge feature/greeting into main"
```

2. Save the last 3 log entries:

```bash
git log --oneline -3 > ../results/task6.txt
```

---

### 4.2 Resolve a Real Conflict

`init.sh` set up `feature/conflict` so that merging it is **guaranteed**
to conflict — both it and `main` edited the same line of `README.md`.

1. Attempt the merge:

```bash
git merge feature/conflict
```

Git stops and tells you `CONFLICT (content): Merge conflict in README.md`.

2. Open `README.md`. You'll see markers like this:

```
<<<<<<< HEAD
# Week 2 Git Lab — Fundamentals

See data.txt for sample data.
=======
# Week 2 Git Lab (feature branch)
>>>>>>> feature/conflict
```

Everything between `<<<<<<< HEAD` and `=======` is **your** side; everything
between `=======` and `>>>>>>>` is the **other branch's** side. Git is
asking you to decide — it is not broken.

3. Replace the whole conflicted block with your own resolution, but make
   sure the file contains this exact line somewhere (the grader looks for
   it):

```
MERGED: combined both README updates
```

For example, replace the file's contents with:

```
# Week 2 Git Lab — Fundamentals

MERGED: combined both README updates

See data.txt for sample data.
```

4. Delete all three marker lines (`<<<<<<<`, `=======`, `>>>>>>>`) — none
   of them should remain in the file — then stage and commit:

```bash
git add README.md
git commit -m "Merge feature/conflict, resolve README conflict"
```

5. Save the result:

```bash
git log --oneline -1 > ../results/task7.txt
```

---

## Section 5 — Remote Collaboration

`origin-bare/` (created by `init.sh`) stands in for "GitHub" — a real
remote, just on your own machine, so this all works offline.

### 5.1 Add a Remote and Push

1. Point `repo/` at the simulated remote:

```bash
git remote add origin ../origin-bare
```

2. Push `main`:

```bash
git push -u origin main
```

3. Save your remote configuration:

```bash
git remote -v > ../results/task8.txt
```

---

### 5.2 Pull a Teammate's Work

1. From the **lab root** (not inside `repo/`), simulate a teammate pushing
   while you were working:

```bash
cd ..
bash simulate_teammate.sh
cd repo
```

This pushes one new commit straight into `origin-bare/` — you don't have
it locally yet.

2. Bring it in:

```bash
git pull origin main
```

3. Save the result:

```bash
git log --oneline -3 > ../results/task9.txt
```

---

## Challenge Tasks

No scripted commands here — you're given a goal and a starting scenario.
Work out the steps yourself using what you learned above.

### Challenge A — Recover a "Lost" Commit

**Scenario:** you're still in `repo/`. Make one more commit, then
accidentally throw it away with `git reset --hard` — and get it back.

1. Create the commit that you're about to "lose" — it must be exactly this:

```bash
echo "important work" > temp_work.txt
git add temp_work.txt
git commit -m "Recoverable commit"
```

2. "Accidentally" delete it:

```bash
git reset --hard HEAD~1
```

Run `git log --oneline` — it's gone from the visible history.

3. Git doesn't forget that fast. Find it:

```bash
git reflog
```

Look for the entry just before your `reset --hard` — it shows the hash of
the commit you just "lost."

4. Bring your branch back to that commit:

```bash
git reset --hard <hash-from-reflog>
```

**Success criteria:** `git log --oneline -1` shows `Recoverable commit`
again, and `temp_work.txt` is back.

```bash
git log --oneline -1 > ../results/challengeA.txt
```

---

### Challenge B — A Bigger Conflict

**Scenario:** `init.sh` also built `repo_challenge/` — a separate repo
where `main` and `feature/challenge` both edited **three** files
(`alpha.txt`, `beta.txt`, `gamma.txt`) differently.

1. Move into it:

```bash
cd ../repo_challenge
```

2. Merge `feature/challenge` into `main` and resolve **all three**
   conflicts by hand — pick whatever final content you want for each
   file, as long as no conflict markers remain anywhere and none of the
   three files end up empty.

3. Commit your resolution with exactly this message:

```bash
git commit -m "Merge feature/challenge, resolve all conflicts"
```

**Success criteria:** no file in the repo contains `<<<<<<<`, `=======`,
or `>>>>>>>`, and `alpha.txt`, `beta.txt`, `gamma.txt` all still exist with
content in them.

```bash
git log --oneline -1 > ../results/challengeB.txt
```

---

### Challenge C — A Push/Pull Race

**Scenario:** back in `repo/`, you make a new local commit — but a
teammate pushes at the same time, before you get a chance to push yours.

1. Back in `repo/`, make your own commit:

```bash
cd ../repo
echo "note" > feature_note.txt
git add feature_note.txt
git commit -m "Add feature note"
```

2. Simulate the teammate again (this is the **second** time you've run
   this script — it will add a distinctly-numbered commit):

```bash
cd ..
bash simulate_teammate.sh
cd repo
```

3. Try to push:

```bash
git push origin main
```

It gets rejected — the remote has a commit you don't have.

4. Pull first, resolve anything that conflicts, then push:

```bash
git pull --no-rebase origin main
git push origin main
```

**Success criteria:** both your commit and the teammate's commit exist in
the history, and `repo/` and `origin-bare/` are back in sync.

```bash
git log --oneline -3 > ../results/challengeC.txt
```

---

## Common Mistakes

**Task 6 — no merge commit appears**
A plain `git merge` fast-forwards silently if `main` hasn't moved since you
branched. Use `--no-ff` — the grader checks for a real merge commit with
two parents.

**Task 7 — conflict markers left behind**
Deleting only two of the three marker lines still leaves broken text in the
file. Check for `<<<<<<<`, `=======`, and `>>>>>>>` — all three must be
gone.

**Challenge C — pushing before pulling**
If you push before pulling, Git rejects it outright ("non-fast-forward").
That's expected — pull first.

**Submitting before checking**
`submit.sh` requires `results.log` to exist.
Always run `bash check.sh` before `bash submit.sh`.
