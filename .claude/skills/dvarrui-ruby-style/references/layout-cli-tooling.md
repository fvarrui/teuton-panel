# Layout, CLI and tooling

## Gem layout

- `lib/teuton/panel.rb` is the facade (entry module with `def self.up(basedir)` etc.). Code in `lib/teuton/panel/<area>/<file>.rb`; snake_case file names, one concept per file.
- In teuton, big classes are split by aspect into several files reopening the same class (`case.rb`, `close.rb`, `play.rb`); mixins that extend a class live in `ext/` and are named `XxxExtension`; DSL folders have an `all.rb` that only lists `require_relative` lines. Use these only when a class really grows.
- Templates copied to the user live in `lib/teuton/panel/files/` and are copied with `FileUtils.cp(File.join(__dir__, "files", CONFIGFILE), target)`.
- Bundler-generated files (`sig/*.rbs`, `bin/console`, `bin/setup`) are left as generated.

## version.rb

Constants only:

```ruby
module Teuton
  module Panel
    VERSION = "0.1.0"
    APPNAME = "teuton-panel"
    CONFIGFILE = "teuton-panel.yaml"
  end
end
```

Class-specific constants go at the top of their class (`LINE = "-" * 50`, `PORT = 4567`).

## Executable

Root-level executable (no `exe/`), same shape in all his recent gems:

```ruby
#!/usr/bin/env ruby

require_relative "lib/teuton/panel/cli"

CLI.start(ARGV)
```

He adds `require "debug"` while developing; don't commit it (it is not a runtime dependency).

## Gemspec

- Keeps the bundler template (block variable `spec` here, `s` in teuton), sets `spec.name = Teuton::Panel::APPNAME`, `spec.version = Teuton::Panel::VERSION`, license `MPL-2.0`, author "David Vargas Ruiz".
- `spec.files = Dir.glob(File.join("lib", "**", "*.*"))`, `spec.executables << "teuton-panel"`, `extra_rdoc_files` with README, LICENSE and `docs/**/*.md`.
- Dependencies pessimistic: `spec.add_runtime_dependency "thor", "~> 1.5"`. Few dependencies; justify each new one (ADR-003).

## Thor CLI

Top-level `class CLI < Thor`. Per command, in this order: `map` aliases (letter, dash, double dash), `option`s, `desc`, `long_desc` with numbered examples, then a one-line method delegating to the facade with Thor's `options` (string keys):

```ruby
map ["--up", "-u", "u"] => "up"
desc "[up] [DIRECTORY]", "Run Teuton Panel from directory"
long_desc <<~LONGDESC
  (1) teuton-panel up PATH/TO/DIR, run panel in that directory.
  (2) teuton-panel, run panel in the current directory.
LONGDESC
def up(dirpath = ".")
  Teuton::Panel.up(dirpath)
end
```

Always `map ["h", "-h", "--help"] => "help"` and a `version` command printing `"#{APPNAME} version #{VERSION}"`. Default command through the fallback:

```ruby
##
# These inputs are equivalents:
# * teuton-panel dir/foo
# * teuton-panel up dir/foo
def method_missing(method, *_args, &_block)
  up(method.to_s)
end

def respond_to_missing?(method_name, include_private = false)
  # Respond to missing methods name
  super
end
```

`def self.exit_on_failure? = true` appears in diamante and asker (not teuton); add it if CLI errors must exit non-zero.

## Config files

- Read: `YAML.load(File.read(filepath))` or `JSON.parse(File.read(filepath), symbolize_names: true)`, inside `begin/rescue => e` with the `[ERROR] Class.method:` message and `exit 1`.
- Fill defaults explicitly after loading: `data[:global] = data[:global] || {}`. A missing file returns a minimal default hash, not an error.
- Write: convert symbol keys to strings when the file is meant for Teuton (`config.d/*.yaml`), then `File.write(filepath, data.to_yaml)`. The panel's own `teuton-panel.yaml` uses symbol keys (`:run:`).
- Create dirs with `FileUtils.mkdir_p(dirpath)` or `Dir.mkdir(dirpath) unless Dir.exist?(dirpath)`.

## Rakefile and Standard

```ruby
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "standard/rake"

task default: %i[test standard]
```

Extra tasks go in `tasks/*.rb` with `namespace`, each with `desc`; he often adds `desc "Help"` + `task :help { system("rake -T") }`. `.standard.yml` holds `ruby_version` and `ignore:` entries, each with a comment naming the ignored cop.

## CHANGELOG

`## [0.2.0] 20261006` (version + compact date) or `## [0.2.0] - 2026-10-06`, then bullets tagged `[FEATURE]`, `[FIX]`, `[REFACTOR]`, `[DOC]`, `[UPDATE]`, `[ADD]`, code in backticks. No "Unreleased" section.

## Commits

His current style (since 2025-11): short, lowercase, loose conventional prefix, no body: `feat: config class`, `fix: getset error with symbol values`, `refactor: config file reader`, `docs: tutorial nginx`, `chore: add sinatra gem and app class`, `release: version 2.11.0-dev`. In this repo always give a real subject (no bare `update`).
