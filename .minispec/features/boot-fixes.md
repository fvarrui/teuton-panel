# Boot fixes

## Problem

- `require "teuton/panel"` (used by `test/test_helper.rb`) raises `NameError`: `lib/teuton/panel.rb` loads `app.rb`, which opens `module Teuton::Panel` before `version.rb` defines `Teuton`.
- `test/teuton/panel_test.rb` keeps the generator's placeholder `assert_equal("expected", "actual")`, so the suite always fails.
- `CLI#new` calls `Teuton.create`, which does not exist in this gem.
- `App` sets `public_folder` to `lib/teuton/panel/public`, which does not exist.
- `gem build` fails: `["bin/teuton-panel"] are not files`. The gemspec declares the `teuton-panel` executable, RubyGems looks for it in `bin/` (default `bindir`), but it lives at the repo root and is not in `spec.files`.
- The root executable does `require "debug"`, a gem not in the Gemfile, so `bundle exec ruby teuton-panel` cannot load it.

## Cause

Skeleton code from the gem generator and early prototyping, never run through `rake`.

## Solution

- Require `version.rb` first in `lib/teuton/panel.rb` (or define `module Teuton; module Panel` explicitly in each file).
- Replace the placeholder test with real smoke tests (`Projects.all`, `Config` with an existing file).
- Remove `CLI#new` and its `map` entry.
- Create `lib/teuton/panel/public/` when the first static file is added; until then, drop the setting.
- Follow teuton's layout: add `bin/teuton-panel` (installed executable: `require "teuton/panel/cli"` via the load path, then `CLI.start(ARGV)`) and add `bin/teuton-panel` to `spec.files`. Keep the root `teuton-panel` as the development launcher (`require_relative "lib/teuton/panel/cli"`).
- `require "debug"` only in the root launcher, with `gem "debug"` added to the Gemfile; never in `bin/teuton-panel`.

## Verification

- `bundle exec rake` passes (tests + Standard).
- `ruby teuton-panel up <dir-with-a-test>` starts the server.
- `gem build teuton-panel.gemspec` succeeds, and the built gem installs a working `teuton-panel` command.
