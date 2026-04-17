---
description: Rules for editing GitHub Actions workflows
applyTo: '.github/workflows/*.yml'
---

# Workflow conventions

Two workflows live here. Both are load-bearing.

## Azure Static Web Apps deploy

- Triggered on pushes to `main` and on PR lifecycle events.
- Build order (**must not change**):
  1. `npm ci`
  2. `npm run build:css`
  3. `hugo --environment production --minify`
- Uploads from `app_location: /public`. Do not change it unless Hugo's
  `publishDir` is also changed.
- `api_location` is empty on purpose (pure static).
- The API token secret name encodes the Azure-generated slug. Do not
  rename without rotating the secret on the Azure side.
- The `close_pull_request_job` tears down preview environments; keep it.

## Release workflow (`release.yml`)

- Triggered on pushes to `main` and tag pushes.
- On tag pushes, zips `public/` into `site.zip` and publishes a GitHub
  Release with `softprops/action-gh-release` and
  `generate_release_notes: true`.
- Regular `main` pushes run the build job only (as a sanity check); no
  release artefact is produced.
- Do not move the `zip`/`upload-artifact`/`release` steps out from
  behind `startsWith(github.ref, 'refs/tags/')` guards — those guards
  are what keep untagged pushes from publishing phantom releases.
- Tag format: prefer `vX.Y.Z`; any tag triggers the release job.

## Versions (both workflows)

- Hugo version comes from `module.hugoVersion` in `config.toml`; keep
  the `peaceiris/actions-hugo` input in step.
- Node version is read from `.nvmrc` via `actions/setup-node`'s
  `node-version-file`. Do not hard-code a Node version inline.

## Secrets and identity

- The deploy workflow uses OIDC (`id-token: write`, `actions/github-script`
  fetches the token). Do not downgrade to long-lived credentials.
- The release workflow uses the default `GITHUB_TOKEN` with
  `contents: write` — do not broaden the scope unless the release job
  genuinely needs it.
- Never echo secrets to logs, never commit a secret value, never
  reference a secret in a PR-from-fork context without scoping.

## Before merging a workflow change

- Validate YAML locally — a broken workflow blocks deploys/releases.
- Confirm the change is the subject of the PR; drive-by edits are
  discouraged.
