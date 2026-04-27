# Contributing to Awesome Cline Skills

First off, thank you for contributing! 🎉 This project thrives because of community contributions. Whether you're fixing a typo, adding a new skill, or improving an existing one — we appreciate it.

## Table of Contents

- [How to Contribute](#how-to-contribute)
- [Skill Quality Standards](#skill-quality-standards)
- [SKILL.md Template](#skillmd-template)
- [Naming Conventions](#naming-conventions)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## How to Contribute

### Adding a New Skill

1. **Check for duplicates** — Browse [existing skills](./skills/) to make sure your idea isn't already covered
2. **Fork the repository** — Click the Fork button on GitHub
3. **Create your skill directory** — Add a new folder under `skills/` with a `SKILL.md` file
4. **Follow the template** — Use the [SKILL.md template](#skillmd-template) below
5. **Test with Cline** — Install your skill locally and verify it works
6. **Submit a pull request** — Open a PR against the `main` branch

### Improving an Existing Skill

1. **Identify the skill** — Find the skill directory in `skills/`
2. **Make focused changes** — Keep edits targeted and explain your reasoning
3. **Test the changes** — Verify the skill still works correctly
4. **Submit a pull request** — Describe what you improved and why

### Fixing Typos or Documentation

Small fixes are always welcome — just fork, edit, and submit a PR. No need to open an issue first.

## Skill Quality Standards

Every skill in this repository must meet these standards:

### Required

| Standard | Requirement |
|----------|-------------|
| **YAML frontmatter** | Must have `name` and `description` fields |
| **Name match** | `name` field must match the directory name exactly |
| **Description** | Under 1,024 characters; describes what the skill does and when to use it |
| **Substantive body** | Not a placeholder — must contain real, actionable instructions |
| **Cline terminology** | Must reference `.cline/skills/`, `use_skill`, or Cline workflow patterns |
| **Working** | Must be tested with Cline before submission |

### Recommended

| Standard | Guideline |
|----------|-----------|
| **Length** | Under 500 lines in SKILL.md (put reference content in `docs/` or `resources/`) |
| **Error handling** | Include guidance for common failure modes and edge cases |
| **Examples** | Provide at least 2 concrete examples of the skill in action |
| **Prerequisites** | Document any tools, packages, or setup needed |
| **Third-person description** | Write descriptions as "This skill should be used when..." rather than "Use this skill when..." |

### Depth Categories

Skills are categorized by documentation depth:

- 📖 **Comprehensive** (250+ lines): Detailed guides with extensive examples, workflows, and best practices
- 📄 **Standard** (50–250 lines): Well-documented skills with clear instructions and examples
- 📄 **Quick Reference** (<50 lines): Concise reference guides for simple tasks

### What Makes a Great Skill Description

The `description` field is critical — it tells Cline when to activate your skill. Good descriptions:

✅ **Do:**
- Start with "This skill should be used when..."
- List specific triggers and use cases
- Mention key capabilities
- Stay under 1,024 characters

❌ **Don't:**
- Use vague language ("helps with stuff")
- Write marketing copy ("the ultimate amazing skill")
- Omit the when-to-use context

**Example — Good:**
```
Game development workflows covering prototyping, mechanics design, balancing, testing, and iteration cycles. This skill should be used when building games, prototyping gameplay systems, designing mechanics, balancing difficulty curves, or implementing game loops and player feedback systems.
```

**Example — Bad:**
```
A game dev skill.
```

## SKILL.md Template

```markdown
---
name: your-skill-name
description: Clear description of what this skill does and when Cline should use it (max 1024 characters). This skill should be used when...
---

# Your Skill Name

Brief overview of the skill's purpose and capabilities.

## When to Use This Skill

- Use case 1
- Use case 2
- Use case 3

## Instructions

### Step 1: Initial Assessment

[How Cline should evaluate the task]

### Step 2: Execution

[Detailed instructions for Cline on how to execute this skill]

### Step 3: Validation

[How to verify the skill produced correct output]

## Best Practices

- Best practice 1
- Best practice 2
- Best practice 3

## Common Pitfalls

- Pitfall 1 and how to avoid it
- Pitfall 2 and how to avoid it

## Examples

### Example 1: [Descriptive Title]

**Input**: [What the user asks]

**Output**: [What Cline should produce]

### Example 2: [Descriptive Title]

**Input**: [What the user asks]

**Output**: [What Cline should produce]

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/your-skill-name/` (project-level) or `~/.cline/skills/your-skill-name/` (global)
2. **Activation**: Cline will suggest this skill when you [describe trigger conditions]
3. **Progressive loading**: Only metadata loads initially; full instructions activate via `use_skill` when needed
```

### Skill Directory Structure

```
your-skill-name/
├── SKILL.md          # Required: Skill instructions and metadata
├── scripts/          # Optional: Helper scripts
├── templates/        # Optional: Document templates
├── docs/             # Optional: Additional documentation
└── resources/        # Optional: Reference files
```

## Naming Conventions

### Skill Directory Names

- Use **lowercase kebab-case**: `api-dev`, `code-refactorer`, `react-nextjs-builder`
- Be **specific and descriptive**: `api-dev` ✅ vs `api` ❌
- Avoid **abbreviations** unless universally understood: `seo-optimizer` ✅ vs `seo-opt` ❌
- Keep names **under 30 characters** when possible
- The directory name must match the `name` field in SKILL.md exactly

### Name Patterns

| Pattern | Example | Use When |
|---------|---------|----------|
| `verb-noun` | `changelog-generator` | Skill performs an action |
| `noun-qualifier` | `api-dev` | Skill focuses on a domain |
| `platform-specific` | `godot-helper` | Skill is platform-specific |
| `role-based` | `staff-engineer-review` | Skill acts in a specific role |

## Pull Request Process

### Before Submitting

1. **Validate your skill**: Ensure the YAML frontmatter parses, name matches directory, description is under 1,024 characters
2. **Test with Cline**: Install the skill and verify it works correctly
3. **Check formatting**: Ensure markdown is clean and well-structured
4. **One skill per PR**: Keep PRs focused — one new skill or one improvement per PR

### PR Template

When submitting a PR, include:

```markdown
## Skill Name
[skill-name]

## Description
[Brief description of what this skill does]

## Testing
- [ ] Tested with Cline locally
- [ ] YAML frontmatter validates
- [ ] Description is under 1,024 characters
- [ ] Name matches directory name

## Screenshots/Output
[If applicable, show the skill in action]
```

### Review Process

1. A maintainer will review your PR within a few days
2. We may suggest changes — this is normal and meant to improve quality
3. Once approved, your skill will be merged and appear in the README

### PR Tips

- **Write clear commit messages**: `feat: add game-dev skill` or `fix: update pdf skill description`
- **Keep PRs small**: Easier to review and faster to merge
- **Respond to feedback**: We want to merge your PR — help us help you

## Reporting Issues

Found a bug in an existing skill? Open an issue with:

1. **Skill name**: Which skill has the problem
2. **Description**: What went wrong
3. **Steps to reproduce**: How to trigger the issue
4. **Expected vs actual**: What should happen vs what does happen

## Questions?

- Open a [GitHub Issue](https://github.com/TheArchitectit/awesome-cline-skills/issues)
- Join the [Cline Discord](https://discord.gg/cline) community

---

Thank you for contributing to Awesome Cline Skills! 🚀
