---
description: Tailwind CSS v4 rules for the site stylesheet source
applyTo: 'assets/css/**/*.css'
---

# Tailwind CSS v4

## Entry point

`assets/css/main.css` is the single source file. Keep these at the top:

```css
@import "tailwindcss";
@plugin "@tailwindcss/typography";
@custom-variant dark (&:where(.dark, .dark *, [data-theme="dark"], [data-theme="dark"] *));
```

The compiled output lives under `assets/css/compiled/` and is
**git-ignored**. Never edit compiled files, never commit them.

## Design tokens

Shared tokens live in `@theme { … }`:

- Brand palette: `--color-brand-*` (cross-site red, mirrored across
  `care`, `homepage`, and `spawn`).
- Typography: `--font-sans` (Inter-first fallback chain).
- Radius / elevation: `--radius-*`, `--shadow-*`.
- **Palette aliases**:
  - `--color-neutral-*` → Tailwind `--color-gray-*`.
  - `--color-primary-*` → Tailwind `--color-purple-*`.

Use the aliases (`neutral-*`, `primary-*`) in templates and CSS.
Re-palettising should be a one-line edit of the `@theme` alias block,
not a grep across templates.

## Link colour blocks

Each `link-<type>` used in `config.toml` should have a matching
`@layer components` block:

```css
@layer components {
  .link-<type> {
    background-color: #RRGGBB;  /* or gradient */
  }
  /* If the background is light, also:
     @apply text-neutral-900; */
}
```

Rules:

- Keep one block per link type. Alphabetise within the "social
  network" group; keep the CAG-specific group (`.link-servers`,
  `.link-lobby`, `.link-files`, `.link-homepage`, `.link-speedtest`,
  `.link-gcalendar`, `.link-care`) together.
- Use brand colours of the target service when there is an established
  identity. Otherwise use a gradient made from CAG tokens.
- Light backgrounds need `@apply text-neutral-900;` so the label
  stays legible.
- The neutral fallback is `.link { @apply bg-primary-700 text-white hover:brightness-90; }`.
  Do not change it without discussing — it is the visual default for
  every otherwise-unstyled type.

## Dark mode

Expressed via the `dark:` variant (declared with `@custom-variant`).
The prose palette uses `@media (prefers-color-scheme: dark)` for the
`.prose-invert` block specifically — keep that one as-is; do not
spread `prefers-color-scheme` elsewhere.

## Build

`npm run build:css` runs the CLI once; `npm run dev:css` watches. Both
wired from `package.json` — do not invoke the Tailwind binary
directly.
