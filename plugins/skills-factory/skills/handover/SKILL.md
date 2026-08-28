---
name: handover
description: Write up the current session so another agent can pick it up cold - what is in flight, what was decided, what is blocked, and what to do next. Use when work needs to travel to a new session, a different tool, a colleague, or a forked side task.
argument-hint: "What will the next session be used for?"
---

# Handover

Write a document that lets a fresh agent continue this work without re-deriving it.

Save it to the OS temporary directory, never the workspace — it should be impossible to commit into a client repo by accident. Report the path when done.

If the user passed an argument, treat it as what the next session will focus on and slant the document that way.

## Include

- **Live thread** — what is in flight, why, and what comes next. This is the state that exists nowhere else and is the reason the document exists.
- **Decided** — what has already been agreed and should not be reopened.
- **Blocked and open** — what is stuck and what is unresolved. Mark these as *unverified*: a blocker recorded here is what this session believed, and the next session should check it rather than trust it.
- **Suggested skills** — which skills the next agent should reach for.

## Leave out

- **Anything already written down.** Specs, issues, commits, diffs and ADRs get referenced by path or URL, never copied in. Duplicated content goes stale and makes the document longer than it is useful.
- **The story of the session.** No blow-by-blow of what was tried. The next agent needs the current state and the next action, not a diary.
- **Secrets and personal data.** Strip keys, tokens, credentials and personal information.

## Keep it short

A screen or two. If it runs longer, it is summarising the wrong things — cut the narrative first, then anything that is a link away.

End with a single **next action**: the one thing the next session should do first.
