# Copilot instructions

The canonical guide for this repo is [`AGENTS.md`](../AGENTS.md). Read it first;
this file only lists always-true invariants so Copilot Chat never breaks them.

## Stack

Hugo (extended) + Tailwind CSS v4 + Node.js, deployed to Azure Static Web Apps.
Do **not** hard-code versions — read `.nvmrc`, `engines` in `package.json`, and
`module.hugoVersion` in `config.toml`.

## Non-negotiables

- Run Tailwind before Hugo. Use `npm run build` / `npm run dev`; never run
  `hugo` without first running `npm run build:css`.
- Never commit generated artefacts: `public/`, `resources/`,
  `assets/css/compiled/`, `.hugo_build.lock`, `hugo_stats.json`. All in
  `.gitignore`.
- Spawn is **single-language (English)**. Do **not** introduce `.en.md` /
  `.hu.md` pairs or `[languages.*]` blocks; this contradicts the minimalist
  design of the site.
- Link list lives under `[params.author]` → `links = [...]` in
  `config.toml`. Each entry is a one-key TOML table where the key is the
  link type. Preserve the commented-out future entries; they are the
  product roadmap.
- Every link `type` needs:
  1. An SVG at `assets/icons/<type>.svg` (or an explicit `icon =` override
     pointing at an existing SVG).
  2. A label in `i18n/en.yaml` keyed `link.<type>` (unless overridden with
     `text =`).
  3. A `.link-<type>` block under `@layer components` in
     `assets/css/main.css` if it needs a bespoke colour; otherwise the
     neutral `.link` fallback applies.
- Tailwind v4 syntax (`@import "tailwindcss"`, `@plugin`, `@theme`,
  `@custom-variant`). Edit `assets/css/main.css`; never touch
  `assets/css/compiled/**`.
- Palette aliases `primary-*` → `purple-*` and `neutral-*` → `gray-*` live
  in `@theme`. Use the aliases in templates/CSS so re-palettising is a
  one-line change.

## Scope-specific rules

Path-scoped guidance lives in `.github/instructions/*.instructions.md` —
Copilot auto-applies the right file via its `applyTo` glob. Reusable
scaffolds for recurring tasks live in `.github/prompts/*.prompt.md`.
