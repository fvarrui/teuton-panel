# ADR-003: Sinatra only, keep it simple

## Decision

The web app is built with plain Sinatra (`Sinatra::Base`) served by WEBrick (pure Ruby; Puma was dropped because it needs a C compiler on Windows). No Rails, no other web framework, no database, no frontend build step. New dependencies are added only when they clearly pay off.

## Motivation

- The panel is a small tool a teacher starts on their own machine; it has to install with `gem install` and run with one command.
- State lives in files Teuton already uses (`config.yaml`, `config.d/`, `var/<test>/*.json`) and in `teuton-panel.yaml`; a database adds nothing.
- The Teuton ecosystem is maintained by a small team; code must stay readable for its maintainers (see the `dvarrui-ruby-style` skill).

## Consequences

- Views are ERB templates with plain CSS; JavaScript only where it is really needed (e.g. auto-refresh).
- Nothing is loaded from the internet (the classroom LAN may be offline): fonts are woff2 files with an open license served from `public/fonts/`, icons are inline SVG, no CDN.
- Rails-oriented patterns, gems and skills (ActiveRecord, ActiveSupport, RSpec-Rails conventions…) do not apply.
- Background work (scheduled runs) uses plain Ruby threads and subprocesses, not a job framework.
- When a feature seems to need a bigger tool, propose a simpler alternative first (`principles.md`).
