---
name: tickets
description: Break a spec, plan, or the current conversation into a set of issues, created as sub-issues under the parent and ordered so they can be worked top to bottom. Use when work is too big for one sitting, or when the user says "break this up", "split this into tickets", or "turn this into issues".
---

# Tickets

Break work into a short, ordered list of issues, each one something a person could pick up cold and finish.

If the whole change fits in one sitting, say so and stop. A single ticket is not worth the ceremony.

## Principles

- **One ticket is one session, independently shippable.** Don't split one component change to look tidy. Don't bundle unrelated fixes because they touch the same page.
- **Written for a human first.** Plain language, no internal jargon, safe for a client or PM to read.
- **No walls of text.** If a ticket takes more than a few seconds to read, it is too long.
- **Order carries the dependencies.** Publish so they can be worked top to bottom. Only state a dependency when one genuinely exists.
- **Assume current framework conventions**, not whatever an older codebase happens to use.
- **No file paths or code snippets.** They go stale before the ticket is picked up.

## Ticket shape

Title: `Bug:`, `Maintenance:`, or `Feature:` followed by a short description.

```
**What to build:** one line — the end behaviour this makes work, from the
user's point of view.

- [ ] One checkbox per observable outcome.

**Do after:** #N        ← only when something genuinely gates this, else omit
**From:** #N            ← the spec or issue this came from

---

**Agent brief:** two to four lines, technical, for whoever picks this up.
What is still unresolved, what to check or decide before starting, and any
area that needs more thought. If nothing is unresolved, say so in one line.
```

The body above the rule is for people. The agent brief below it is the only place technical detail belongs — keep it just as short.

## Process

1. **Gather.** Use what is in the conversation. If the user points at an issue or spec, read it in full, including comments.
2. **Draft.** Present the numbered breakdown — title and what each delivers. Ask whether the granularity is right and what should be merged, split, or reordered. Iterate until approved. Create nothing before then.
3. **Create.** One issue per ticket, in order, using labels the repo already has. Never invent a label.
4. **Link.** Attach each to the parent as a sub-issue.

### Creating sub-issues

There is no `gh` subcommand for this. Use the REST endpoint, which takes the child's numeric `id`, **not** its issue number — passing the number fails or links the wrong issue:

```
gh api repos/<owner>/<repo>/issues/<child-number> --jq .id
gh api --method POST repos/<owner>/<repo>/issues/<parent-number>/sub_issues \
  -F sub_issue_id=<child-id>
```

With no parent issue, skip the linking. Never close or edit the parent beyond adding the links.

## Reporting back

Finish with a table in work order:

| # | Ticket | Do after | Link |
|---|--------|----------|------|
| 1 | Feature: … | — | url |
