# Sinatra web app

dvarrui has little Sinatra code. Evidence, in order of weight:

1. The `teuton config --server` form he wrote in Dec 2025 (`ConfigServer < Sinatra::Base`, ERB views, `public/css/style.css`), deleted from teuton in commit `246e5a2`; read it with `git show 246e5a2^:lib/teuton/config/server.rb` in a teuton clone.
2. The start of this repo (`App < Sinatra::Base`, state through `App.set`).
3. Classroom snippets (`dvarrui/charlas`, `proyectos-de-ejemplo`, `iloveruby`, 2014–2022) and `osl.iespto/src/get-info.d` (2026, classic style, possibly AI-assisted).

Rules marked *(inferred)* extend that evidence in his spirit; keep them simple.

## App class

- One modular app: `class App < Sinatra::Base` inside `module Teuton::Panel`. No classic `require "sinatra"`, no `config.ru`, no Rack builder files. Launched from the facade with `App.run!` (Puma).
- Server settings in the class body; class constants for fixed values:

```ruby
class App < Sinatra::Base
  set :bind, "0.0.0.0"
  set :port, 4567
  set :views, File.join(__dir__, "views")
  set :public_folder, File.join(__dir__, "public")
```

- State is injected from outside, never global variables: the facade does `App.set(:panel_projects, projects)` / `App.set(:panel_config, config)`, routes read `settings.panel_projects`. (His ConfigServer used `@@class_vars`; prefer `set` as this repo does.)
- Routes written directly in the class, `get "/path" do ... end`. Small helper methods as plain instance methods or a `helpers do ... end` block in the same class *(inferred)*; split routes into another file only when the class grows past ~150 lines, reopening `class App` (his split-by-aspect habit).
- A startup banner with `puts` (and Rainbow) like ConfigServer: app name, version, URL, base dir.

## Routes and requests

```ruby
get "/register" do
  erb :register, locals: {fields: registration_fields}
end

post "/register" do
  ip = request.ip
  save_case_config(params, ip)
  puts "==> [INFO] Registration from #{ip}"
  erb :register_done, locals: {ip: ip}
end
```

- Read input from `params` and `request.ip`; pass data to views with `locals:`.
- `redirect "/students"` after a successful form when a page reload must not repeat the action.
- Errors in a route: `halt 403, t(:forbidden)` or render an error view. Never `exit` or `warn`+`exit` inside a request.
- Guard filters for areas: `before "/teacher*" do halt 403, ... unless local_request? end` *(inferred)*.
- Plain-text answers for `curl`: `content_type :text` and a string built line by line *(inferred)*.

## Views

- ERB templates in `lib/teuton/panel/views/`, one simple `layout.erb` *(inferred; ConfigServer had standalone pages)*. Escape output (`Rack::Utils.escape_html`) for anything that comes from students.
- Plain hand-written CSS in `public/css/style.css` or inline `<style>`; tiny inline JS only when needed (auto-refresh). No CSS framework, no CDN, no JS build (ADR-003). His HTML report (`teuton/lib/teuton/files/template/case.html`) is ERB with inline CSS and JS.

## i18n

He never used a gem for it:

- asker: one YAML file per language (`lib/asker/files/language/<code>/templates.yaml`) loaded with `YAML.load` into a small `Lang` class.
- teuton readme: inline hash `lang["en"] = {...}; lang["es"] = {...}` looked up as `lang[locale][key]`.

For this repo follow the asker shape: `en.yml` / `es.yml` loaded once by a small class, and a `t(key)` helper in the app (see the `gui-i18n` feature for the location).
