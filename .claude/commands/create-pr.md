---
description: Create a PR from current branch changes
---

Create a pull request for the current branch:

1. Check git status and ensure all changes are committed
2. Push the current branch to origin with `-u` flag
3. Create PR using `gh pr create` with:
   - Concise title (under 70 chars)
   - Summary section with bullet points
   - Test plan section
4. Return the PR URL
