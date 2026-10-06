# Stack

## Language

- Ruby ≥ 3.2.8 (Standard configured for 3.2)

## Runtime

- Teuton 3.0.0 (runtime dependency, run as a subprocess)
- kramdown (Markdown to HTML)
- Thor (CLI)
- Sinatra 4 (web)
- Rackup + WEBrick (server; pure Ruby, installs without a compiler on Windows)

## Development

- Bundler, Rake
- test-unit, rack-test
- Standard (lint)

## Data

- YAML: the panel's `teuton-panel.yaml`; Teuton's `config.yaml` and per-student files in `config.d/`
- JSON: Teuton reports in `var/<test>/` (`resume.json`, `case-NN.json`)

## Distribution

- RubyGems gem, MPL-2.0 license

## Compatibility

- Teuton 3.0.0 needs Ruby ≥ 3.2.8 and thor ~> 1.3; no conflict with sinatra, webrick or thor ~> 1.5.
- No dependency may need a C compiler: RubyInstaller without MSYS2 must be able to install the gem (that is why WEBrick replaced Puma).
