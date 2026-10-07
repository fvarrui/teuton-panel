# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "standard/rake"

task default: %i[test standard]

desc "Run every use case against samples/linux-files-basics (a few minutes)"
task :usecases do
  ruby "-Ilib", "test/usecases/run.rb"
end

namespace :docs do
  desc "Take the documentation screenshots in en, es and ca (needs Chrome or Edge)"
  task :screenshots do
    ruby "docs/_scripts/screenshots.rb"
  end
end
