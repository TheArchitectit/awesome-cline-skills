---
name: canvas-design
description: Create original visual art and designs as PNG or PDF using design philosophy principles. This skill should be used when Cline needs to create posters, visual art, design pieces, or other static visual artifacts that require artistic composition, color theory, and design craftsmanship rather than simple document generation.
---

# Canvas Design

This skill creates original visual art and designs as PNG and PDF files using design philosophy principles. Unlike document generation, this skill treats each output as an art object — composed with intention, visual hierarchy, and craftsmanship.

## When to Use This Skill

- Creating posters, prints, or visual art
- Designing visual compositions for presentations or publications
- Generating artwork with specific aesthetic movements
- Creating design-forward flyers, cards, or one-pagers
- Any request for "something beautiful" or "a design" as output
- Visual design that prioritizes form, color, and composition over text

## What This Skill Does

1. **Creates Design Philosophies**: Develops aesthetic movements as the foundation for visual work
2. **Expresses Visually**: Translates philosophy into PNG/PDF artifacts
3. **Emphasizes Craftsmanship**: Every output should look meticulously crafted by a master designer
4. **Minimal Text**: Designs communicate through space, form, and color — not paragraphs
5. **Iterative Refinement**: Polishes compositions until pristine

## Process

### Step 1: Create a Design Philosophy

Generate a visual philosophy (not a layout or template) that will be expressed through form, space, color, and composition.

**Name the movement** (1-2 words): "Brutalist Joy" / "Chromatic Silence" / "Geometric Silence"

**Articulate the philosophy** (4-6 paragraphs) covering:
- Space and form
- Color and material
- Scale and rhythm
- Composition and balance
- Visual hierarchy

**Critical guidelines**:
- Emphasize **craftsmanship repeatedly**: The work must appear meticulously crafted, the product of deep expertise
- **Avoid redundancy**: Each design aspect should be mentioned once with depth
- **Leave creative space**: Remain specific about aesthetic direction but concise enough for interpretive choices
- **Visual expression over text**: Ideas communicate through design, not paragraphs

Save the design philosophy as a `.md` file.

**Example philosophies**:

| Name | Essence |
|------|---------|
| Concrete Poetry | Monumental form, bold geometry, sculptural type |
| Chromatic Language | Color as primary information system, minimal labels |
| Analog Meditation | Texture, breathing room, Japanese photobook aesthetic |
| Organic Systems | Natural clustering, modular growth patterns |
| Geometric Silence | Grid precision, dramatic negative space, Swiss formalism |

### Step 2: Identify the Conceptual Thread

Before creating the canvas, identify the subtle conceptual thread from the original request. The topic should be a **refined, niche reference embedded within the art** — sophisticated, not literal. Someone familiar with the subject should feel it intuitively; others simply experience a masterful composition.

Think like a jazz musician quoting another song — only those who know will catch it, but everyone appreciates the music.

### Step 3: Create the Canvas

With both the philosophy and conceptual framework established, express it visually.

**Requirements for professional output**:

- Use Python with `Pillow` (PIL), `reportlab`, or `cairo` for generation
- Create one single page, highly visual, design-forward output
- Use repeating patterns and perfect shapes for systematic composition
- Add sparse, clinical typography and systematic reference markers
- Anchor with simple phrases positioned subtly
- Use a limited, intentional color palette
- Ensure all elements are contained within canvas boundaries with proper margins
- Nothing overlaps unless intentionally designed to do so
- Different fonts for different text elements — research available fonts
- Thin fonts by default; make typography part of the art

**Create work that looks like it took countless hours** — composition, spacing, color choices, and typography should all demonstrate expert-level craftsmanship.

### Step 4: Refine and Polish

After the initial creation, take a second pass:

- **Don't add more graphics** — refine what exists
- Make the composition more cohesive with the philosophy
- Ensure extreme crispness and precision
- If the instinct is to add a new shape, instead ask: "How can I make what's already here more of a piece of art?"
- Check: nothing overlaps, formatting is flawless, every detail is perfect

### Step 5: Multi-Page (Optional)

If requested, create additional pages:
- Each page should be unique variations on the design philosophy
- Treat the collection like a coffee table book
- Pages should tell a story in a tasteful way
- Bundle in a single PDF or multiple PNGs

## Implementation with Python

```python
from PIL import Image, ImageDraw, ImageFont
import math

# Define canvas and palette
WIDTH, HEIGHT = 2400, 3200
BG_COLOR = (28, 40, 51)
ACCENT = (254, 68, 71)
TEXT_COLOR = (244, 246, 246)

img = Image.new('RGB', (WIDTH, HEIGHT), BG_COLOR)
draw = ImageDraw.Draw(img)

# Load fonts (use system fonts or download)
try:
    font_title = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Thin.ttf", 120)
    font_body = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Light.ttf", 36)
except:
    font_title = ImageFont.load_default()
    font_body = ImageFont.load_default()

# Compose with design philosophy
# ... (apply the aesthetic principles from step 1)

# Save
img.save('output.png', quality=95)
```

```python
# Alternative: PDF with reportlab
from reportlab.lib.pagesizes import A3
from reportlab.pdfgen import canvas

c = canvas.Canvas('output.pdf', pagesize=A3)
width, height = A3

# Apply design philosophy composition
# ...

c.save()
```

## Design Philosophy Examples

### Brutalist Joy
Philosophy: Communication through monumental form and bold geometry. Massive color blocks, sculptural typography (huge single words, tiny labels). Ideas expressed through visual weight and spatial tension. Text as rare, powerful gesture — never paragraphs. Every element placed with the precision of a master craftsman.

### Chromatic Silence
Philosophy: Color as the primary information system. Geometric precision where color zones create meaning. Typography minimal — small sans-serif labels letting chromatic fields communicate. Josef Albers' interaction meets data visualization. Words only to anchor what color already shows. The result of painstaking chromatic calibration.

### Geometric Silence
Philosophy: Pure order and restraint. Grid-based precision, stark graphics, dramatic negative space. Typography precise but minimal. Swiss formalism meets material honesty. Structure communicates, not words. Every alignment the work of countless refinements.

## Common Mistakes to Avoid

- ❌ Too much text — designs should be 90% visual, 10% essential text
- ❌ Literal interpretation — embed concepts subtly, not obviously
- ❌ AI-generated look — obsess over craftsmanship to avoid the "AI aesthetic"
- ❌ Overlapping elements — nothing should accidentally overlap
- ❌ Ignoring margins — everything needs breathing room
- ❌ Using only default fonts — typography is part of the art

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/canvas-design/` (project-level) or `~/.cline/skills/canvas-design/` (global)
2. **Two-phase output**: Always produce both the philosophy .md file AND the visual .png/.pdf file
3. **Craftsmanship emphasis**: The final output must look like a master designer created it — slow down and polish
4. **Font management**: Search for available fonts on the system; download additional ones if needed
5. **High resolution**: Generate at high DPI (at least 2400×3200 for print quality)
6. **Refinement pass**: Always do at least one refinement pass — never ship the first draft
7. **Originality**: Never copy existing artists' work to avoid copyright violations

## Dependencies

```bash
pip install Pillow reportlab
# Optional for advanced vector graphics:
pip install pycairo cairocffi
# For font management:
pip install fonttools
```
