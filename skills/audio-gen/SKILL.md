---
name: audio-gen
description: Audio generation and transcription covering text-to-speech (TTS), speech-to-text (STT/Whisper), audio format conversion, podcast editing workflows, and audio processing. This skill should be used when Cline needs to generate speech from text, transcribe audio recordings, convert between audio formats, or perform audio editing tasks.
---

# Audio Generation

This skill handles audio generation, transcription, format conversion, and editing. It covers text-to-speech synthesis, speech-to-text transcription with Whisper, format conversion between audio types, and podcast-style editing workflows including segment assembly and normalization.

## When to Use This Skill

- Converting text to speech (TTS) for narration or accessibility
- Transcribing audio recordings to text (STT)
- Converting between audio formats (MP3, WAV, OGG, FLAC, AAC, M4A)
- Editing audio: trimming, concatenating, normalizing volume
- Podcast production: assembling segments, adding intro/outro, leveling
- Batch processing audio files (format conversion, normalization)
- Extracting audio from video files
- Generating audio with specific characteristics (sample rate, bitrate, channels)
- Creating audio snippets or ringtone-length clips

## What This Skill Does

1. **Text-to-Speech (TTS)**: Generate spoken audio from text input
2. **Speech-to-Text (STT)**: Transcribe audio to text with timestamps
3. **Format Conversion**: Convert between audio formats with quality control
4. **Audio Editing**: Trim, concatenate, normalize, and process audio
5. **Podcast Workflows**: Assemble episodes from segments with professional polish

## Process

### Step 1: Text-to-Speech Generation

Generate speech from text using available TTS engines:

```python
import subprocess
from pathlib import Path

def tts_with_edge_tts(text, output_path, voice="en-US-AriaNeural", rate="+0%", pitch="+0Hz"):
    """Generate speech using edge-tts (free, high quality, many voices).

    Args:
        text: Text content to speak
        output_path: Output audio file path (.mp3 or .wav)
        voice: Voice name (list with: edge-tts --list-voices)
        rate: Speaking rate adjustment (e.g., "+20%", "-10%")
        pitch: Pitch adjustment (e.g., "+5Hz", "-10Hz")
    """
    cmd = [
        "edge-tts",
        "--voice", voice,
        "--rate", rate,
        "--pitch", pitch,
        "--text", text,
        "--write-media", output_path
    ]
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path


def tts_with_piper(text, output_path, model="en_US-lessac-medium", noise_scale=0.667):
    """Generate speech using Piper (local, fast, offline).

    Args:
        model: Voice model name (browse: https://rhasspy.github.io/piper-samples/)
        noise_scale: Controls variation (0.0 = deterministic, 1.0 = varied)
    """
    cmd = [
        "piper",
        "--model", model,
        "--noise-scale", str(noise_scale),
        "--output_file", output_path
    ]
    subprocess.run(cmd, input=text.encode(), check=True, capture_output=True)
    return output_path
```

**Voice selection guide**:

| Engine | Best For | Pros | Cons |
|--------|----------|------|------|
| edge-tts | General narration | Free, many voices, natural | Requires internet |
| Piper | Offline/local use | Fast, no internet, private | Fewer voice options |
| espeak | Quick prototyping | Ubiquitous, tiny | Robotic quality |
| macOS say | Mac users | Built-in | Mac only, basic quality |

### Step 2: Speech-to-Text Transcription

```python
import json

def transcribe_with_whisper(audio_path, output_format="txt", model="base", language=None):
    """Transcribe audio using OpenAI Whisper.

    Args:
        audio_path: Path to audio file
        output_format: txt, srt, vtt, json, tsv
        model: tiny, base, small, medium, large (quality/speed tradeoff)
        language: Language code (e.g., "en") or None for auto-detect
    """
    cmd = ["whisper", audio_path, "--output_format", output_format, "--model", model]
    if language:
        cmd.extend(["--language", language])

    subprocess.run(cmd, check=True, capture_output=True)

    # Read the output file
    stem = Path(audio_path).stem
    parent = Path(audio_path).parent
    output_file = parent / f"{stem}.{output_format}"

    if output_format == "json" and output_file.exists():
        with open(output_file) as f:
            return json.load(f)
    elif output_file.exists():
        return output_file.read_text()
    return None


def transcribe_with_faster_whisper(audio_path, model="base", language=None):
    """Transcribe using faster-whisper (4x faster, less memory).

    Returns list of segments with timestamps.
    """
    from faster_whisper import WhisperModel

    whisper_model = WhisperModel(model, device="cpu", compute_type="int8")
    segments, info = whisper_model.transcribe(audio_path, language=language)

    results = []
    for segment in segments:
        results.append({
            "start": segment.start,
            "end": segment.end,
            "text": segment.text.strip()
        })
    return results
```

**Model selection guide**:

| Model | VRAM | Speed | Accuracy | Best For |
|-------|------|-------|----------|----------|
| tiny | ~1 GB | Fastest | Basic | Quick rough drafts |
| base | ~1 GB | Fast | Good | Most use cases |
| small | ~2 GB | Moderate | Better | Interviews, meetings |
| medium | ~5 GB | Slow | Great | Professional transcripts |
| large | ~10 GB | Slowest | Best | Critical accuracy needs |

### Step 3: Audio Format Conversion

```python
def convert_audio(input_path, output_path, bitrate="192k", sample_rate=None, channels=None):
    """Convert between audio formats with quality control.

    Format detected from output_path extension.
    Common: mp3, wav, ogg, flac, aac, m4a, opus
    """
    cmd = ["ffmpeg", "-i", input_path, "-y"]

    # Codec selection based on format
    format_codecs = {
        ".mp3": "libmp3lame",
        ".ogg": "libvorbis",
        ".flac": "flac",
        ".aac": "aac",
        ".m4a": "aac",
        ".opus": "libopus",
        ".wav": None,  # PCM, no codec needed
    }

    ext = Path(output_path).suffix.lower()
    codec = format_codecs.get(ext)
    if codec:
        cmd.extend(["-c:a", codec])

    if bitrate and ext not in (".wav", ".flac"):
        cmd.extend(["-b:a", bitrate])

    if sample_rate:
        cmd.extend(["-ar", str(sample_rate)])

    if channels:
        cmd.extend(["-ac", str(channels)])

    cmd.append(output_path)
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path
```

**Format recommendations**:

| Format | Use Case | Typical Bitrate |
|--------|----------|-----------------|
| MP3 | Universal compatibility | 128-320 kbps |
| WAV | Lossless editing, archives | 1411 kbps (CD) |
| FLAC | Lossless with compression | ~800 kbps |
| OGG Vorbis | Web, open formats | 128-256 kbps |
| Opus | Best quality/size ratio | 64-128 kbps |
| M4A/AAC | Apple ecosystem | 128-256 kbps |

### Step 4: Audio Editing

```python
def trim_audio(input_path, output_path, start_sec=0, end_sec=None):
    """Trim audio to specified time range."""
    cmd = ["ffmpeg", "-i", input_path, "-ss", str(start_sec)]
    if end_sec:
        cmd.extend(["-to", str(end_sec)])
    cmd.extend(["-c", "copy", "-y", output_path])
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path


def concatenate_audio(input_files, output_path, crossfade_sec=0):
    """Concatenate multiple audio files.

    Args:
        input_files: List of audio file paths
        crossfade_sec: Crossfade duration between segments (0 = no crossfade)
    """
    if crossfade_sec > 0:
        # Use ffmpeg complex filter for crossfade
        inputs = []
        for f in input_files:
            inputs.extend(["-i", f])

        filter_parts = []
        n = len(input_files)
        # Build crossfade chain
        for i in range(n - 1):
            if i == 0:
                input_a = f"[{i}:a]"
            else:
                input_a = f"[cf{i-1}]"
            input_b = f"[{i+1}:a]"
            output_label = f"[cf{i}]"
            filter_parts.append(
                f"{input_a}{input_b}acrossfade=d={crossfade_sec}:c1=tri:c2=tri{output_label}"
            )

        cmd = ["ffmpeg"] + inputs + [
            "-filter_complex", ";".join(filter_parts),
            "-y", output_path
        ]
    else:
        # Simple concatenation (requires same format)
        list_file = "/tmp/concat_list.txt"
        with open(list_file, "w") as f:
            for path in input_files:
                f.write(f"file '{path}'\n")

        cmd = [
            "ffmpeg", "-f", "concat", "-safe", "0",
            "-i", list_file, "-c", "copy", "-y", output_path
        ]

    subprocess.run(cmd, check=True, capture_output=True)
    return output_path


def normalize_audio(input_path, output_path, target_lufs=-16):
    """Normalize audio loudness to broadcast standard.

    Args:
        target_lufs: Target loudness in LUFS (-14 for Spotify, -16 for podcast, -24 for broadcast)
    """
    cmd = [
        "ffmpeg", "-i", input_path,
        "-af", f"loudnorm=I={target_lufs}:TP=-1.5:LRA=11",
        "-y", output_path
    ]
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path
```

### Step 5: Podcast Production Workflow

```python
def assemble_podcast(segments, output_path, intro_path=None, outro_path=None,
                     crossfade=1.5, target_lufs=-16):
    """Assemble a podcast episode from segments with intro/outro and normalization.

    Args:
        segments: Ordered list of segment audio file paths
        intro_path: Optional intro music/audio
        outro_path: Optional outro music/audio
        crossfade: Crossfade duration between segments in seconds
        target_lufs: Target loudness for normalization
    """
    all_parts = []
    if intro_path:
        all_parts.append(intro_path)
    all_parts.extend(segments)
    if outro_path:
        all_parts.append(outro_path)

    # Step 1: Concatenate with crossfade
    raw_path = output_path.replace(".mp3", "_raw.mp3")
    concatenate_audio(all_parts, raw_path, crossfade_sec=crossfade)

    # Step 2: Normalize loudness
    normalize_audio(raw_path, output_path, target_lufs=target_lufs)

    # Cleanup
    Path(raw_path).unlink(missing_ok=True)
    return output_path


def extract_audio_from_video(video_path, output_path=None, bitrate="192k"):
    """Extract audio track from a video file."""
    if output_path is None:
        output_path = f"{Path(video_path).stem}.mp3"

    cmd = [
        "ffmpeg", "-i", video_path,
        "-vn",  # No video
        "-acodec", "libmp3lame",
        "-b:a", bitrate,
        "-y", output_path
    ]
    subprocess.run(cmd, check=True, capture_output=True)
    return output_path
```

## Error Handling

- **Missing ffmpeg**: Verify ffmpeg is installed before any operation; provide platform-specific install instructions
- **Unsupported format**: Check format compatibility; suggest conversion before processing
- **Memory errors on long audio**: For files >1 hour, process in segments; use streaming where possible
- **Transcription quality**: If Whisper output is poor, try a larger model or specify language explicitly
- **Voice model not found**: List available voices/models and suggest alternatives
- **Concatenation failures**: Ensure all segments share the same sample rate and channel count before concatenating

## Common Pitfalls

- ❌ Not normalizing audio — inconsistent loudness is the #1 podcast quality issue
- ❌ Using low-quality TTS voices for professional output — test multiple voices before committing
- ❌ Forgetting `-y` flag in ffmpeg — it will hang waiting for overwrite confirmation
- ❌ Using `-c copy` for crossfade operations — re-encoding is required for filter effects
- ❌ Not specifying language in Whisper — auto-detection can be wrong for short clips or accented speech

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/audio-gen/` (project-level) or `~/.cline/skills/audio-gen/` (global)
2. **Always check for ffmpeg first**: Most operations depend on ffmpeg being available
3. **Preserve originals**: Never overwrite source audio files — always write to new paths
4. **Report audio properties**: Show duration, format, bitrate, and sample rate after processing
5. **Normalize by default**: Always normalize loudness for podcast and content production
6. **Use lossless intermediates**: When chaining operations, use WAV for intermediate files to avoid generation loss
7. **Test with short clips**: For long audio, test the workflow on a 30-second clip first

## Dependencies

```bash
# Required:
sudo apt install ffmpeg   # or: brew install ffmpeg

# TTS options:
pip install edge-tts      # Free cloud TTS
pip install piper-tts     # Local offline TTS

# Transcription:
pip install openai-whisper          # OpenAI Whisper
pip install faster-whisper         # Faster alternative

# Audio processing:
pip install pydub          # Higher-level audio manipulation
pip install Pillow         # For waveform visualization if needed
```
