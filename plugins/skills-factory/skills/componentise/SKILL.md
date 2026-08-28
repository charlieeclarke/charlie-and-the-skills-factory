---
name: componentise
description: Refactor a site's pages into a library of reusable per-section components, one page at a time, finishing with each component in its own folder. Use when the user wants to componentise/componentize/sectionise pages, extract page sections into reusable components, or turn large page.tsx blobs into shared components. Assumes Next.js App Router + CSS Modules + TypeScript. Runs a grill-me interview first, then works page-by-page pausing for review.
---

# Componentise pages into reusable section components

Refactor pages (each a large JSX blob backed by a per-page CSS module) into a library of reusable, presentational **section components**. Proven on a Next.js App Router + CSS Modules + TypeScript codebase; adapt the CSS-Modules-specific steps if a project differs.

## Phase 0 — Grill first (always)

Before writing anything, invoke the **grill-me** skill (`/grill-me`, or `/skills-factory:grill-me` when installed as a plugin) to resolve the project-specific design decisions. Explore the codebase to answer what you can; only ask the user what's genuinely their call. Cover at least:

- **Reuse scope** — genuinely shared components vs one-off extraction per page.
- **Cross-page duplicates** — build the shared component the first time the pattern recurs, then reuse it; vs a dedupe pass at the end.
- **Naming source** — section comments vs the section's CSS class names.
- **Components location & CSS** — which dir; whether each component gets its own CSS module carved from the page module.
- **Data boundary** — page fetches data and passes flat, typed props; components stay presentational (matters if a CMS/API integration is planned later).
- **Item granularity** — keep mapped items inline unless the same shape recurs elsewhere.
- **Hero/card families** — which near-duplicate layouts are truly one shared component vs similar-but-distinct (don't force-merge distinct ones).
- **Scope & order** — which pages are in scope and in what order (usually nav order).

## Method (applied to every page)

First **detect the repo's actual conventions** — components dir, path alias, CSS approach, existing shared components. Don't hardcode paths.

- **Thin pages.** A page becomes a composition of `<Section />` components. Keep all data-fetching in the page; pass flat, typed props down. Components are pure/presentational.
- **Shared-component discipline.** Build a shared component the first time a pattern recurs; reuse and lightly generalise it (via props) afterwards — even when that means touching a component built in an earlier chunk. Name components from their section's CSS class.
- **Own stylesheet.** Each component gets its own CSS module, carved out of the page's module. Split the page module's responsive rules into the components they belong to.
- **Faithful render.** Preserve exactly what renders today. Where a `.localClass .globalUtility` selector is **dead** — CSS Modules hashes the utility class name (`.btn`, `.small`, `.eyebrow`, `.lead`, `.arrow`), so `.local .btn` never matches a global `class="btn"` — omit it and add it to a running dead-overrides list. Never silently change the look.
- **Flag drift.** When unifying near-duplicate layouts into one shared component, values won't be pixel-identical across instances. Pick canonical values and flag the per-page shifts in your summary.

## Chunk rhythm

- **One page per chunk.** After finishing a page, **pause for the user's feedback** before starting the next.
- On approval, **commit each chunk** on a feature branch (branch first if on the default branch) with a page-named message.

## Per-chunk verification

After each page, before pausing:

- Run the type-checker (`tsc --noEmit`).
- Delete the now-distributed page CSS module.
- Grep for stale references to the deleted module and any renamed symbols.

## Final chunk A — fix the dead CSS

Once every page is done, fix the accumulated dead overrides so the original design intent renders. In CSS Modules, wrap the global utility in `:global()` so the contextual override applies again:

```css
.heroActions :global(.btn) { background: #fff; color: var(--ink); }
.head :global(.small) { text-align: right; }
```

Scan every component module for any remaining un-`:global`-ed `.local .utility` selector to confirm none were missed. Flag any override whose intent you're unsure about rather than guessing.

## Final chunk B — folder per component

End by giving each component its own folder (this is a required step, not optional):

- `Name.tsx` → `Name/index.tsx`; `Name.module.css` → `Name/Name.module.css`.
- **External imports stay unchanged** (`@/…/components/Name` resolves to `Name/index.tsx`).
- Update **sibling imports** within the components dir from `./X` to `../X`; leave **stylesheet imports** (`./Name.module.css`) as-is — they remain in the same folder.
- Use `git mv` to preserve history. Run the type-checker to confirm every import still resolves, then commit.
