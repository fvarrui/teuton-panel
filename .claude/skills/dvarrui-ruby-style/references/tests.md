# Tests

- Framework: test-unit (never RSpec, never mocks libraries). Files `test/<area>/<name>_test.rb` mirroring `lib/`, classes `XxxTest < Test::Unit::TestCase`.
- Current style (myrepos, trusted-number, this repo): `test "description" do ... end` blocks. Older teuton tests use `def test_t03_read_yaml_config`; both are accepted, prefer the block form here.
- `require "test_helper"` at the top (bundler's helper: `$LOAD_PATH.unshift`, `require "teuton/panel"`, `require "test-unit"`). Teuton's own tests do `require "test/unit"` + `require_relative "../../lib/..."` instead.
- Assertions without parentheses: `assert_equal expected, actual`; parentheses when the first argument is a literal hash or array: `assert_equal({}, data[:global])`. He often writes `assert_equal true, x`; plain `assert x` is fine too.
- Fixtures in `test/files/`, often one folder per scenario named `tNN-description/` (`t03-read-yaml/config.yaml`), paths built with `File.join(File.dirname(__FILE__), "files", ...)`.
- Reset global state in `setup`.
- Slow tests that shell out are named `slow_*_test.rb` and kept out of the default task (teuton: `test:fast` excludes `/slow_/`).
- Endless defs are fine inside tests: `def action = @case.action`.
- Sinatra routes: `Rack::Test::Methods` with `def app = Teuton::Panel::App` *(inferred; he has no web tests)*; set `REMOTE_ADDR` to test localhost vs LAN.

```ruby
# frozen_string_literal: true

require "test_helper"

class ConfigTest < Test::Unit::TestCase
  def setup
    @dirpath = File.join(File.dirname(__FILE__), "files", "t01-config-ok")
  end

  test "read panel config" do
    config = Teuton::Panel::Config.new(@dirpath)
    assert_equal 300, config[:run][:every]
  end
end
```
