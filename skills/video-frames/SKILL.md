---
name: video-frames
description: Extract and analyze video frames, create thumbnails, perform frame-by-frame analysis, and generate visual summaries from video files. This skill should be used when Cline needs to work with video content at the frame level — extracting specific frames, creating sprite sheets, analyzing visual content over time, or generating representative thumbnails.
---

# Video Frames

This skill extracts, analyzes, and processes individual frames from video files. It handles frame extraction at specific timestamps, batch frame sampling, thumbnail generation, sprite sheet creation, and frame-by-frame visual analysis for understanding video content.

## When to Use This Skill

- Extracting frames at specific timestamps from a video
- Creating thumbnails or preview images from videos
- Generating sprite sheets or contact sheets for visual overviews
- Performing frame-by-frame analysis of video content
- Detecting scene changes or transitions in video
- Creating animated GIF previews from video segments
- Extracting keyframes representative of video sections
- Comparing frames to detect visual changes over time
- Creating time-lapse summaries from long videos
- Preparing video frames for machine learning or computer vision tasks

## What This Skill Does

1. **Frame Extraction**: Pull individual or batch frames at specified timestamps or intervals
2. **Thumbnail Generation**: Create high-quality representative thumbnails from video
3. **Sprite Sheet Creation**: Generate contact sheets with evenly spaced frames
4. **Scene Detection**: Identify scene changes and transitions
5. **Frame Analysis**: Analyze visual content of extracted frames
6. **GIF Preview**: Create animated GIFs from video segments

## Process

### Step 1: Probe Video Properties

Always inspect the video before processing:

```python
import subprocess
import json

def probe_video(filepath):
    """Get video metadata using ffprobe."""
    cmd = [
        "ffprobe", "-v", "quiet", "-print_format", "json",
        "-show_format", "-show_streams", filepath
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    data = json.loads(result.stdout)

    video_stream = next(
        (s for s in data["streams"] if s["codec_type"] == "video"), None
    )
    if not video_stream:
        raise ValueError("No video stream found")

    return {
        "duration_seconds": float(data["format"]["duration"]),
        "width": video_stream["width"],
        "height": video_stream["height"],
        "fps": eval(video_stream["r_frame_rate"]),  # e.g., 30000/1001
        "codec": video_stream["codec_name"],
        "frame_count": int(video_stream.get("nb_frames", 0)),
        "file_size_mb": float(data["format"]["size"]) / (1024 * 1024),
    }
```

### Step 2: Extract Frames at Specific Timestamps

```python
import subprocess
from pathlib import Path

def extract_frame_at(video_path, timestamp_sec, output_path=None, quality=2):
    """Extract a single frame at a specific timestamp.

    Args:
        timestamp_sec: Time in seconds (e.g., 12.5 for 12.5s)
        quality: JPEG quality 1-31 (lower = better, use 2 for high quality)
    """
    if output_path is None:
        stem = Path(video_path).stem
        output_path = f"{stem}_frame_{timestamp_sec:.1f}s.png"

    cmd = [
        "ffmpeg", "-ss", str(timestamp_sec),
        "-i", video_path,
        "-frames:v", "1",
        "-q:v", str(quality),
        "-y", output_path
    ]
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path


def extract_multiple_frames(video_path, timestamps, output_dir="."):
    """Extract frames at multiple timestamps."""
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    results = []

    for ts in timestamps:
        output_path = str(Path(output_dir) / f"frame_{ts:.1f}s.png")
        extract_frame_at(video_path, ts, output_path)
        results.append(output_path)

    return results
```

### Step 3: Extract Frames at Regular Intervals

```python
def extract_frames_interval(video_path, interval_sec=1, output_dir=".", max_frames=None):
    """Extract frames at regular intervals throughout the video."""
    info = probe_video(video_path)
    duration = info["duration_seconds"]
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    cmd = [
        "ffmpeg", "-i", video_path,
        "-vf", f"fps=1/{interval_sec}",
        "-q:v", "2",
        "-y", str(Path(output_dir) / "frame_%04d.png")
    ]
    subprocess.run(cmd, check=True, capture_output=True)

    frames = sorted(Path(output_dir).glob("frame_*.png"))
    if max_frames and len(frames) > max_frames:
        # Keep evenly distributed subset
        step = len(frames) / max_frames
        frames = [frames[int(i * step)] for i in range(max_frames)]

    return [str(f) for f in frames]
```

### Step 4: Generate Thumbnails

```python
def generate_thumbnail(video_path, output_path=None, timestamp=None, width=320):
    """Generate a representative thumbnail from video.

    If no timestamp specified, picks 25% into the video (avoids black intro frames).
    """
    info = probe_video(video_path)
    if timestamp is None:
        timestamp = info["duration_seconds"] * 0.25

    if output_path is None:
        output_path = f"{Path(video_path).stem}_thumb.jpg"

    # Scale to target width maintaining aspect ratio
    height = int(width * info["height"] / info["width"])
    # Ensure even dimensions (required by some codecs)
    height = height + (height % 2)

    cmd = [
        "ffmpeg", "-ss", str(timestamp),
        "-i", video_path,
        "-frames:v", "1",
        "-vf", f"scale={width}:{height}",
        "-q:v", "2",
        "-y", output_path
    ]
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path
```

### Step 5: Create Sprite Sheet / Contact Sheet

```python
from PIL import Image

def create_sprite_sheet(video_path, output_path=None, columns=5, rows=4, thumb_width=320):
    """Create a contact sheet with evenly spaced frames."""
    info = probe_video(video_path)
    duration = info["duration_seconds"]
    total_thumbs = columns * rows

    # Calculate even intervals
    interval = duration / (total_thumbs + 1)
    timestamps = [interval * (i + 1) for i in range(total_thumbs)]

    # Extract thumbnails to temp directory
    temp_dir = f"/tmp/sprite_{Path(video_path).stem}"
    frames = extract_frames_interval(video_path, interval_sec=interval, output_dir=temp_dir, max_frames=total_thumbs)

    # Sort and take only what we need
    frames = sorted(frames)[:total_thumbs]

    # Calculate dimensions
    sample = Image.open(frames[0])
    thumb_h = int(thumb_width * sample.height / sample.width)
    padding = 4
    label_height = 20

    sheet_width = columns * (thumb_width + padding) + padding
    sheet_height = rows * (thumb_h + label_height + padding) + padding

    sheet = Image.new("RGB", (sheet_width, sheet_height), (30, 30, 30))

    for idx, frame_path in enumerate(frames):
        img = Image.open(frame_path)
        img = img.resize((thumb_width, thumb_h), Image.LANCZOS)

        col = idx % columns
        row = idx // columns
        x = padding + col * (thumb_width + padding)
        y = padding + row * (thumb_h + label_height + padding)

        sheet.paste(img, (x, y))

    if output_path is None:
        output_path = f"{Path(video_path).stem}_spritesheet.jpg"

    sheet.save(output_path, quality=90)

    # Cleanup temp files
    for f in frames:
        Path(f).unlink(missing_ok=True)
    Path(temp_dir).rmdir()

    return output_path
```

### Step 6: Scene Change Detection

```python
def detect_scenes(video_path, threshold=0.3, output_dir="."):
    """Detect scene changes using frame difference analysis."""
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    # Use ffmpeg's scene detection filter
    cmd = [
        "ffmpeg", "-i", video_path,
        "-filter:v", f"select='gt(scene,{threshold})',showinfo",
        "-f", "null", "-"
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, stderr=subprocess.STDOUT)

    # Parse scene change timestamps from showinfo output
    scenes = []
    for line in result.stdout.split("\n"):
        if "showinfo" in line and "pts_time:" in line:
            try:
                pts_time = float(line.split("pts_time:")[1].split()[0])
                scenes.append(pts_time)
            except (ValueError, IndexError):
                continue

    # Extract keyframe at each scene change
    for idx, ts in enumerate(scenes):
        output_path = str(Path(output_dir) / f"scene_{idx:03d}_{ts:.1f}s.png")
        extract_frame_at(video_path, ts, output_path)

    return scenes
```

### Step 7: Create Animated GIF Preview

```python
def create_gif_preview(video_path, output_path=None, start_sec=0, duration_sec=5,
                       width=480, fps=10):
    """Create an animated GIF preview from a video segment."""
    if output_path is None:
        output_path = f"{Path(video_path).stem}_preview.gif"

    cmd = [
        "ffmpeg", "-ss", str(start_sec),
        "-t", str(duration_sec),
        "-i", video_path,
        "-vf", f"fps={fps},scale={width}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse",
        "-loop", "0",
        "-y", output_path
    ]
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path
```

## Error Handling

- **Missing ffmpeg**: Check for ffmpeg availability first; provide install instructions if absent
- **Corrupted video files**: Catch subprocess errors and report the specific ffmpeg error message
- **Duration mismatch**: If extracted frame count doesn't match expected count, verify fps and duration
- **Memory limits on long videos**: For videos >30 min, use interval extraction instead of every-frame; warn about disk space
- **Codec incompatibility**: If ffmpeg fails, try with `-hwaccel auto` or `-c:v libx264` for re-encoding
- **Timestamp out of range**: Validate requested timestamps against video duration before extraction

## Common Pitfalls

- ❌ Using `-ss` after `-i` (slow seeking) — place `-ss` before `-i` for fast seeking
- ❌ Not using `-q:v 2` — default JPEG quality from ffmpeg is poor
- ❌ Extracting every frame from long videos — always use interval-based sampling
- ❌ Ignoring orientation metadata — some phone videos need rotation filters
- ❌ GIF files too large — limit duration, reduce fps, and scale down for web previews

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/video-frames/` (project-level) or `~/.cline/skills/video-frames/` (global)
2. **Always probe first**: Get video metadata before any extraction to validate parameters
3. **Fast seeking**: Use `-ss` before `-i` for timestamp extraction (much faster)
4. **Disk space awareness**: Warn user when extracting many frames from long videos
5. **Clean up temp files**: Remove intermediate frames after sprite sheet creation
6. **Report results**: Show frame count, file sizes, and timestamps after extraction

## Dependencies

```bash
# Required: ffmpeg and ffprobe
# Ubuntu/Debian:
sudo apt install ffmpeg
# macOS:
brew install ffmpeg

# Python dependencies:
pip install Pillow
```
