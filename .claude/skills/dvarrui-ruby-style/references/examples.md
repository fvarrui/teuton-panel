# Canonical excerpts

Real code by dvarrui (teuton 3.0.0 unless stated). Use them as the reference for tone and shape.

## Facade with lazy require (lib/teuton.rb)

```ruby
def self.create(path_to_new_dir)
  require_relative "teuton/skeleton"
  Skeleton.new.create(path_to_new_dir)
end

private_class_method def self.require_dsl_and_script(dslpath)
  # Load DSL file and then load script file
  require_relative dslpath
  begin
    require_relative Project.value[:script_path]
  rescue => e
    warn Rainbow("[ERROR] require_dsl_and_script: <#{e}>").bright.red # original has Rainbow.new(...), a bug
    exit 1
  end
end
```

## Chained guard clauses (utils/config_file_reader.rb)

```ruby
def self.call(filepath)
  return minimum_configuration_with_one_case unless File.exist?(filepath)

  return read_yaml(filepath) if [".yaml", ".yml"].include? File.extname(filepath)

  return read_json(filepath) if File.extname(filepath) == ".json"

  raise "[ERROR] ConfigFileReader.call: <#{filepath}>. Unkown extension!"
end
```

## Class-level state (utils/project.rb)

```ruby
class Project
  def self.init
    @project = {}
    @project[:output_basedir] = "var"
    @project[:format] = :txt # Default export format
  end

  def self.value
    @project
  end

  init
```

## Mixin helper (utils/verbose.rb)

```ruby
module Verbose
  def verboseln(text)
    verbose(text.to_s + "\n")
  end

  def verbose(text)
    return if Project.quiet?

    print text
  end
end
```

## Service object with private delegators (case/execute/execute_manager.rb)

```ruby
def call(host)
  start_time = Time.now
  run_on(host)
  action[:duration] = (Time.now - start_time).round(3)
end

private

def action
  @parent.action
end
```

## Default-then-override (case/dsl/log.rb)

```ruby
s = " INFO"
s = Rainbow("WARN!").color(:yellow) if type == :warn
s = Rainbow("ERROR").bg(:red) if type == :error
```

## Conditional assignment (case/host.rb)

```ruby
@protocol = if @ip == "localhost" || @ip.start_with?("127.0.0.")
  "local"
else
  "ssh"
end
```

## Status output (skeleton.rb)

```ruby
def create_dir(dirpath)
  if Dir.exist? dirpath
    puts "* Exists dir!       => #{Rainbow(dirpath).yellow}"
  else
    begin
      FileUtils.mkdir_p(dirpath)
      puts "* Create dir        => #{Rainbow(dirpath).green}"
    rescue
      puts "* Create dir  ERROR => #{Rainbow(dirpath).red}"
    end
  end
end
```

## Doc header (case/dsl/run.rb)

```ruby
##
# DSL run and goto
# run: It's the same as goto :localhost
# @param command (String)
# @param args (Hash)
def run(command, args = {})
  args[:exec] = command.to_s
  host = args[:on] || :localhost
  goto(host, args)
end
```

## Project discovery (teuton-panel, lib/teuton/panel/project.rb)

```ruby
def self.all(basedir)
  projects = []
  files = Dir.glob("#{basedir}/**/start.rb")
  files.map do
    dirpath = File.dirname(_1)
    projects << Project.new(dirpath)
  end

  if projects.size.zero?
    puts "No projects were found in the directory! (#{basedir})"
    exit 1
  end

  projects
end
```

## Sinatra (ConfigServer, `git show 246e5a2^:lib/teuton/config/server.rb`)

```ruby
class ConfigServer < Sinatra::Base
  LINE = "-" * 50
  PORT = 8080
  set :bind, "0.0.0.0"
  set :port, PORT

  get "/" do
    erb :form, locals: {param_names: get_param_names_to_configure}
  end

  post "/submit" do
    ip = request.ip
    @data[ip] = params.clone
    puts "==> [RECEIVED DATA #{@data.size}] from #{ip}"
    save_case_config(@data[ip])
    erb :feedback
  end
```

## ERB rendering (report/formatter/default/html.rb)

```ruby
filepath = File.join(basedir, "files", "template", "case.html")
@template = File.read(filepath)
render = ERB.new(@template)
w render.result(binding)
```

## Thor command with exit_on_failure (diamante/lib/diamante/cli.rb)

```ruby
map ["s", "-s", "--show"] => "show"
desc "show PATH/TO/FILE", "Show slides (from YAML or MD file)"
def show(filepath)
  Diamante::show(filepath)
end

def self.exit_on_failure?
  true
end
```

## Test (test/utils/config_file_reader_test.rb)

```ruby
class ConfigFileReaderTest < Test::Unit::TestCase
  def test_t01_read_yaml_config_with_strings
    filepath = File.join("test", "files", "t01-read-config", "demo.yaml")
    data = ConfigFileReader.call(filepath)
    assert_equal({}, data[:global])
    assert_equal 1, data[:cases].size
    assert_equal "student_1", data[:cases][0][:tt_members]
  end
end
```
