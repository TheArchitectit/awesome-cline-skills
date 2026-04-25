---
name: skill-creator
description: Guide for creating effective Cline Skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Cline's capabilities with specialized knowledge, workflows, or tool integrations.
---

# Skill Creator

This skill provides guidance for creating effective Cline Skills.

## About Cline Skills

Skills are modular, self-contained packages that extend Cline's capabilities by providing specialized knowledge, workflows, and tools. Unlike rules (which are always active via `.clinerules/`), skills are loaded on-demand when triggered — keeping Cline's context window clean until specialized knowledge is needed.

### What Skills Provide

1. **Specialized workflows** — Multi-step procedures for specific domains
2. **Tool integrations** — Instructions for working with specific file formats or APIs
3. **Domain expertise** — Company-specific knowledge, schemas, business logic
4. **Bundled resources** — Scripts, references, and assets for complex and repetitive tasks

### Anatomy of a Skill

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required, must match directory name exactly)
│   │   └── description: (required, max 1024 chars)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── docs/             - Additional documentation loaded as needed
    ├── templates/        - Document or code templates
    └── resources/        - Reference files
```

#### SKILL.md (required)

**Metadata Quality:** The `name` and `description` in YAML frontmatter determine when Cline will use the skill. Be specific about what the skill does and when to use it. Use the third-person (e.g., "This skill should be used when..." instead of "Use this skill when...").

**Critical Rule:** The `name` field in frontmatter must match the directory name exactly. For example, a skill in directory `pdf-editor/` must have `name: pdf-editor` in its frontmatter.

#### Bundled Resources (optional)

##### Scripts (`scripts/`)

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by Cline for patching or environment-specific adjustments

##### Docs (`docs/`)

Additional documentation and reference material intended to be loaded as needed into context.

- **When to include**: For documentation that Cline should reference while working
- **Examples**: `docs/api_reference.md`, `docs/workflow_guide.md`
- **Use cases**: Database schemas, API documentation, domain knowledge, company policies, detailed workflow guides
- **Benefits**: Keeps SKILL.md lean, loaded only when Cline determines it's needed
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md

##### Templates (`templates/`)

Document or code templates that Cline can copy and modify for output.

- **When to include**: When the skill produces output following a consistent pattern
- **Examples**: `templates/report_header.md`, `templates/api_server.py`
- **Benefits**: Ensures consistent output, reduces token usage by avoiding inline templates

### Progressive Disclosure Design Principle

Cline Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** — Always in context (~100 tokens)
2. **SKILL.md body** — When skill triggers (<5k tokens)
3. **Bundled resources** — As needed by Cline (Unlimited*)

*Unlimited because scripts can be executed without reading into context window.

## Skill Creation Process

To create a skill, follow these steps in order, skipping steps only if there is a clear reason why they are not applicable.

### Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood.

To create an effective skill, clearly understand concrete examples of how the skill will be used. This understanding can come from either direct user examples or generated examples that are validated with user feedback.

For example, when building an image-editor skill, relevant questions include:

- "What functionality should the image-editor skill support? Editing, rotating, anything else?"
- "Can you give some examples of how this skill would be used?"
- "I can imagine users asking for things like 'Remove the red-eye from this image' or 'Rotate this image'. Are there other ways you imagine this skill being used?"
- "What would a user say that should trigger this skill?"

To avoid overwhelming users, avoid asking too many questions in a single message. Start with the most important questions and follow up as needed.

Conclude this step when there is a clear sense of the functionality the skill should support.

### Step 2: Planning the Reusable Skill Contents

To turn concrete examples into an effective skill, analyze each example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, docs, templates, and resources would be helpful when executing these workflows repeatedly

Example: When building a `pdf-editor` skill to handle queries like "Help me rotate this PDF," the analysis shows:

1. Rotating a PDF requires re-writing the same code each time
2. A `scripts/rotate_pdf.py` script would be helpful to store in the skill

Example: When designing a `frontend-webapp-builder` skill for queries like "Build me a todo app," the analysis shows:

1. Writing a frontend webapp requires the same boilerplate HTML/React each time
2. A `templates/hello-world/` template containing boilerplate project files would be helpful

Example: When building a `big-query` skill to handle queries like "How many users have logged in today?" the analysis shows:

1. Querying BigQuery requires re-discovering the table schemas and relationships each time
2. A `docs/schema.md` file documenting the table schemas would be helpful

### Step 3: Initialize the Skill Directory

Create the skill directory structure:

```bash
mkdir -p skill-name/{scripts,docs,templates,resources}
```

Create the SKILL.md file with proper frontmatter:

```markdown
---
name: skill-name
description: Clear description of what this skill does and when Cline should use it.
---

# Skill Name

## When to Use This Skill

- [Use cases]

## Instructions

[Detailed instructions for Cline]

## Examples

[Real-world examples]
```

### Step 4: Edit the Skill

When editing the skill, remember that the skill is being created for another instance of Cline to use. Focus on including information that would be beneficial and non-obvious to Cline. Consider what procedural knowledge, domain-specific details, or reusable assets would help another Cline instance execute these tasks more effectively.

#### Start with Reusable Skill Contents

To begin implementation, start with the reusable resources identified above: `scripts/`, `docs/`, `templates/`, and `resources/` files. Note that this step may require user input. For example, when implementing a `brand-guidelines` skill, the user may need to provide brand assets or templates to store in `templates/`, or documentation to store in `docs/`.

Also, delete any example files and directories not needed for the skill.

#### Update SKILL.md

**Writing Style:** Write the entire skill using **imperative/infinitive form** (verb-first instructions), not second person. Use objective, instructional language (e.g., "To accomplish X, do Y" rather than "You should do X"). This maintains consistency and clarity for AI consumption.

To complete SKILL.md, answer the following questions:

1. What is the purpose of the skill, in a few sentences?
2. When should the skill be used?
3. In practice, how should Cline use the skill? All reusable skill contents developed above should be referenced so that Cline knows how to use them.

### Step 5: Validate the Skill

Verify the skill meets these requirements:

- [ ] SKILL.md exists in the skill directory
- [ ] YAML frontmatter has `name` field matching directory name exactly
- [ ] YAML frontmatter has `description` field under 1024 characters
- [ ] Description is written in third-person ("This skill should be used when...")
- [ ] Instructions are written for Cline (AI agent), not end users
- [ ] SKILL.md is under 5,000 words (put detailed reference in `docs/`)
- [ ] Optional directories only exist if they contain content
- [ ] Examples are included

### Step 6: Install and Test

Install the skill and test it with Cline:

1. Copy the skill to `.cline/skills/` (project) or `~/.cline/skills/` (global)
2. Start Cline and trigger the skill
3. Verify the skill loads and executes correctly
4. Iterate on any issues found

## Skill Installation Paths

Cline discovers skills from these locations:

- **Project-level**: `.cline/skills/skill-name/` — Shared with team via version control
- **Global**: `~/.cline/skills/skill-name/` — Available across all projects

## Tips

- Focus on specific, repeatable tasks
- Include clear examples and edge cases
- Write instructions for Cline, not end users
- Test with Cline before sharing
- Document prerequisites and dependencies
- Include error handling guidance
- Put reference material in `docs/` to keep SKILL.md lean
