# Linux files basics: a sample challenge for teuton-panel.
#
# Every student works in homes/<home>/ (a stand-in for their machine's home
# directory), and Teuton checks it on localhost, so the challenge runs with
# no student machines. Each check is a small Ruby one-liner, which works the
# same in cmd.exe and in a Unix shell.

def ruby_check(code)
  "ruby -e \"#{code}\""
end

# Students type their home folder name at registration: never put a typed
# value into a command without checking it.
def home_dir(name)
  name = name.to_s
  name = "invalid-home" unless name.match?(/\A[a-z0-9_-]+\z/)
  File.join(__dir__, "homes", name)
end

group "Files and directories" do
  home = home_dir(get(:home))

  target "Directory docs exists", weight: 1
  run ruby_check("puts File.directory?('#{home}/docs') ? 'docs=yes' : 'docs=no'"), on: :host1
  expect "docs=yes"

  target "File docs/notes.txt exists", weight: 1
  run ruby_check("puts File.file?('#{home}/docs/notes.txt') ? 'notes=yes' : 'notes=no'"), on: :host1
  expect "notes=yes"

  target "docs/notes.txt has exactly 3 lines", weight: 2
  run ruby_check("f = '#{home}/docs/notes.txt'; puts 'lines=' + (File.file?(f) ? File.readlines(f).size.to_s : '0')"), on: :host1
  expect "lines=3"
end

group "Shell configuration" do
  home = home_dir(get(:home))

  target "File .bashrc defines the alias ll", weight: 2
  run ruby_check("f = '#{home}/.bashrc'; puts((File.file?(f) && File.read(f).include?('alias ll=')) ? 'alias=yes' : 'alias=no')"), on: :host1
  expect "alias=yes"
end

group "Backup script" do
  home = home_dir(get(:home))
  script = "#{home}/scripts/backup.sh"

  target "File scripts/backup.sh exists", weight: 1
  run ruby_check("puts File.file?('#{script}') ? 'script=yes' : 'script=no'"), on: :host1
  expect "script=yes"

  target "backup.sh starts with #!/bin/bash", weight: 1
  run ruby_check("f = '#{script}'; puts((File.file?(f) && File.readlines(f).first.to_s.start_with?('#!/bin/bash')) ? 'shebang=yes' : 'shebang=no')"), on: :host1
  expect "shebang=yes"

  target "backup.sh creates a tar archive of docs", weight: 2
  run ruby_check("f = '#{script}'; puts((File.file?(f) && File.read(f).match?(/tar .*docs/)) ? 'tar=yes' : 'tar=no')"), on: :host1
  expect "tar=yes"
end

play do
  show
  export
end
