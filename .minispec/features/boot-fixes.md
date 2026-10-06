# Boot fixes

## Problem

- `require "teuton/panel"` (used by `test/test_helper.rb`) raises `NameError`: `lib/teuton/panel.rb` loads `app.rb`, which opens `module Teuton::Panel` before `version.rb` defines `Teuton`.
- `test/teuton/panel_test.rb` keeps the generator's placeholder `assert_equal("expected", "actual")`, so the suite always fails.
- `CLI#new` calls `Teuton.create`, which does not exist in this gem.
- `App` sets `public_folder` to `lib/teuton/panel/public`, which does not exist.
- The executable does `require "debug"`, a development-only gem.

## Cause

Skeleton code from the gem generator and early prototyping, never run through `rake`.

## Solution

- Require `version.rb` first in `lib/teuton/panel.rb` (or define `module Teuton; module Panel` explicitly in each file).
- Replace the placeholder test with real smoke tests (`Projects.all`, `Config` with an existing file).
- Remove `CLI#new` and its `map` entry.
- Create `lib/teuton/panel/public/` when the first static file is added; until then, drop the setting.
- Remove `require "debug"` from the executable.

## Verification

- `bundle exec rake` passes (tests + Standard).
- `ruby teuton-panel up <dir-with-a-test>` starts the server.
