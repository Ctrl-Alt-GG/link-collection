---
name: Link request
about: Add, update, or remove a link on the Spawn landing page.
title: "[link] "
labels: link
---

## Action

- [ ] Add a new link
- [ ] Update an existing link
- [ ] Remove a link

## Link details

- Link type (becomes `link-<type>` CSS class and default icon filename):
  <!-- e.g. discord, lobby, care, steam, homepage -->
- URL:
  <!-- e.g. https://discord.gg/... -->
- Label:
  <!-- Either the literal text for a `text =` override, OR the key to add under `link.<type>` in i18n/en.yaml -->
- Icon:
  <!-- Filename under assets/icons/. If one with the same name as the type already exists, leave blank. Otherwise, attach the SVG or link to the source. -->
- Target / title (optional):
  <!-- e.g. target="_blank", hover title text. Leave blank for defaults. -->

## Checklist for the implementer

- [ ] Entry added to `params.author.links` in `config.toml`
- [ ] `assets/icons/<type>.svg` exists (or an explicit `icon =` override is set)
- [ ] `link.<type>` label added to `i18n/en.yaml` (unless `text =` is set on the entry)
- [ ] `.link-<type>` background treatment added under `@layer components` in `assets/css/main.css` (optional — falls back to neutral purple)
- [ ] `npm run build` succeeds locally

## Why

<!-- Context: new community resource, event-day dashboard, etc. -->

<!--
Tip: for step-by-step scaffolding, run the `/add-link` prompt in Copilot Chat.
See `.github/prompts/add-link.prompt.md`.
-->
