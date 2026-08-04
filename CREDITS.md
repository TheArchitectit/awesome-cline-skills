# Skill Credits & Licenses

This manifest records the origin and license of every skill in this repository,
so credit is preserved for all migrated content. The `scripts/check_skills.sh`
pre-commit hook verifies that each skill directory carries a LICENSE.

## Naming convention

- **In-repo (upstream shared repo):** skills ported from the
  `ComposioHQ/awesome-claude-skills` upstream (Apache-2.0). These carry an
  Apache-2.0 `LICENSE.txt`.
- **Vendored (standalone repo):** skills copied from an external GitHub repo.
  Each carries that repo's own LICENSE (MIT / Apache-2.0) for attribution.

## Standalone-repo credits (>500★, free, permissive license)

| Skill dir | Source repo | License | ★ |
| ----------- | ------------- | --------- | --: |
| `playwright-skill` | lackeyjb/playwright-skill | MIT | 2,972 |
| `ios-simulator-skill` | conorluddy/ios-simulator-skill | MIT | 1,198 |
| `skill-seekers` | yusufkaraaslan/Skill_Seekers | MIT | 14,687 |
| `lean-ctx` | yvgude/lean-ctx | Apache-2.0 | 3,484 |
| `article-extractor` | michalparkola/tapestry-skills-for-claude-code | MIT | 511 |
| `youtube-transcript` | michalparkola/tapestry-skills-for-claude-code | MIT | 511 |
| `ship-learn-next` | michalparkola/tapestry-skills-for-claude-code | MIT | 511 |
| `finishing-a-development-branch` | obra/superpowers | MIT | 265,830 |
| `using-git-worktrees` | obra/superpowers | MIT | 265,830 |
| `test-driven-development` | obra/superpowers | MIT | 265,830 |
| `brainstorming` | obra/superpowers | MIT | 265,830 |
| `git-pushing` | mhattingpete/claude-skills-marketplace | Apache-2.0 | 656 |
| `review-implementing` | mhattingpete/claude-skills-marketplace | Apache-2.0 | 656 |
| `test-fixing` | mhattingpete/claude-skills-marketplace | Apache-2.0 | 656 |

## Upstream-repo credits (in-repo, Apache-2.0)

| Skill dir | Source | License |
|-----------|--------|---------|
| `langsmith-fetch`, `tailored-resume-generator`, `twitter-algorithm-optimizer` | ComposioHQ/awesome-claude-skills | Apache-2.0 |
| All other 32 original skills | Awesome Cline Skills initial collection | Apache-2.0 |

## Add a new skill

1. Copy the skill source into `skills/<skill-name>/`.
2. Include the upstream `LICENSE` (or add Apache-2.0 `LICENSE.txt` for in-repo).
3. Add a row to the relevant credits table above.
4. Run `./scripts/check_skills.sh --strict` before committing.
