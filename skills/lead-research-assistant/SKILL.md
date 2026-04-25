---
name: lead-research-assistant
description: Identifies high-quality leads for products or services by analyzing business context, searching for target companies, and providing actionable contact strategies with outreach messaging. This skill should be used when Cline needs to find potential customers, build prospect lists, qualify leads, research companies matching an ideal customer profile, or prepare outreach strategies for sales and business development.
---

# Lead Research Assistant

This skill helps identify and qualify potential leads by analyzing your product/service, understanding your ideal customer profile (ICP), and providing actionable outreach strategies with personalized messaging.

## When to Use This Skill

- Finding potential customers or clients for a product/service
- Building a list of companies to reach out to for partnerships
- Identifying target accounts for sales outreach
- Researching companies that match your ideal customer profile
- Preparing for business development activities
- Qualifying leads before investing outreach effort
- Preparing personalized outreach messaging

## What This Skill Does

1. **Understands Your Business**: Analyzes your product/service, value proposition, and target market
2. **Identifies Target Companies**: Finds companies matching your ICP based on industry, size, tech stack, growth signals
3. **Prioritizes Leads**: Ranks companies by fit score and relevance
4. **Provides Contact Strategies**: Suggests personalized outreach approaches
5. **Enriches Data**: Gathers information about decision-makers and company context

## How to Use

### Basic Usage

```
I'm building [product description]. Find me 10 companies in [location/industry] that would be good leads.
```

### With Codebase Context

For better results, run from your product's source code directory:

```
Look at what I'm building in this repository and identify the top 10 companies in [location/industry] that would benefit from this product.
```

### Advanced With ICP Details

```
My product: [description]
Ideal customer profile:
- Industry: [industry]
- Company size: [size range]
- Location: [location]
- Current pain points: [pain points]
- Technologies they use: [tech stack]

Find me 20 qualified leads with contact strategies for each.
```

## Process

### Step 1: Understand the Product/Service

- If in a codebase directory, analyze the codebase to understand the product
- Ask clarifying questions about the value proposition
- Identify key features, benefits, and differentiation
- Understand what problems it solves and for whom

### Step 2: Define Ideal Customer Profile

Determine:
- Target industries and sectors
- Company size ranges (employees, revenue)
- Geographic preferences or constraints
- Relevant pain points the product addresses
- Technology requirements or compatibility
- Budget indicators (funding stage, spending patterns)
- Buying signals (job postings, recent news, expansion)

### Step 3: Research and Identify Leads

Search for companies matching the criteria:
- Industry directories and databases
- Job postings indicating need
- Technology stack signals (tools they use)
- Recent funding or growth announcements
- Conference attendee/sponsor lists
- Social media presence and activity
- News mentions and press releases

### Step 4: Prioritize and Score

Create a fit score (1-10) for each lead based on:
- Alignment with ICP
- Signals of immediate need
- Budget availability or indicators
- Competitive landscape overlap
- Timing indicators (hiring, expanding, fundraising)
- Accessibility of decision-makers

### Step 5: Provide Actionable Output

For each lead, include:

```markdown
## Lead: [Company Name]

**Website**: [URL]
**Priority Score**: [X/10]
**Industry**: [Industry]
**Size**: [Employee count/revenue range]

**Why They're a Good Fit**:
[2-3 specific reasons based on their business context]

**Target Decision Maker**: [Role/Title]
**LinkedIn**: [URL if available]

**Value Proposition for Them**:
[Specific benefit for this company]

**Outreach Strategy**:
[Personalized approach — mention specific pain points, recent company news, or relevant context]

**Conversation Starters**:
- [Specific point 1 — reference their recent activities]
- [Specific point 2 — connect their problem to your solution]
```

### Step 6: Summary Report

```markdown
# Lead Research Results

## Summary
- Total leads found: [X]
- High priority (8-10): [X]
- Medium priority (5-7): [X]
- Average fit score: [X]

## Top 3 Immediate Opportunities
1. [Company] — [Why urgent/timely]
2. [Company] — [Why urgent/timely]
3. [Company] — [Why urgent/timely]

## Recommended Next Steps
1. [Action for top-priority lead]
2. [Action for secondary leads]
3. [Follow-up research to deepen insights]
```

### Step 7: Offer Follow-Up Options

- Save results to CSV for CRM import
- Draft personalized outreach emails for top leads
- Deep-dive research on specific companies
- Monitor specific leads for timing opportunities
- Build outreach sequence templates

## Qualification Framework

### BANT Assessment

For each lead, quickly assess:

| Criteria | Question | Signal |
|----------|----------|--------|
| **Budget** | Can they afford the solution? | Funding raised, company size, spending patterns |
| **Authority** | Who makes the decision? | Job titles, org chart signals |
| **Need** | Do they have the problem? | Job postings, tech stack, product reviews |
| **Timeline** | When do they need it? | Hiring urgency, expansion signals, quarter-end |

### Fit Score Guide

| Score | Meaning | Action |
|-------|---------|--------|
| 9-10 | Perfect fit + urgent need | Immediate personalized outreach |
| 7-8 | Strong fit, clear need | Prioritize in outreach sequence |
| 5-6 | Good fit, some signals | Add to nurture campaign |
| 3-4 | Partial fit, unclear need | Monitor for timing signals |
| 1-2 | Poor fit | Skip unless strategic value |

## Outreach Template Structure

```markdown
Subject: [Personalized subject line referencing their context]

Hi [Name],

I noticed [specific observation about their company — recent news, job posting, 
tech stack change, etc.]. That resonated because [connect to their problem].

[Your company] helps [target audience] [achieve outcome] by [mechanism]. 
[Specific result or case study relevant to them].

Would you be open to a brief conversation about [specific topic]?

Best,
[Signature]
```

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/lead-research-assistant/` (project-level) or `~/.cline/skills/lead-research-assistant/` (global)
2. **Web research required**: Cline uses browser tools and web fetch to research companies — ensure connectivity
3. **Data accuracy**: Always note when information may be outdated or uncertain
4. **Scoring transparency**: Explain why each lead received its score
5. **Output formats**: Default to Markdown with optional CSV export for CRM import
6. **Privacy**: Keep lead data local and don't expose proprietary research publicly
7. **Iterative refinement**: Offer to deepen research on top-priority leads

## Related Use Cases

- Drafting personalized outreach emails after identifying leads
- Building a CRM-ready CSV of qualified prospects
- Researching specific companies in detail
- Analyzing competitor customer bases
- Identifying partnership opportunities
- Preparing for sales calls with company research
