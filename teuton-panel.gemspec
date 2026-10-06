# frozen_string_literal: true

require_relative "lib/teuton/panel/version"

Gem::Specification.new do |spec|
  spec.name = Teuton::Panel::APPNAME
  spec.version = Teuton::Panel::VERSION
  spec.license = "MPL-2.0"
  spec.authors = ["David Vargas Ruiz"]
  spec.email = ["dvarrui@proton.me"]

  spec.homepage = "https://github.com/dvarrui/teuton-panel"
  spec.summary = "Panel gráfico para Teuton"
  spec.description = <<-EOF
  Intrastructure test, useful for:
  (1) Sysadmin teachers to evaluate students remote machines.
  (2) Sysadmin apprentices to evaluate their learning process as a game.
  (3) Professional sysadmin to monitor remote machines.

  Allow us:
  (a) Write test units for real or virtual machines using simple DSL.
  (b) Check compliance with requirements on remote machines.
  EOF

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/dvarrui/teuton-panel/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # gemspec = File.basename(__FILE__)
  # spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
  #   ls.readlines("\x0", chomp: true).reject do |f|
  #     (f == gemspec) ||
  #       f.start_with?(*%w[bin/ Gemfile .gitignore test/ .standard.yml])
  #   end
  # end
  # spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = ["README.md", "LICENSE"] + Dir.glob(File.join("docs", "**", "*.md"))
  spec.executables << "teuton-panel"
  spec.files = Dir.glob(File.join("lib", "**", "*.*")) + ["bin/teuton-panel"]

  spec.required_ruby_version = ">= 3.2.8"
  spec.add_runtime_dependency "thor", "~> 1.5"
  spec.add_runtime_dependency "teuton", "~> 3.0"
  spec.add_runtime_dependency "kramdown", "~> 2.5"
  spec.add_runtime_dependency "sinatra", "~> 4.2"
  spec.add_runtime_dependency "rackup", "~> 2.3"
  spec.add_runtime_dependency "webrick", "~> 1.9"
end
