---
name: godot-helper
description: Godot 4.x development guide covering scene tree patterns, GDScript best practices, signal architecture, export templates, and engine-specific workflows. This skill should be used when developing games in Godot 4.x, designing scene hierarchies, writing GDScript, configuring exports, or troubleshooting Godot-specific issues.
---

# Godot 4.x Development Guide

This skill provides structured guidance for building games in Godot 4.x, covering scene architecture, GDScript patterns, signal design, and export workflows specific to the engine.

## Prerequisites

- Godot 4.x installed (4.2+ recommended)
- Basic familiarity with the Godot editor
- Understanding of object-oriented programming concepts

## When to Use This Skill

- Designing scene trees and node hierarchies in Godot 4.x
- Writing GDScript 2.0 code following engine conventions
- Setting up signal-based communication between nodes
- Configuring export templates for multi-platform builds
- Debugging common Godot-specific issues
- Optimizing Godot projects for performance

## Scene Tree Patterns

### Composition Over Inheritance

Godot's node system favors composition. Design scenes as reusable building blocks rather than deep inheritance hierarchies.

**❌ Avoid (deep inheritance):**
```
Character → Player → Warrior → WarriorWithShield
```

**✅ Prefer (composition):**
```
Character (base scene)
  ├── HealthComponent (attached script)
  ├── CombatComponent (attached script)
  └── MovementComponent (attached script)
```

### Scene Instancing Patterns

```
# Inherit: Base scene + modifications
# Use when: You need the base scene with small overrides

# Instance: Standalone copy of the scene
# Use when: You need the scene as-is, no modifications

# Transient: Created/destroyed at runtime
# Use when: Bullets, particles, pickups
```

### Node Organization

```
Game (Node)
├── World (Node3D)
│   ├── Environment (WorldEnvironment)
│   ├── Sun (DirectionalLight3D)
│   ├── Level (Node3D) ← Load levels here
│   └── Entities (Node3D) ← Spawn dynamic entities here
├── Players (Node)
│   └── Player1 (CharacterBody3D)
├── UI (CanvasLayer) ← UI stays independent of world
│   ├── HUD (Control)
│   ├── Menus (Control)
│   └── Dialogs (Control)
├── Systems (Node) ← Autoloads and managers
│   ├── GameManager
│   ├── AudioManager
│   └── SaveManager
└── Debug (CanvasLayer) ← Debug overlays, only in dev builds
```

### Scene Switching

```gdscript
# SceneManager autoload
extends Node

var current_scene: Node

func _ready():
    current_scene = get_child(0)

func switch_scene(scene_path: String) -> void:
    # Fade out (optional)
    call_deferred("_deferred_switch", scene_path)

func _deferred_switch(scene_path: String) -> void:
    current_scene.free()
    var next_scene = load(scene_path).instantiate()
    add_child(next_scene)
    current_scene = next_scene
```

## GDScript Best Practices

### Script Structure Template

```gdscript
## Brief description of what this script does.
##
## Extended description of the script's purpose and how it fits
## into the larger system.

class_name ClassName  # Optional but recommended for typed references

# Signals
signal health_changed(new_value: float)
signal died

# Exports
@export var max_health: float = 100.0
@export_range(0.0, 1.0) var defense_modifier: float = 0.0

# Public variables
var current_health: float

# Private variables
var _is_invulnerable: bool = false

# References
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Lifecycle
func _init() -> void:
    # Initialize non-node dependencies
    pass

func _ready() -> void:
    # Setup node references, connect signals, initialize state
    current_health = max_health

func _process(delta: float) -> void:
    # Frame-by-frame logic (UI, timers, non-physics updates)
    pass

func _physics_process(delta: float) -> void:
    # Physics-dependent logic (movement, collision checks)
    pass

# Public methods
func take_damage(amount: float) -> void:
    if _is_invulnerable:
        return
    var actual_damage = amount * (1.0 - defense_modifier)
    current_health = maxf(0.0, current_health - actual_damage)
    health_changed.emit(current_health)
    if current_health <= 0.0:
        died.emit()

# Private methods
func _apply_knockback(direction: Vector2, force: float) -> void:
    velocity = direction * force
```

### Typed Code

```gdscript
# ✅ Always use static types for variables
var speed: float = 300.0
var target: Node2D
var inventory: Array[Item] = []

# ✅ Type function parameters and returns
func calculate_damage(base: float, multiplier: float) -> float:
    return base * multiplier

# ✅ Use @export with types
@export var walk_speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var weapon_scene: PackedScene
@export_flags_2d_physics var collision_mask: int = 0

# ❌ Avoid untyped code
var speed = 300.0  # Works but loses type safety
func calculate_damage(base, multiplier):  # No type information
```

### Resource and Node References

```gdscript
# ✅ @onready for node references (waits until node is in tree)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D

# ✅ Preload for resources used every time
const EXPLOSION_SCENE: PackedScene = preload("res://effects/explosion.tscn")
const HIT_SOUND: AudioStream = preload("res://sounds/hit.wav")

# ✅ Load for resources used conditionally (lazy loading)
var boss_scene: PackedScene
func spawn_boss() -> void:
    if not boss_scene:
        boss_scene = load("res://enemies/boss.tscn")
    add_child(boss_scene.instantiate())

# ❌ Never use @onready + preload together (redundant)
# ❌ Never load in _process (causes frame hitches)
```

## Signal Architecture

### Signal Design Principles

1. **Signals are for observation, not command** — Emit to notify, not to order
2. **Pass data with signals** — Avoid making listeners query the emitter
3. **One signal, one meaning** — Don't overload a signal with flags
4. **Connect in _ready, disconnect in _exit_tree** — Manage connections explicitly

### Signal Patterns

```gdscript
# ✅ Pass relevant data with the signal
signal weapon_fired(projectile: Node2D, origin: Vector2, direction: Vector2)
signal inventory_changed(item: Item, count: int)

# ✅ Use signal buses for cross-scene communication (Autoload)
# event_bus.gd
extends Node
signal game_paused
signal game_resumed
signal level_loaded(level_name: String)
signal player_died

# Connect from anywhere:
# EventBus.player_died.connect(_on_player_died)

# ✅ Disconnect when leaving
func _exit_tree() -> void:
    EventBus.game_paused.disconnect(_on_game_paused)
```

### Common Signal Mistakes

```gdscript
# ❌ Polling instead of signals
func _process(_delta):
    if player.health <= 0:
        show_game_over()

# ✅ Signal-driven
func _ready():
    player.died.connect(show_game_over)

# ❌ Signal carrying too much responsibility
signal state_changed(old_state, new_state, reason, data)

# ✅ Specific signals for specific events
signal health_depleted
signal shield_broken
signal transformed(new_form: String)
```

## Export Templates & Build Configuration

### Setting Up Export Presets

```ini
# export_presets.cfg structure (managed via editor: Project → Export)

[preset.0]
name="Windows Desktop"
platform="Windows Desktop"
runnable=true

[preset.0.options]
custom_template/debug=""
custom_template/release=""
binary_format/64_bits=true
texture_format/bptc=true
texture_format/s3tc=true
```

### Export Template Checklist

1. **Download templates**: Editor → Manage Export Templates → Download
2. **Configure icons**: Set per-platform icons (Project → Project Settings → Application → Icon)
3. **Set boot splash**: Project → Project Settings → Application → Boot Splash Image
4. **Enable required permissions**: Android/iOS permissions in export settings
5. **Configure signing**: macOS/iOS certificates, Android keystore
6. **Test export**: Always test the exported build, not just running from editor

### Build Automation Script

```bash
#!/bin/bash
# build_all.sh - Export all configured platforms
GODOT="/path/to/Godot_v4.x"
PROJECT="/path/to/project"

# Export headlessly
$GODOT --headless --export-release "Windows Desktop" "$PROJECT/builds/windows/game.exe"
$GODOT --headless --export-release "Linux/X11" "$PROJECT/builds/linux/game.x86_64"
$GODOT --headless --export-release "macOS" "$PROJECT/builds/macOS/game.dmg"
$GODOT --headless --export-release "Web" "$PROJECT/builds/web/index.html"
```

### Platform-Specific Notes

| Platform | Key Considerations |
|----------|-------------------|
| **Windows** | MSVC runtime, code signing, antivirus whitelisting |
| **Linux** | AppImage or Flatpak recommended, no container needed |
| **macOS** | Code signing required for distribution, notarization |
| **Web** | 2D only recommended, WASM size constraints, CORS issues |
| **Android** | Minimum SDK version, keystore management, Google Play policies |
| **iOS** | Provisioning profiles, App Store review, memory constraints |

## Performance Optimization

### Common Bottlenecks

```gdscript
# ❌ Creating instances every frame
func _process(delta):
    var particle = ParticleScene.instantiate()
    add_child(particle)

# ✅ Object pooling
var _pool: Array[Node2D] = []

func get_particle() -> Node2D:
    for particle in _pool:
        if not particle.visible:
            particle.visible = true
            return particle
    var new_particle = ParticleScene.instantiate()
    _pool.append(new_particle)
    add_child(new_particle)
    return new_particle

# ❌ _process doing unnecessary work
func _process(delta):
    update_ui()  # Runs 60 times/sec even when nothing changes

# ✅ Update on demand
func _on_score_changed(new_score: int) -> void:
    score_label.text = str(new_score)
```

### Profiling

- Use **Debugger → Profiler** to identify frame time spikes
- Use **Debugger → Monitors** for realtime memory and FPS tracking
- Profile in release builds — debug builds include overhead
- Watch for `_physics_process` running longer than `1/physics_fps` seconds

## Error Handling

### Common Godot 4.x Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| Node returns null in `_ready` | Node not yet in tree | Use `@onready` or `call_deferred` |
| Signal not firing | Not connected or wrong name | Check Connections dock, use `print_signal_connections` |
| Scene not loading | Wrong path or not imported | Check `res://` path, verify `.tscn` exists |
| Physics jitter | Mix of `_process` and `_physics_process` | Keep physics logic in `_physics_process` only |
| Memory leak | Nodes not freed | Use `queue_free()` and check orphans in Monitors |
| Export fails | Templates missing or paths wrong | Download templates, verify export paths |

### Debugging Patterns

```gdscript
# Debug overlay (add as Autoload)
extends CanvasLayer

@export var show_fps := true
@export var show_memory := true

var _label: Label

func _ready() -> void:
    _label = Label.new()
    _label.position = Vector2(10, 10)
    add_child(_label)

func _process(_delta: float) -> void:
    if not visible:
        return
    var info := ""
    if show_fps:
        info += "FPS: %d\n" % Engine.get_frames_per_second()
    if show_memory:
        info += "Static Mem: %.1f MB\n" % (Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0)
    _label.text = info

# Toggle with key
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.keycode == KEY_F12 and event.pressed:
        visible = not visible
```

## Project Structure

```
project/
├── project.godot
├── export_presets.cfg
├── addons/                 # Editor plugins
├── assets/
│   ├── art/               # Sprites, models, textures
│   ├── audio/             # Music, SFX
│   └── fonts/             # Custom fonts
├── scenes/
│   ├── actors/            # Player, enemies, NPCs
│   ├── levels/            # Level scenes
│   ├── ui/                # Menus, HUD, dialogs
│   └── effects/           # Particles, shaders
├── scripts/
│   ├── autoloads/         # Global singletons
│   ├── components/        # Reusable behavior scripts
│   └── resources/         # Custom Resource classes
└── tests/                 # GDScript unit tests
```

## Tips

- Use `class_name` for scripts you reference from other scripts — it enables autocomplete
- Group related exports with `@export_group("Combat")` for inspector organization
- Use `@export_tool_button("Generate", "Refresh")` for editor utility buttons (4.3+)
- Prefer `Mathf`/`Vector2` methods over raw operators for clarity
- Use `@warning_ignore` sparingly — fix the warning if possible
- Test on target hardware early — mobile performance ≠ desktop performance

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/godot-helper/` (project-level) or `~/.cline/skills/godot-helper/` (global)
2. **Activation**: Cline will suggest this skill when you're developing in Godot 4.x, writing GDScript, or configuring exports
3. **Progressive loading**: Only metadata loads initially; full Godot patterns and best practices activate via `use_skill`
