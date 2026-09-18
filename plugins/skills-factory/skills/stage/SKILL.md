---
name: stage
description: Commit the current work in per-component chunks and open a pull request with a short summary and a design link for each component changed. Use whenever the user says "stage this", "commit and PR", "ship this branch", "open a PR for this", or asks to commit finished component work - even if they only mention one half. Commits carry no AI attribution.
argument-hint: "Optional: PR title or a note on what the branch is for"
---

# Stage

Turn the working tree into a reviewable pull request: one commit per component, then a PR a reviewer can check against the design without asking where it lives.

## 1. Branch

Check `git status` and the current branch. If on the default branch, create one first, named in the style the repo already uses. Never commit to the default branch directly.

## 2. Commit in chunks

Read the full diff, including untracked files, and group the changes by **parent component** — the top-level component folder, wherever this repo keeps them. Sub-parts belong to their parent; sibling components get separate commits.

Chunking matters because reviewers read history per component. One "update styles" commit touching four components hides which change belongs to which design.

For each chunk, stage only its paths — never `git add -A` — and commit:

```
feat: <Component> <action>
```

- `<Component>` is the folder name as written.
- `<action>` is lowercase imperative, describing what changed from the user's point of view, not the implementation.
- `fix:` only when the chunk purely corrects broken behaviour.
- Shared changes (tokens, utilities, config) get their own commit with the area in place of the component name.

Match the repo's existing commit style if it differs from this.

**No attribution.** No `Co-Authored-By` trailer, no "generated with" line, in commits or the PR body.

If the tree is already fully committed, skip to step 3. Don't create empty commits or rewrite existing ones.

## 3. Collect design links

Where the branch implements a design, each component needs a link to the frame it implements. Look in the conversation first — the link was usually shared when the component was built. Only ask if one is genuinely missing, and ask once, listing every component still without one.

Keep URLs exactly as given, including any node or frame identifier, so they open on the frame rather than the file.

If the branch has no design behind it, omit the section rather than leave it empty.

## 4. Push and open the PR

Push the branch, then open a PR against the default branch with:

**Title:** the argument if given, otherwise a short sentence-case description of the whole branch, no `feat:` prefix. Match existing PR titles in the repo.

**Body:**

```
<25-word summary: what the branch does and why, one paragraph>

## Design

- **<Component>** — <frame url>
```

The summary lets a reviewer decide whether to open the diff, so say what changed for the user, not which files moved. One bullet per component, in commit order.

## 5. Report

Reply with the PR URL and the commits made (hash and message). If any design link came from the user rather than the conversation, say so.
