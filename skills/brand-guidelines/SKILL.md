---
name: brand-guidelines
description: Applies consistent brand colors and typography to artifacts for professional visual identity and design standards. This skill should be used when creating branded presentations, reports, documents, or visual assets that need consistent look-and-feel with professional color palettes and typography.
---

# Brand Guidelines Styling

## Overview

This skill provides access to brand identity and style resources for creating consistent, professional visual artifacts.

**Keywords**: branding, corporate identity, visual identity, post-processing, styling, brand colors, typography, visual formatting, visual design

## Brand Color Palette

### Primary Colors

When creating artifacts for professional presentation, use these colors:

- **Dark Background**: `#1a1b26` or `#1e1e2e` (based on Nord/dark themes)
- **Light Background**: `#eceff4` or `#d8dee9` (based on Nord light themes)
- **Text (Dark)**: `#d8dee9` or `#eceff4`
- **Text (Light)**: `#2e3440` or `#434c5e`
- **Accent Blue**: `#81a1c1` or `#88c0d0`
- **Accent Green**: `#a3be8c` or `#8fbcbb`
- **Accent Purple**: `#b48ead` or `#d08770`
- **Accent Yellow**: `#ebcb8b` or `#bf616a`

### Functional Colors

- **Success Green**: Used for success states and positive indicators
- **Error Red**: Used for error states and destructive actions
- **Warning Yellow**: Used for warnings and caution indicators
- **Info Blue**: Used for informational elements and neutral highlights

## Typography

### Font Selection

- **Headings/Code**: JetBrains Mono, Fira Code, or any modern monospace font
- **Body Text**: System sans-serif (Inter, San Francisco, or equivalent)

### Font Application Rules

- Apply monospace fonts to code blocks, headings (24pt and larger), and technical content
- Apply system sans-serif fonts to body text and general paragraphs
- Automatically fall back to system defaults if custom fonts unavailable
- Preserve readability across all systems

### Text Styling

- Code blocks and headings (14pt+): Monospace font
- Body text: System sans-serif font
- Smart color selection based on background (dark/light)
- Preserve text hierarchy and formatting

## Shape and Accent Colors

- Non-text shapes use accent colors from palette
- Cycle through blue, green, purple, and yellow accents
- Maintain visual interest while staying on-brand
- Support both dark and light modes

## Usage Guidelines

### When to Use

- Creating presentation slides, reports, or documents
- Designing visual assets or graphics
- Applying consistent styling across multiple artifacts
- Creating branded materials

### Best Practices

- Use monospace fonts for code and technical content
- Apply accent colors sparingly for maximum impact
- Ensure sufficient contrast between text and background
- Consider dark/light mode when choosing colors
- Test color combinations in both light and dark contexts

## Implementing in Documents

### PowerPoint (python-pptx)

```python
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor

# Brand colors
DARK_BG = RGBColor(0x1a, 0x1b, 0x26)
LIGHT_TEXT = RGBColor(0xd8, 0xde, 0xe9)
ACCENT_BLUE = RGBColor(0x81, 0xa1, 0xc1)
ACCENT_GREEN = RGBColor(0xa3, 0xbe, 0x8c)

# Apply to shapes
from pptx import Presentation
prs = Presentation()
slide = prs.slides.add_slide(prs.slide_layouts[6])  # Blank layout

# Set background
background = slide.background
fill = background.fill
fill.solid()
fill.fore_color.rgb = DARK_BG
```

### PDF (reportlab)

```python
from reportlab.lib.colors import HexColor

# Brand colors
DARK_BG = HexColor('#1a1b26')
LIGHT_TEXT = HexColor('#d8dee9')
ACCENT_BLUE = HexColor('#81a1c1')
```

### HTML/CSS

```css
:root {
  --bg-dark: #1a1b26;
  --text-light: #d8dee9;
  --accent-blue: #81a1c1;
  --accent-green: #a3be8c;
  --accent-purple: #b48ead;
  --accent-yellow: #ebcb8b;
}
```

## Font Management

- Uses system-installed JetBrains Mono or Fira Code when available
- Provides automatic fallback to system monospace fonts
- No font installation required — works with existing system fonts
- For best results, install JetBrains Mono or Fira Code in your environment

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/brand-guidelines/` (project-level) or `~/.cline/skills/brand-guidelines/` (global)
2. **Activation**: Cline will suggest this skill when you need consistent branding on documents or visual assets
3. **Progressive loading**: Metadata is always available; detailed color and typography guidance loads on demand via `use_skill`
