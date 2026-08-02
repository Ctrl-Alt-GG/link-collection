---
description: Rules for editing GitHub Actions workflows
applyTo: '.github/workflows/*.yml'
---

# Workflow conventions

Three publishing workflows live here. All are load-bearing.

## Shared production build

- Every publishing workflow checks out the repository and then calls
  `.github/actions/build-site/action.yml`.
- Keep the build order in that action:
  1. `npm ci`
  2. `npm run build:css`
  3. `hugo --environment production --minify`
- Do not copy these setup or build steps back into individual workflows.
- The action reads Node from `.nvmrc` and Hugo from
  `module.hugoVersion` in `config.toml`.

## Azure Static Web Apps deploy

- Triggered on pushes to `main` and on PR lifecycle events.
- Build order is provided by the shared production build action and **must not
  change**.
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

## OCI image workflow (`publish-image.yml`)

- Triggered on pushes to `main`, tag pushes, and manual dispatches.
- Publishes the lowercase repository name to GHCR using the default
  `GITHUB_TOKEN`; keep job permissions limited to `contents: read` and
  `packages: write`.
- `latest` tracks the default branch, tag pushes retain their Git ref name,
  and each build also receives a commit-SHA tag.
- The Dockerfile packages the already-built `public/` directory only. Do not
  duplicate the Node, Tailwind, or Hugo build inside the image.
- Keep the runtime unprivileged and listening on port 8080.

## Versions

- Hugo version comes from `module.hugoVersion` in `config.toml`; keep the
  `peaceiris/actions-hugo` input in the shared build action.
- Node version is read from `.nvmrc` via `actions/setup-node`'s
  `node-version-file` in the shared build action. Do not hard-code a Node
  version inline.

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
