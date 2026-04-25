---
name: competitive-ads-extractor
description: Extracts and analyzes competitors' ads from ad libraries (Facebook Ad Library, LinkedIn, etc.) to understand what messaging, problems, and creative approaches are working. This skill should be used when Cline needs to research competitor ad strategies, find inspiration for ad campaigns, analyze market positioning, identify successful ad patterns, or discover messaging that resonates with target audiences.
---

# Competitive Ads Extractor

This skill extracts and analyzes competitors' ads from ad libraries to understand what messaging, problems, and creative approaches are working — helping inspire and improve your own ad campaigns.

## When to Use This Skill

- Researching competitor ad strategies and positioning
- Finding inspiration for your own ad creative and copy
- Understanding market positioning across competitors
- Identifying successful messaging patterns and hooks
- Discovering new use cases or pain points to target
- Planning ad campaigns with proven concepts
- Analyzing seasonal or time-based ad trends

## What This Skill Does

1. **Extracts Ads**: Scrapes ads from Facebook Ad Library, LinkedIn, and other platforms
2. **Captures Screenshots**: Saves visual copies of all ads for reference
3. **Analyzes Messaging**: Identifies problems, use cases, and value propositions
4. **Categorizes Ads**: Groups by theme, audience, format, and platform
5. **Identifies Patterns**: Finds common successful approaches across competitors
6. **Provides Insights**: Explains why certain ads likely perform well

## How to Use

### Basic Extraction

```
Extract all current ads from [Competitor Name] on Facebook Ad Library
```

```
Scrape ads from [Company] and analyze their messaging
```

### Specific Analysis

```
Get all ads from [Competitor] focusing on their messaging about [specific problem]. What pain points are they highlighting?
```

### Competitive Set

```
Extract ads from these 5 competitors: [list]. Compare their approaches and tell me what's working.
```

### Specific Platform

```
Get LinkedIn ads from [Competitor] and analyze their B2B positioning strategy
```

## Process

### Step 1: Access Ad Libraries

Navigate to the relevant ad library:

- **Facebook Ad Library**: https://www.facebook.com/ads/library/
- **LinkedIn Ad Library**: Available via LinkedIn Ads platform
- **Google Ads Transparency Center**: https://adstransparency.google.com/
- **TikTok Ad Library**: https://library.tiktok.com/

Use browser tools or Playwright to navigate and extract ad data when APIs are unavailable.

### Step 2: Extract Ad Data

For each ad found, capture:

- **Ad copy** (headline, body text, CTA)
- **Visual creative** (screenshot or download)
- **Ad format** (static image, video, carousel)
- **Landing page URL** (if accessible)
- **Active status** and duration
- **Platform-specific metadata** (engagement, spend estimates)

Save to organized directory:

```
competitor-ads/
└── [competitor-name]/
    ├── ad-001-collaboration.png
    ├── ad-002-productivity.png
    └── analysis.md
```

### Step 3: Analyze Messaging Patterns

For each competitor, identify and categorize:

**Problems Highlighted**:
- What pain points appear most frequently?
- How are they framing the problem?
- What emotions do they target?

**Value Propositions**:
- What benefits do they emphasize?
- How do they differentiate?
- What proof points do they use?

**Copy Patterns**:
- Headline lengths and structures
- CTA language and placement
- Tone (urgent, friendly, professional)
- Social proof usage

### Step 4: Identify Creative Patterns

Categorize visual patterns:

| Pattern | Description | When Effective |
|---------|-------------|----------------|
| Before/After Split | Chaotic → Clean transformation | Productivity, organization tools |
| Feature Showcase | GIF/video of actual product usage | New features, demos |
| Social Proof | Customer logos, user counts, quotes | Enterprise, trust-building |
| Problem Statement | Bold question or pain point headline | Awareness, top-of-funnel |
| Comparison | Us vs. them layout | Competitive positioning |
| Testimonial | Real user story or quote | Trust, conversion |

### Step 5: Generate Analysis Report

```markdown
# [Competitor] Ad Analysis

## Overview
- Total Ads: [X] active
- Primary Themes: [Theme 1] (X%), [Theme 2] (X%), ...
- Ad Formats: Static (X%), Video (X%), Carousel (X%)
- CTA Patterns: [Common CTAs]

## Key Problems They're Highlighting

1. **[Problem 1]** (X ads)
   - Copy: "[Representative excerpt]"
   - Why it works: [Analysis]

2. **[Problem 2]** (X ads)
   - Copy: "[Representative excerpt]"
   - Why it works: [Analysis]

## Successful Creative Patterns

### Pattern 1: [Name]
- [Description]
- Used in X ads
- Why effective: [Analysis]

## Top Performing Copy Formulas

Best Headlines:
1. "[Headline]" → Why it works: [Analysis]
2. "[Headline]" → Why it works: [Analysis]

## Recommendations for Your Ads

1. **[Recommendation 1]** → Based on: [Evidence]
2. **[Recommendation 2]** → Based on: [Evidence]
3. **[Recommendation 3]** → Based on: [Evidence]
```

## Advanced Analysis

### Trend Tracking

```
Compare [Competitor]'s ads from Q1 vs Q2. What messaging has changed?
```

### Multi-Competitor Comparison

```
Extract ads from [Company A], [Company B], [Company C]. What are the common patterns? Where do they differ?
```

### Industry Benchmarks

```
Show me ad patterns across the top 10 [industry] tools. What problems do they all focus on?
```

## Best Practices

### Legal & Ethical
- ✅ Only use for research and inspiration
- ✅ Don't copy ads directly
- ✅ Respect intellectual property
- ✅ Use insights to inform original creative
- ❌ Don't plagiarize copy or steal designs

### Analysis Tips
1. Look for patterns — what themes repeat across competitors?
2. Track over time — save ads monthly to see evolution
3. Test hypotheses — adapt successful patterns for your brand
4. Segment by audience — different messages target different segments
5. Compare platforms — LinkedIn vs Facebook messaging differs significantly

### Organizing Results
- Save all ads by competitor and date
- Create a master spreadsheet tracking themes over time
- Build a "swipe file" of top-performing ad patterns
- Tag ads by format, audience, and funnel stage

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/competitive-ads-extractor/` (project-level) or `~/.cline/skills/competitive-ads-extractor/` (global)
2. **Browser access**: Cline may use browser tools to access ad libraries that don't have public APIs
3. **Data privacy**: Keep scraped data local and don't expose competitors' proprietary ad strategies publicly
4. **Output formats**: Default to Markdown analysis reports with organized image files
5. **Rate limiting**: When scraping, respect platform rate limits and add delays between requests
6. **Regular monitoring**: Schedule periodic re-analysis to track changes in competitor strategies

## Related Use Cases

- Writing better ad copy for your campaigns
- Understanding market positioning gaps
- Finding content gaps in your messaging
- Discovering new use cases for your product
- Planning product marketing strategy
- Inspiring social media content
