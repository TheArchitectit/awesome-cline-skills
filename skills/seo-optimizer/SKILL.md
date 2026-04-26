---
name: seo-optimizer
description: SEO analysis and optimization covering keyword research, meta tag generation, structured data markup, sitemap creation, and technical SEO audits. This skill should be used when Cline needs to analyze or improve a website's search engine optimization — from on-page elements like meta tags and headings to technical aspects like structured data, sitemaps, and canonical URLs.
---

# SEO Optimizer

This skill analyzes and improves search engine optimization for websites and web content. It covers keyword research, meta tag creation, structured data markup, sitemap generation, robots.txt configuration, and technical SEO best practices. Every recommendation prioritizes sustainable, white-hat SEO over quick tricks.

## When to Use This Skill

- Performing keyword research for content planning
- Generating optimized meta tags (title, description, canonical)
- Creating structured data markup (JSON-LD) for rich results
- Generating XML sitemaps for search engine crawling
- Auditing pages for SEO issues (missing tags, broken hierarchy, duplicate content)
- Optimizing heading structure (H1-H6 hierarchy)
- Creating robots.txt files with proper directives
- Analyzing internal linking structure
- Optimizing URL structures for crawlability
- Generating Open Graph and Twitter Card meta tags for social sharing

## What This Skill Does

1. **Keyword Research**: Identify primary and secondary keywords with search intent
2. **Meta Tag Optimization**: Generate complete, optimized meta tag sets
3. **Structured Data**: Create JSON-LD markup for rich search results
4. **Sitemap Generation**: Build XML sitemaps following protocol specifications
5. **Technical SEO**: Audit and fix common technical SEO issues

## Process

### Step 1: Keyword Research

Identify and prioritize target keywords:

```markdown
## Keyword Research: [Topic]

### Primary Keywords
| Keyword | Monthly Volume | Difficulty | Intent | Priority |
|---------|---------------|------------|--------|----------|
| [keyword 1] | [volume] | [low/med/high] | [informational/commercial/transactional] | Primary |
| [keyword 2] | [volume] | [low/med/high] | [intent] | Secondary |

### Long-Tail Variations
- [keyword 1] + [modifier] — [specific intent]
- [keyword 1] + [modifier] — [specific intent]
- how to [keyword 1] — informational intent
- best [keyword 1] for [use case] — commercial intent

### Related / Semantic Keywords (for topical authority)
- [related term 1], [related term 2], [related term 3]

### Keyword Mapping
| Page/URL | Primary Keyword | Secondary Keywords |
|----------|----------------|-------------------|
| /page-1 | [keyword 1] | [keyword 2], [keyword 3] |
| /page-2 | [keyword 4] | [keyword 5] |

**Selection criteria**:
- Relevance to business/content goals
- Search volume vs. competition balance
- Clear search intent alignment
- No keyword cannibalization across pages
```

### Step 2: Meta Tag Generation

Complete meta tag set for a page:

```html
<!-- Essential SEO Meta Tags -->
<title>Primary Keyword: Benefit or Promise | Brand Name</title>
<meta name="description" content="Primary keyword near start. Compelling summary under 155 characters with clear value proposition and CTA implication.">
<link rel="canonical" href="https://example.com/page-url">

<!-- Open Graph (Facebook, LinkedIn) -->
<meta property="og:type" content="article">
<meta property="og:title" content="Compelling Title for Social Sharing">
<meta property="og:description" content="Summary that encourages clicks when shared on social.">
<meta property="og:image" content="https://example.com/images/og-image-1200x630.jpg">
<meta property="og:url" content="https://example.com/page-url">
<meta property="og:site_name" content="Brand Name">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Title for Twitter Card">
<meta name="twitter:description" content="Description for Twitter Card">
<meta name="twitter:image" content="https://example.com/images/twitter-image.jpg">

<!-- Additional SEO Tags -->
<meta name="robots" content="index, follow">
<meta name="author" content="Author Name">
<meta property="article:published_time" content="2025-01-15T09:00:00+00:00">
<meta property="article:modified_time" content="2025-01-20T14:30:00+00:00">
```

**Title tag rules**:
- 50-60 characters (Google truncates at ~600px width)
- Primary keyword within first 30 characters
- Brand name at the end separated by " | "
- Each page has a unique title — no duplicates

**Meta description rules**:
- 120-155 characters (Google truncates at ~920px width)
- Primary keyword in the first sentence
- Includes a value proposition or benefit
- May include a CTA ("Learn how", "Discover", "Get started")
- Unique per page

### Step 3: Structured Data (JSON-LD)

Generate schema markup for rich results:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title",
  "description": "Article description for search engines.",
  "image": "https://example.com/images/article-hero.jpg",
  "author": {
    "@type": "Person",
    "name": "Author Name",
    "url": "https://example.com/authors/author-name"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Brand Name",
    "logo": {
      "@type": "ImageObject",
      "url": "https://example.com/logo.png"
    }
  },
  "datePublished": "2025-01-15T09:00:00+00:00",
  "dateModified": "2025-01-20T14:30:00+00:00",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://example.com/article-url"
  }
}
</script>
```

**Common schema types**:

| Content Type | Schema Type | Rich Result |
|-------------|-------------|-------------|
| Blog post | Article | Article rich result |
| Product page | Product | Product snippet, price |
| FAQ page | FAQPage | FAQ accordion in SERP |
| How-to guide | HowTo | Step-by-step rich result |
| Local business | LocalBusiness | Knowledge panel, map |
| Event | Event | Event rich result |
| Recipe | Recipe | Recipe carousel |
| Organization | Organization | Knowledge panel |
| Breadcrumb | BreadcrumbList | Breadcrumb trail in SERP |

**FAQ schema example**:
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is [keyword]?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Clear, concise answer that may appear directly in search results."
      }
    },
    {
      "@type": "Question",
      "name": "How does [keyword] work?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Another clear answer targeting a common search query."
      }
    }
  ]
}
</script>
```

### Step 4: Sitemap Generation

```python
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from pathlib import Path

def generate_xml_sitemap(pages, output_path="sitemap.xml"):
    """Generate an XML sitemap from a list of page data.

    Args:
        pages: List of dicts with keys: url, lastmod, changefreq, priority
    """
    urlset = ET.Element("urlset")
    urlset.set("xmlns", "https://www.sitemaps.org/schemas/sitemap/0.9")

    for page in pages:
        url_elem = ET.SubElement(urlset, "url")

        loc = ET.SubElement(url_elem, "loc")
        loc.text = page["url"]

        if "lastmod" in page:
            lastmod = ET.SubElement(url_elem, "lastmod")
            lastmod.text = page["lastmod"]

        if "changefreq" in page:
            changefreq = ET.SubElement(url_elem, "changefreq")
            changefreq.text = page["changefreq"]

        if "priority" in page:
            priority = ET.SubElement(url_elem, "priority")
            priority.text = str(page["priority"])

    tree = ET.ElementTree(urlset)
    ET.indent(tree, space="  ")
    tree.write(output_path, xml_declaration=True, encoding="utf-8")
    return output_path


# Example usage
def sitemap_for_site(base_url, pages_list):
    """Create a standard sitemap for a website."""
    pages = []
    priority_map = {
        "homepage": "1.0",
        "main_page": "0.8",
        "sub_page": "0.6",
        "blog_post": "0.5",
    }

    for page_info in pages_list:
        pages.append({
            "url": f"{base_url.rstrip('/')}/{page_info['path'].lstrip('/')}",
            "lastmod": page_info.get("lastmod", datetime.now(timezone.utc).strftime("%Y-%m-%d")),
            "changefreq": page_info.get("changefreq", "monthly"),
            "priority": priority_map.get(page_info.get("type", "sub_page"), "0.5"),
        })

    return generate_xml_sitemap(pages)
```

### Step 5: Robots.txt Configuration

```markdown
## robots.txt Templates

### Standard website
User-agent: *
Allow: /
Sitemap: https://example.com/sitemap.xml

Disallow: /admin/
Disallow: /search/
Disallow: /*?sort=
Disallow: /*?filter=

### With specific bot rules
User-agent: *
Allow: /
Disallow: /api/
Disallow: /internal/

User-agent: Googlebot
Allow: /

User-agent: GPTBot          # OpenAI
Disallow: /

User-agent: Google-Extended  # Google AI training
Disallow: /

Sitemap: https://example.com/sitemap.xml
```

### Step 6: Technical SEO Audit

```markdown
## SEO Audit Checklist

### On-Page Elements
- [ ] Unique title tag (50-60 chars) with primary keyword
- [ ] Unique meta description (120-155 chars) with primary keyword
- [ ] Single H1 tag with primary keyword
- [ ] Proper heading hierarchy (H1 > H2 > H3, no skipped levels)
- [ ] Canonical URL specified
- [ ] Images have descriptive alt text with keywords where natural

### Structured Data
- [ ] JSON-LD markup present for content type
- [ ] Schema validates (test at schema.org validator)
- [ ] No duplicate or conflicting schema

### Technical
- [ ] Page loads in under 3 seconds
- [ ] Mobile responsive (passes mobile-friendly test)
- [ ] HTTPS enabled
- [ ] No broken links (internal or external)
- [ ] XML sitemap submitted to Google Search Console
- [ ] robots.txt does not block important pages
- [ ] Proper 301 redirects for moved/renamed pages
- [ ] No duplicate content issues (canonical tags resolve)
- [ ] Open Graph and Twitter Card meta tags present

### URL Structure
- [ ] URLs are lowercase with hyphens (not underscores)
- [ ] URLs are readable and descriptive (not query-string heavy)
- [ ] URL depth is 3 or fewer levels from root
- [ ] No trailing slash inconsistency
```

## Error Handling

- **Missing keyword data**: Use semantic clustering and related term analysis as a fallback; be transparent about data limitations
- **Schema validation errors**: Always validate JSON-LD with Schema.org validator before implementing; fix type mismatches and missing required properties
- **Sitemap too large**: Split sitemaps at 50,000 URLs; create a sitemap index file referencing child sitemaps
- **Canonical conflicts**: Ensure canonical URL matches the preferred URL; remove www/non-www and http/https ambiguity
- **Robots.txt blocking resources**: Test with Google Search Console's robots.txt tester; avoid blocking CSS/JS needed for rendering

## Common Pitfalls

- ❌ Keyword stuffing — write naturally for humans first, optimize second
- ❌ Duplicate meta descriptions — every page needs a unique description
- ❌ Multiple H1 tags — one H1 per page, containing the primary keyword
- ❌ Ignoring mobile — Google indexes mobile-first; test mobile experience
- ❌ Forgetting canonical tags — critical for preventing duplicate content issues
- ❌ Over-optimizing for rich snippets — structured data should accurately represent content, not manipulate results

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/seo-optimizer/` (project-level) or `~/.cline/skills/seo-optimizer/` (global)
2. **Always audit before optimizing**: Check what exists before generating new tags — avoid conflicts
3. **Validate structured data**: Use Schema.org validator or Google Rich Results Test after generating JSON-LD
4. **Preserve existing good SEO**: Don't overwrite meta tags that are already well-optimized
5. **Page-by-page approach**: SEO optimization works best when applied per page, not site-wide templates
6. **White-hat only**: Never suggest cloaking, hidden text, or manipulative practices
7. **Document changes**: Track all SEO modifications so the user can measure impact

## Dependencies

```bash
# Python (for sitemap generation):
pip install lxml     # Better XML handling than stdlib (optional)
# No other external dependencies required for core functionality
```
