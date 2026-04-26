---
name: a-b-testing
description: A/B testing design and analysis covering hypothesis framing, metric selection, sample size calculation, test implementation, statistical significance evaluation, and results interpretation. This skill should be used when Cline needs to design, run, or analyze A/B tests — from website experiments and email campaigns to feature comparisons and pricing tests.
---

# A/B Testing

This skill designs and analyzes A/B tests with statistical rigor. It covers hypothesis formulation, metric selection, sample size determination, test implementation, significance evaluation, and actionable result interpretation. Every test is designed to produce reliable, trustworthy conclusions.

## When to Use This Skill

- Designing A/B tests for websites, apps, or emails
- Framing clear, testable hypotheses
- Selecting primary and guardrail metrics
- Calculating required sample sizes and test duration
- Implementing tests with proper randomization
- Evaluating statistical significance and confidence intervals
- Analyzing test results to make data-driven decisions
- Determining whether to ship, iterate, or abandon a change
- Planning multi-variant tests

## What This Skill Does

1. **Hypothesis Framing**: Transform ideas into clear, testable hypotheses
2. **Metric Selection**: Choose primary, secondary, and guardrail metrics
3. **Sample Size Planning**: Calculate minimum sample sizes for reliable results
4. **Test Implementation**: Design proper randomization and assignment
5. **Significance Evaluation**: Assess results with appropriate statistical tests
6. **Results Interpretation**: Translate statistics into business decisions

## Process

### Step 1: Frame the Hypothesis

Every test starts with a clear, falsifiable hypothesis:

```markdown
## Hypothesis Template

**Observation**: [What you noticed or what data suggests a problem/opportunity]
**Hypothesis**: If we [change], then [metric] will [direction] by [magnitude] because [rationale].
**Prediction**: We expect [specific measurable outcome] within [timeframe].

### Example Hypotheses

**Weak** (vague, untestable):
"Changing the button will improve the page."

**Strong** (specific, testable):
"If we change the CTA button from 'Learn More' to 'Get Started Free', then click-through rate will increase by 15-20% because 'Get Started Free' reduces commitment anxiety and clarifies the next step."

**Weak**: "The new design is better."
**Strong**: "If we reduce the signup form from 7 fields to 4 fields, then completion rate will increase by 25% because fewer fields reduce friction and our analytics show 60% of drop-offs occur at field 5+."

### Hypothesis Quality Checklist
- [ ] States a specific change (what's different between A and B?)
- [ ] States a specific metric (how will success be measured?)
- [ ] States expected direction (increase or decrease)
- [ ] States expected magnitude (by how much?)
- [ ] Explains the "because" (why do you expect this outcome?)
- [ ] Is falsifiable (could the data prove you wrong?)
```

### Step 2: Select Metrics

```markdown
## Metric Selection Framework

### Primary Metric (ONE per test)
The single metric that determines success or failure.

**Selection criteria**:
- Directly measures the hypothesis
- Sensitive enough to detect the expected change
- Actionable (you can do something with the result)
- Not easily gamed

**Examples**:
| Test Type | Good Primary Metric | Poor Primary Metric |
|-----------|--------------------|--------------------|
| CTA button change | Click-through rate | Page views |
| Pricing change | Conversion rate | Revenue per visitor* |
| Email subject line | Open rate | Total revenue |
| Onboarding flow | Completion rate | Time on page |
| Feature visibility | Feature adoption rate | Number of clicks |

*Revenue per visitor can work as primary if you have sufficient volume.

### Secondary Metrics (1-3)
Supporting metrics that provide context for the primary metric.

**Examples**:
- Primary: Click-through rate → Secondary: Bounce rate, time on page
- Primary: Conversion rate → Secondary: Average order value, items per purchase
- Primary: Open rate → Secondary: Click-to-open rate, unsubscribe rate

### Guardrail Metrics (1-2)
Metrics that must not degrade — safety constraints.

**Examples**:
- Page load time (must not increase)
- Error rate (must not increase)
- Unsubscribe rate (must not spike)
- Customer support tickets (must not increase)
- Revenue per user (must not decrease significantly)

### Metric Definition Template
For each metric, define precisely:
- **Name**: [Clear, unambiguous label]
- **Definition**: [Exact formula or calculation]
- **Numerator**: [What counts]
- **Denominator**: [Who's eligible]
- **Time window**: [Over what period]
- **Expected baseline**: [Current performance]
- **MDE**: [Minimum detectable effect worth detecting]
```

### Step 3: Calculate Sample Size

```python
import math

def sample_size_proportion(baseline_rate, mde, alpha=0.05, power=0.8):
    """Calculate minimum sample size per variant for a proportion metric.

    Args:
        baseline_rate: Current conversion rate (e.g., 0.05 for 5%)
        mde: Minimum detectable effect as relative change (e.g., 0.20 for 20% lift)
        alpha: Significance level (0.05 = 95% confidence)
        power: Statistical power (0.8 = 80% chance of detecting true effect)

    Returns:
        Required sample size per variant
    """
    # Z-scores for common alpha/power values
    z_alpha = {0.05: 1.96, 0.025: 2.24, 0.01: 2.576}
    z_power = {0.8: 0.84, 0.9: 1.28, 0.95: 1.645}

    z_a = z_alpha.get(alpha, 1.96)
    z_b = z_power.get(power, 0.84)

    p1 = baseline_rate
    p2 = baseline_rate * (1 + mde)  # Expected rate in treatment
    p_avg = (p1 + p2) / 2

    n = ((z_a * math.sqrt(2 * p_avg * (1 - p_avg)) +
          z_b * math.sqrt(p1 * (1 - p1) + p2 * (1 - p2))) ** 2) / (p2 - p1) ** 2

    return math.ceil(n)


def test_duration(sample_per_variant, daily_traffic, allocation=1.0):
    """Estimate how many days a test will need to run.

    Args:
        sample_per_variant: Required sample per variant
        daily_traffic: Average daily visitors/users eligible for test
        allocation: Fraction of traffic allocated to test (0.0-1.0)
    """
    total_sample = sample_per_variant * 2  # Two variants
    eligible_daily = daily_traffic * allocation
    days = math.ceil(total_sample / eligible_daily)
    return days


# Quick reference table for common scenarios
def sample_size_quick_ref():
    """Print a quick reference for common baseline rates and MDEs."""
    scenarios = [
        (0.02, 0.20),  # 2% baseline, 20% lift
        (0.05, 0.15),  # 5% baseline, 15% lift
        (0.10, 0.10),  # 10% baseline, 10% lift
        (0.20, 0.10),  # 20% baseline, 10% lift
        (0.50, 0.05),  # 50% baseline, 5% lift
    ]

    print(f"{'Baseline':>10} {'MDE':>8} {'Sample/Variant':>16} {'Total':>10}")
    print("-" * 50)
    for baseline, mde in scenarios:
        n = sample_size_proportion(baseline, mde)
        print(f"{baseline:>10.0%} {mde:>8.0%} {n:>16,} {n*2:>10,}")
```

**Sample size quick reference** (α=0.05, power=0.8):

| Baseline Rate | MDE (lift) | Per Variant | Total |
|---------------|-----------|-------------|-------|
| 2% | 20% | ~38,000 | ~76,000 |
| 5% | 15% | ~17,000 | ~34,000 |
| 10% | 10% | ~14,000 | ~28,000 |
| 20% | 10% | ~6,200 | ~12,400 |
| 50% | 5% | ~6,200 | ~12,400 |

### Step 4: Test Implementation

```markdown
## Implementation Checklist

### Randomization
- [ ] Users are assigned to variants randomly (not by user choice)
- [ ] Assignment is consistent (same user sees same variant on return)
- [ ] Assignment is roughly 50/50 (verify actual split matches plan)
- [ ] No selection bias in assignment mechanism

### Duration and Timing
- [ ] Test runs for at least 2 full business cycles (typically 2 weeks)
- [ ] Covers both weekdays and weekends (behavior differs)
- [ ] Not running during holidays or unusual events (unless intentional)
- [ ] Not stopping early based on "trending" results

### Data Quality
- [ ] Event tracking verified for both variants before launching
- [ ] Primary metric definition matches between implementation and analysis
- [ ] Bot/invalid traffic filtered from analysis
- [ ] Segment data available for post-hoc analysis

### Launch Protocol
1. **Spike test**: Send 1% of traffic to verify tracking works
2. **QA both variants**: Manually check each variant renders correctly
3. **Ramp up**: Increase to full test allocation (typically 50/50)
4. **Monitor guardrail metrics**: Check daily for first 3 days
5. **Run to completion**: Don't peek at results until sample size is met
```

### Step 5: Statistical Analysis

```python
import math
from scipy import stats

def analyze_ab_test(control_conversions, control_total,
                    treatment_conversions, treatment_total,
                    alpha=0.05):
    """Analyze A/B test results for a proportion metric.

    Returns statistical significance, confidence intervals, and recommendation.
    """
    p_control = control_conversions / control_total
    p_treatment = treatment_conversions / treatment_total
    lift = (p_treatment - p_control) / p_control

    # Standard error for difference in proportions
    se = math.sqrt(
        (p_control * (1 - p_control) / control_total) +
        (p_treatment * (1 - p_treatment) / treatment_total)
    )

    # Z-test for difference in proportions
    z_score = (p_treatment - p_control) / se
    p_value = 2 * (1 - stats.norm.cdf(abs(z_score)))  # Two-tailed

    # Confidence interval for the difference
    z_critical = stats.norm.ppf(1 - alpha / 2)
    ci_lower = (p_treatment - p_control) - z_critical * se
    ci_upper = (p_treatment - p_control) + z_critical * se

    is_significant = p_value < alpha

    return {
        "control_rate": f"{p_control:.4%}",
        "treatment_rate": f"{p_treatment:.4%}",
        "absolute_diff": f"{p_treatment - p_control:.4%}",
        "relative_lift": f"{lift:+.2%}",
        "z_score": round(z_score, 3),
        "p_value": round(p_value, 4),
        "significant": is_significant,
        "confidence_interval": (f"{ci_lower:.4%}", f"{ci_upper:.4%}"),
        "recommendation": _make_recommendation(is_significant, lift, p_value, ci_lower)
    }


def _make_recommendation(significant, lift, p_value, ci_lower):
    """Generate a plain-language recommendation from test results."""
    if not significant:
        return "No significant difference detected. Do not ship the change based on this test. Consider: larger sample size, bigger change, or different hypothesis."

    if significant and lift > 0 and ci_lower > 0:
        return f"Significant positive result (p={p_value:.4f}). Ship the treatment variant. Expected lift: {lift:+.1%} with 95% CI improvement."

    if significant and lift < 0 and ci_lower < 0:
        return f"Significant negative result (p={p_value:.4f}). Do NOT ship the treatment. It performs worse than control."

    return "Significant but mixed signals. The confidence interval crosses zero on some metrics. Investigate guardrail metrics and segment-level effects before deciding."
```

### Step 6: Results Interpretation

```markdown
## Test Results Report Template

### Executive Summary
**Test**: [Variant B description]
**Result**: [Ship / Don't ship / Inconclusive]
**Primary metric impact**: [+X% / -X% / No significant change]

### Detailed Results

| Metric | Control (A) | Treatment (B) | Difference | Lift | Significant? |
|--------|-------------|---------------|------------|------|-------------|
| [Primary] | [rate] | [rate] | [diff] | [+%] | Yes/No (p=X.XX) |
| [Secondary 1] | [rate] | [rate] | [diff] | [+%] | Yes/No |
| [Secondary 2] | [rate] | [rate] | [diff] | [+%] | Yes/No |
| [Guardrail] | [rate] | [rate] | [diff] | [+%] | Yes/No |

### Confidence Intervals (95%)
- Primary metric lift: [lower%] to [upper%]
- Interpretation: [What this range means for the business]

### Segment Analysis
| Segment | Control | Treatment | Lift | Significant? |
|---------|---------|-----------|------|-------------|
| [Segment 1] | [rate] | [rate] | [%] | Yes/No |
| [Segment 2] | [rate] | [rate] | [%] | Yes/No |

### Decision
- **Action**: [Ship variant B / Keep control / Run follow-up test]
- **Rationale**: [Why, in plain language]
- **Next steps**: [What to test next or what to implement]

### Key Learnings
1. [What this test taught us about user behavior]
2. [What surprised us vs. our hypothesis]
3. [What hypothesis this suggests for the next test]
```

## Error Handling

- **Insufficient sample size**: Never call a test before reaching the planned sample size; early results are unreliable
- **Simpson's Paradox**: Check segment-level results — an effect that appears in the total may reverse in segments
- **Novelty effect**: New designs often perform well initially because they're different, not better; run tests long enough for novelty to wear off
- **Multiple testing problem**: Testing many variants or metrics inflates false positive rate; apply Bonferroni correction or reduce alpha
- **Missing data**: Exclusion criteria must be defined before the test starts; post-hoc exclusions introduce bias

## Common Pitfalls

- ❌ Peeking at results early and stopping — inflates false positive rate to 30%+
- ❌ Testing too many things at once — each additional variant reduces power per comparison
- ❌ Ignoring guardrail metrics — a CTA lift doesn't matter if revenue per user drops
- ❌ Running tests on low traffic — you can't detect small effects with small samples
- ❌ Believing every "significant" result — p<0.05 means 1 in 20 tests is a false positive by chance
- ❌ Not documenting hypotheses before testing — post-hoc hypotheses are always "confirmed"

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/a-b-testing/` (project-level) or `~/.cline/skills/a-b-testing/` (global)
2. **Hypothesis first, data second**: Always frame the hypothesis before looking at any data
3. **One primary metric per test**: Multiple primary metrics = no clear decision criterion
4. **Never stop early**: Even if results look clear at day 3, run the full planned duration
5. **Report confidence intervals**: Point estimates are misleading; always include the CI range
6. **Document fixed decisions before the test**: Write down what you'll do for each possible outcome before starting
7. **No peeking policy**: Resist the urge to check daily results; set a review date based on sample size calculations

## Dependencies

```bash
pip install scipy  # For statistical tests (z-test, chi-squared)
# Optional:
pip install statsmodels  # More advanced statistical models
pip install numpy        # Numerical computing (scipy dependency)
```
