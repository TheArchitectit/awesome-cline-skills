---
name: your-skill-name
description: Clear description of what this skill does and when Cline should use it. This skill should be used when [specific trigger conditions] for [key capabilities]. Max 1024 characters.
---

# Your Skill Name

Brief overview of the skill's purpose and capabilities. Explain what Cline can accomplish with this skill and why it exists.

## When to Use This Skill

- When [specific trigger condition 1]
- When [specific trigger condition 2]
- When [specific trigger condition 3]
- When you need [key capability]

## Instructions

### Step 1: Initial Assessment

Before executing, evaluate the request:

- [ ] Confirm the task matches this skill's scope
- [ ] Check for prerequisites (tools, packages, access)
- [ ] Identify any constraints or special requirements

### Step 2: Execution

[Detailed instructions for Cline on how to execute the skill. Be specific about: ]

- What tools or commands to use
- What order to follow
- What output format to produce
- How to handle variations in the request

### Step 3: Validation

After execution, verify the output:

- [ ] Output matches the expected format
- [ ] Content is accurate and complete
- [ ] No errors or warnings remain
- [ ] User's original request is fully addressed

## Best Practices

- Best practice 1: [Specific, actionable guidance]
- Best practice 2: [Specific, actionable guidance]
- Best practice 3: [Specific, actionable guidance]

## Common Pitfalls

- **Pitfall 1**: [Description] → [How to avoid or fix]
- **Pitfall 2**: [Description] → [How to avoid or fix]
- **Pitfall 3**: [Description] → [How to avoid or fix]

## Examples

### Example 1: [Descriptive Title]

**Input**: 
```
User asks: "[example user request]"
```

**Output**:
```
[What Cline should produce]
```

### Example 2: [Descriptive Title]

**Input**: 
```
User asks: "[example user request]"
```

**Output**:
```
[What Cline should produce]
```

## Error Handling

If something goes wrong:

1. **Missing prerequisites**: Inform the user what needs to be installed and provide the installation command
2. **Invalid input**: Explain what valid input looks like and provide an example
3. **Partial failure**: Complete what's possible and clearly document what failed and why
4. **Unexpected output**: Describe the discrepancy and suggest next steps

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/your-skill-name/` (project-level) or `~/.cline/skills/your-skill-name/` (global)
2. **Activation**: Cline will suggest this skill when you [describe trigger conditions]
3. **Progressive loading**: Only metadata loads initially; full instructions activate via `use_skill` when needed
