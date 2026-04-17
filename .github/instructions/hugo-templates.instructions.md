---
description: Conventions for Hugo Go templates under layouts/
applyTo: 'layouts/**/*.html'
---

# Hugo template conventions

## Entry points

- `layouts/_default/baseof.html` wraps every page.
- `layouts/index.html` is the homepage (list of links). Most changes
  happen either here or in `layouts/partials/`.

## Idioms

- Open templates with `{{ $page := . }}` and work off `$page`.
- Read parameters with `.Param "author.name"` (or `site.Params.Author.name`)
  so values cascade.
- Pipe user-provided text through `markdownify | plainify | htmlUnescape`
  before embedding into attributes (`<title>`, `<meta content="…">`,
  `alt`, `title`).
- Render icons via `{{ partial "icon.html" (dict "name" "…" "class" "…") }}`
  — do not inline SVG paths.
- `safeHTML` is only acceptable for template-owned SVG fragments (e.g. the
  inlined wordmark loaded via `resources.Get "new_logo_long.svg"`). Never
  call it on author-provided strings.

## Link rendering contract

`layouts/index.html` reads `site.Params.Author.links` and for each
one-key map `{ <type> = <value> }`:

- `<type>` drives the class (`link-<type>`) **and** the icon filename
  (`assets/icons/<type>.svg`) by default.
- When `<value>` is a string, it is treated as `href`; the label falls
  back to `{{ i18n (printf "link.%s" $type) }}`.
- When `<value>` is a table, fields `href`, `icon`, `text`, `target`,
  `title` override the defaults.

Do not refactor this contract lightly — the table-or-string
polymorphism is intentional (short syntax for simple social links,
verbose syntax for CAG portal entries).

## Internationalisation

- User-facing text comes from `i18n/en.yaml`. Add every new
  `link.<type>` key when a new link type is introduced.
- If a future bilingual version is ever considered, revisit this
  repo's design — current templates and config assume single-locale.

## Safety

- Keep templates idempotent — no global state, no writes outside the
  render.
- Treat `rel="me noopener noreferrer"` and `target="_blank"` as the
  default for external links; only change when the site is serving an
  internal route.
