---
name: spike
description: Build throwaway code to answer one design question - usually what something should look like, sometimes whether a state model holds up. Use when the user wants to try a few directions before committing, sanity-check an approach, or asks to prototype or spike something.
---

# Spike

Throwaway code that answers **one question**. The question decides the shape.

Name the question before writing anything. If it can't be answered in one sitting, it is too big — split it.

## Pick the branch

- **"What should this look like?"** → build several genuinely different variations, not three shades of the same idea. This is the common case.
- **"Does this model hold up?"** → drive the states by hand and print the full state after every action, so the awkward cases are visible rather than imagined.

If the question is ambiguous and the user isn't around, pick the one the surrounding code suggests and say which assumption you made at the top of the spike.

## Rules

- **Throwaway from the start, and obviously so.** One clearly-named route or file that nobody could mistake for production. Follow the project's routing conventions, assuming current framework practice rather than whatever an older part of the codebase does.
- **One command to run.** Whatever the project already uses to start. No setup, no thinking.
- **No persistence.** State lives in memory. Persistence is usually the thing being questioned, not something to depend on.
- **No polish.** No tests, no error handling beyond making it run, no abstractions. The point is to learn something fast.
- **Show all the variants at once.** Put them on one route, switched by a `?v=` param with a small fixed switcher, so it's one link to share and easy to compare side by side.

## When it's answered

Never merge a spike to main.

- Leave it on its own branch.
- Write the verdict on the issue: the question, the answer, and why.
- Fold only the decision into real code.
