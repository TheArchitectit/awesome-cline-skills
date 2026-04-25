---
name: meeting-insights-analyzer
description: Analyzes meeting transcripts and recordings to uncover behavioral patterns, communication insights, and actionable feedback. This skill should be used when Cline needs to identify conflict avoidance, filler words, speaking patterns, leadership tendencies, or communication improvement opportunities from meeting transcripts for professional development and coaching.
---

# Meeting Insights Analyzer

This skill transforms meeting transcripts into actionable insights about communication patterns, helping you become a more effective communicator and leader.

## When to Use This Skill

- Analyzing your communication patterns across multiple meetings
- Getting feedback on leadership and facilitation style
- Identifying when you avoid difficult conversations
- Understanding speaking habits and filler words
- Tracking improvement in communication skills over time
- Preparing for performance reviews with concrete examples
- Coaching team members on their communication style
- Analyzing meeting effectiveness and group dynamics

## What This Skill Does

1. **Pattern Recognition**: Identifies recurring behaviors across meetings
2. **Communication Analysis**: Evaluates effectiveness of communication
3. **Actionable Feedback**: Provides specific, timestamped examples with improvement suggestions
4. **Trend Tracking**: Compares patterns over time when analyzing multiple meetings
5. **Strengths & Growth**: Highlights both what's working and areas for improvement

## How to Use

### Setup

1. Download meeting transcripts to a folder (e.g., `~/meetings/`)
2. Supported formats: `.txt`, `.md`, `.vtt`, `.srt`, `.docx`
3. Ensure transcripts have speaker labels and timestamps for best results

### Quick Start

```
Analyze all meetings in this folder and tell me when I avoided conflict.
```

```
Look at my meetings from the past month and identify my communication patterns.
```

```
Compare my facilitation style between these two meeting folders.
```

### Advanced Analysis

```
Analyze all transcripts in this folder and:
1. Identify when I interrupted others
2. Calculate my speaking ratio
3. Find moments I avoided giving direct feedback
4. Track my use of filler words
5. Show examples of good active listening
```

## Process

### Step 1: Discover Available Data

- Scan the folder for transcript files
- Check if files contain speaker labels and timestamps
- Confirm the date range of meetings
- Identify the user's name/identifier in transcripts

### Step 2: Clarify Analysis Goals

If not specified, ask what they want to learn:
- Specific behaviors (conflict avoidance, interruptions, filler words)
- Communication effectiveness (clarity, directness, listening)
- Meeting facilitation skills
- Speaking patterns and ratios
- Growth areas for improvement

### Step 3: Analyze Patterns

#### Conflict Avoidance
Look for:
- Hedging language ("maybe", "kind of", "I think", "sort of")
- Indirect phrasing instead of direct requests
- Changing subject when tension arises
- Agreeing without commitment ("yeah, but...")
- Not addressing obvious problems
- Over-qualifying ("I was wondering if perhaps we might consider...")

#### Speaking Ratios
- Calculate percentage of meeting time spent speaking
- Count interruptions (by and of the user)
- Measure average speaking turn length
- Track question vs. statement ratios
- Note who speaks most/least in group settings

#### Filler Words
- Count "um", "uh", "like", "you know", "actually", "basically", "right"
- Note frequency per minute or per speaking turn
- Identify situations where frequency increases (nervous, uncertain, presenting)

#### Active Listening
- Questions that reference others' previous points
- Paraphrasing or summarizing others' ideas
- Building on others' contributions
- Asking clarifying questions
- Acknowledging before pivoting

#### Leadership & Facilitation
- Decision-making approach (directive vs. collaborative)
- How disagreements are handled
- Inclusion of quieter participants
- Time management and agenda control
- Follow-up and action item clarity

### Step 4: Provide Specific Examples

For each pattern found:

```markdown
### [Pattern Name]

**Finding**: [One-sentence summary]
**Frequency**: [X times across Y meetings]

**Example**:

**[Meeting Name/Date]** — [Timestamp]

**What Happened**:
> [Actual quote from transcript]

**Why This Matters**:
[Explanation of the impact or missed opportunity]

**Better Approach**:
[Specific alternative phrasing or behavior]
```

### Step 5: Synthesize Insights

Generate a comprehensive summary:

```markdown
# Meeting Insights Summary

**Analysis Period**: [Date range]
**Meetings Analyzed**: [X]
**Total Duration**: [X hours]

## Key Patterns Identified

### 1. [Primary Pattern]
- **Observed**: [What you saw]
- **Impact**: [Why it matters]
- **Recommendation**: [How to improve]

### 2. [Second Pattern]
[Same structure]

## Communication Strengths

1. [Strength 1 with example]
2. [Strength 2 with example]
3. [Strength 3 with example]

## Growth Opportunities

1. **[Area 1]**: [Specific, actionable advice]
2. **[Area 2]**: [Specific, actionable advice]

## Speaking Statistics

- Average speaking time: [X% of meeting]
- Questions asked: [X per meeting average]
- Filler words: [X per minute]
- Interruptions: [X given / Y received per meeting]

## Next Steps

[3-5 concrete actions to improve communication]
```

### Step 6: Offer Follow-Up

- Track same metrics in future meetings
- Deep dive into specific meetings or patterns
- Create a personal communication development plan
- Generate a summary for performance reviews
- Compare to benchmarks over time

## Getting Meeting Transcripts

| Source | How to Export |
|--------|-------------|
| **Granola** | Auto-transcribes; export to text files |
| **Zoom** | Enable cloud recording with transcription; download VTT/SRT |
| **Google Meet** | Use Google Docs auto-transcription; save as .txt |
| **Fireflies.ai** | Export transcripts in bulk; store locally |
| **Otter.ai** | Export transcripts; save as .txt or .md |
| **Microsoft Teams** | Download transcript from meeting recording |

### File Naming Convention

Use consistent naming: `YYYY-MM-DD - Meeting Name.txt`

## Common Analysis Questions

- "When do I avoid difficult conversations?"
- "How often do I interrupt others?"
- "What's my speaking vs. listening ratio?"
- "Do I ask good questions?"
- "How do I handle disagreement?"
- "Am I inclusive of all voices?"
- "Do I use too many filler words?"
- "How clear are my action items?"
- "Do I stay on agenda or get sidetracked?"
- "How has my communication changed over time?"

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/meeting-insights-analyzer/` (project-level) or `~/.cline/skills/meeting-insights-analyzer/` (global)
2. **Transcript quality matters**: Results improve dramatically with speaker-labeled, timestamped transcripts
3. **Privacy first**: Meeting data is sensitive — keep analysis local and don't expose private conversations
4. **Specific over general**: Always provide concrete examples with quotes rather than vague observations
5. **Balanced feedback**: Include both strengths and growth areas — not just problems
6. **Action-oriented**: Every insight should come with a "Better Approach" suggestion
7. **Track over time**: Encourage regular analysis (monthly) to measure improvement
8. **Batch processing**: When analyzing multiple meetings, process them together to identify cross-meeting patterns

## Related Use Cases

- Creating a personal development plan from insights
- Preparing performance review materials with examples
- Coaching direct reports on their communication
- Analyzing customer calls for sales or support patterns
- Studying negotiation tactics and outcomes
- Team communication health assessment
