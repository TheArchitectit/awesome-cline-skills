---
name: git-workflow
description: Git version control best practices covering branching strategies, commit conventions, pull request workflows, conflict resolution, and repository management. This skill should be used when setting up Git workflows, writing conventional commits, resolving merge conflicts, managing branches, or establishing team Git standards.
---

# Git Workflow

This skill provides structured guidance for Git version control best practices, covering branching strategies, commit conventions, pull request workflows, and conflict resolution patterns.

## Prerequisites

- Git installed and configured
- Access to a Git repository (GitHub, GitLab, Bitbucket)
- Basic Git command knowledge

## When to Use This Skill

- Setting up a branching strategy for a team
- Writing consistent, useful commit messages
- Managing pull requests and code reviews
- Resolving merge conflicts
- Recovering from Git mistakes
- Establishing team Git conventions

## Branching Strategies

### Strategy Comparison

| Strategy | Best For | Complexity | Branch Types |
|----------|----------|------------|-------------|
| **Trunk-Based** | CI/CD, small teams | Low | main + short-lived feature branches |
| **GitHub Flow** | Open source, continuous deploy | Low | main + feature branches + PRs |
| **Git Flow** | Scheduled releases, complex projects | High | main, develop, feature, release, hotfix |
| **Release Train** | Multiple supported versions | Medium | main + release branches |

### Trunk-Based Development (Recommended for Most Teams)

```
main ─────●────●────●────●────●────●────●────
           \  /      \  /      \  /
feat/a     ●─●       │         │
feat/b              ●─●       │
feat/c                        ●─●

Rules:
- Feature branches live < 2 days
- Merge to main via PR (or direct if small)
- Main is always deployable
- Feature flags for incomplete work
```

### GitHub Flow

```
main ─────●─────────────●──────────●────
           \           / \         /
feat/a     ●─●─●─●──PR    │       │
feat/b                    ●─●─●─PR

Rules:
- Create branch from main
- Add commits with descriptive messages
- Open a pull request for discussion
- Review, approve, and merge
- Delete branch after merge
```

### Branch Naming Convention

```
<type>/<ticket>-<short-description>

Types:
  feat/     New feature
  fix/      Bug fix
  refactor/ Code refactoring
  docs/     Documentation
  test/     Test additions/changes
  chore/    Build, CI, tooling

Examples:
  feat/AUTH-123-add-oauth-login
  fix/PAY-456-handle-null-discount
  refactor/CORE-789-extract-validator
```

## Commit Conventions

### Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

#### Types

| Type | When to Use | Example |
|------|------------|---------|
| `feat` | New feature | `feat(auth): add OAuth2 login flow` |
| `fix` | Bug fix | `fix(payments): handle null discount code` |
| `refactor` | Code restructure (no behavior change) | `refactor(api): extract validation helpers` |
| `docs` | Documentation only | `docs(readme): add setup instructions` |
| `test` | Test additions/changes | `test(auth): add login failure cases` |
| `chore` | Build, CI, tooling | `chore(deps): bump next to 14.1` |
| `perf` | Performance improvement | `perf(query): add index for user lookups` |
| `style` | Formatting, whitespace | `style(lint): fix trailing commas` |

#### Commit Message Rules

1. **Imperative mood** — "add feature" not "added feature" or "adds feature"
2. **Subject ≤ 72 characters** — Short and scannable
3. **No period at end** — It's a title, not a sentence
4. **Blank line between subject and body** — Standard Git format
5. **Body explains why, not what** — The diff shows what; explain motivation
6. **Reference issues in footer** — `Closes #123` or `Refs #456`

```bash
# ✅ Good commits
git commit -m "feat(api): add rate limiting to public endpoints

Implemented sliding window rate limiter using Redis.
Anonymous: 30/min, Authenticated: 100/min, Premium: 300/min.

Closes #234"

git commit -m "fix(auth): prevent session fixation on login

Regenerate session ID after successful authentication
to prevent session fixation attacks."

# ❌ Bad commits
git commit -m "fixed stuff"
git commit -m "WIP"
git commit -m "changes"
git commit -m "update"
```

### Atomic Commits

Each commit should represent one logical change:

```bash
# ✅ Atomic: Each commit is one coherent change
git commit -m "feat(auth): add login endpoint"
git commit -m "test(auth): add login endpoint tests"
git commit -m "docs(api): document login endpoint"

# ❌ Non-atomic: Mixed concerns in one commit
git commit -m "add login, fix bug, update docs"

# ❌ Over-split: One logical change across multiple commits
git commit -m "add login part 1"
git commit -m "add login part 2"
git commit -m "add login part 3"
```

## Pull Request Workflows

### PR Template

```markdown
## Summary
<!-- Brief description of what this PR does and why -->

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation
- [ ] Test
- [ ] Chore

## How to Test
1. Step-by-step instructions
2. Expected behavior

## Checklist
- [ ] Tests pass
- [ ] No breaking changes (or documented if there are)
- [ ] Self-reviewed the diff
- [ ] Updated relevant documentation

## Related Issues
Closes #
```

### PR Size Guidelines

| Size | Lines Changed | Action |
|------|--------------|--------|
| 🟢 Small | < 200 | Quick review, approve readily |
| 🟡 Medium | 200–500 | Thorough review, same day |
| 🔴 Large | 500+ | Break into smaller PRs if possible |

### Code Review Checklist

- **Correctness**: Does it do what the PR says?
- **Edge cases**: Are error cases handled?
- **Security**: Any injection, auth, or data exposure risks?
- **Performance**: N+1 queries, unnecessary loops, missing indexes?
- **Tests**: Are new behaviors tested?
- **Naming**: Variables, functions, files clearly named?
- **Docs**: Are public APIs documented?

### Review Etiquette

```
# ✅ Constructive feedback
"Consider extracting this into a helper function — it would be 
reusable in the settings page too."

"Nit: This variable name could be more descriptive. `userCount` 
instead of `n`?"

# ❌ Unhelpful feedback
"Wrong."
"This is bad."
"Change this."
```

## Conflict Resolution

### Prevention

1. **Pull/rebase frequently** — At least daily from main
2. **Small PRs** — Fewer changes = fewer conflicts
3. **Communicate** — Tell teammates about files you're changing
4. **Separate concerns** — Don't modify the same file for unrelated features
5. **Short-lived branches** — The longer a branch lives, the more it drifts

### Resolution Process

```bash
# Step 1: Update your branch with latest main
git checkout main
git pull origin main
git checkout feature/my-branch
git rebase main

# Step 2: When conflicts occur
# Git marks conflicts in the file:
# <<<<<<< HEAD (your changes)
# your code
# =======
# their code
# >>>>>>> main (incoming changes)

# Step 3: Resolve each conflict manually
# - Open each conflicted file
# - Choose: yours, theirs, or a combination
# - Remove conflict markers (<<<<<<, =======, >>>>>>>)

# Step 4: Mark as resolved and continue
git add <resolved-file>
git rebase --continue

# Step 5: Force push (rebase rewrites history)
git push --force-with-lease origin feature/my-branch
```

### Conflict Resolution Strategies

| Strategy | When to Use | Command |
|----------|------------|---------|
| **Manual** | Complex conflicts | Edit file, choose best of both |
| **Accept ours** | Your change supersedes | `git checkout --ours <file>` |
| **Accept theirs** | Their change supersedes | `git checkout --theirs <file>` |
| **Combine** | Both changes needed | Edit to include both logically |

## Recovery Commands

### Undo Last Commit (keep changes)

```bash
git reset --soft HEAD~1      # Undo commit, keep staged
git reset --mixed HEAD~1     # Undo commit, keep unstaged (default)
git reset --hard HEAD~1      # Undo commit, discard changes ⚠️
```

### Amend Last Commit

```bash
# Fix commit message
git commit --amend -m "correct message"

# Add forgotten files
git add forgotten-file.js
git commit --amend --no-edit
```

### Recover Deleted Branch

```bash
# Find the commit SHA
git reflog
# a1b2c3d HEAD@{5}: checkout: moving from feature/lost to main

# Recreate the branch
git branch feature/lost a1b2c3d
```

### Clean Up

```bash
# Remove merged local branches
git branch --merged main | grep -v "main" | xargs git branch -d

# Remove stale remote-tracking references
git remote prune origin

# Interactive rebase to clean up commits (before push)
git rebase -i HEAD~3  # Edit last 3 commits
```

## Repository Setup

### Initial Configuration

```bash
# Essential config
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase true

# Helpful aliases
git config --global alias.st "status -sb"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.lg "log --oneline --graph --decorate -20"
git config --global alias.last "log -1 HEAD --stat"

# Conventional commit template
git config --global commit.template ~/.gitmessage
```

### .gitignore Template

```
# Dependencies
node_modules/
vendor/
.venv/

# Build output
dist/
build/
*.min.js
*.min.css

# Environment
.env
.env.*
!.env.example

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Coverage
coverage/
.nyc_output/
```

## Tips

- Commit early and often locally; squash before pushing if needed
- Use `git push --force-with-lease` instead of `--force` — it checks for remote changes
- Write the PR description before the code — it clarifies your thinking
- Keep main green: CI should pass before merge, and main should always be deployable
- Use `git stash` to temporarily shelve work: `git stash push -m "WIP: auth refactor"`
- Review your own PR before assigning reviewers — you'll catch obvious issues first
- Rebase feature branches onto main rather than merging main into them (cleaner history)

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/git-workflow/` (project-level) or `~/.cline/skills/git-workflow/` (global)
2. **Activation**: Cline will suggest this skill when you need branching strategies, commit conventions, or PR workflows
3. **Progressive loading**: Metadata is always in context; detailed Git patterns load on demand via `use_skill`
