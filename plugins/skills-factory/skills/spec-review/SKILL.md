---
name: spec-review
description: Review changes since a fixed point along two separate axes - does the code follow this repo's conventions, and does it do what the spec or issue actually asked for. Runs both as parallel sub-agents and reports them side by side. Use when reviewing a branch or PR against a spec, or when the user asks to review work against what was requested.
---

# Spec review

Review the diff between `HEAD` and a fixed point along two axes that are kept **separate**:

- **Standards** — does the code follow this repo's conventions?
- **Spec** — does it do what the issue or spec actually asked for?

A change can pass one and fail the other. Code can follow every convention while building the wrong thing, or do exactly what was asked while ignoring how the project is written. Merging the two lets one hide the other, so they are never merged.

This is not a correctness review. Use the built-in `/code-review` for bug hunting.

## Process

### 1. Pin the fixed point

Take whatever the user gave — a commit, branch, tag, `main`. Ask if they didn't say.

Confirm it resolves and the diff is non-empty **before** spawning anything. A bad ref should fail here, not inside two sub-agents.

Use `git diff <fixed-point>...HEAD` (three dots, so it compares against the merge base) and `git log <fixed-point>..HEAD --oneline`.

### 2. Find the two sources

- **Standards**: whatever the repo documents about how code should be written. If it documents nothing, say so — do not substitute a generic checklist and present it as the repo's standard.
- **Spec**: an issue referenced in the commits, a path the user passed, or a spec file matching the branch. If there is none, ask. If the user says there isn't one, skip the Spec axis and report that.

### 3. Run both in parallel

Spawn the two as independent sub-agents so neither sees the other's reasoning. Give each the diff command, the commit list, and its own source.

- **Standards brief**: where the diff departs from what the repo documents. Cite the rule — file and line. Separate hard breaches from judgement calls. Skip anything linting or formatting already enforces.
- **Spec brief**: what the spec asked for that is missing or partial, behaviour that appeared without being asked for, and anything implemented but implemented wrongly. Quote the spec line for each.

Keep each under 400 words.

### 4. Report

Two headings, `## Standards` and `## Spec`, side by side. Do not merge, rerank, or reconcile them.

Every finding carries its evidence, so a wrong one can be dismissed at a glance.

End with one line per axis: how many findings, and the worst within that axis. No overall verdict — picking a single winner across the two is exactly the collapse this skill exists to prevent.
