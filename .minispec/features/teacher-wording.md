# Plain wording in the teacher area

## Goal

Remove English and Teuton jargon from the translated teacher pages.

## Context

- `es.yml` and `ca.yml` keep English or Teuton words: the run history column "Cases"; the tests table "0 cases fijos" (`teacher.tests.config_ok`).
- Teachers know Teuton, but the rest of the panel speaks plain Spanish and Catalan; these words stand out.

## Changes

- Review every value in `es.yml` and `ca.yml` for untranslated words and Teuton jargon ("case", "target", "config").
- Use the panel's words: "Alumnos"/"Alumnes" for cases, "objetivos"/"objectius" for targets; "config.yaml: 0 alumnos escritos a mano" for fixed cases.
- Add the chosen terms to `.minispec/core/glossary.md` (term per language), so later strings stay consistent.
- English keeps "cases" only where it means Teuton's config file entries.

## Acceptance

- No English word left in the Spanish or Catalan teacher pages, except proper names and file names.
- The glossary lists the translations of case, target and run.
