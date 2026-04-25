---
name: pptx
description: Presentation creation, editing, and analysis with support for layouts, formatting, speaker notes, and visual design. This skill should be used when Cline needs to create new PowerPoint presentations, modify or edit existing slides, work with presentation layouts, add speaker notes, or perform any other presentation tasks.
---

# PPTX Creation, Editing, and Analysis

## Overview

This skill enables Cline to create, edit, and analyze PowerPoint presentations (.pptx files). A .pptx file is a ZIP archive containing XML — different tools and workflows are available depending on the task.

## When to Use This Skill

- Creating new presentations from scratch
- Modifying or editing existing presentation content
- Working with slide layouts, masters, and themes
- Adding speaker notes or comments
- Designing professional slides with visual hierarchy
- Analyzing presentation structure and content

## Workflow Decision Tree

### Reading/Analyzing Content
Use **pandoc** for text extraction or **python-pptx** for detailed structure analysis.

### Creating New Presentation
Use **python-pptx** for full control over layouts, formatting, and content.

### Editing Existing Presentation
Use **python-pptx** to load, modify, and save while preserving structure, or edit OOXML directly for advanced changes.

## Reading and Analyzing Content

### Text Extraction with pandoc

```bash
pandoc path-to-file.pptx -o output.md
```

### Detailed Analysis with python-pptx

```python
from pptx import Presentation

prs = Presentation('presentation.pptx')

for i, slide in enumerate(prs.slides):
    print(f"\nSlide {i+1}:")
    for shape in slide.shapes:
        if shape.has_text_frame:
            for paragraph in shape.text_frame.paragraphs:
                print(f"  {paragraph.text}")
        if shape.has_table:
            table = shape.table
            for row in table.rows:
                print("  | " + " | ".join(cell.text for cell in row.cells) + " |")
        if hasattr(shape, "image"):
            print(f"  [Image: {shape.image.content_type}]")
```

### Raw XML Access (Advanced)

For comments, animations, slide layouts, and complex formatting, unpack the .pptx:

```python
import zipfile

with zipfile.ZipFile('presentation.pptx') as z:
    z.extractall('unpacked/')
```

Key file structures:
- `ppt/presentation.xml` — Main presentation metadata
- `ppt/slides/slide{N}.xml` — Individual slide contents
- `ppt/notesSlides/notesSlide{N}.xml` — Speaker notes
- `ppt/slideLayouts/` — Layout templates
- `ppt/theme/theme1.xml` — Theme colors and fonts
- `ppt/media/` — Images and media

## Creating New Presentations

### Basic Presentation

```python
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

prs = Presentation()
prs.slide_width = Inches(13.333)  # 16:9 widescreen
prs.slide_height = Inches(7.5)

# Title slide
slide_layout = prs.slide_layouts[0]  # Title Slide layout
slide = prs.slides.add_slide(slide_layout)
slide.shapes.title.text = "Quarterly Report"
slide.placeholders[1].text = "Q4 2026 Results"

prs.save('report.pptx')
```

### Custom Slide from Scratch

```python
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

prs = Presentation()
slide = prs.slides.add_slide(prs.slide_layouts[6])  # Blank layout

# Add background
background = slide.background
fill = background.fill
fill.solid()
fill.fore_color.rgb = RGBColor(0x1C, 0x28, 0x33)

# Add text box
left = Inches(1)
top = Inches(2)
width = Inches(8)
height = Inches(2)

txBox = slide.shapes.add_textbox(left, top, width, height)
tf = txBox.text_frame
tf.word_wrap = True

p = tf.paragraphs[0]
p.text = "Key Insight"
p.font.size = Pt(44)
p.font.bold = True
p.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
p.alignment = PP_ALIGN.LEFT

prs.save('custom_slide.pptx')
```

### Adding Shapes and Images

```python
from pptx.enum.shapes import MSO_SHAPE

# Add shape
shape = slide.shapes.add_shape(
    MSO_SHAPE.ROUNDED_RECTANGLE,
    Inches(1), Inches(4), Inches(3), Inches(1.5)
)
shape.fill.solid()
shape.fill.fore_color.rgb = RGBColor(0x00, 0x70, 0xC0)
shape.line.fill.background()

# Add text in shape
tf = shape.text_frame
tf.text = "Call to Action"
tf.paragraphs[0].font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
tf.paragraphs[0].font.size = Pt(18)
tf.paragraphs[0].alignment = PP_ALIGN.CENTER

# Add image
slide.shapes.add_picture('logo.png', Inches(10), Inches(0.5), Inches(2), Inches(1))
```

### Adding Tables

```python
rows, cols = 4, 3
left = Inches(1)
top = Inches(2)
width = Inches(8)
height = Inches(3)

table_shape = slide.shapes.add_table(rows, cols, left, top, width, height)
table = table_shape.table

# Set headers
headers = ['Metric', 'Current', 'Previous']
for i, header in enumerate(headers):
    cell = table.cell(0, i)
    cell.text = header
    cell.fill.solid()
    cell.fill.fore_color.rgb = RGBColor(0x00, 0x70, 0xC0)

# Add data
data = [
    ['Revenue', '$1.2M', '$980K'],
    ['Users', '15,000', '12,000'],
    ['Growth', '22%', '18%'],
]
for row_idx, row_data in enumerate(data, 1):
    for col_idx, value in enumerate(row_data):
        table.cell(row_idx, col_idx).text = value
```

### Adding Charts

```python
from pptx.chart.data import CategoryChartData
from pptx.enum.chart import XL_CHART_TYPE

chart_data = CategoryChartData()
chart_data.categories = ['Q1', 'Q2', 'Q3', 'Q4']
chart_data.add_series('Revenue', (100, 120, 130, 150))
chart_data.add_series('Expenses', (80, 85, 90, 95))

chart_shape = slide.shapes.add_chart(
    XL_CHART_TYPE.COLUMN_CLUSTERED,
    Inches(1), Inches(2), Inches(8), Inches(5),
    chart_data
)
```

## Editing Existing Presentations

### Modify Content

```python
from pptx import Presentation

prs = Presentation('existing.pptx')

for slide in prs.slides:
    for shape in slide.shapes:
        if shape.has_text_frame:
            for paragraph in shape.text_frame.paragraphs:
                # Modify specific text
                if "Old Company Name" in paragraph.text:
                    for run in paragraph.runs:
                        run.text = run.text.replace("Old Company Name", "New Company Name")

prs.save('modified.pptx')
```

### Add Speaker Notes

```python
from pptx import Presentation

prs = Presentation('existing.pptx')

for slide in prs.slides:
    notes_slide = slide.notes_slide
    notes_slide.notes_text_frame.text = "Remember to discuss Q3 metrics in detail."

prs.save('with_notes.pptx')
```

## Design Principles

### Color Palette Selection

Choose colors that match the content's subject, industry, and mood. Some starting palettes:

| Palette | Colors |
|---------|--------|
| Classic Blue | Navy #1C2833, Slate #2E4053, Silver #AAB7B8 |
| Teal & Coral | Teal #5EA8A7, Deep Teal #277884, Coral #FE4447 |
| Warm Blush | Mauve #A49393, Blush #EED6D3, Cream #FAF7F2 |
| Black & Gold | Gold #BF9A4A, Black #000000, Cream #F4F6F6 |
| Sage & Terracotta | Sage #87A96B, Terracotta #E07A5F, Cream #F4F1DE |

### Layout Best Practices

- **Two-column layout (preferred)**: Header spanning full width, then text and chart side-by-side
- **Full-slide layout**: Let charts/tables take the entire slide for maximum impact
- **Never vertically stack**: Don't place charts/tables below text in a single column
- **16:9 widescreen**: Use `Inches(13.333)` × `Inches(7.5)` for modern presentations
- **Consistent margins**: Keep at least 0.5" padding on all sides

### Typography

- Use web-safe fonts: Arial, Helvetica, Georgia, Verdana, Trebuchet MS
- Create hierarchy through size, weight, and color
- Extreme size contrast: 44pt headlines vs 14pt body
- Ensure strong text-background contrast for readability
- All-caps headers with wide letter spacing for section titles

## Converting to Images (Verification)

To visually verify presentation output:

```bash
soffice --headless --convert-to pdf presentation.pptx
pdftoppm -jpeg -r 150 presentation.pdf slide
```

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/pptx/` (project-level) or `~/.cline/skills/pptx/` (global)
2. **State your design approach**: Before creating a presentation, explain your color and layout choices
3. **Use python-pptx by default**: It provides full control over content, formatting, and structure
4. **Verify output**: Convert to images and inspect for layout issues before delivering
5. **Preserve existing work**: When editing, match the existing template's conventions and styles
6. **Blank layout for custom slides**: Use layout index 6 for full design control
7. **Always use widescreen (16:9)**: Modern presentations default to widescreen

## Code Style

- Write concise Python code
- Avoid verbose variable names and redundant operations
- Avoid unnecessary print statements
- Use context managers where appropriate

## Dependencies

```bash
pip install python-pptx
# For text extraction:
pip install pandoc  # or: sudo apt-get install pandoc
# For PDF conversion:
# sudo apt-get install libreoffice poppler-utils
```
