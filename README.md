# Charlie & the Skills Factory

```
       ▄▄▄▄▄▄▄▄
     ▄█████████▄
    ███ ▄▄  ▄▄ ███
    ███ ██  ██ ███
    ▀█████████████▀
       █████████
       █████████
       ▀███████▀
```

**1-UP your Claude Code.** A small factory of hand-made skills, wrapped and ready to install.

## Power-ups

| Skill | What it does |
| --- | --- |
| **`/grill-me`** | Interviews you relentlessly about a plan or design until you reach shared understanding — walking the design tree, resolving decisions one by one, recommending an answer to each. |
| **`/componentise`** | Refactors a site's pages into a library of reusable per-section components, one page at a time, ending with each component in its own folder. Runs a `grill-me` interview first. |

`componentise` calls `grill-me` in its first phase, so they ship together.

## Install

### The one-liner

```sh
curl -fsSL https://raw.githubusercontent.com/charlieeclarke/charlie-and-the-skills-factory/main/install.sh | sh
```

Copies both skills into `~/.claude/skills/`, so they keep their bare names: `/grill-me` and `/componentise`. Restart Claude Code afterwards.

If a skill of the same name is already there, it is **moved** to `~/.claude/skills/.factory-backup/<name>-<timestamp>` first — nothing is overwritten blind.

Environment overrides:

| Variable | Default | Purpose |
| --- | --- | --- |
| `CLAUDE_SKILLS_DIR` | `~/.claude/skills` | Where skills are installed |
| `SKILLS_FACTORY_REF` | `main` | Branch or tag to install from |
| `NO_COLOR` | unset | Set to disable colour and animation |

### The plugin marketplace

```
/plugin marketplace add charlieeclarke/charlie-and-the-skills-factory
/plugin install skills-factory@charlie-and-the-skills-factory
```

Managed and updatable through `/plugin`. Skills are namespaced by the plugin: `/skills-factory:grill-me`, `/skills-factory:componentise`.

Pick one method or the other — installing both gives you two copies of each skill.

## Uninstall

```sh
rm -rf ~/.claude/skills/grill-me ~/.claude/skills/componentise
```

Or, for the plugin: `/plugin uninstall skills-factory@charlie-and-the-skills-factory`

## Layout

```
charlie-and-the-skills-factory/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest
├── plugins/
│   └── skills-factory/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           ├── grill-me/SKILL.md
│           └── componentise/SKILL.md
├── install.sh                    # curl | sh installer
└── README.md
```

The skills are the source of truth in `plugins/skills-factory/skills/` — both install methods read from there.

## Licence

MIT — see [LICENSE](LICENSE).
