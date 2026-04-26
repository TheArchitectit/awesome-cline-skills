---
name: image-enhancer
description: Improve image and screenshot quality including resolution upscaling, sharpness correction, noise reduction, color grading, and formatting optimization for documentation, presentations, and web. This skill should be used when Cline needs to enhance, resize, reformat, or otherwise improve the visual quality of images and screenshots.
---

# Image Enhancer

This skill improves the visual quality of images and screenshots through resolution upscaling, sharpness correction, noise reduction, color optimization, and format conversion. It produces professional-grade results suitable for documentation, presentations, web publishing, and print.

## When to Use This Skill

- Upscaling low-resolution screenshots or images
- Sharpening blurry photos or captured screens
- Reducing noise from compressed or low-light images
- Converting between image formats (PNG, JPEG, WebP, SVG, TIFF)
- Optimizing images for web (file size reduction while preserving quality)
- Preparing images for documentation or presentations
- Adding watermarks or annotations
- Batch processing multiple images with consistent settings
- Cropping and resizing for specific aspect ratios or dimensions

## What This Skill Does

1. **Resolution Enhancement**: Upscales images while preserving detail and minimizing artifacts
2. **Sharpness Correction**: Applies targeted sharpening to recover detail from soft images
3. **Noise Reduction**: Removes compression artifacts and sensor noise
4. **Color Optimization**: Adjusts brightness, contrast, saturation, and white balance
5. **Format Conversion**: Converts between formats with optimal compression settings
6. **Batch Processing**: Applies consistent enhancements across multiple files

## Process

### Step 1: Analyze the Source Image

Before processing, assess the image:

- **Resolution**: Current dimensions and target dimensions
- **Quality issues**: Blur, noise, compression artifacts, poor lighting
- **Format**: Current format and whether conversion is needed
- **Use case**: Documentation, web, presentation, print, social media

```python
from PIL import Image
import os

def analyze_image(filepath):
    """Analyze image properties and quality indicators."""
    img = Image.open(filepath)
    info = {
        "filename": os.path.basename(filepath),
        "format": img.format,
        "mode": img.mode,
        "size": img.size,
        "width": img.width,
        "height": img.height,
        "dpi": img.info.get("dpi", (72, 72)),
        "file_size_kb": os.path.getsize(filepath) / 1024,
    }
    # Detect potential quality issues
    if img.width < 800 or img.height < 600:
        info["issue"] = "low_resolution"
    elif img.mode == "P":
        info["issue"] = "palette_mode_limited_colors"
    return info
```

### Step 2: Apply Resolution Enhancement

Upscale images using appropriate interpolation:

```python
from PIL import Image

def upscale_image(filepath, target_width=None, target_height=None, scale_factor=2):
    """Upscale image with high-quality interpolation."""
    img = Image.open(filepath)

    if target_width and target_height:
        new_size = (target_width, target_height)
    else:
        new_size = (img.width * scale_factor, img.height * scale_factor)

    # LANCZOS is best for upscaling — preserves detail and reduces aliasing
    upscaled = img.resize(new_size, Image.LANCZOS)
    return upscaled
```

For screenshot-specific upscaling (pixel art, UI elements):
```python
def upscale_screenshot(filepath, scale_factor=2):
    """Upscale screenshots preserving pixel clarity."""
    img = Image.open(filepath)
    new_size = (img.width * scale_factor, img.height * scale_factor)
    # NEAREST preserves hard pixel edges for UI screenshots
    return img.resize(new_size, Image.NEAREST)
```

### Step 3: Sharpen and Denoise

Apply sharpening and noise reduction in the correct order:

```python
from PIL import Image, ImageFilter, ImageEnhance

def enhance_sharpness(img, factor=1.5):
    """Apply controlled sharpening without over-sharpening."""
    # For screenshots — use UnsharpMask for control
    return img.filter(ImageFilter.UnsharpMask(radius=2, percent=150, threshold=3))

def reduce_noise(img, strength=1):
    """Reduce noise while preserving edges."""
    # Mild median filter for noise without destroying detail
    return img.filter(ImageFilter.MedianFilter(size=strength))

def enhance_for_docs(filepath, sharpness=1.3, contrast=1.1, brightness=1.05):
    """Full enhancement pipeline for documentation images."""
    img = Image.open(filepath)

    # Order matters: denoise → sharpen → adjust → color
    img = reduce_noise(img, strength=1)
    img = enhance_sharpness(img, factor=sharpness)

    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(contrast)

    enhancer = ImageEnhance.Brightness(img)
    img = enhancer.enhance(brightness)

    return img
```

### Step 4: Format Conversion and Optimization

Convert between formats with appropriate settings:

```python
def convert_format(img, output_format, output_path, quality=85):
    """Convert image to specified format with optimal settings."""
    format_config = {
        "JPEG": {"format": "JPEG", "quality": quality, "optimize": True},
        "PNG": {"format": "PNG", "optimize": True},
        "WEBP": {"format": "WEBP", "quality": quality, "method": 6},
        "TIFF": {"format": "TIFF", "compression": "tiff_lzw"},
    }

    config = format_config.get(output_format.upper())
    if not config:
        raise ValueError(f"Unsupported format: {output_format}")

    # Convert RGBA to RGB for JPEG (no alpha support)
    if output_format.upper() == "JPEG" and img.mode in ("RGBA", "LA", "P"):
        background = Image.new("RGB", img.size, (255, 255, 255))
        if img.mode == "P":
            img = img.convert("RGBA")
        background.paste(img, mask=img.split()[-1])
        img = background

    img.save(output_path, **config)
    return output_path
```

**Format selection guide**:

| Use Case | Format | Quality | Notes |
|----------|--------|---------|-------|
| Documentation | PNG | Lossless | Crisp text, screenshots |
| Web photos | WebP | 80-85 | Smaller than JPEG, good quality |
| Web graphics | PNG | Lossless | Sharp edges, transparency |
| Presentations | PNG/JPEG | 90+ | High quality display |
| Print | TIFF/PNG | Lossless | Maximum quality |
| Social media | JPEG | 82-88 | Good quality, manageable size |
| Email | JPEG | 75-80 | Small file size priority |

### Step 5: Optimize for Specific Use Cases

```python
def optimize_for_docs(filepath, output_path, max_width=1200):
    """Optimize image for technical documentation."""
    img = Image.open(filepath)

    # Resize if wider than max_width
    if img.width > max_width:
        ratio = max_width / img.width
        new_size = (max_width, int(img.height * ratio))
        img = img.resize(new_size, Image.LANCZOS)

    # Ensure PNG for documentation (sharp text)
    if output_path.endswith('.png'):
        img.save(output_path, format="PNG", optimize=True)
    else:
        img.save(output_path, format="JPEG", quality=90, optimize=True)

    return output_path

def optimize_for_web(filepath, output_path, target_size_kb=200):
    """Optimize image for web with target file size."""
    img = Image.open(filepath)

    # Try WebP first — best compression for web
    quality = 85
    while quality >= 50:
        img.save(output_path, format="WEBP", quality=quality, method=6)
        if os.path.getsize(output_path) / 1024 <= target_size_kb:
            break
        quality -= 5

    return output_path
```

### Step 6: Batch Processing

```python
import os
from pathlib import Path

def batch_enhance(input_dir, output_dir, config=None):
    """Apply consistent enhancements to all images in a directory."""
    config = config or {"sharpness": 1.3, "contrast": 1.1, "max_width": 1200}
    os.makedirs(output_dir, exist_ok=True)

    supported = (".png", ".jpg", ".jpeg", ".webp", ".tiff", ".bmp")
    results = []

    for filepath in Path(input_dir).iterdir():
        if filepath.suffix.lower() not in supported:
            continue

        output_path = Path(output_dir) / filepath.name
        img = Image.open(filepath)

        # Apply enhancements
        img = reduce_noise(img, strength=1)
        img = enhance_sharpness(img, factor=config.get("sharpness", 1.3))

        enhancer = ImageEnhance.Contrast(img)
        img = enhancer.enhance(config.get("contrast", 1.1))

        if config.get("max_width") and img.width > config["max_width"]:
            ratio = config["max_width"] / img.width
            img = img.resize((config["max_width"], int(img.height * ratio)), Image.LANCZOS)

        img.save(str(output_path), format=filepath.suffix.lstrip(".").upper(), quality=90)
        results.append(str(output_path))

    return results
```

### Step 7: Add Watermarks and Annotations

```python
from PIL import Image, ImageDraw, ImageFont

def add_watermark(img, text="CONFIDENTIAL", position="bottom-right", opacity=128):
    """Add a text watermark to an image."""
    img = img.convert("RGBA")
    overlay = Image.new("RGBA", img.size, (255, 255, 255, 0))
    draw = ImageDraw.Draw(overlay)

    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 24)
    except (OSError, IOError):
        font = ImageFont.load_default()

    bbox = draw.textbbox((0, 0), text, font=font)
    text_width, text_height = bbox[2] - bbox[0], bbox[3] - bbox[1]
    margin = 20

    positions = {
        "bottom-right": (img.width - text_width - margin, img.height - text_height - margin),
        "bottom-left": (margin, img.height - text_height - margin),
        "top-right": (img.width - text_width - margin, margin),
        "top-left": (margin, margin),
        "center": ((img.width - text_width) // 2, (img.height - text_height) // 2),
    }

    pos = positions.get(position, positions["bottom-right"])
    draw.text(pos, text, fill=(200, 200, 200, opacity), font=font)

    return Image.alpha_composite(img, overlay).convert("RGB")
```

## Error Handling

- **Unsupported format**: Check format before processing; provide clear error with supported format list
- **Memory errors on large images**: Process in tiles or reduce resolution first; warn user before processing images >50MP
- **Transparency loss**: Convert RGBA → RGB with white background for JPEG; warn about alpha channel loss
- **EXIF orientation**: Always honor EXIF rotation data before processing
- **Corrupted files**: Catch `PIL.UnidentifiedImageError` and report without crashing
- **Font not found**: Always fall back to `ImageFont.load_default()` when custom fonts unavailable

## Common Pitfalls

- ❌ Over-sharpening — creates halos and unnatural edges. Use moderate values (1.2-1.5x)
- ❌ Upscaling beyond 4x — results become soft regardless of interpolation method
- ❌ Saving JPEG with quality >95 — negligible visual gain, much larger files
- ❌ Ignoring color profiles — images may look different across devices
- ❌ Re-compressing JPEGs multiple times — generation loss degrades quality each time

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/image-enhancer/` (project-level) or `~/.cline/skills/image-enhancer/` (global)
2. **Always analyze first**: Check image properties and quality issues before processing
3. **Preserve originals**: Never overwrite source files — always save to a new path
4. **Pipeline order**: Denoise → Sharpen → Adjust brightness/contrast → Color correct → Convert format
5. **Use LANCZOS for photos, NEAREST for pixel art/screenshots** when upscaling
6. **Report before/after**: Show file size, dimensions, and format changes to the user
7. **Batch operations**: Process all images in a directory with consistent settings when requested

## Dependencies

```bash
pip install Pillow
# Optional for advanced operations:
pip install piexif  # EXIF handling
pip install imagehash  # Perceptual image comparison
```
