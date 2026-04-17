---
description: Rules for editing the root Hugo config
applyTo: 'config.toml'
---

# Site configuration

The root `config.toml` is the product. Almost every user-visible change
to this site is a config change, not a template change.

## Structure (do not rearrange)

- `title`, `copyright`, and top-level flags (`enableEmoji`,
  `enableRobotsTXT`, `disableKinds`) sit at the root.
- `[params.author]` holds the homepage content: `name`, `headline`,
  `links = [...]`.
- `[module.hugoVersion]` pins the Hugo floor.
- `[markup.highlight]` and `[markup.goldmark]` control rendering;
  `unsafe = true` is intentional (inline HTML in the welcome blurb).

## Link array schema

`links` is an ordered TOML array of **one-key inline tables**:

```toml
links = [
  { homepage = { href = "https://www.ctrl-alt-gg.hu", text = "Homepage" } },
  { care     = { href = "https://care.ctrl-alt-gg.hu", text = "Support page (Care)" } },
  { lobby    = { href = "https://lobby.ctrl-alt-gg.hu", text = "Lobby" } },
  { discord  = "https://discord.gg/…" },
  { steam    = "https://steamcommunity.com/groups/Ctrl-Alt-GG" },
]
```

Rules:

1. The **key** is the link type. It drives the CSS class
   (`link-<type>`) and the default icon filename (`<type>.svg`).
2. Value may be:
   - A **string** — shorthand, treated as `href`. Icon defaults to
     `assets/icons/<type>.svg`; label defaults to the
     `link.<type>` translation in `i18n/en.yaml`.
   - A **table** — explicit, allowing `href`, `icon`, `text`,
     `target`, `title`.
3. **Order is display order.** The array order is the rendered order.
4. Keep each entry on one line for diff-friendliness.
5. **Do not delete commented-out entries.** Lines starting with `#    {` are
   the event roadmap (servers, files, speedtest, gcalendar, facebook).
   Uncomment when the corresponding portal is live; otherwise leave
   them.

## Invariants enforced outside this file

Every uncommented entry must satisfy:

- `assets/icons/<type>.svg` exists **or** the table sets
  `icon = "<existing-svg>"`.
- Either `text =` is set **or** `i18n/en.yaml` has an entry keyed
  `link.<type>`.
- If a bespoke colour is desired, `assets/css/main.css` has a
  matching `.link-<type>` block under `@layer components`. Otherwise
  the neutral `.link` fallback applies.

When adding a link, verify all three in the same commit.

## Things to not change

- `defaultContentLanguage` / `[languages]` — Spawn is deliberately
  single-language. Do not mirror the bilingual setup from the
  sister repos.
- `[markup.goldmark.renderer] unsafe = true` — required for the
  emoji-rich welcome blurb and inline HTML tweaks.
- Module mounts — none are declared. Do not add one unless a new
  root directory is being introduced for a reason that warrants
  it.
