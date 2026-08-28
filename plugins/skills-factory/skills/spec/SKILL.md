---
name: spec
description: Write up already-agreed work as a spec on an issue. Use when a decision has been reached and needs recording before anyone builds it, or when the user says "spec this", "write this up", or "put this on the issue". Synthesises decisions already made - it does not interview.
---

# Spec

Turn work that has **already been decided** into a spec on an issue.

Synthesise, do not interview. If you reach a decision that has not actually been made, stop and say which one — `/grill-me` exists to resolve it. Do not fill the gap with something plausible.

## Principles

- **One issue, one piece of work.** A spec longer than the change it describes is a failure.
- **Write only what was agreed.** `/tickets` breaks it down, `/prototype` answers open questions. Neither is this skill's job.
- **Omit anything with nothing to say.** No user stories, no test strategy unless asked for.
- **Never overwrite what is already on the issue.** Append below it and leave existing links and context intact.
- **Use the repo's own vocabulary and conventions** where it documents them.

## Shape

```
## Problem
What is wrong or missing, from the user's point of view.

## Approach
What changes, and what this deliberately does not touch.

## Acceptance criteria
- [ ] One per observable outcome, verifiable by looking at the result.

## Content
Only when someone has to add or edit content or data by hand.
Say what changes and who has to do it.
```

## Publishing

Ask whether this goes on an existing issue or a new one, unless the user already said which.

Show the draft and wait for approval before writing anything. Then post it and reply with the URL.
