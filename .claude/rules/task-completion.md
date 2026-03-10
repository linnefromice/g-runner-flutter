---
description: Checklist before marking any implementation task as complete
globs:
alwaysApply: true
---

# Task Completion Checklist

Before considering a task complete:

1. **Analysis passes**: `flutter analyze` reports no issues
2. **Tests pass**: `flutter test` passes (if tests exist for the changed area)
3. **IMPLEMENTATION_PLAN.md updated**: Mark completed items with `[x]`
4. **No regressions**: Existing game features still work as expected
5. **Code follows patterns**: New components follow existing conventions (component structure, coordinate system, collision patterns)
