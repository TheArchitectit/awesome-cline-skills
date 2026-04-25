---
name: changelog-generator
description: Automatically creates user-facing changelogs from git commits by analyzing commit history, categorizing changes, and transforming technical commits into clear, customer-friendly release notes. This skill should be used when preparing release notes, creating weekly or monthly product update summaries, or documenting changes for customers and users.
---

# Changelog Generator

This skill transforms technical git commits into polished, user-friendly changelogs that customers and users will actually understand and appreciate.

## Prerequisites

- **Git**: Required for reading commit history
- **Repository access**: Must be run from a git repository root
- **Optional**: Custom changelog style guide (CHANGELOG_STYLE.md)

## When to Use This Skill

- Preparing release notes for a new version
- Creating weekly or monthly product update summaries
- Documenting changes for customers
- Writing changelog entries for app store submissions
- Generating update notifications
- Creating internal release documentation
- Maintaining a public changelog/product updates page

## What This Skill Does

1. **Scans Git History** — Analyzes commits from a specific time period or between versions
2. **Categorizes Changes** — Groups commits into logical categories (features, improvements, bug fixes, breaking changes, security)
3. **Translates Technical → User-Friendly** — Converts developer commits into customer language
4. **Formats Professionally** — Creates clean, structured changelog entries
5. **Filters Noise** — Excludes internal commits (refactoring, tests, etc.)
6. **Follows Best Practices** — Applies changelog guidelines and brand voice

## How to Use

### Basic Usage

From your project repository:

```
Create a changelog from commits since last release
```

```
Generate changelog for all commits from the past week
```

```
Create release notes for version 2.5.0
```

### With Specific Date Range

```
Create a changelog for all commits between March 1 and March 15
```

### With Custom Guidelines

```
Create a changelog for commits since v2.4.0, using my changelog guidelines from CHANGELOG_STYLE.md
```

## Process

### Step 1: Gather Commits

Run the appropriate git command to collect commits:

```bash
# Commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Commits from the past N days
git log --since="7 days ago" --oneline

# Commits between two versions
git log v2.4.0..v2.5.0 --oneline

# Full commit details
git log --since="7 days ago" --format="%H|%s|%an|%ad" --date=short
```

### Step 2: Categorize Changes

Group each commit into one of these categories:

| Category | Emoji | Include When |
|----------|-------|--------------|
| New Features | ✨ | New user-facing functionality |
| Improvements | 🔧 | Enhancements to existing features |
| Bug Fixes | 🐛 | Fixes for user-reported issues |
| Breaking Changes | ⚠️ | Changes that break backward compatibility |
| Security | 🔒 | Security-related fixes |
| Performance | ⚡ | Performance improvements |
| Deprecations | 📦 | Features being phased out |

### Step 3: Transform Technical → User-Friendly

For each commit, rewrite the technical description in user-friendly language:

| Technical Commit | User-Friendly |
|-----------------|---------------|
| `feat: add pagination to /api/users` | **User Directory Pagination**: Browse large user lists more easily with page-by-page navigation |
| `fix: resolve null pointer in payment processor` | **Payment Processing Fix**: Resolved issue where some payments would fail to process |
| `refactor: migrate auth to OAuth2` | *(Exclude — internal change)* |
| `perf: optimize DB queries for dashboard` | **Faster Dashboard**: Dashboard now loads 2x faster with optimized data queries |

**Filter out**: internal refactoring, test updates, CI/CD changes, dependency bumps, code style fixes

### Step 4: Format the Changelog

```markdown
# What's New - [Version/Date Range]

## ✨ New Features

- **[Feature Name]**: [User-friendly description of what it does and why it matters]

## 🔧 Improvements

- **[Improved Feature]**: [What changed and the benefit to users]

## 🐛 Bug Fixes

- [Description of what was fixed in user terms]

## ⚠️ Breaking Changes

- [What changed and what users need to do differently]

## 🔒 Security

- [Security improvements made]
```

### Step 5: Review and Refine

- Ensure all entries are in user-friendly language
- Verify no internal/technical jargon remains
- Check that categories are correct
- Remove any entries that don't affect users
- Ensure the tone matches your brand

## Example

**User**: "Create a changelog for commits from the past 7 days"

**Output**:
```markdown
# Updates - Week of March 10, 2024

## ✨ New Features

- **Team Workspaces**: Create separate workspaces for different projects. Invite team members and keep everything organized.

- **Keyboard Shortcuts**: Press ? to see all available shortcuts. Navigate faster without touching your mouse.

## 🔧 Improvements

- **Faster Sync**: Files now sync 2x faster across devices
- **Better Search**: Search now includes file contents, not just titles

## 🐛 Fixes

- Fixed issue where large images wouldn't upload
- Resolved timezone confusion in scheduled posts
- Corrected notification badge count
```

## Tips

- Run from your git repository root
- Specify date ranges for focused changelogs
- Use your CHANGELOG_STYLE.md for consistent formatting
- Review and adjust the generated changelog before publishing
- Save output directly to CHANGELOG.md
