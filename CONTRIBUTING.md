# Contributing to Awesome Cline Skills

Thank you for your interest in contributing! This guide will help you submit high-quality skills to the repository.

## How to Contribute

### Submitting a New Skill

1. **Check for duplicates** — Browse existing skills to make sure your idea isn't already covered.
2. **Create your skill** — Follow the skill structure template below.
3. **Test your skill** — Verify it works with Cline before submitting.
4. **Submit a pull request** — Include a clear description of what the skill does and when to use it.

### Skill Structure

```
skills/
└── your-skill-name/
    ├── SKILL.md          # Required: Skill instructions and metadata
    ├── scripts/          # Optional: Helper scripts
    ├── templates/        # Optional: Document templates
    ├── docs/             # Optional: Additional documentation
    └── resources/        # Optional: Reference files
```

### SKILL.md Template

```markdown
---
name: your-skill-name
description: A clear description of what this skill does and when Cline should use it. Max 1024 characters.
---

# Your Skill Name

## When to Use This Skill

- Use case 1
- Use case 2

## Instructions

[Detailed instructions for Cline on how to execute this skill]

## Examples

[Real-world examples]
```

## Quality Standards

### Required

- **YAML frontmatter** with `name` (matching directory name) and `description` (max 1024 chars)
- **Clear "When to Use" section** so Cline knows when to activate the skill
- **Detailed instructions** written for Cline (the AI agent), not end users
- **Examples** showing the skill in action

### Recommended

- **Progressive disclosure** — Keep SKILL.md under 5,000 words; put detailed reference in `docs/` or `resources/`
- **Prerequisites** — Document what tools, libraries, or setup the skill requires
- **Error handling** — Include guidance for common failure modes
- **Third-person descriptions** — "This skill should be used when..." rather than "Use this skill when..."

### Skill Depth Guidelines

- 📖 **Comprehensive** (250+ lines): Complex workflows with extensive examples, edge cases, and best practices
- 📄 **Standard** (50-250 lines): Clear instructions with examples, ready to use
- 📄 **Quick Reference** (<50 lines): Concise reference for simple, frequent tasks

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-new-skill`)
3. Add your skill under `skills/your-skill-name/`
4. Update the README.md to include your skill in the appropriate category
5. Commit with a descriptive message
6. Open a pull request

### PR Checklist

- [ ] Skill directory name matches the `name` field in SKILL.md frontmatter
- [ ] Description is clear and under 1024 characters
- [ ] Instructions are written for Cline (AI agent), not end users
- [ ] Examples are included
- [ ] README.md updated with the new skill entry
- [ ] Skill has been tested with Cline

## Code of Conduct

- Be respectful and constructive
- Focus on practical, real-world use cases
- Ensure skills do not contain malicious code or instructions
- Credit original authors when adapting existing work

## Questions?

Open an issue on GitHub or start a discussion — we're happy to help!
