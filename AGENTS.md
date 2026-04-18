# AGENTS.md — Ctrl-Alt-GG Spawn (link collection)

> Canonical guide for AI coding agents (GitHub Copilot, Cursor, Codex, Claude, etc.)
> working on this repository. Editors, humans, and automation should all read this first.
> See `README.md` for the human-facing quickstart.

## 1. What this repo is

Ctrl-Alt-GG **Spawn** is the link-collection landing page that opens on the
intranet wall during the LAN event, so attendees can jump straight to Discord,
the lobby, support, etc. A tiny Hugo + Tailwind v4 site deployed to Azure
Static Web Apps, with an extra release workflow that publishes a zipped
bundle on tag pushes.

Unlike the other two Ctrl-Alt-GG sites, Spawn is **single-language (English)**
by design — keep content minimal and i18n keys simple.

## 2. Source of truth for the stack

| Fact | Pinned in |
|---|---|
| Node.js version | `.nvmrc` and `engines.node` in `package.json` |
| Hugo version floor | `module.hugoVersion` in `config.toml` |
| Dev / build commands | `scripts` in `package.json` |
| Azure deploy pipeline | `.github/workflows/azure-static-web-apps-*.yml` |
| Release pipeline (tag → zip) | `.github/workflows/release.yml` |
| Link dictionary (homepage content) | `[params.author]` → `links = [...]` in `config.toml` |
| i18n labels | `i18n/en.yaml` |
| Ignored / generated paths | `.gitignore` |

Do **not** hard-code versions or commands in docs or code; read them from the
pinned source.

## 3. Repository shape (conventions, not inventory)

- `content/_index.md` — the homepage copy (welcome blurb, Wi-Fi password,
  …). Short and on-the-day content; no other content pages.
- `config.toml` — all site configuration, including the `params.author.links`
  array that drives the link buttons.
- `layouts/index.html` — the root template. Iterates `params.author.links`
  and renders each entry as a `<a class="link link-{type}">` button.
- `layouts/_default/baseof.html` — page scaffold.
- `layouts/partials/` — `head`, `head.html`, `footer.html`, `icon.html`.
- `assets/css/main.css` — Tailwind source; `assets/css/compiled/main.css`
  is generated at build time (git-ignored).
- `assets/icons/` — SVG icon set used by the `icon.html` partial (`{name}.svg`
  filenames map to `icon="<name>"` on link entries).
- `assets/new_logo_long.svg` — the site wordmark; inlined via
  `resources.Get`.
- `i18n/en.yaml` — labels for each link, keyed as `link.<type>`.
- `static/`, `public/` — static assets and build output (`public/` git-ignored).

If a new top-level directory is needed, prefer extending an existing one over
inventing a new root.

## 4. Running the project

```bash
nvm use              # honours .nvmrc
npm ci               # install locked deps
npm run dev          # Tailwind --watch + hugo server
npm run build        # production build (build:css then build:hugo)
```

Never run `hugo` without first running `npm run build:css` locally — the root
template references link classes (e.g. `link-discord`, `link-lobby`) that
only exist in the compiled stylesheet.

## 5. How the link list works

The homepage iterates `params.author.links` in `config.toml`. Each array
entry is a **one-key TOML table** where the **key is the link type** and the
**value is either a URL string or a nested table**:

```toml
[params.author]
  name = "Ctrl-Alt-GG"
  headline = "GL&HF, IRL."
  links = [
    { homepage = { href = "https://www.ctrl-alt-gg.hu", text = "Homepage" } },
    { care     = { href = "https://care.ctrl-alt-gg.hu", text = "Support page (Care)" } },
    { lobby    = { href = "https://lobby.ctrl-alt-gg.hu", text = "Lobby" } },
    { discord  = "https://discord.gg/…" },
    { steam    = "https://steamcommunity.com/groups/Ctrl-Alt-GG" },
  ]
```

The template (`layouts/index.html`) resolves each entry this way:

- `$type` (the map key) selects the CSS class (`link-<type>`) and the
  default icon (`assets/icons/<type>.svg`).
- `$text` falls back to `i18n "link.<type>"` from `i18n/en.yaml` when no
  `text =` is given.
- If the value is a table, fields `href`, `icon`, `text`, `target`, `title`
  override the defaults.

Rules:

1. Each link entry **must** have either a matching `icon` override pointing
   at an existing `assets/icons/<name>.svg`, or a same-named SVG under
   `assets/icons/<type>.svg`.
2. Each link `type` without a `text =` override **must** have a translation
   in `i18n/en.yaml` keyed `link.<type>`.
3. Each `link-<type>` used **should** have a background style under
   `@layer components` in `assets/css/main.css`. Missing styles fall back
   to the neutral `.link` purple, which is visually valid but uninspired.
4. Keep commented-out entries in place when they represent future event
   components (servers, files, speedtest) — the file is the product
   roadmap.

## 6. Templating conventions

- Start non-trivial templates with `{{ $page := . }}` and work off `$page`.
- Read parameters with `.Param "author.name"` (or `site.Params.Author.name`)
  so values cascade.
- All user-facing strings that are not in `config.toml` go through
  `{{ i18n "key" }}`; add the key to `i18n/en.yaml`.
- Render icons via `{{ partial "icon.html" (dict "name" "…" "class" "…") }}`.
- `safeHTML` is reserved for template-owned fragments (e.g. the inlined
  wordmark SVG) — never call it on author input.

## 7. Styling (Tailwind CSS v4)

- Entry: `assets/css/main.css` (`@import "tailwindcss"`, `@plugin
  "@tailwindcss/typography"`).
- Do not edit `assets/css/compiled/main.css` by hand — it is git-ignored and
  regenerated by `npm run build:css`.
- Spawn's palette aliases: `neutral-*` → Tailwind `gray-*`, `primary-*` →
  Tailwind `purple-*`. Use `primary-*` in templates so re-palettising is a
  one-line token swap.
- Link background treatments live under `@layer components` as
  `.link-<type>`. Add a new treatment when a new link type is added. Keep
  brand hexes/gradients out of templates.
- The brand red palette (`--color-brand-*`) is mirrored from the other CAG
  sites for cross-brand highlights; use it instead of ad-hoc reds.

## 8. Deployment and releases

Two workflows live in `.github/workflows/`:

- `azure-static-web-apps-*.yml` — push and PR deploys to Azure.
  `app_location: /public`. Do not rename the workflow or the secret name.
- `release.yml` — on tag push, zips `public/` into `site.zip` and creates a
  GitHub Release with it (so the site can be hosted elsewhere if needed).

Required build order in both: `npm ci` → `npm run build:css` →
`hugo --environment production --minify`. Node version is read from `.nvmrc`;
Hugo version is read from `module.hugoVersion` in `config.toml`.

## 9. Do-not-touch list

- `assets/css/compiled/main.css` — git-ignored, generated at build time; never edit by hand.
- `public/**`, `resources/**`, `.hugo_build.lock`, `hugo_stats.json`.
- `node_modules/**`.
- `.github/workflows/**` unless that is the subject of the change.

## 10. How to make changes safely

1. Scope first: most tasks are "add/update a link" (edit `config.toml` +
   possibly `i18n/en.yaml` + possibly a `.link-<type>` rule), "edit the
   homepage copy" (edit `content/_index.md`), or "restyle" (edit
   `assets/css/main.css`).
2. Read the matching `.github/instructions/*.instructions.md` file.
3. Run `npm run build` locally. A clean build is the bar for "done".

## 11. Where the other Copilot files fit

- `.github/copilot-instructions.md` — thin always-loaded pointer to this
  document.
- `.github/instructions/*.instructions.md` — path-scoped rules (templates,
  CSS, workflows, site config) auto-applied by glob.
- `.github/prompts/*.prompt.md` — reusable slash-command scaffolds
  (currently: `add-link`).
