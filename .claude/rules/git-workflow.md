---
description: Git commit and branch conventions for this project
globs:
alwaysApply: true
---

# Git Workflow

## Commit Message Format

Use Conventional Commits:

```
<type>: <short description>

<optional body>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`

Examples:
- `feat: add Rush enemy type with high-speed charge behavior`
- `fix: prevent player bullets from passing through enemies at high speed`
- `refactor: extract collision detection into separate system`

## Branch Naming

```
feat/<feature-name>
fix/<bug-description>
refactor/<what>
```

## Feature Implementation Order

When implementing a new game feature:
1. Add data definitions (constants, enums, stage data)
2. Implement core component(s)
3. Wire into GRunnerGame (spawning, collision, effects)
4. Update HUD if needed
5. Update IMPLEMENTATION_PLAN.md status
6. Test on device/emulator
