# Readme publishing

## Goal

Publish the active test's statement (`teuton readme`) as a web page for students.

## Context

- `teuton readme --lang=en|es` prints Markdown to stdout: required hosts, params, groups and targets.
- It also prints global config values, including passwords set in `global`.
- Teuton produces no HTML for the readme; the panel needs a Markdown renderer.

## Changes

- Run `teuton readme --lang=<request language>` through the Teuton runner; cache one result per language until the test or its files change.
- Filter password values (`*_password`) and `tt_include_params` before rendering.
- Render Markdown to HTML with `kramdown` (pure Ruby, no native extensions; add to the gemspec and `stack.md`).
- Student route `GET /readme` (HTML, or raw Markdown for `curl`); switch `student.readme`.
- Teacher preview of exactly what students will see.

## Acceptance

- `/readme` shows the test statement as HTML in a browser and as Markdown with `curl`.
- No password from `config.yaml` appears in the published readme.
- With the switch off, the route is refused.
