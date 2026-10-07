# frozen_string_literal: true

# Reset the linux-files-basics sample to its demo state:
# - registered students in config.d/ (their work is in homes/<home>/)
# - registration fields in teuton-panel-params.yaml
# - panel settings in teuton-panel.yaml
# - an invented history of three class runs and one student run in .teuton-panel/
#
# Usage: ruby samples/linux-files-basics/reset.rb

require "fileutils"
require "json"
require "yaml"

BASEDIR = __dir__
TEST = File.basename(BASEDIR) # The test id is the folder name
DAY = "2026-10-07"

# Target id => [group, description, weight, output when done, output when not]
TARGETS = {
  1 => ["Files and directories", "Directory docs exists", 1, "docs=yes", "docs=no"],
  2 => ["Files and directories", "File docs/notes.txt exists", 1, "notes=yes", "notes=no"],
  3 => ["Files and directories", "docs/notes.txt has exactly 3 lines", 2, "lines=3", "lines=2"],
  4 => ["Shell configuration", "File .bashrc defines the alias ll", 2, "alias=yes", "alias=no"],
  5 => ["Backup script", "File scripts/backup.sh exists", 1, "script=yes", "script=no"],
  6 => ["Backup script", "backup.sh starts with #!/bin/bash", 1, "shebang=yes", "shebang=no"],
  7 => ["Backup script", "backup.sh creates a tar archive of docs", 2, "tar=yes", "tar=no"]
}

STUDENTS = [
  {code: "A2KP", name: "Ana García", email: "ana.garcia@example.com", home: "ana", ip: "192.168.1.21"},
  {code: "B3MQ", name: "Luis Pérez", email: "luis.perez@example.com", home: "luis", ip: "192.168.1.22"},
  {code: "C4NR", name: "Marta Ruiz", email: "marta.ruiz@example.com", home: "marta", ip: "192.168.1.23"},
  {code: "D5PS", name: "Diego Santana", email: "diego.santana@example.com", home: "diego", ip: "192.168.1.24"},
  {code: "E6QT", name: "Lucía Hernández", email: "lucia.hernandez@example.com", home: "lucia", ip: "192.168.1.25"},
  {code: "F7RU", name: "Sara Medina", email: "sara.medina@example.com", home: "sara", ip: "192.168.1.26"},
  {code: "G8SV", name: "Pablo Torres", email: "pablo.torres@example.com", home: "pablo", ip: "192.168.1.27", disabled: true}
]

# Run time, kind and the targets each student had done (nil = not in the run).
# The last full run matches what is really in homes/.
RUNS = [
  ["09:00:00", "full", {"A2KP" => [1, 2], "B3MQ" => [1], "C4NR" => [1], "D5PS" => [1], "E6QT" => [1, 2], "F7RU" => [], "G8SV" => [1, 2, 3]}],
  ["09:20:00", "full", {"A2KP" => [1, 2, 3, 4], "B3MQ" => [1, 2, 3], "C4NR" => [1, 2], "D5PS" => [1, 2, 3], "E6QT" => [1, 2, 3, 5], "F7RU" => [], "G8SV" => [1, 2, 3, 4]}],
  ["09:35:00", "student", {"C4NR" => [1, 2, 5]}],
  ["09:40:00", "full", {"A2KP" => [1, 2, 3, 4, 5, 6, 7], "B3MQ" => [1, 2, 3, 4, 5, 7], "C4NR" => [1, 2, 5], "D5PS" => [1, 2, 3, 4], "E6QT" => [1, 2, 3, 5, 6, 7], "F7RU" => []}]
]

def write_yaml(filepath, data)
  File.write(filepath, data.to_yaml)
  puts "* Create file       => #{filepath.delete_prefix(BASEDIR + "/")}"
end

def grade(done)
  total = TARGETS.values.sum { _1[2] }
  good = done.sum { TARGETS[_1][2] }
  (100.0 * good / total).round.to_f
end

def case_result(student, done, time)
  result = {}
  result["key"] = student[:code]
  result["code"] = student[:code]
  result["members"] = student[:name]
  result["moodle_id"] = student[:email]
  result["grade"] = grade(done)
  result["unique_fault"] = 0
  result["conn_status"] = {}
  result["finished_at"] = "#{DAY} #{time} +0100"
  result["targets"] = TARGETS.map do |id, (group, description, weight, ok_output, fail_output)|
    check = done.include?(id)
    {"group" => group, "target_id" => format("%02d", id), "description" => description, "check" => check,
     "weight" => weight.to_f, "command" => "ruby -e \"...\"", "expected" => ok_output,
     "output" => check ? ok_output : fail_output}
  end
  result
end

# Step 1: clean generated files (student work in homes/ is kept)
Dir.glob(File.join(BASEDIR, "config.d", "*.yaml")).each { File.delete(_1) }
FileUtils.rm_rf(File.join(BASEDIR, ".teuton-panel"))
FileUtils.mkdir_p(File.join(BASEDIR, "config.d"))

# Step 2: registered students
STUDENTS.each do |student|
  data = {"tt_members" => student[:name], "tt_moodle_id" => student[:email], "home" => student[:home],
          "host1_ip" => "localhost", "tt_panel_code" => student[:code], "tt_source_ip" => student[:ip]}
  data["tt_panel_disabled"] = true if student[:disabled]
  write_yaml(File.join(BASEDIR, "config.d", "#{student[:code]}.yaml"), data)
end

# Step 3: registration fields and panel settings
File.write(File.join(BASEDIR, "teuton-panel-params.yaml"), <<~YAML)
  # Registration fields for teuton-panel and how each one is filled:
  # ASK (free text), AS NAME, AS EMAIL, AUTO IP (request IP) or a fixed value.
  tt_members: "AS NAME"
  tt_moodle_id: "AS EMAIL"
  home: "ASK"
  host1_ip: "localhost"
YAML
puts "* Create file       => teuton-panel-params.yaml"
settings = {server: {bind: "0.0.0.0", port: 4567}, language: "es", test: TEST, student: {feedback: true}}
write_yaml(File.join(BASEDIR, "teuton-panel.yaml"), settings)

# Step 4: invented run history and latest result of each student
runsdir = File.join(BASEDIR, ".teuton-panel", "tests", TEST, "runs")
results = {}
last = nil
RUNS.each do |time, kind, progress|
  id = "#{DAY.delete("-")}-#{time.delete(":")}-000-#{kind}"
  cases = progress.map do |code, done|
    student = STUDENTS.find { _1[:code] == code }
    case_result(student, done, time)
  end
  summary = {"id" => id, "kind" => kind, "test" => TEST, "started_at" => "#{DAY} #{time} +0100",
             "keys" => progress.keys, "exitcode" => 0, "finished_at" => "#{DAY} #{time} +0100",
             "cases" => cases, "ok" => true}
  FileUtils.mkdir_p(File.join(runsdir, id))
  File.write(File.join(runsdir, id, "summary.json"), JSON.pretty_generate(summary))
  File.write(File.join(runsdir, id, "output.log"), "Invented run created by reset.rb (#{kind}, #{time}).\n")
  puts "* Create run        => #{id}"
  cases.each { results[_1["key"]] = _1.merge("run_id" => id) }
  last = summary.except("cases")
end
File.write(File.join(BASEDIR, ".teuton-panel", "tests", TEST, "results.json"),
  JSON.pretty_generate({"results" => results, "last_run" => last}))

puts "==> [INFO] Sample ready. Start it with: teuton-panel up #{BASEDIR}"
