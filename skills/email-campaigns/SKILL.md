---
name: email-campaigns
description: Email marketing campaign creation covering subject line optimization, A/B test design, template generation, segmentation strategies, and performance tracking. This skill should be used when Cline needs to create, optimize, or analyze email marketing campaigns — from individual newsletter editions to automated drip sequences and promotional blasts.
---

# Email Campaigns

This skill creates and optimizes email marketing campaigns. It covers subject line crafting and testing, email template design, audience segmentation, A/B test planning, drip sequence design, and performance analysis. Every campaign balances conversion goals with subscriber trust.

## When to Use This Skill

- Writing email subject lines that drive opens
- Designing A/B tests for subject lines, content, or send times
- Creating email templates for newsletters, promotions, and transactional emails
- Planning email drip sequences and automation workflows
- Segmenting audiences for targeted messaging
- Analyzing campaign performance and recommending improvements
- Creating welcome sequences, onboarding emails, and re-engagement campaigns
- Writing email copy that converts without being pushy

## What This Skill Does

1. **Subject Line Optimization**: Craft and test high-open-rate subject lines
2. **A/B Test Design**: Plan statistically valid tests for email elements
3. **Template Creation**: Build reusable email templates with proper structure
4. **Sequence Design**: Plan drip campaigns and automated email flows
5. **Performance Analysis**: Track metrics and optimize based on data

## Process

### Step 1: Define the Campaign

```markdown
## Campaign Brief

- **Campaign name**: [Descriptive name]
- **Type**: [Newsletter / Promotion / Welcome / Onboarding / Re-engagement / Transactional]
- **Goal**: [What action should recipients take?]
- **Audience**: [Segment — who receives this?]
- **Send frequency**: [One-time / Daily / Weekly / Triggered]
- **Success metric**: [Open rate / Click rate / Conversion rate / Revenue]
- **Target numbers**: [Specific goal: e.g., 25% open rate, 3% click rate]
- **Sender name**: [Who is this from?]
- **Landing page**: [Where does the primary CTA link?]
```

### Step 2: Subject Line Optimization

Generate and evaluate subject line variants:

```markdown
## Subject Line Framework

### Variants by Approach

**Curiosity** (what happens next?)
- The one thing your [audience] is missing about [topic]
- I didn't expect this to work (but it did)
- [Number] [things] your competitors already know

**Urgency/Scarcity** (time-sensitive)
- 24 hours left: [offer/benefit]
- [Deadline] is almost here — here's what to do
- Last chance to [action]

**Benefit-Driven** (what's in it for them?)
- How to [achieve outcome] in [timeframe]
- The simple way to [solve problem]
- Get [benefit] without [common obstacle]

**Personal/Social Proof** (human connection)
- How [person/company] achieved [result]
- What I learned after [experience]
- [Number] people already [action] — here's why

**Direct** (for B2B / transactional)
- [Action required]: [what/why]
- Your [thing] is ready
- Update: [what changed]

### Subject Line Checklist
- [ ] Under 50 characters (mobile displays ~40-50)
- [ ] First 20 characters contain the hook (preview text matters)
- [ ] No misleading claims (trust > clicks)
- [ ] No ALL CAPS or excessive punctuation (!!!)
- [ ] Personalization where appropriate (first name, company)
- [ ] Aligned with email content (no bait-and-switch)
- [ ] Preview text complements the subject line (don't repeat)
```

### Step 3: A/B Test Design

```markdown
## A/B Test Plan

### Test: Subject Line Optimization
- **Variable**: Subject line wording
- **Variants**:
  - A (Control): [Original subject line]
  - B (Challenger): [Modified subject line]
- **Split**: 50/50 of test segment (minimum 1,000 per variant)
- **Duration**: 24 hours (most opens occur in first 4-8 hours)
- **Primary metric**: Open rate
- **Secondary metric**: Click rate (are we attracting the right opens?)

### Test: CTA Design
- **Variable**: Button text and placement
- **Variants**:
  - A: "Learn More" button below main content
  - B: "Get Started Now" button above fold + below content
- **Split**: 50/50
- **Primary metric**: Click-through rate
- **Secondary metric**: Conversion rate on landing page

### Test: Send Time
- **Variable**: Day and time of send
- **Variants**:
  - A: Tuesday 10:00 AM
  - B: Thursday 2:00 PM
- **Split**: 25/25 (hold 50% for the winner rollout)
- **Primary metric**: Open rate + click rate combined
- **Duration**: Test both sends, compare 48-hour results

### A/B Test Rules
1. **Test one variable at a time** — multiple changes = unclear results
2. **Wait for statistical significance** — don't call a test after 100 opens
3. **Segment equally** — ensure both variants see similar audience quality
4. **Document everything** — results, hypotheses, and learnings for future tests
5. **Roll out the winner** — don't leave performance on the table

### Significance Calculator
- Need at least 1,000 opens per variant for reliable results
- A 5-10% difference in open rates is typically meaningful
- Use a chi-squared test or online calculator for formal significance testing
```

### Step 4: Email Template Creation

```html
<!-- Newsletter Template -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{subject}}</title>
</head>
<body style="margin:0;padding:0;background-color:#f4f4f4;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#f4f4f4;padding:20px 0;">
    <tr>
      <td align="center">
        <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="background-color:#ffffff;border-radius:8px;overflow:hidden;">

          <!-- Header / Logo -->
          <tr>
            <td style="padding:20px 30px;background-color:#1a1a2e;text-align:center;">
              <h1 style="margin:0;color:#ffffff;font-family:Arial,sans-serif;font-size:24px;">
                {{brand_name}}
              </h1>
            </td>
          </tr>

          <!-- Hero Section -->
          <tr>
            <td style="padding:30px;">
              <h2 style="margin:0 0 15px 0;font-family:Arial,sans-serif;font-size:22px;color:#1a1a2e;">
                {{headline}}
              </h2>
              <p style="margin:0 0 20px 0;font-family:Arial,sans-serif;font-size:16px;line-height:1.6;color:#444444;">
                {{intro_paragraph}}
              </p>
              <!-- Primary CTA Button -->
              <table role="presentation" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background-color:#e94560;border-radius:6px;">
                    <a href="{{cta_url}}" style="display:inline-block;padding:14px 30px;font-family:Arial,sans-serif;font-size:16px;color:#ffffff;text-decoration:none;font-weight:bold;">
                      {{cta_text}}
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Content Section -->
          <tr>
            <td style="padding:0 30px 30px 30px;">
              <h3 style="margin:0 0 10px 0;font-family:Arial,sans-serif;font-size:18px;color:#1a1a2e;">
                {{section_title}}
              </h3>
              <p style="margin:0 0 15px 0;font-family:Arial,sans-serif;font-size:15px;line-height:1.6;color:#444444;">
                {{section_content}}
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding:20px 30px;background-color:#f8f8f8;text-align:center;">
              <p style="margin:0 0 8px 0;font-family:Arial,sans-serif;font-size:12px;color:#888888;">
                {{company_name}} · {{company_address}}
              </p>
              <p style="margin:0;font-family:Arial,sans-serif;font-size:12px;">
                <a href="{{unsubscribe_url}}" style="color:#888888;">Unsubscribe</a> ·
                <a href="{{preferences_url}}" style="color:#888888;">Email preferences</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

**Template best practices**:
- Use tables for layout (not div/CSS grid — email clients vary wildly)
- Inline all styles (most clients strip `<style>` blocks)
- Maximum width: 600px (mobile-friendly)
- Alt text on all images (many clients block images by default)
- Always include unsubscribe link (legal requirement: CAN-SPAM, GDPR)
- Test in multiple clients before sending (Gmail, Outlook, Apple Mail, mobile)

### Step 5: Drip Sequence Design

```markdown
## Welcome Sequence (5 emails)

**Trigger**: New subscriber / signup

**Email 1 - Welcome (Immediate)**
- Subject: Welcome to {{brand}} — here's what's next
- Content: Thank you + deliver lead magnet if promised + set expectations (what they'll receive, how often)
- CTA: Follow on social / join community

**Email 2 - Value (Day 2)**
- Subject: The [thing] most [audience] get wrong
- Content: Quick win or key insight (deliver value before asking)
- CTA: Read related content / try a feature

**Email 3 - Social Proof (Day 4)**
- Subject: How [person/company] [achieved result]
- Content: Case study or testimonial showing transformation
- CTA: See more results / start free trial

**Email 4 - Objection Handling (Day 7)**
- Subject: "I'm not sure if this works for [situation]"
- Content: Address top 2-3 objections directly with evidence
- CTA: Book a call / start trial

**Email 5 - Offer (Day 10)**
- Subject: Ready to [achieve outcome]? Let's do this.
- Content: Clear offer with value stack + deadline or urgency element
- CTA: Buy / upgrade / book

## Re-engagement Sequence (3 emails)

**Trigger**: No opens in 60 days

**Email 1 - Check In (Day 1)**
- Subject: We miss you / Are we still a fit?
- Content: Gentle check-in, ask for feedback, offer help
- CTA: Update preferences / reply with feedback

**Email 2 - Best Of (Day 7)**
- Subject: Here's what you missed
- Content: Top 3 best-performing content pieces from the period they missed
- CTA: Read the top post / re-engage

**Email 3 - Last Chance (Day 14)**
- Subject: Last call — should we update your preferences?
- Content: Honest — if this isn't useful, no hard feelings. Update or unsubscribe.
- CTA: Update preferences / unsubscribe
```

### Step 6: Performance Tracking

```markdown
## Campaign Performance Report

**Campaign**: [Name]
**Date**: [Send date]
**Segment**: [Who received it]

### Core Metrics
| Metric | Result | Benchmark | Status |
|--------|--------|-----------|--------|
| Delivery rate | [%] | >98% | ✅/⚠️ |
| Open rate | [%] | 20-30% (varies by industry) | ✅/⚠️ |
| Click-to-open rate | [%] | 10-20% | ✅/⚠️ |
| Click-through rate | [%] | 2-5% | ✅/⚠️ |
| Conversion rate | [%] | 1-3% | ✅/⚠️ |
| Unsubscribe rate | [%] | <0.5% | ✅/⚠️ |
| Bounce rate | [%] | <2% | ✅/⚠️ |

### What Worked
- [Insight 1 with data]
- [Insight 2 with data]

### What to Improve
- [Issue 1 with hypothesis]
- [Issue 2 with hypothesis]

### Next Actions
1. [Specific change to test next send]
2. [Segment to try or avoid]
3. [Subject line pattern to iterate on]
```

## Error Handling

- **Low open rates**: Check sender reputation, subject line clarity, and send time; test subject lines with a small segment first
- **High unsubscribe rates**: Review frequency, content relevance, and expectations set at signup; segment more precisely
- **Poor click-through rates**: Improve CTA visibility, reduce email length, clarify the value of clicking
- **High bounce rates**: Clean the list — remove hard bounces, validate email addresses before adding
- **Spam complaints**: Check content for spam triggers (ALL CAPS, excessive links, misleading subject); review authentication (SPF, DKIM, DMARC)

## Common Pitfalls

- ❌ Buying email lists — always grow organically; purchased lists damage sender reputation
- ❌ Image-only emails — many clients block images; always have text fallbacks
- ❌ One-size-fits-all messaging — segment by engagement, interest, and lifecycle stage
- ❌ Ignoring mobile — 60%+ of emails are opened on mobile; test mobile rendering
- ❌ No unsubscribe link — legally required and builds trust; make it easy, not hidden
- ❌ Testing in only one email client — Outlook rendersvery differently than Gmail

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/email-campaigns/` (project-level) or `~/.cline/skills/email-campaigns/` (global)
2. **Always include unsubscribe**: Never create an email template without an unsubscribe mechanism
3. **Test before sending**: Send a test email to yourself and check rendering across clients
4. **Subject lines are half the battle**: Spend disproportionate time on subject lines — they determine if anything else matters
5. **One CTA per email**: Multiple competing CTAs dilute click-through rates; pick one primary action
6. **Track everything**: Every campaign should have measurable goals tracked from send to conversion
7. **Respect the inbox**: Email is a privilege, not a right — provide value or lose the subscriber

## Dependencies

No external dependencies required. This skill uses Cline's native capabilities with optional integration to email service providers via API.
