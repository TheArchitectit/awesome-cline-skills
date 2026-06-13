<h1 align="center">Awesome Cline Skills</h1>

<p align="center">
  <a href="https://awesome.re">
    <img src="https://awesome.re/badge.svg" alt="Awesome" />
  </a>
  <a href="https://makeapullrequest.com">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square" alt="PRs Welcome" />
  </a>
  <a href="https://www.apache.org/licenses/LICENSE-2.0">
    <img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg?style=flat-square" alt="License: Apache-2.0" />
  </a>
  <img src="https://img.shields.io/badge/Skills-32-blueviolet.svg?style=flat-square" alt="32 Skills" />
</p>

A curated list of 32 practical Cline Skills for enhancing productivity across the [Cline](https://cline.bot) AI coding agent ecosystem.

## Contents

- [What Are Cline Skills?](#what-are-cline-skills)
- [Skills](#skills)
  - [Document Processing](#document-processing)
  - [Development & Code Tools](#development--code-tools)
  - [Data & Analysis](#data--analysis)
  - [Business & Marketing](#business--marketing)
  - [Communication & Writing](#communication--writing)
  - [Creative & Media](#creative--media)
  - [Productivity & Organization](#productivity--organization)
- [Skill Depth Legend](#skill-depth-legend)
- [Getting Started](#getting-started)
- [Creating Skills](#creating-skills)
- [Contributing](#contributing)
- [Resources](#resources)
- [License](#license)

## What Are Cline Skills?

Cline Skills are customizable on-demand workflows that teach [Cline](https://cline.bot) how to perform specific tasks according to your unique requirements. Unlike rules (which are always active via `.clinerules/`), skills are loaded on-demand when triggered — keeping your context window clean until you need specialized knowledge.

### How Skills Work

- **Progressive loading**: Skill metadata (~100 tokens) is always available. Detailed instructions load when triggered (<5k tokens). Resources are loaded as needed.
- **On-demand activation**: Use Cline's `use_skill` tool to load a skill's instructions into context.
- **Skills vs Rules**: Rules (`.clinerules/`) are always active. Skills (`.cline/skills/`) are loaded only when needed.

### Skill Locations

Skills can be installed in two places:

- **Project-level**: `.cline/skills/` in your project directory (team-shared)
- **Global**: `~/.cline/skills/` in your home directory (personal)

> **Note:** Skills are an experimental feature. Enable them in Cline via **Settings → Features → Enable Skills**.

## Skills

### Document Processing

| Skill | Description | Depth |
|-------|-------------|-------|
| [docx](./skills/docx/) | Create, edit, and analyze Word documents with tracked changes, comments, formatting preservation, and text extraction | 📖 Comprehensive |
| [pdf](./skills/pdf/) | Extract text and tables, create new PDFs, merge/split documents, handle forms, and annotate PDFs | 📖 Comprehensive |
| [pptx](./skills/pptx/) | Create, edit, and analyze PowerPoint presentations with layouts, formatting, speaker notes, charts, and visual design principles | 📖 Comprehensive |
| [xlsx](./skills/xlsx/) | Create, edit, and analyze spreadsheets with formulas, formatting, data transformation, charts, and financial model conventions using openpyxl and pandas | 📖 Comprehensive |

### Development & Code Tools

| Skill | Description | Depth |
|-------|-------------|-------|
| [api-dev](./skills/api-dev/) | REST and GraphQL API design with schema-first approach, versioning, authentication, rate limiting, error handling, and documentation | 📖 Comprehensive |
| [code-refactorer](./skills/code-refactorer/) | Refactoring with design patterns, SOLID principles, dead code elimination, performance optimization, and safe incremental workflows | 📖 Comprehensive |
| [database-manager](./skills/database-manager/) | Database operations covering schema design, migrations, query optimization, indexing, and backups for PostgreSQL, MySQL, and MongoDB | 📖 Comprehensive |
| [docker-deploy](./skills/docker-deploy/) | Containerization with Dockerfiles, Docker Compose, multi-stage builds, health checks, image optimization, and production patterns | 📖 Comprehensive |
| [game-dev](./skills/game-dev/) | Game development workflows for prototyping, mechanics design, balancing, testing, player feedback, and iteration cycles | 📖 Comprehensive |
| [git-workflow](./skills/git-workflow/) | Git best practices for branching strategies, conventional commits, pull request workflows, conflict resolution, and repository management | 📖 Comprehensive |
| [godot-helper](./skills/godot-helper/) | Godot 4.x development with scene tree patterns, GDScript best practices, signal architecture, export templates, and engine-specific workflows | 📖 Comprehensive |
| [mcp-builder](./skills/mcp-builder/) | Guides creation of high-quality MCP (Model Context Protocol) servers for integrating external APIs and services with LLMs using Python or TypeScript | 📄 Standard |
| [react-nextjs-builder](./skills/react-nextjs-builder/) | React and Next.js development with component architecture, SSR/SSG strategies, API routes, state management, and performance optimization | 📖 Comprehensive |
| [skill-creator](./skills/skill-creator/) | Provides guidance for creating effective Cline Skills that extend capabilities with specialized knowledge, workflows, and tool integrations | 📄 Standard |
| [staff-engineer-review](./skills/staff-engineer-review/) | Performs deep code review of pull requests as a Staff+ engineer, evaluating alignment, architecture, code quality, correctness, performance, and test coverage | 📄 Standard |
| [webapp-testing](./skills/webapp-testing/) | Tests local web applications using Playwright for verifying frontend functionality, debugging UI behavior, and capturing screenshots | 📄 Standard |

### Data & Analysis

| Skill | Description | Depth |
|-------|-------------|-------|
| [meeting-insights-analyzer](./skills/meeting-insights-analyzer/) | Analyzes meeting transcripts to uncover behavioral patterns, conflict avoidance, filler words, speaking ratios, and actionable communication feedback | 📄 Standard |

### Business & Marketing

| Skill | Description | Depth |
|-------|-------------|-------|
| [a-b-testing](./skills/a-b-testing/) | Design and analyze A/B tests: hypothesis framing, metric selection, sample size calculation, statistical significance evaluation, and results interpretation | 📖 Comprehensive |
| [blog-writer](./skills/blog-writer/) | Blog post creation: outlines, SEO-optimized headlines, meta descriptions, content structures, and publication-ready drafting with proper formatting | 📖 Comprehensive |
| [brand-guidelines](./skills/brand-guidelines/) | Applies consistent brand colors and typography to artifacts for professional visual identity and design standards | 📄 Standard |
| [competitive-ads-extractor](./skills/competitive-ads-extractor/) | Extract and analyze competitors' ads from ad libraries to understand messaging patterns, creative approaches, and positioning strategies | 📄 Standard |
| [domain-name-brainstormer](./skills/domain-name-brainstormer/) | Generate creative domain name ideas and check TLD availability across .com, .io, .dev, .ai, and more with branding insights | 📄 Standard |
| [email-campaigns](./skills/email-campaigns/) | Email marketing: subject line optimization, A/B test design, template creation, drip sequences, segmentation strategies, and performance tracking | 📖 Comprehensive |
| [lead-research-assistant](./skills/lead-research-assistant/) | Identify and qualify leads with ideal customer profiles, fit scoring, and personalized outreach strategies for sales and business development | 📄 Standard |
| [seo-optimizer](./skills/seo-optimizer/) | SEO analysis: keyword research, meta tag generation, structured data markup (JSON-LD), XML sitemaps, robots.txt, and technical SEO audits | 📖 Comprehensive |
| [social-media-manager](./skills/social-media-manager/) | Social media content: platform-specific post creation, hashtag research, content calendars, engagement analysis, and content repurposing across Twitter, LinkedIn, Instagram, Facebook, and Bluesky | 📖 Comprehensive |

### Communication & Writing

| Skill | Description | Depth |
|-------|-------------|-------|
| [content-research-writer](./skills/content-research-writer/) | Research-backed content writing with collaborative outlining, citation management, hook improvement, and section-by-section feedback | 📄 Standard |

### Creative & Media

| Skill | Description | Depth |
|-------|-------------|-------|
| [audio-gen](./skills/audio-gen/) | Audio generation and transcription: text-to-speech (edge-tts, Piper), speech-to-text (Whisper), format conversion, podcast production, and audio editing | 📖 Comprehensive |
| [canvas-design](./skills/canvas-design/) | Create original visual art and designs as PNG or PDF using design philosophy principles, composition, and craftsmanship | 📄 Standard |
| [image-enhancer](./skills/image-enhancer/) | Improve image and screenshot quality: resolution upscaling, sharpness correction, noise reduction, color optimization, and format conversion for docs, web, and print | 📖 Comprehensive |
| [video-frames](./skills/video-frames/) | Extract and analyze video frames, create thumbnails and sprite sheets, detect scene changes, and generate animated GIF previews | 📖 Comprehensive |

### Productivity & Organization

| Skill | Description | Depth |
|-------|-------------|-------|
| [changelog-generator](./skills/changelog-generator/) | Automatically creates user-facing changelogs from git commits by analyzing history and transforming technical commits into customer-friendly release notes | 📄 Standard |

## Skill Depth Legend

Skills are categorized by documentation depth:

- 📖 **Comprehensive** (250+ lines): Detailed guides with extensive examples, workflows, and best practices. Ideal for learning a skill in depth.
- 📄 **Standard** (50–250 lines): Well-documented skills with clear instructions and examples. Ready to use quickly with sufficient guidance.
- 📄 **Quick Reference** (<50 lines): Concise reference guides for simple tasks or frequently used commands.

## Getting Started

### Installing Skills

#### Global Installation

Install skills to your global Cline directory so they're available across all projects:

```bash
mkdir -p ~/.cline/skills/
cp -r skills/skill-name ~/.cline/skills/
```

#### Project-Local Installation

Install skills to a specific project for team sharing:

```bash
mkdir -p .cline/skills/
cp -r skills/skill-name .cline/skills/
```

### Using Skills

Once installed, skills are discoverable by Cline. When you describe a task that matches a skill's description, Cline will use its `use_skill` tool to load the skill's instructions.

You can also explicitly ask Cline to use a skill:

```
Use the docx skill to create a professional report
```

```
Use the changelog-generator skill to create release notes from the last week's commits
```

### Enabling Skills

Skills are an experimental feature in Cline. To enable them:

1. Open Cline Settings
2. Navigate to **Features**
3. Enable **Skills**

## Creating Skills

### Skill Structure

Each skill is a directory containing a `SKILL.md` file with YAML frontmatter:

```
skill-name/
├── SKILL.md          # Required: Skill instructions and metadata
├── scripts/          # Optional: Helper scripts
├── templates/        # Optional: Document templates
├── docs/             # Optional: Additional documentation
└── resources/        # Optional: Reference files
```

### Basic Skill Template

```markdown
---
name: my-skill-name
description: A clear description of what this skill does and when Cline should use it. Max 1024 characters.
---

# My Skill Name

Detailed description of the skill's purpose and capabilities.

## When to Use This Skill

- Use case 1
- Use case 2
- Use case 3

## Instructions

[Detailed instructions for Cline on how to execute this skill]

## Examples

[Real-world examples showing the skill in action]
```

### Important Rules

- The `name` field in frontmatter **must match** the directory name exactly
- The `description` field tells Cline when to use the skill (max 1,024 characters)
- Use third-person language: "This skill should be used when..." rather than "Use this skill when..."
- Write instructions for Cline (the AI agent), not for end users
- Keep SKILL.md under 5,000 words — detailed reference material goes in `docs/` or `resources/`

### Progressive Disclosure

Cline skills use three levels of loading to manage context efficiently:

1. **Metadata** (name + description) — Always in context (~100 tokens)
2. **SKILL.md body** — Loaded when the skill is triggered (<5k tokens)
3. **Bundled resources** — Loaded on-demand as needed (unlimited)

### Skill Best Practices

- Focus on specific, repeatable tasks
- Include clear examples and edge cases
- Write instructions for Cline, not for end users
- Test your skill with Cline
- Document prerequisites and dependencies
- Include error handling guidance
- Put detailed reference material in `docs/` or `resources/` directories

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- How to submit new skills
- Skill quality standards
- SKILL.md template and naming conventions
- Pull request process

### Quick Contribution Steps

1. Use the [skill template](./template/SKILL.md) as a starting point
2. Ensure your skill is based on a real use case
3. Check for duplicates in existing skills
4. The `name` in SKILL.md frontmatter must match the directory name
5. Test your skill with Cline
6. Submit a pull request with clear documentation

## Resources

### Official Documentation

- [Cline](https://cline.bot) — Cline AI coding agent
- [Cline Documentation](https://docs.cline.bot) — Official documentation
- [Cline GitHub Repository](https://github.com/cline/cline) — Source code and issues

### Community

- [Cline Discord](https://discord.gg/cline) — Discuss Cline with other users
- [Cline Reddit](https://www.reddit.com/r/cline/) — Cline community on Reddit

### Related Projects

- [Awesome OpenCode Skills](https://github.com/TheArchitectit/awesome-opencode-skills) — Skills for the OpenCode AI coding agent
- [Awesome Claude Code](https://github.com/anthropics/awesome-claude-code) — Resources for Claude Code

## License

This repository is licensed under the Apache License 2.0.

Individual skills may have different licenses — please check each skill's folder for specific licensing information.

---

**Note:** Cline Skills are compatible with Cline's skill system. Skills are automatically discovered from `.cline/skills/` (project-level) and `~/.cline/skills/` (global) directories.

---

### ☕ Support This Project

Help keep this project going — use a referral link below and both of us get credits!

| Service | Your Bonus | Details | Referral Code |
|---------|-----------|---------|---------------|
| [**Neuralwatt**](https://portal.neuralwatt.com/auth/register?ref=NW-ROGER-ET3Y) | $10 in credits | Spend $10+ → you get $10, we get $20 | `NW-ROGER-ET3Y` |
| [**Synthetic**](https://synthetic.new/?referral=UAWqkKQQLFkzMkY) | $10 in credits | Subscribe → both get $10 credit | `UAWqkKQQLFkzMkY` |


## ☁️ Cloud Credits

Power your AI projects with [Ozore.com](https://ozore.com) — use code **lundrog50** for 50% off your first month.

> `direct-pin` and `custom-router` are available on **Pro** and **Max** plans only.
