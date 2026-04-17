<!--
Thanks for contributing to Ctrl-Alt-GG Spawn!
Keep this short. If a section doesn't apply, delete it.
-->

## What changed

<!-- One or two sentences. What does this PR do, and why? -->

## Scope

- [ ] Link entry (`params.author.links` in `config.toml`)
- [ ] Homepage copy (`content/_index.md`)
- [ ] Presentation (`layouts/`, `assets/css/main.css`, `assets/icons/`)
- [ ] Configuration (`config.toml`, `package.json`, workflows)
- [ ] Docs / agent files (`AGENTS.md`, `.github/instructions/`, `.github/prompts/`)

## Checks

- [ ] `npm run build` succeeds locally with no template errors
- [ ] No generated artefacts committed (`public/`, `resources/`, `assets/css/compiled/`, `.hugo_build.lock`, `hugo_stats.json`)
- [ ] New link has an icon at `assets/icons/<type>.svg` (or an explicit `icon =` override)
- [ ] New link without a `text =` override has a matching `link.<type>` label in `i18n/en.yaml`
- [ ] New `link-<type>` has a background treatment under `@layer components` in `assets/css/main.css` (or is intentionally using the neutral fallback)
- [ ] Agent-facing docs updated if behaviour changed (`AGENTS.md`, `.github/instructions/`)

## Screenshots / notes

<!-- Optional. Especially helpful for new link treatments or CSS changes. -->
