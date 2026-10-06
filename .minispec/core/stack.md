# Stack

## Language

- Ruby ≥ 3.2.8 (Standard configured for 3.2)

## Runtime

- Teuton 3.0.0 (run as a subprocess; not yet in the gemspec)
- Thor (CLI)
- tty-prompt (terminal prompts)
- Sinatra 4 (web)
- Rackup + Puma (server)

## Development

- Bundler, Rake
- test-unit
- Standard (lint)

## Data

- YAML: the panel's `teuton-panel.yaml`; Teuton's `config.yaml` and per-student files in `config.d/`
- JSON: Teuton reports in `var/<test>/` (`resume.json`, `case-NN.json`)

## Distribution

- RubyGems gem, MPL-2.0 license

## Compatibility

- Teuton 3.0.0 needs Ruby ≥ 3.2.8 and thor ~> 1.3; no conflict with sinatra, puma, thor ~> 1.5 or tty-prompt.
