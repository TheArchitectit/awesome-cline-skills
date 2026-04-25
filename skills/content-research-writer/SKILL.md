---
name: content-research-writer
description: Assists in writing high-quality content by conducting research, adding citations, improving hooks, iterating on outlines, and providing section-by-section feedback. This skill should be used when Cline needs to help write blog posts, articles, newsletters, case studies, technical documentation, or any long-form content that benefits from research-backed insights and collaborative editing.
---

# Content Research Writer

This skill acts as a collaborative writing partner — helping research, outline, draft, and refine content while preserving your unique voice and style.

## When to Use This Skill

- Writing blog posts, articles, or newsletters
- Creating educational content or tutorials
- Drafting thought leadership pieces
- Researching and writing case studies
- Producing technical documentation with sources
- Writing with proper citations and references
- Improving hooks and introductions
- Getting section-by-section feedback while writing
- Repurposing content across formats

## What This Skill Does

1. **Collaborative Outlining**: Helps structure ideas into coherent outlines
2. **Research Assistance**: Finds relevant information and adds citations
3. **Hook Improvement**: Strengthens openings to capture attention
4. **Section Feedback**: Reviews each section as you write
5. **Voice Preservation**: Maintains your writing style and tone
6. **Citation Management**: Adds and formats references properly
7. **Iterative Refinement**: Helps improve through multiple drafts

## Process

### Step 1: Understand the Writing Project

Ask clarifying questions:
- What's the topic and main argument?
- Who's the target audience?
- What's the desired length/format?
- What's your goal? (educate, persuade, entertain, explain)
- Any existing research or sources to include?
- What's your writing style? (formal, conversational, technical)

### Step 2: Create a Collaborative Outline

Develop structure together:

```markdown
# Article Outline: [Title]

## Hook
- [Opening line/story/statistic]
- [Why reader should care]

## Introduction
- Context and background
- Problem statement
- What this article covers

## Main Sections

### Section 1: [Title]
- Key point A, Key point B
- Example/evidence
- [Research needed: specific topic]

### Section 2: [Title]
- Key point C, Key point D
- Data/citation needed

### Section 3: [Title]
- Key point E
- Counter-arguments
- Resolution

## Conclusion
- Summary of main points
- Call to action

## Research To-Do
- [ ] Find data on [topic]
- [ ] Get examples of [concept]
- [ ] Source citation for [claim]
```

**Iterate on the outline**: Adjust based on feedback, ensure logical flow, identify research gaps, and mark sections needing deep dives.

### Step 3: Conduct Research

When research is requested:
- Search for relevant information using available tools
- Find credible sources and recent data
- Extract key facts, quotes, and statistics
- Add citations in the requested format
- Note contradictions or gaps in available information

Example research output:
```markdown
## Research: [Topic]

Key Findings:

1. **[Finding 1]**: [Details] [Source citation]
2. **[Finding 2]**: [Details] [Source citation]
3. **Expert Quote**: "[Quote]" — [Name], [Title/Org] [Source citation]

Added to outline under Section [X].
```

### Step 4: Improve Hooks

When a user shares an introduction, analyze and strengthen:

**Current Hook Analysis**:
- What works: [positive elements]
- What could be stronger: [areas for improvement]

**Suggested Alternatives**:

| Approach | Example | Why It Works |
|----------|---------|-------------|
| Bold statement | "[Opening line]" | [Explanation] |
| Personal story | "[Opening line]" | [Explanation] |
| Surprising data | "[Opening line]" | [Explanation] |
| Provocative question | "[Opening line]" | [Explanation] |

**Hook Questions**:
- Does it create curiosity?
- Does it promise value?
- Is it specific enough?
- Does it match the audience?

### Step 5: Provide Section-by-Section Feedback

For each section, review:

```markdown
# Feedback: [Section Name]

## What Works Well ✓
- [Strength 1]
- [Strength 2]

## Suggestions
### Clarity
- [Issue] → [Suggested fix]

### Flow
- [Transition issue] → [Better connection]

### Evidence
- [Claim needing support] → [Add citation or example]

## Specific Line Edits

Original:
> [Quote from draft]

Suggested:
> [Improved version]

Why: [Explanation]
```

### Step 6: Preserve Writer's Voice

Important principles:
- **Learn their style**: Read existing writing samples
- **Suggest, don't replace**: Offer options, not directives
- **Match tone**: Formal, casual, technical, friendly
- **Respect choices**: If they prefer their version, support it
- **Enhance, don't override**: Make their writing better, not different

### Step 7: Citation Management

Handle references based on user preference:

**Inline**: Studies show 40% improvement (McKinsey, 2024).

**Numbered**: Studies show 40% improvement [1]. → [1] McKinsey Global Institute. (2024). "Title."

**Footnote**: Studies show 40% improvement^1 → ^1: Full citation.

Maintain a running references list throughout the writing process.

### Step 8: Final Review

When the draft is complete:
- Overall assessment of strengths and areas for refinement
- Structure and flow evaluation
- Content quality check (argument strength, evidence sufficiency)
- Technical quality review (grammar, consistency, citations)
- Pre-publish checklist: all claims sourced, citations formatted, transitions smooth

## Writing Workflows

### Blog Post
1. Outline together → 2. Research key points → 3. Write intro → feedback → 4. Write body sections → feedback each → 5. Write conclusion → 6. Polish

### Newsletter
1. Discuss hook ideas → 2. Quick outline → 3. Draft in one session → 4. Review for clarity → 5. Quick polish

### Technical Tutorial
1. Outline steps → 2. Write code examples → 3. Add explanations → 4. Test instructions → 5. Add troubleshooting → 6. Final review for accuracy

### Thought Leadership
1. Brainstorm unique angle → 2. Research existing perspectives → 3. Develop thesis → 4. Write with strong POV → 5. Add evidence → 6. Craft conclusion

## File Organization

```
writing/
└── article-name/
    ├── outline.md          # Outline and structure
    ├── research.md         # Research and citations
    ├── draft-v1.md         # First draft
    ├── draft-v2.md         # Revised draft
    └── final.md            # Publication-ready
```

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/content-research-writer/` (project-level) or `~/.cline/skills/content-research-writer/` (global)
2. **Voice preservation is critical**: Never rewrite in your own style — enhance the writer's voice, don't replace it
3. **Research with web tools**: Use Cline's browser and web fetch capabilities for research
4. **Iterative by default**: Always offer feedback and alternatives rather than single rewrites
5. **Save work frequently**: Keep drafts in numbered versions to prevent data loss
6. **Citation format flexibility**: Ask which citation style the user prefers before adding references
7. **One section at a time**: Get feedback incrementally rather than reviewing entire drafts at once

## Related Use Cases

- Creating social media posts from long-form articles
- Adapting content for different audiences and platforms
- Writing email newsletters from existing content
- Drafting technical documentation with examples
- Developing course outlines and educational materials
