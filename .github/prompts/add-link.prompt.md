---
description: Add a new link button to the homepage
mode: agent
---

# Add a link

Inputs:

- `${input:type}` — kebab-case link type. Becomes the CSS class
  (`link-<type>`), the icon filename (`<type>.svg`), and the i18n key
  (`link.<type>`). Must be unique within `[params.author]` `links` in
  `config.toml`.
- `${input:href}` — absolute URL the button points at.
- `${input:text}` — visible label (English). If empty, the i18n entry
  will be used as the label.
- `${input:icon}` — optional icon override. If empty, defaults to
  `assets/icons/${input:type}.svg`.
- `${input:colour}` — optional bespoke colour / gradient spec for the
  button background. If empty, the neutral `.link` purple fallback
  applies.

## Pre-flight checks

Before modifying anything, verify:

1. `config.toml` does not already contain an entry with the same key
   (uncommented or commented). If it does, stop and ask whether to
   **uncomment** the existing one (preferred) or rename.
2. Either `assets/icons/${input:type}.svg` exists, or
   `${input:icon}` points at an existing SVG under `assets/icons/`.
   If neither, stop and ask for an SVG.
3. If `${input:text}` is empty, confirm we can add a translation to
   `i18n/en.yaml` keyed `link.${input:type}` in this same change.

## Steps

1. **`config.toml`** — under `[params.author]` `links = [...]`, add a
   new entry. Use the shorthand (string) form when there is nothing to
   override:

   ```toml
   { ${input:type} = "${input:href}" },
   ```

   Otherwise use the table form:

   ```toml
   { ${input:type} = { href = "${input:href}", text = "${input:text}" } },
   ```

   Place the entry at the position the user wants in the displayed list
   (the array order is the render order). Preserve all commented-out
   lines in place.

2. **`i18n/en.yaml`** — if the entry does not set `text =`, append:

   ```yaml
   - id: link.${input:type}
     translation: <English label>
   ```

3. **`assets/css/main.css`** — if `${input:colour}` is provided, add a
   block under `@layer components` alongside the other
   `.link-<type>` rules:

   ```css
   .link-${input:type} {
     background-color: ${input:colour};
   }
   ```

   Use `@apply text-neutral-900;` as well if the background is light.

4. **Icon** — if the user provided a new SVG, place it at
   `assets/icons/${input:type}.svg`. Otherwise confirm an existing
   SVG is referenced.

5. Run `npm run build`. Open `public/index.html` (or the dev server) and
   verify the button renders with the expected label, icon, and colour.

## Invariants to double-check

- The new entry is valid TOML (the trailing comma before `]` is
  acceptable but not required).
- Commented-out roadmap entries are still present.
- No changes leaked into generated directories
  (`public/`, `resources/`, `assets/css/compiled/`).
- If `${input:colour}` was skipped, the neutral `.link` purple is
  genuinely what we want for this entry; otherwise stop and add a
  style.
