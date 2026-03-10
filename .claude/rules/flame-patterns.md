---
description: Flame engine patterns and conventions specific to this project
globs: "lib/game/**/*.dart"
alwaysApply: false
---

# Flame Patterns

## Component Conventions

- All game entities extend `PositionComponent` with `HasGameReference<GRunnerGame>`
- Use `anchor = Anchor.center` for all positioned entities
- Components access game state via `game` (provided by `HasGameReference`)
- Remove off-screen components in `update()` via `removeFromParent()`

## Coordinate System

- Always work in logical coordinates (width = 320)
- Use `game.logicalHeight` for dynamic height
- Never use screen pixels directly in game logic

## Collision Detection

- Use manual AABB via `Rect.fromCenter()` + `Rect.overlaps()`
- Collision checks live in `GRunnerGame._checkCollisions()` (centralized)
- Check `isMounted` before accessing component position in collision loops

## Rendering

- Use `Canvas` directly in `render()` override
- Colors defined as constants or computed from state (e.g., depth-based opacity)
- Glow effects via semi-transparent larger shapes behind main shape

## Entity Lifecycle

```
world.add(component)  →  onLoad()  →  update(dt) / render(canvas)  →  removeFromParent()
```

- Spawn: `game.world.add(Entity(...))`
- Despawn: `removeFromParent()` in component's own `update()`
- Death: Component handles death logic, calls `game.onEnemyKilled()` etc., then removes itself
