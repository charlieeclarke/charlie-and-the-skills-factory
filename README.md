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

A small factory of hand-made Claude Code skills. Everything here is produced on site, wrapped, and shipped.

## Power-ups

| Skill | What it does |
| --- | --- |
| **`/grill-me`** | Interviews you relentlessly about a plan or design until you reach shared understanding — walking the design tree, resolving decisions one by one, recommending an answer to each. |
| **`/componentise`** | Refactors a site's pages into a library of reusable per-section components, one page at a time, ending with each component in its own folder. Runs a `grill-me` interview first. |

`componentise` calls `grill-me` in its first phase, so they ship together.

## Install

Three ways in. Pick **one** — installing by more than one route leaves you with duplicate copies of each skill.

| | Command | Skill names | Needs |
| --- | --- | --- | --- |
| **npm / yarn** | `npx charlie-and-the-skills-factory` | `/grill-me` | Node 14+ |
| **Shell** | `curl -fsSL … \| sh` | `/grill-me` | curl, tar |
| **Plugin** | `/plugin marketplace add …` | `/skills-factory:grill-me` | Claude Code |

### npm / yarn

The skills are bundled inside the package, so nothing is fetched from the network mid-install.

```sh
npx charlie-and-the-skills-factory
```

```sh
yarn dlx charlie-and-the-skills-factory
```

Or install the command permanently:

```sh
npm install -g charlie-and-the-skills-factory && skills-factory
```

```sh
yarn global add charlie-and-the-skills-factory && skills-factory
```

Both `charlie-and-the-skills-factory` and the shorter `skills-factory` are registered as commands.

### Shell one-liner

```sh
curl -fsSL https://raw.githubusercontent.com/charlieeclarke/charlie-and-the-skills-factory/main/install.sh | sh
```

Downloads the repo tarball and copies the skills out of it. No Node required.

### Claude Code plugin

```
/plugin marketplace add charlieeclarke/charlie-and-the-skills-factory
/plugin install skills-factory@charlie-and-the-skills-factory
```

Managed and updatable through `/plugin`. Note the skills are namespaced by the plugin here: `/skills-factory:grill-me`, `/skills-factory:componentise`.

### What the installers do

Both the npm and shell installers copy the skill folders into `~/.claude/skills/`, so the skills keep their bare names. Restart Claude Code afterwards.

If a skill of the same name is already there, it is **moved** to `~/.claude/skills/.factory-backup/<name>-<timestamp>` first — nothing is overwritten blind.

| Variable | Default | Purpose |
| --- | --- | --- |
| `CLAUDE_SKILLS_DIR` | `~/.claude/skills` | Where skills are installed |
| `SKILLS_FACTORY_REF` | `main` | Branch or tag to install from (shell installer only) |
| `NO_COLOR` | unset | Set to disable colour and animation |

## Uninstall

```sh
rm -rf ~/.claude/skills/grill-me ~/.claude/skills/componentise
```

For the plugin: `/plugin uninstall skills-factory@charlie-and-the-skills-factory`

## Layout

```
charlie-and-the-skills-factory/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest
├── bin/
│   └── install.js                # npm / npx installer
├── plugins/
│   └── skills-factory/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           ├── grill-me/SKILL.md
│           └── componentise/SKILL.md
├── preview/
│   └── index.html                # browser replay of the installer
├── install.sh                    # curl | sh installer
├── package.json
└── README.md
```

`plugins/skills-factory/skills/` is the single source of truth — all three install routes read from there.

## Releasing

```sh
npm login
npm publish --access public
```

Bump `version` in `package.json` and tag the repo to match. Until it is published, `npx github:charlieeclarke/charlie-and-the-skills-factory` installs straight from GitHub.

## Licence

MIT — see [LICENSE](LICENSE).
