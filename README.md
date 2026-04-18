# Ctrl-Alt-GG Spawn

The link-collection landing pad that opens on the intranet wall during the [Ctrl-Alt-GG](https://ctrl-alt-gg.hu) LAN, so attendees can jump straight to Discord, the lobby, support, and everything else on the day. Single-language (English) by design.

A tiny Hugo + Tailwind v4 site. The "product" is essentially one array — `params.author.links` in `config.toml` — rendered as a grid of themed buttons.

## Stack

Hugo (extended) + Tailwind CSS v4 + Node.js, deployed to Azure Static Web Apps. A second workflow zips the built site on tag pushes and attaches it to a GitHub Release, so the bundle can be hosted on the intranet if Azure is unreachable.

Tool versions and build commands are pinned in the repo — don't copy them into docs. Read them from:

- `.nvmrc` and `engines.node` in `package.json` — Node version
- `module.hugoVersion` in `config.toml` — Hugo version floor
- `scripts` in `package.json` — dev and build commands

## Local development

```bash
nvm use
npm ci
npm run dev
```

Tailwind runs in watch mode alongside `hugo server`; the site is served at <http://localhost:1313/>.

## Build

```bash
npm run build
```

Builds the Tailwind stylesheet first, then runs Hugo. Output is written to `public/`. Never run `hugo` directly without `npm run build:css` first — the root template references `.link-<type>` classes that only exist in the compiled stylesheet.

## Project layout

- `config.toml` — all site configuration. The `params.author.links` array drives the homepage buttons; each entry is a one-key TOML table where the key is the link type and the value is a URL string or a `{ href, icon, text, target, title }` table.
- `content/_index.md` — the homepage copy (welcome blurb, Wi-Fi password, etc.). There are no other content pages.
- `layouts/index.html` — the root template; iterates `params.author.links` and renders each as `<a class="link link-<type>">`.
- `layouts/_default/baseof.html`, `layouts/partials/` — page scaffold and reusable fragments (`head`, `footer`, `icon`).
- `assets/css/main.css` — Tailwind v4 source. The compiled output `assets/css/compiled/main.css` is git-ignored and generated at build time. Link background treatments live under `@layer components` as `.link-<type>`.
- `assets/icons/` — SVG icon set. A link of type `<name>` resolves its icon from `assets/icons/<name>.svg` unless overridden.
- `i18n/en.yaml` — labels for each link type, keyed `link.<type>`. A link without a `text =` override must have a matching label here.

## Adding a link

Adding a new link usually touches three places: `config.toml` (the entry), `assets/icons/<type>.svg` (the icon), and `i18n/en.yaml` (the label). A `.link-<type>` rule in `assets/css/main.css` gives it a branded background; without one it falls back to the neutral purple. See the [`add-link` prompt](.github/prompts/add-link.prompt.md) for a step-by-step scaffold.

## Contributing and working with AI agents

The canonical contributor guide — for humans and AI agents alike — is [`AGENTS.md`](AGENTS.md). It covers the link-entry contract, templating conventions, the Tailwind setup, and the "do-not-touch" list.

Path-scoped rules for Copilot and other agents live under `.github/instructions/` and are auto-applied by glob. Reusable slash-command scaffolds live under `.github/prompts/`.

When opening a PR, follow [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md). The most important checks are that `npm run build` is clean, no generated artefacts are committed, and any new link has its icon, i18n label, and CSS treatment in place.

## Deployment and releases

Two workflows live in `.github/workflows/`:

- `azure-static-web-apps-*.yml` — pushes and PRs targeting `main` are built and deployed to Azure Static Web Apps. The deploy uploads from `app_location: /public`.
- `release.yml` — on tag push, zips `public/` into `site.zip` and publishes a GitHub Release with it, so the site can be hosted elsewhere (e.g. the intranet) during the event.

Both workflows run `npm ci` → `npm run build:css` → `hugo --environment production --minify`. Node version is read from `.nvmrc`; Hugo version is read from `module.hugoVersion` in `config.toml`.
