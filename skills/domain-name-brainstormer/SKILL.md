---
name: domain-name-brainstormer
description: Generates creative domain name ideas for projects and checks availability across multiple TLDs (.com, .io, .dev, .ai, .app, etc.). This skill should be used when Cline needs to brainstorm domain names for a new project, product, or company, check domain availability, find alternatives when a preferred name is taken, or evaluate naming options with branding insights.
---

# Domain Name Brainstormer

This skill helps find the perfect domain name by generating creative options and checking what's actually available to register across multiple TLDs.

## When to Use This Skill

- Starting a new project, product, or company
- Launching a service that needs a web presence
- Creating a personal brand or portfolio site
- Rebranding an existing project
- Finding alternatives when a first choice is taken
- Registering domains for side projects or experiments
- Checking social media handle availability alongside domains

## What This Skill Does

1. **Understands Your Project**: Analyzes what you're building and who it's for
2. **Generates Creative Names**: Creates relevant, memorable domain options
3. **Checks Availability**: Verifies which domains are actually available across TLDs
4. **Multiple Extensions**: Suggests .com, .io, .dev, .ai, .app, .co, and more
5. **Provides Alternatives**: Offers variations when top choices are taken
6. **Branding Insights**: Explains why certain names work well for the target audience

## How to Use

### Basic Brainstorming

```
I'm building a project management tool for remote teams. Suggest domain names.
```

```
Help me brainstorm domain names for a personal finance app
```

### With Specific Preferences

```
I need a domain for my AI writing assistant. Prefer short names with .ai or .io extension.
```

### With Keywords

```
Suggest domain names using the words "pixel" or "studio" for my design agency
```

## Process

### Step 1: Understand the Project

Ask clarifying questions if needed:
- What are you building? (product/service description)
- Who is the target audience?
- What mood or feeling should the name evoke?
- Any keywords or themes to include?
- Preferred TLDs (.com, .io, .dev, .ai, etc.)?
- Length preference? (short/punchy vs. descriptive)
- Avoid any words or themes?

### Step 2: Generate Name Categories

Create names across multiple categories:

**Descriptive Names**: Directly describe what the product does
- Example: `taskboard.com`, `codeclip.io`

**Metaphorical Names**: Use imagery or concepts related to the product
- Example: `nest.dev`, `beacon.ai`

**Portmanteau Names**: Blend two relevant words
- Example: `devsync.com`, `flowstate.io`

**Abstract/Brandable Names**: Short, memorable, open to interpretation
- Example: `notion.so`, `figma.com`

**Action-Oriented Names**: Use verbs that describe the user benefit
- Example: `launchkit.dev`, `buildfast.io`

### Step 3: Check Availability

Use DNS lookup or WHOIS to check domain availability:

```python
import socket
import dns.resolver

def check_domain(domain):
    """Check if a domain is likely available (no DNS records)."""
    try:
        socket.gethostbyname(domain)
        return False  # Domain resolves, likely taken
    except socket.gaierror:
        try:
            dns.resolver.resolve(domain, 'NS')
            return False  # Has nameservers, taken
        except:
            return True  # No records found, likely available
```

Note: DNS absence doesn't guarantee availability. For definitive checks, use a registrar API.

### Step 4: Present Results

```markdown
# Domain Name Suggestions

## [Project Type] - [Brief Description]

### Available (.com)
1. ✅ **snippetbox.com** - Clear, memorable
   Why: Directly describes the product, easy to remember

2. ✅ **codeclip.com** - Short and snappy
   Why: Implies quick sharing, only 8 characters

### Available (Alternative TLDs)
3. ✅ **snippet.dev** - Perfect for developers
   Why: .dev extension signals developer tool

4. ✅ **codebox.io** - Tech-forward
   Why: .io popular with tech startups

### Taken/Premium
- codeshare.com (Taken)
- snippets.com (Premium, est. $2,500)

### 🏆 Top Pick
**snippet.dev** — Perfect for developer audience, short and memorable, available now!
```

## TLD Selection Guide

| TLD | Best For | Typical Cost |
|-----|----------|-------------|
| .com | Universal, businesses, broad appeal | $10-15/yr |
| .io | Tech startups, developer tools | $30-50/yr |
| .dev | Developer-focused products | $10-15/yr |
| .ai | AI/ML products | $50-100/yr |
| .app | Mobile and web applications | $10-15/yr |
| .co | Alternative to .com, startups | $10-25/yr |
| .xyz | Modern, creative projects | $1-10/yr |
| .design | Design agencies, creative work | $30-50/yr |
| .tech | Technology companies | $10-40/yr |
| .so | Startups (popular with Notion-style brands) | $30-50/yr |

## Domain Naming Tips

### What Makes a Good Domain
- ✅ **Short**: Under 15 characters ideal
- ✅ **Memorable**: Easy to recall and spell
- ✅ **Pronounceable**: Can be said in conversation
- ✅ **Descriptive**: Hints at what you do
- ✅ **Brandable**: Unique enough to stand out
- ✅ **No hyphens**: Easier to share verbally
- ✅ **No numbers**: Avoid confusion (is it "5" or "five"?)

### Common Mistakes
- ❌ Too long or complex to spell
- ❌ Unintended word combinations (watch for hidden words in concatenated names)
- ❌ Hard to pronounce over the phone
- ❌ Overusing trendy TLDs when .com is available
- ❌ Names that limit future product expansion

## Advanced Features

### Check Similar Variations

```
Check availability for "codebase" and similar variations across .com, .io, .dev
```

### Competitor Domain Analysis

```
Show me domain patterns used by successful [industry] tools, then suggest similar available ones
```

### Social Media Handle Consistency

```
Check if [domain name] is also available on Twitter/X, GitHub, and LinkedIn
```

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/domain-name-brainstormer/` (project-level) or `~/.cline/skills/domain-name-brainstormer/` (global)
2. **Availability checking**: Use DNS lookups for quick checks; for definitive results, suggest the user verify with a registrar
3. **Creative generation**: Generate at least 10-15 options across multiple categories before checking availability
4. **Client-side verification**: Always remind users to verify availability before purchasing, as DNS checks are not definitive
5. **Prioritize .com**: Unless the user specifies otherwise, always include .com options alongside alternative TLDs
6. **Rate limiting**: When using registrar APIs for bulk availability checks, add delays between requests

## Related Use Cases

- Logo design consultation for chosen domain
- Brand identity planning (colors, typography)
- Social media handle availability research
- Trademark conflict checking
- Launch page or landing page creation
