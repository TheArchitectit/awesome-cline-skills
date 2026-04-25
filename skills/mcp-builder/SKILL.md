---
name: mcp-builder
description: Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. This skill should be used when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).
---

# MCP Server Development Guide

## Overview

This skill guides creation of high-quality MCP (Model Context Protocol) servers that enable LLMs to effectively interact with external services. An MCP server provides tools that allow LLMs to access external services and APIs. The quality of an MCP server is measured by how well it enables LLMs to accomplish real-world tasks using the tools provided.

---

# Process

## 🚀 High-Level Workflow

Creating a high-quality MCP server involves four main phases:

### Phase 1: Deep Research and Planning

#### 1.1 Understand Agent-Centric Design Principles

Before implementing, understand how to design tools for AI agents:

**Build for Workflows, Not Just API Endpoints:**
- Don't simply wrap existing API endpoints — build thoughtful, high-impact workflow tools
- Consolidate related operations (e.g., `schedule_event` that both checks availability and creates event)
- Focus on tools that enable complete tasks, not just individual API calls

**Optimize for Limited Context:**
- Agents have constrained context windows — make every token count
- Return high-signal information, not exhaustive data dumps
- Provide "concise" vs "detailed" response format options
- Default to human-readable identifiers over technical codes (names over IDs)

**Design Actionable Error Messages:**
- Error messages should guide agents toward correct usage patterns
- Suggest specific next steps: "Try using filter='active_only' to reduce results"
- Make errors educational, not just diagnostic

**Follow Natural Task Subdivisions:**
- Tool names should reflect how humans think about tasks
- Group related tools with consistent prefixes for discoverability
- Design tools around natural workflows, not just API structure

#### 1.2 Study MCP Protocol Documentation

**Fetch the latest MCP protocol documentation:**

Use WebFetch to load: `https://modelcontextprotocol.io/llms-full.txt`

This comprehensive document contains the complete MCP specification and guidelines.

#### 1.3 Study Framework Documentation

**For Python implementations:**
- Use WebFetch to load `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`

**For Node/TypeScript implementations:**
- Use WebFetch to load `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`

#### 1.4 Exhaustively Study API Documentation

To integrate a service, read through **ALL** available API documentation:
- Official API reference documentation
- Authentication and authorization requirements
- Rate limiting and pagination patterns
- Error responses and status codes
- Available endpoints and their parameters
- Data models and schemas

#### 1.5 Create a Comprehensive Implementation Plan

Based on research, create a detailed plan that includes:

**Tool Selection:**
- List the most valuable endpoints/operations to implement
- Prioritize tools that enable the most common and important use cases
- Consider which tools work together to enable complex workflows

**Input/Output Design:**
- Define input validation models (Pydantic for Python, Zod for TypeScript)
- Design consistent response formats (JSON or Markdown)
- Plan for large-scale usage (thousands of users/resources)
- Implement character limits and truncation strategies

**Error Handling Strategy:**
- Plan graceful failure modes
- Design clear, actionable, LLM-friendly error messages that prompt further action
- Consider rate limiting and timeout scenarios

---

### Phase 2: Implementation

Now that you have a comprehensive plan, begin implementation.

#### 2.1 Set Up Project Structure

**For Python:**
```
mcp-server-name/
├── src/
│   └── mcp_server_name/
│       ├── __init__.py
│       ├── __main__.py
│       ├── server.py
│       └── models.py
├── pyproject.toml
└── README.md
```

**For Node/TypeScript:**
```
mcp-server-name/
├── src/
│   └── index.ts
├── package.json
├── tsconfig.json
└── README.md
```

#### 2.2 Implement Core Infrastructure First

Create shared utilities before implementing tools:
- API request helper functions
- Error handling utilities
- Response formatting functions (JSON and Markdown)
- Pagination helpers
- Authentication/token management

#### 2.3 Implement Tools Systematically

For each tool in the plan:

**Define Input Schema:**
- Use Pydantic (Python) or Zod (TypeScript) for validation
- Include proper constraints (min/max length, regex patterns, ranges)
- Provide clear, descriptive field descriptions
- Include diverse examples in field descriptions

**Write Comprehensive Docstrings/Descriptions:**
- One-line summary of what the tool does
- Detailed explanation of purpose and functionality
- Complete parameter types with examples
- Error handling documentation

**Implement Tool Logic:**
- Use shared utilities to avoid code duplication
- Follow async/await patterns for all I/O
- Implement proper error handling
- Support multiple response formats (JSON and Markdown)
- Respect pagination parameters
- Check character limits and truncate appropriately

**Add Tool Annotations:**
- `readOnlyHint`: true (for read-only operations)
- `destructiveHint`: false (for non-destructive operations)
- `idempotentHint`: true (if repeated calls have same effect)
- `openWorldHint`: true (if interacting with external systems)

---

### Phase 3: Review and Refine

After initial implementation:

#### 3.1 Code Quality Review

Review the code for:
- **DRY Principle**: No duplicated code between tools
- **Composability**: Shared logic extracted into functions
- **Consistency**: Similar operations return similar formats
- **Error Handling**: All external calls have error handling
- **Type Safety**: Full type coverage
- **Documentation**: Every tool has comprehensive docstrings

#### 3.2 Test and Build

**Important:** MCP servers are long-running processes. Running them directly will cause the process to hang.

**Safe ways to test the server:**
- Use the evaluation harness (see Phase 4) — recommended
- Run the server in tmux to keep it outside your main process
- Use a timeout: `timeout 5s python server.py`

#### 3.3 Quality Checklist

- [ ] All tools have proper input schemas with validation
- [ ] Error messages are actionable and guide toward correct usage
- [ ] Response formats are consistent across tools
- [ ] Pagination is handled for large result sets
- [ ] Character limits prevent context window overflow
- [ ] Authentication is properly managed
- [ ] README.md documents setup and usage
- [ ] Code is well-organized with shared utilities

---

### Phase 4: Create Evaluations

After implementing the MCP server, create comprehensive evaluations.

#### 4.1 Understand Evaluation Purpose

Evaluations test whether LLMs can effectively use the MCP server to answer realistic, complex questions.

#### 4.2 Create 10 Evaluation Questions

1. **Tool Inspection**: List available tools and understand their capabilities
2. **Content Exploration**: Use READ-ONLY operations to explore available data
3. **Question Generation**: Create 10 complex, realistic questions
4. **Answer Verification**: Solve each question yourself to verify answers

#### 4.3 Evaluation Requirements

Each question must be:
- **Independent**: Not dependent on other questions
- **Read-only**: Only non-destructive operations required
- **Complex**: Requiring multiple tool calls and deep exploration
- **Realistic**: Based on real use cases
- **Verifiable**: Single, clear answer verifiable by string comparison
- **Stable**: Answer won't change over time

#### 4.4 Output Format

Create an XML file:

```xml
<evaluation>
  <qa_pair>
    <question>Find discussions about AI model launches with animal codenames.</question>
    <answer>expected answer</answer>
  </qa_pair>
</evaluation>
```
