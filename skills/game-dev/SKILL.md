---
name: game-dev
description: Game development workflows covering prototyping, mechanics design, balancing, testing, and iteration cycles. This skill should be used when building games, prototyping gameplay systems, designing mechanics, balancing difficulty curves, or implementing game loops and player feedback systems.
---

# Game Development Workflows

This skill provides structured workflows for game development, from early prototyping through mechanics iteration, balancing, and testing. It covers core game dev patterns that apply across engines and genres.

## Prerequisites

- A game engine or framework (Unity, Godot, Unreal, or custom)
- Basic understanding of game loops and real-time systems
- Version control (git) for iterative development

## When to Use This Skill

- Prototyping a new game idea or mechanic
- Designing and iterating on gameplay systems
- Balancing difficulty, economy, or progression
- Building player feedback and juice/polish systems
- Structuring game projects for iterative development
- Writing game-specific tests and validation

## Core Workflows

### 1. Prototyping

**Goal:** Validate the core fun factor before investing in production.

#### Rapid Prototype Process

1. **Identify the core loop** — What does the player do repeatedly?
2. **Strip to minimum** — Remove everything that isn't the core mechanic
3. **Time-box to 48 hours** — Prototypes that take longer are too complex
4. **Playtest immediately** — If it's not fun in 5 minutes, redesign

#### Prototype Structure

```
prototype/
├── core_mechanic/      # The one thing the game is about
├── player_input/       # Minimal input handling
├── feedback/           # Visual/audio response to actions
└── win_lose/           # Success and failure states
```

#### Prototype Checklist

- [ ] Player can perform the core action within 10 seconds
- [ ] Core loop is clear: action → feedback → consequence → repeat
- [ ] There is a clear success and failure state
- [ ] The game communicates its rules without a tutorial
- [ ] It's fun (or at least interesting) for 2+ minutes

#### Key Questions

- What is the **one verb** the player uses most? (jump, shoot, build, negotiate)
- What makes that verb interesting? (timing, strategy, creativity, reflexes)
- What's the minimum needed to test if that verb is fun?

### 2. Mechanics Design

**Goal:** Build systems that create interesting decisions.

#### Mechanics Framework

Every mechanic should answer:

| Element | Question | Example |
|---------|----------|---------|
| **Trigger** | When can the player use it? | When holding a weapon, during combat |
| **Action** | What does the player do? | Press attack button |
| **Cost** | What does it consume? | Stamina, ammo, cooldown time |
| **Effect** | What happens in the game? | Deal damage in a cone |
| **Feedback** | How does the player know it worked? | Screen shake, hit particles, sound |
| **Counter** | How can enemies/players respond? | Block, dodge, interrupt |

#### Designing for Depth

- **Orthogonal mechanics**: Each mechanic should solve a different problem. Avoid overlap.
- **Emergent interactions**: Mechanics should combine in unexpected ways.
- **Risk/reward**: Every powerful option should have a meaningful cost.
- **Counter-play**: Every strategy should have a viable counter.

#### Systems Architecture Pattern

```javascript
// Component-based mechanic design
class Mechanic {
  constructor(config) {
    this.trigger = config.trigger;    // When it activates
    this.cost = config.cost;          // Resource cost
    this.effect = config.effect;      // Game state change
    this.feedback = config.feedback;  // Player-facing response
    this.cooldown = config.cooldown;  // Timing constraint
  }

  canActivate(playerState) {
    return this.trigger.isMet(playerState) 
      && this.cost.canPay(playerState)
      && this.cooldown.isReady();
  }

  activate(playerState, worldState) {
    if (!this.canActivate(playerState)) return false;
    this.cost.pay(playerState);
    this.effect.apply(playerState, worldState);
    this.feedback.play();
    this.cooldown.start();
    return true;
  }
}
```

### 3. Game Balancing

**Goal:** Create the right difficulty curve and progression pacing.

#### Balance Types

| Balance Type | What It Controls | Example |
|-------------|-----------------|---------|
| **Difficulty** | Challenge over time | Enemy health, AI aggression |
| **Economy** | Resource flow | Gold income vs. item costs |
| **Progression** | Player power growth | XP curve, unlock schedule |
| **Pacing** | Tension and relief | Combat density, rest areas |
| **Options** | Strategic viability | Build diversity, weapon balance |

#### Balancing Process

1. **Define target experience** — "Player should feel challenged but never stuck"
2. **Instrument the game** — Log every relevant metric
3. **Establish baselines** — Average completion time, death count, resource levels
4. **Adjust one variable at a time** — Never tune multiple things simultaneously
5. **Playtest with fresh players** — You're immune to your own difficulty

#### Difficulty Curve Design

```
Difficulty
    │        ╭──────╮
    │       ╱       ╲     ← Boss spikes
    │     ╱╱         ╲╱╱
    │   ╱╱              ╲╱╱   ← Gradual ramp
    │ ╱╱                    ╲
    │╱                       ╲
    └──────────────────────────▶ Time/Progression
    ▲                        ▲
    Learn mechanics      Mastery test
```

#### Balancing Spreadsheet Structure

| Item/Enemy | HP | Damage | Speed | Cost | DPS | Value | Notes |
|-----------|-----|--------|-------|------|-----|-------|-------|
| Slime | 10 | 2 | Slow | — | 2 | Low | Tutorial enemy |
| Goblin | 25 | 5 | Med | — | 5 | Med | First real threat |
| Dragon | 500 | 40 | Fast | — | 40 | Boss | End-of-act challenge |

**Key ratios to track:**
- Time-to-kill vs. time-to-die (player should win by a comfortable margin in normal encounters)
- Resource income vs. expenditure per encounter
- Damage output of each build relative to content difficulty

### 4. Game Testing

**Goal:** Verify mechanics work correctly and the experience matches intent.

#### Testing Layers

| Layer | Scope | Frequency |
|-------|-------|-----------|
| **Unit** | Individual mechanics, damage calc, inventory | Every change |
| **Integration** | Mechanic interactions, save/load, progression | Daily |
| **Balance** | Difficulty, economy, pacing | Weekly |
| **Playtest** | Full experience, new player onboarding | Per milestone |

#### Test Patterns for Games

```python
# Damage calculation test
def test_damage_with_armor():
    player = Player(attack=50)
    enemy = Enemy(armor=20, hp=100)
    
    damage = calculate_damage(player.attack, enemy.armor)
    enemy.take_damage(damage)
    
    assert damage == 30  # 50 - 20
    assert enemy.hp == 70

# Economy balance test  
def test_economy_over_10_levels():
    income_per_level = [100, 120, 150, 180, 220, 270, 330, 400, 480, 580]
    expenses_per_level = [80, 100, 130, 160, 200, 250, 310, 380, 460, 560]
    
    total_gold = 0
    for i in range(10):
        total_gold += income_per_level[i] - expenses_per_level[i]
        assert total_gold >= 0, f"Player goes broke at level {i+1}"
        assert total_gold <= 500, f"Player too rich at level {i+1}"
```

#### Playtest Protocol

1. **Brief the tester minimally** — "Figure out how to play" tests onboarding
2. **Observe without helping** — Note where they struggle, not how to fix it yet
3. **Track key metrics**: Time to first success, death locations, confusion points
4. **Debrief after**: What was confusing? What was fun? What would you change?
5. **Document findings** before implementing changes

### 5. Player Feedback and Juice

**Goal:** Make every action feel satisfying and every event readable.

#### Feedback Hierarchy

| Priority | Type | Purpose | Example |
|----------|------|---------|---------|
| 1 | **Critical** | Player must not miss this | Health low, objective updated, death |
| 2 | **Important** | Player should notice this | Damage dealt, item collected, level up |
| 3 | **Enhancing** | Makes things feel better | Screen shake, particles, sound variants |
| 4 | **Ambient** | World feels alive | Footstep sounds, idle animations, weather |

#### Juice Checklist Per Mechanic

- [ ] Visual feedback on action (flash, particle, trail)
- [ ] Audio feedback on action (hit sound, whoosh, chord)
- [ ] Camera response (shake, zoom, pan)
- [ ] Haptic feedback (if applicable)
- [ ] Numerical feedback (damage numbers, +XP popup)
- [ ] State change indicated (color shift, icon update)

## Error Handling

### Common Prototyping Pitfalls

- **Scope creep**: Cut features ruthlessly. If it's not core, it's not prototype.
- **Premature polish**: Gray boxes and placeholder sounds are fine. Fun first, pretty later.
- **No failure state**: A prototype where you can't lose isn't testing the right thing.

### Common Balancing Pitfalls

- **Over-tuning numbers before testing systems**: Get systems right first, then tune.
- **Balancing for yourself**: You've played it 100 times. You are not the player.
- **Flat difficulty**: Players learn. Difficulty must escalate to match growing mastery.

### Common Testing Pitfalls

- **Only testing happy paths**: Test edge cases — zero resources, max level, save corruption.
- **Testing on powerful hardware**: Profile on target minimum spec.
- **Skipping playtests**: Developer testing catches bugs. Playtesting catches bad design.

## Project Structure

```
game-project/
├── src/
│   ├── core/           # Game loop, state machine, manager singletons
│   ├── mechanics/      # Individual gameplay mechanics
│   ├── entities/       # Player, enemies, items, obstacles
│   ├── systems/        # AI, physics, economy, progression
│   ├── feedback/       # VFX, SFX, camera, haptics
│   └── data/           # Balance tables, level data, configs
├── tests/
│   ├── unit/           # Mechanic and system tests
│   ├── integration/    # Cross-system interaction tests
│   └── balance/        # Data-driven balance validation
└── docs/
    ├── gdd/            # Game design document sections
    ├── balance/        # Spreadsheets, analysis
    └── playtest/       # Observation notes, findings
```

## Tips

- Prototype the riskiest mechanic first — the thing you're least sure will be fun
- Keep a "kill list" of features you cut — they might work in a different context
- Session length matters: design knowing whether players play for 5 minutes or 5 hours
- Replayability comes from meaningful variation, not just randomization
- The best tutorials teach by doing, not by showing text
