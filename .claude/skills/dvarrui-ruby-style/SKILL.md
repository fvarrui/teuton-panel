---
name: dvarrui-ruby-style
description: Write Ruby the way dvarrui (David Vargas Ruiz, Teuton maintainer) does - small procedural classes, require_relative wiring, guard clauses with a blank line, glued variable names (filepath, basedir), puts/warn + exit 1 errors, Thor CLIs with letter aliases, test-unit `test "..." do` tests, Standard. Use for ANY Ruby code in teuton-panel (lib/, CLI, Sinatra app, views, tests, gemspec, Rakefile) and when reviewing Ruby changes for style.
---

# Ruby like dvarrui

Write code that the Teuton maintainer would read as his own. The rules come from teuton 3.0.0 (about 2,750 of his commits; all current lib code is his) and his 2023–2026 gems (myrepos, diamante, dsl-python, asker), plus the start of this repo. Project rules (`.minispec/core/conventions.md`, ADRs) win when they differ; the known differences are listed at the end.

## Core rules

- **Simple and procedural.** Small classes (30–130 lines), short methods (5–25 lines). No Rails, no ActiveSupport, no Struct/OpenStruct/Data, no DI, no custom exception classes, no metaprogramming beyond `instance_eval` for DSLs and Thor's `method_missing`.
- **Explicit wiring.** `require` for gems and stdlib first, then `require_relative` for internal files. Every file requires what it uses. No autoload. Lazy `require_relative` inside a facade method for heavy subsystems.
- **Facade + service objects.** `lib/teuton/panel.rb` exposes `def self.xxx` methods that build an object and call it. Service objects expose `call` (`Runner.new.call(...)`); stateless helpers are modules with `def self.call`.
- **Data as plain hashes**, built field by field (`@path = {}; @path[:script] = ...`). Symbol keys, written `{source: "a", target: "b"}` (no inner spaces, no `{x:}` shorthand). Thor and CLI options keep string keys (`options["cname"]`).
- **`initialize` assigns every ivar**, with a trailing comment when the purpose is not obvious. Optional arguments as `args = {}` read with `args[:on] || :default`; keyword arguments only occasionally.
- **`attr_reader` one per line**; a bare `private` line, then helpers. Delegate with tiny private wrapper methods, not `Forwardable`.
- **Every domain class defines `to_s`** (`"Project: #{@dirpath}"`). Config wrappers expose `def [](key)`.

## Idioms

- Double quotes always. `"#{x}"` interpolation.
- Guard clauses, **followed by a blank line**; chain several early returns rather than nesting:

```ruby
def self.quiet?
  return true if value[:options]["quiet"]
  return true unless value[:verbose]

  false
end
```

- `unless` for negative guards, never `unless ... else`. Explicit `.nil?` and `x = x || {}` rather than `||=`; `&.` rarely.
- Default-then-override instead of ternaries: `c = "fail"` then `c = "good" if cond`. Conditional assignment Standard-style (`@protocol = if ... else ... end`).
- `if/elsif` chains are fine; `case/when` when it reads better. No `case/in`.
- Blocks: `{ |x| ... }` one-liners, `do |x| ... end` multi-line, `&:sym` where it fits. Numbered params `_1` are fine; **never `it`** (the gem supports Ruby 3.2).
- Paths always with `File.join`, `File.dirname(__FILE__)`/`__dir__`, `Dir.glob(File.join(basedir, "**", "start.rb"))`.
- `format("%03d", n)` for padding. Heredocs `<<~TEXT`.
- Shell out with `Open3.capture2e` (or `spawn` when the process must be killable).
- Predicates: `ok?`, `skip?`, `exists?`; `is_valid?`-style names also appear in his code, accept them.
- Variable names glued, lowercase: `filepath`, `dirpath`, `basedir`, `projectpath`, `configfile`, `logfile`. One-letter names only in tiny scopes.
- Sentinels from Teuton: `"NODATA"` for missing values, `"TOCHANGE"` for placeholders; config keys `tt_*`.

## Output and errors

- Normal output `puts`; errors and warnings `warn`. Tagged messages: `[ERROR]`, `[WARN]`, `[INFO]`, progress `==> [INFO] ...`.
- Current error format: `Class.method: detail`, then an advice line with the path in angle brackets:

```ruby
rescue => e
  warn "[ERROR] ConfigFileReader.read_yaml: #{e}"
  warn "[ERROR] Revise file content! <#{filepath}>"
  exit 1
end
```

- Fatal user errors at startup or in the CLI: message, then `exit 1`. **Never `exit` inside a Sinatra route**; there, answer with a status and a translated message (`halt 403, ...`).
- File creation status lines aligned: `puts "* Create file       => #{dest}"`.
- Colors: Rainbow (the Teuton ecosystem's gem) only if colors are needed; `Rainbow("...").bright.red`.

## Comments

- English. Moderate density: one comment per 5–10 lines, short trailing notes (`# Default export format`).
- Public methods and classes get a `##` header with `@param name (Type) desc`:

```ruby
##
# Find project filenames from input project relative path
# @param relprojectpath (String)
def find_filenames_for(relprojectpath)
```

- `# TODO: ...`, `# Step 1: ...` inside long methods. Do not leave commented-out code in new code (he does, then cleans it up later).

## Where the details are

- [references/layout-cli-tooling.md](references/layout-cli-tooling.md) — gem layout, version.rb, executable, gemspec, Thor CLI, Rakefile, Standard, CHANGELOG, commits.
- [references/sinatra-web.md](references/sinatra-web.md) — how to write the Sinatra app, views, forms and i18n in his style (partly inferred: he has little Sinatra code).
- [references/tests.md](references/tests.md) — test-unit conventions and fixtures.
- [references/examples.md](references/examples.md) — canonical excerpts from his code, with sources.

## Project rules that override his habits

- Everything in English, including comments and user-visible CLI text (he mixes Spanish). GUI text comes from locale files.
- Keep the `Teuton::Panel` namespace this repo started with (compact `module Teuton::Panel`, `version.rb` loaded first). Inside it, nested classes use the block form. Teuton itself uses top-level classes; don't copy that here.
- `# frozen_string_literal: true` on every Ruby file (he is inconsistent).
- Commit messages: lowercase type prefix like his current ones (`feat: ...`, `fix: ...`, `refactor: ...`), but always with a meaningful subject (no bare `update`).
- Run Standard (`bundle exec rake standard`) before finishing; he sometimes forgets (single quotes in `app.rb`).
