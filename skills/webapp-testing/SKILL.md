---
name: webapp-testing
description: Toolkit for interacting with and testing local web applications using Playwright. This skill should be used when verifying frontend functionality, debugging UI behavior, capturing browser screenshots, checking page content, or automating browser interactions for testing purposes.
---

# Web Application Testing

To test local web applications, write native Python Playwright scripts.

## Decision Tree: Choosing Your Approach

```
User task → Is it static HTML?
    ├─ Yes → Read HTML file directly to identify selectors
    │         ├─ Success → Write Playwright script using selectors
    │         └─ Fails/Incomplete → Treat as dynamic (below)
    │
    └─ No (dynamic webapp) → Is the server already running?
        ├─ No → Start the server, then proceed
        │
        └─ Yes → Reconnaissance-then-action:
            1. Navigate and wait for networkidle
            2. Take screenshot or inspect DOM
            3. Identify selectors from rendered state
            4. Execute actions with discovered selectors
```

## Quick Start

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)  # Always use headless mode
    page = browser.new_page()
    page.goto('http://localhost:3000')
    page.wait_for_load_state('networkidle')  # CRITICAL: Wait for JS to execute
    page.screenshot(path='screenshot.png', full_page=True)
    browser.close()
```

## Prerequisites

Install Playwright:

```bash
pip install playwright
playwright install chromium
```

## Reconnaissance-Then-Action Pattern

For dynamic applications, always inspect before acting:

### 1. Inspect the Rendered DOM

```python
# Take a screenshot to see what's visible
page.screenshot(path='/tmp/inspect.png', full_page=True)

# Get the full HTML content
content = page.content()

# Find all interactive elements
buttons = page.locator('button').all()
links = page.locator('a').all()
inputs = page.locator('input').all()
```

### 2. Identify Selectors

From the inspection results, identify reliable selectors:
- Text-based: `page.get_by_text("Submit")`
- Role-based: `page.get_by_role("button", name="Save")`
- Label-based: `page.get_by_label("Email")`
- Test ID: `page.get_by_test_id("login-btn")`
- CSS: `page.locator(".submit-button")`

### 3. Execute Actions

```python
# Click
page.get_by_role("button", name="Submit").click()

# Type text
page.get_by_label("Email").fill("user@example.com")

# Select dropdown
page.get_by_label("Country").select_option("US")

# Check checkbox
page.get_by_label("Accept terms").check()
```

## Common Testing Patterns

### Testing Page Navigation

```python
page.goto('http://localhost:3000')
page.wait_for_load_state('networkidle')

# Click a link and wait for navigation
with page.expect_navigation():
    page.get_by_text("About").click()

assert page.url == 'http://localhost:3000/about'
```

### Testing Form Submission

```python
page.goto('http://localhost:3000/contact')
page.wait_for_load_state('networkidle')

# Fill form
page.get_by_label("Name").fill("Test User")
page.get_by_label("Email").fill("test@example.com")
page.get_by_label("Message").fill("Hello World")

# Submit and check result
page.get_by_role("button", name="Send").click()
page.wait_for_selector(".success-message")
assert page.get_by_text("Message sent").is_visible()
```

### Capturing Console Logs

```python
logs = []

def handle_console(msg):
    logs.append(f"{msg.type}: {msg.text}")

page.on("console", handle_console)
page.goto('http://localhost:3000')
page.wait_for_load_state('networkidle')

# Check for errors
errors = [log for log in logs if log.startswith("error")]
if errors:
    print(f"Console errors found: {errors}")
```

### Waiting for Dynamic Content

```python
# Wait for specific element
page.wait_for_selector(".data-loaded")

# Wait for network to be idle
page.wait_for_load_state('networkidle')

# Wait with custom timeout
page.wait_for_selector(".result", timeout=10000)
```

## Common Pitfall

❌ **Don't** inspect the DOM before waiting for `networkidle` on dynamic apps
✅ **Do** wait for `page.wait_for_load_state('networkidle')` before inspection

## Best Practices

- Always use `sync_playwright()` for synchronous scripts
- Always launch Chromium in headless mode
- Always close the browser when done
- Use descriptive selectors: text, role, label, or test ID
- Add appropriate waits before interacting with elements
- Take screenshots to debug unexpected behavior
- Use `full_page=True` for comprehensive visual debugging

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/webapp-testing/` (project-level) or `~/.cline/skills/webapp-testing/` (global)
2. **Activation**: Cline will suggest this skill when you need to test a web app, take browser screenshots, or debug UI behavior
3. **Progressive loading**: Only metadata loads initially; full testing patterns activate via `use_skill` when testing begins
