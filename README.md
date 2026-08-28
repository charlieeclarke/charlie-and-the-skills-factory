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

## The skills

| Skill | What it does |
| --- | --- |
| **`/grill-me`** | Interviews you relentlessly about a plan or design until you reach shared understanding — walking the design tree, resolving decisions one by one, recommending an answer to each. |
| **`/spec`** | Writes up already-agreed work as a spec on an issue. Synthesises decisions already made; it does not interview. Defers to `/grill-me` when it hits an open question. |
| **`/tickets`** | Breaks a spec or conversation into ordered issues, created as sub-issues under the parent. Human-readable body, short agent brief at the bottom. |
| **`/prototype`** | Throwaway code that answers one design question — usually what something should look like. Never merged; the answer is recorded, the code stays on its branch. |
| **`/componentise`** | Refactors a site's pages into a library of reusable per-section components, one page at a time, ending with each component in its own folder. |
| **`/deep-review`** | Reviews a diff on two separate axes — repo conventions, and whether it does what the spec asked — run as parallel sub-agents and never merged into one verdict. |
| **`/handover`** | Writes up a session so another agent can continue it cold: what's in flight, what's decided, what's blocked, what to do next. |

`/spec`, `/tickets`, `/prototype`, `/deep-review` and `/handover` are original text; the ideas behind them come from Matt Pocock's [Skills for Real Engineers](https://github.com/mattpocock/skills). See [NOTICE](NOTICE).

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

### Where the skills go

Both installers ask two questions, or take them as flags:

**Which agent?** Claude Code, Codex, or both.

**Where?** Just you, or this project.

| Agent | Just me | This project |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `~/.codex/skills/` | `.agents/skills/` |

`.agents/skills/` is the shared project location, so installing for Codex also covers Cursor, Cline, Zed and several others.

Choosing **this project** and committing the folder means everyone who clones the repo gets the skills with no install step at all. One caveat: **a personal skill overrides a project one of the same name**, so a teammate with their own `~/.claude/skills/spec` will get theirs, not the repo's. If the repo's version must always win, use the plugin route — those are namespaced and never collide.

Skipping the questions:

```sh
npx charlie-and-the-skills-factory --agent claude-code,codex --project
```

| Flag | Effect |
| --- | --- |
| `--agent <list>` | `claude-code`, `codex`, or both comma-separated |
| `--project` / `-p` | Install into the current project |
| `--global` / `-g` | Install for just you |
| `--yes` / `-y` | Skip the prompts, take the defaults |

Non-interactive runs (CI, piped input) default to Claude Code, just-me, and never prompt.

### Updating

Re-run the installer. It replaces the skills in place and reports `updated: 1.0.0 ► 1.1.0`.

Claude Code picks up the change live, without a restart — the only exception is a first-ever install into a folder that didn't exist when the session started, and the installer tells you when that applies.

A skill of the same name is never overwritten blind: it is moved to `.factory-backup/<name>-<timestamp>` alongside the skills first.

| Variable | Default | Purpose |
| --- | --- | --- |
| `CLAUDE_SKILLS_DIR` | — | Install to an exact path, ignoring agent and scope |
| `SKILLS_FACTORY_REF` | `main` | Branch or tag to install from (shell installer only) |
| `NO_COLOR` | unset | Disable colour and animation |

### Other agents

For anything beyond Claude Code and Codex, [`npx skills`](https://github.com/vercel-labs/skills) installs to around 25 agents:

```sh
npx skills@latest add charlieeclarke/charlie-and-the-skills-factory
```

## Uninstall

```sh
rm -rf ~/.claude/skills/{grill-me,componentise,spec,tickets,prototype,deep-review,handover}
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
│           ├── grill-me/       componentise/
│           ├── spec/           tickets/
│           ├── prototype/      deep-review/
│           └── handover/
├── preview/
│   └── index.html                # browser replay of the installer
├── NOTICE                        # attribution
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
