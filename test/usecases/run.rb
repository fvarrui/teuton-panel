# frozen_string_literal: true

# Use-case run of teuton-panel against a copy of samples/linux-files-basics.
# Simulates teacher and student requests (with their IPs) through Rack, on real
# files and with the real teuton command. Takes a few minutes.
#
# Usage: bundle exec rake usecases

require "fileutils"
require "json"
require "rack/mock"
require "yaml"
require "teuton/panel"

ROOT = File.expand_path("../..", __dir__)
WORK = File.join(ROOT, "tmp", "uc", "linux-files-basics")
LOCAL = "127.0.0.1"
LAN = "192.168.1.77"
RESULTS = []

def check(id, title, ok, detail = "")
  RESULTS << [id, title, ok, detail]
  puts "#{ok ? "PASS" : "FAIL"} #{id} #{title}#{detail.empty? ? "" : " -- #{detail}"}"
end

def req(method, path, ip: LAN, params: {}, headers: {})
  env = {"REMOTE_ADDR" => ip}.merge(headers)
  env[:params] = params unless params.empty?
  Rack::MockRequest.new(Teuton::Panel::App).send(method, path, env)
end

def json(response)
  JSON.parse(response.body)
rescue JSON::ParserError
  {}
end

def wait_idle(seconds = 180)
  (seconds * 5).times do
    break unless SCHED.active?

    sleep 0.2
  end
end

def student_file(code)
  File.join(WORK, "config.d", "#{code}.yaml")
end

# Fresh copy of the sample in its demo state
FileUtils.rm_rf(WORK)
FileUtils.mkdir_p(WORK)
Dir.children(File.join(ROOT, "samples", "linux-files-basics")).each do |entry|
  next if %w[config.d .teuton-panel teuton-panel.yaml var].include?(entry)

  FileUtils.cp_r(File.join(ROOT, "samples", "linux-files-basics", entry), WORK)
end
system(RbConfig.ruby, File.join(WORK, "reset.rb"), out: File::NULL)

CONFIG = Teuton::Panel::Config.new(WORK)
QUEUE = Teuton::Panel::RunQueue.new(CONFIG[:runs][:max_parallel])
SCHED = Teuton::Panel::Scheduler.new(QUEUE)
app = Teuton::Panel::App
app.set(:panel_projects, Teuton::Panel::Projects.all(WORK))
app.set(:panel_config, CONFIG)
app.set(:panel_queue, QUEUE)
app.set(:panel_scheduler, SCHED)

puts "== Teacher area access (T11)"
check "T11.1", "teacher home from localhost", req(:get, "/teacher", ip: LOCAL).status == 200
check "T11.2", "teacher home from a LAN IP is 403", req(:get, "/teacher", ip: LAN).status == 403
check "T11.3", "teacher JSON from a LAN IP is 403", req(:get, "/teacher/results.json", ip: LAN).status == 403
CONFIG.update(teacher: {allow: [LAN]})
check "T11.4", "allowed teacher IP gets the teacher area", req(:get, "/teacher", ip: LAN).status == 200
CONFIG.update(teacher: {allow: []})
r = req(:post, "/teacher/run/stop", ip: LAN)
check "T11.5", "teacher POST from a LAN IP is 403", r.status == 403

puts "== Tests (T3)"
r = req(:get, "/teacher/tests", ip: LOCAL)
check "T3.1", "tests page lists the sample", r.status == 200 && r.body.include?("linux-files-basics")
r = req(:get, "/teacher/tests?check=1", ip: LOCAL)
check "T3.2", "teuton check output shown", r.status == 200 && r.body.include?("Groups"), r.body[/<pre class="log">(.{0,120})/m, 1].to_s.strip
r = req(:post, "/teacher/tests/select", ip: LOCAL, params: {"test" => "linux-files-basics"})
check "T3.3", "re-activating the active test redirects", [302, 303].include?(r.status)
r = req(:post, "/teacher/tests/select", ip: LOCAL, params: {"test" => "nope"})
check "T3.4", "activating an unknown test is 404", r.status == 404

puts "== Invented data on the dashboard (T8)"
rows = json(req(:get, "/teacher/results.json", ip: LOCAL))
grades = rows.to_h { [_1["code"], _1["grade"]] }
check "T8.1", "invented grades on the dashboard", grades == {"A2KP" => 100.0, "B3MQ" => 90.0, "C4NR" => 30.0, "D5PS" => 60.0, "E6QT" => 80.0, "F7RU" => 0.0, "G8SV" => 60.0}, grades.inspect
check "T8.2", "Pablo shown as disabled", rows.find { _1["code"] == "G8SV" }&.dig("disabled") == true
r = req(:get, "/teacher/results?projector=1", ip: LOCAL)
check "T8.3", "projector mode renders tiles", r.status == 200 && r.body.include?("tiles") && r.body.include?("Ana Garc")
r = req(:get, "/teacher/results/B3MQ", ip: LOCAL)
check "T8.4", "result detail shows commands (tooltip)", r.status == 200 && r.body.include?("shebang")
r = req(:get, "/teacher/results/B3MQ?projector=1", ip: LOCAL)
check "T8.5", "projector detail hides commands and output", r.status == 200 && !r.body.include?("ruby -e")
r = req(:get, "/teacher/moodle.csv", ip: LOCAL)
check "T8.6", "moodle.csv has every evaluated student", r.status == 200 && r.body.lines.size == 8 && r.body.include?("ana.garcia@example.com,100.0"), "#{r.body.lines.size} lines"
check "T8.7", "moodle.csv is an attachment", r.headers["content-disposition"].to_s.include?("attachment")

puts "== History (T7)"
r = req(:get, "/teacher/runs", ip: LOCAL)
check "T7.1", "history lists the 4 invented runs", r.status == 200 && r.body.scan("/teacher/runs/2026").size == 4, r.body.scan("/teacher/runs/2026").size.to_s
r = req(:get, "/teacher/runs/20261007-093500-000-student", ip: LOCAL)
check "T7.2", "run detail of Marta's request", r.status == 200 && r.body.include?("Marta Ruiz")
r = req(:get, "/teacher/runs/..%2F..%2Fsecret", ip: LOCAL)
check "T7.3", "run id with path traversal is 404", r.status == 404

puts "== Student area home and list (S2)"
r = req(:get, "/students")
check "S2.1", "student home HTML", r.status == 200 && r.body.include?("linux-files-basics")
r = req(:get, "/students.txt")
check "S2.2", "student home text with curl help", r.status == 200 && r.body.include?("/register.txt?tt_members=") && r.body.include?("Ana Garc")
check "S2.3", "text help lists asked fields only", r.body.include?("home=") && !r.body.include?("host1_ip=")
r = req(:get, "/students.json")
check "S2.4", "student home JSON without codes", r.status == 200 && json(r)["members"].size == 7 && !r.body.include?("A2KP")
CONFIG.update(student: {list: false})
r = req(:get, "/students.json")
check "S2.5", "list switch off hides members", json(r)["members"].nil?
CONFIG.update(student: {list: true})

puts "== Registration (S1)"
r = req(:get, "/students/register")
check "S1.1", "registration form shows asked fields", r.status == 200 && r.body.include?("name=\"home\"") && !r.body.include?("name=\"host1_ip\"")
r = req(:get, "/students/register.txt?tt_members=Carmen%20Vega&tt_moodle_id=carmen@example.com&home=ana")
code = r.body[/\b[A-HJKMNP-Z2-9]{4}\b/]
check "S1.2", "register from curl returns a code", r.status == 200 && !code.nil?, r.body.lines.first.to_s.strip
data = code ? YAML.load_file(student_file(code)) : {}
check "S1.3", "registered file has fixed host and source IP", data["host1_ip"] == "localhost" && data["tt_source_ip"] == LAN, data.inspect
r = req(:post, "/students/register.json", params: {"tt_members" => "Iván Díaz", "tt_moodle_id" => "ivan@example.com", "home" => "nobody"})
ivan = json(r)["code"]
check "S1.4", "register from a form/JSON", r.status == 200 && !ivan.nil?
r = req(:get, "/students/register.txt?tt_members=&tt_moodle_id=bad&home=x")
check "S1.5", "invalid registration is 422 with field errors", r.status == 422 && r.body.include?("tt_members") && r.body.include?("tt_moodle_id")
r = req(:get, "/students/register.txt?tt_members=Hack&tt_moodle_id=h@example.com&home=x&tt_panel_code=ZZZZ&host1_ip=10.0.0.9")
hack = r.body[/\b[A-HJKMNP-Z2-9]{4}\b/]
hdata = hack ? YAML.load_file(student_file(hack)) : {}
check "S1.6", "client cannot set tt_panel_code or fixed fields", hdata["tt_panel_code"] == hack && hdata["host1_ip"] == "localhost", hdata.inspect
r = req(:get, "/students/register.txt?tt_members=Eve&tt_moodle_id=e@example.com&home=ana%27")
check "S1.7", "registration rejects quotes in typed values", r.status == 422, "status #{r.status}"
CONFIG.update(student: {register: false})
check "S1.8", "register switch off is 403", req(:get, "/students/register.txt?tt_members=X").status == 403
CONFIG.update(student: {register: true})

puts "== Personal page and update (S1)"
r = req(:get, "/students/#{code}.txt")
check "S1.9", "personal page text", r.status == 200 && r.body.include?("Carmen Vega")
r = req(:post, "/students/#{code}", params: {"tt_members" => "Carmen Vega R.", "tt_moodle_id" => "carmen@example.com", "home" => "luis"})
check "S1.10", "update own data", r.status == 200 && YAML.load_file(student_file(code))["home"] == "luis"
r = req(:get, "/students/A2KP.json")
check "S1.11", "personal JSON hides tt_panel keys", r.status == 200 && !r.body.include?("tt_panel_code")
check "S1.12", "unknown code is 404", req(:get, "/students/ZZZZ.txt").status == 404
check "S1.13", "go form redirects to personal page", req(:get, "/students/go?code=a2kp").headers["location"].to_s.end_with?("/students/A2KP")

puts "== Student runs (S3, S4, S5, S6)"
r = req(:get, "/students/#{code}/run.json")
j = json(r)
check "S3.1", "new student runs own case (home luis = 90)", j["state"] == "done" && j.dig("result", "grade").to_i == 90, j.inspect[0, 160]
r = req(:get, "/students/#{code}/run.json")
check "S3.2", "second run too soon", json(r)["state"] == "too_soon"
r = req(:get, "/students/#{ivan}/run.json", ip: "192.168.1.78")
check "S3.3", "student with a missing home gets 0", json(r).dig("result", "grade") == 0.0, json(r).inspect[0, 120]
r = req(:get, "/students/G8SV/run.json", ip: "192.168.1.79")
check "S3.4", "disabled student cannot run", json(r)["state"] == "disabled"
rows = json(req(:get, "/teacher/results.json", ip: LOCAL))
check "S3.5", "a student run keeps the other results", rows.find { _1["code"] == "A2KP" }&.dig("grade").to_i == 100 && rows.size == 10, rows.size.to_s
r = req(:get, "/students/#{code}/results.json")
targets = json(r).dig("result", "targets")
check "S4.1", "results with feedback (sample enables it)", !targets.nil? && targets.size == 7 && !r.body.include?("ruby -e")
CONFIG.update(student: {feedback: false})
check "S4.2", "feedback off hides targets", json(req(:get, "/students/#{code}/results.json")).dig("result", "targets").nil?
CONFIG.update(student: {feedback: true})
r = req(:get, "/students/C4NR/history.txt")
check "S5.1", "history of Marta (4 rows)", r.status == 200 && r.body.lines.count { _1.include?("2026-10-07") } == 4
r = req(:get, "/students/#{code}/history.json")
check "S5.2", "history of a new student (1 row)", json(r)["runs"].size == 1
r = req(:get, "/students/A2KP/status.json")
check "S6.1", "status ok after an invented run", json(r)["connection"] == "ok"
r = req(:get, "/students/G8SV/status.txt")
check "S6.2", "status of a disabled student", r.body.include?("paus") || r.body.include?("paused")
r = req(:get, "/students/#{hack}/status.json")
check "S6.3", "status of a never evaluated student", r.status == 200 && json(r)["connection"].nil?

puts "== Readme (S7, T9)"
r = req(:get, "/students/readme.md")
check "S7.1", "readme as Markdown", r.status == 200 && r.body.include?("linux-files-basics") && r.body.include?("Directory docs exists")
r = req(:get, "/students/readme")
check "S7.2", "readme as HTML", r.status == 200 && r.body.include?("<table")
check "S7.3", "readme JSON", json(req(:get, "/students/readme.json"))["markdown"].to_s.include?("Backup script")
CONFIG.update(student: {readme: false})
check "S7.4", "readme switch off is 403", req(:get, "/students/readme.md").status == 403
CONFIG.update(student: {readme: true})
check "T9.1", "teacher readme preview", req(:get, "/teacher/readme", ip: LOCAL).status == 200

puts "== Formats and languages"
CONFIG.update(student: {formats: ["txt"]})
r = req(:get, "/students/A2KP")
check "F.1", "HTML disabled answers 403 naming .txt", r.status == 403 && r.body.include?(".txt")
check "F.2", "txt still works", req(:get, "/students/A2KP.txt").status == 200
CONFIG.update(student: {formats: []})
check "F.3", "no formats closes the student area", req(:get, "/students.txt").status == 403
check "F.4", "teacher area unaffected by student formats", req(:get, "/teacher", ip: LOCAL).status == 200
CONFIG.update(student: {formats: %w[html txt json]})
check "F.5", "unknown suffix is 404", req(:get, "/students/A2KP.xml").status == 404
check "F.6", "teacher routes reject .txt", req(:get, "/teacher/results.txt", ip: LOCAL).status == 404
r = req(:get, "/students", headers: {"HTTP_ACCEPT_LANGUAGE" => "en-US,en;q=0.9"})
check "L.1", "English from Accept-Language", r.body.include?("Welcome to the lab")
r = req(:get, "/students?lang=es", headers: {"HTTP_ACCEPT_LANGUAGE" => "en-US"})
check "L.2", "?lang=es wins and sets a cookie", r.body.include?("Bienvenido") && r.headers["set-cookie"].to_s.include?("lang=es")
r = req(:get, "/students.txt", headers: {"HTTP_COOKIE" => "lang=en"})
check "L.3", "cookie language in text", r.body.include?("Commands")

puts "== Registration fields editor (T4)"
r = req(:get, "/teacher/registration", ip: LOCAL)
check "T4.1", "editor lists the sample fields", r.status == 200 && r.body.include?("value=\"home\"")
fields = {"0" => {"name" => "tt_members", "mode" => "AS NAME"}, "1" => {"name" => "tt_moodle_id", "mode" => "AS EMAIL"},
          "2" => {"name" => "home", "mode" => "ASK"}, "3" => {"name" => "host1_ip", "mode" => "FIXED", "value" => "localhost"},
          "4" => {"name" => "group", "mode" => "FIXED", "value" => "ASIR1"}}
req(:post, "/teacher/registration", ip: LOCAL, params: {"fields" => fields})
spec = Teuton::Panel::Params.load(Teuton::Panel::Projects.all(WORK).first)
check "T4.2", "saving adds a fixed field", spec["group"] == "ASIR1" && spec["host1_ip"] == "localhost", spec.inspect
fields["4"]["delete"] = "1"
req(:post, "/teacher/registration", ip: LOCAL, params: {"fields" => fields})
spec = Teuton::Panel::Params.load(Teuton::Panel::Projects.all(WORK).first)
check "T4.3", "deleting a field", !spec.key?("group")
check "T4.4", "config.yaml comments kept", File.read(File.join(WORK, "config.yaml")).include?("# Linux files basics")

puts "== Students management (T5)"
r = req(:get, "/teacher/students", ip: LOCAL)
check "T5.1", "students page shows codes", r.status == 200 && r.body.include?("A2KP") && r.body.include?(code.to_s)
r = req(:post, "/teacher/students/D5PS", ip: LOCAL, params: {"data" => {"tt_members" => "Diego Santana", "tt_moodle_id" => "diego.santana@example.com", "home" => "ana", "host1_ip" => "localhost", "tt_source_ip" => "192.168.1.24"}})
check "T5.2", "teacher edits a student", [302, 303].include?(r.status) && YAML.load_file(student_file("D5PS"))["home"] == "ana"
r = req(:post, "/teacher/students/D5PS", ip: LOCAL, params: {"data" => {"tt_members" => "Diego Santana", "tt_moodle_id" => "x@example.com", "home" => "ana", "host1_ip" => "localhost", "tt_source_ip" => "192.168.1.24"}})
check "T5.3", "teacher may keep a teacher-defined localhost host", [302, 303].include?(r.status), "status #{r.status}"
req(:post, "/teacher/students/G8SV/disable", ip: LOCAL, params: {"value" => "0"})
check "T5.4", "enable Pablo", YAML.load_file(student_file("G8SV"))["tt_panel_disabled"].nil?
req(:post, "/teacher/students/#{hack}/delete", ip: LOCAL)
check "T5.5", "delete a registration", !File.exist?(student_file(hack))
File.write(File.join(WORK, "config.d", "manual.yaml"), {"tt_members" => "Manual Case", "home" => "ana", "host1_ip" => "localhost"}.to_yaml)
r = req(:get, "/teacher/students", ip: LOCAL)
check "T5.6", "code-less file shown with 'no code'", r.body.include?("Manual Case")
req(:post, "/teacher/students/assign", ip: LOCAL, params: {"filepath" => File.join(WORK, "config.d", "manual.yaml")})
assigned = Teuton::Panel::Students.new(File.join(WORK, "config.d")).all.find { _1[:data]["tt_members"] == "Manual Case" }
check "T5.7", "assign a code to a code-less file", !assigned.nil? && !assigned[:code].nil?, assigned&.dig(:filepath).to_s

puts "== Teacher runs (T6)"
req(:post, "/teacher/run/start", ip: LOCAL, params: {"mode" => "once"})
wait_idle
rows = json(req(:get, "/teacher/results.json", ip: LOCAL))
g = rows.to_h { [_1["code"], _1["grade"]] }
check "T6.1", "run once evaluates the class (Diego now home ana = 100, Pablo enabled = 100)", g["D5PS"].to_i == 100 && g["G8SV"].to_i == 100 && g["A2KP"].to_i == 100, g.inspect
before = Teuton::Panel::History.runs(File.join(WORK, ".teuton-panel", "tests", "linux-files-basics", "runs")).size
req(:post, "/teacher/run/start", ip: LOCAL, params: {"mode" => "times", "times" => "2", "delay" => "0", "keys" => ["A2KP", "B3MQ"]})
wait_idle
runs = Teuton::Panel::History.runs(File.join(WORK, ".teuton-panel", "tests", "linux-files-basics", "runs"))
check "T6.2", "run 2 times a selection", runs.size == before + 2 && runs.first["kind"] == "selection" && runs.first["cases"].size == 2, "#{runs.size - before} runs, kind #{runs.first["kind"]}"
req(:post, "/teacher/run/start", ip: LOCAL, params: {"mode" => "every", "every" => "10"})
sleep 1
check "T6.3", "every T is active", SCHED.active?
r = req(:get, "/students/A2KP/run.json", ip: "192.168.1.80")
check "T6.4", "student run during a loop answers next_pass", json(r)["state"] == "next_pass", json(r).inspect[0, 100]
r = req(:post, "/teacher/sessions/new", ip: LOCAL, params: {"label" => "x"})
check "T10.1", "new session refused while running", r.headers["location"].to_s.include?("error=running")
r = req(:get, "/teacher/run", ip: LOCAL)
check "T6.5", "run page shows the active loop", r.status == 200
req(:post, "/teacher/run/stop", ip: LOCAL)
check "T6.6", "stop ends the loop", !SCHED.active?
req(:post, "/teacher/run/start", ip: LOCAL, params: {"mode" => "every", "every" => "10", "until" => "2000-01-01T00:00"})
wait_idle(120)
check "T6.7", "until in the past stops after one pass", !SCHED.active?

puts "== Settings (T2)"
r = req(:post, "/teacher/settings", ip: LOCAL, params: {"student" => {"register" => "1", "list" => "1", "run" => "1", "results" => "1", "status" => "1"}, "formats" => %w[html txt], "run_interval" => "5", "language" => "en", "max_parallel" => "2", "teacher_allow" => "10.0.0.5, 10.0.0.6"})
saved = Teuton::Panel::Config.new(WORK)
check "T2.1", "settings saved", [302, 303].include?(r.status) && saved[:student][:formats] == %w[html txt] && saved[:teacher][:allow] == %w[10.0.0.5 10.0.0.6] && saved[:language] == "en" && saved[:student][:readme] == false
check "T2.2", "settings page renders", req(:get, "/teacher/settings", ip: LOCAL).status == 200
CONFIG.update(student: {formats: %w[html txt json], readme: true, history: true, feedback: true}, language: "es")

puts "== Sessions (T10)"
req(:post, "/teacher/sessions/new", ip: LOCAL, params: {"label" => "Group A"})
rows = json(req(:get, "/teacher/results.json", ip: LOCAL))
check "T10.2", "new session empties students and results", rows.empty?, rows.size.to_s
r = req(:get, "/teacher/sessions", ip: LOCAL)
sid = r.body[%r{/teacher/sessions/(\d{8}-\d{6})}, 1]
check "T10.3", "archived session listed", !sid.nil?
r = req(:get, "/teacher/sessions/#{sid}", ip: LOCAL)
check "T10.4", "archived session shows students and grades", r.status == 200 && r.body.include?("Ana Garc") && r.body.include?("100")
r = req(:get, "/teacher/sessions/#{sid}/moodle.csv", ip: LOCAL)
check "T10.5", "archived moodle.csv", r.status == 200 && r.body.include?("ana.garcia@example.com")
check "T10.6", "old codes no longer work", req(:get, "/students/A2KP.txt").status == 404
check "T10.7", "student work in homes/ untouched", File.exist?(File.join(WORK, "homes", "ana", ".bashrc"))

puts "== No active test and renamed sample"
base = File.join(ROOT, "tmp", "uc-multi")
FileUtils.rm_rf(base)
%w[alpha beta].each do |name|
  FileUtils.mkdir_p(File.join(base, name))
  File.write(File.join(base, name, "start.rb"), "")
end
multi = Teuton::Panel::Config.new(base)
app.set(:panel_projects, Teuton::Panel::Projects.all(base))
app.set(:panel_config, multi)
app.set(:panel_stores, {})
check "N.1", "teacher home without an active test", req(:get, "/teacher", ip: LOCAL).status == 200
check "N.2", "test pages ask to choose a test (409)", req(:get, "/teacher/results", ip: LOCAL).status == 409
multi.update(test: "gone")
check "N.3", "teacher home with a missing active test", req(:get, "/teacher", ip: LOCAL).status == 200
renamed = File.join(ROOT, "tmp", "uc-renamed", "renamed-sample")
FileUtils.rm_rf(File.dirname(renamed))
FileUtils.mkdir_p(File.dirname(renamed))
FileUtils.cp_r(File.join(ROOT, "samples", "linux-files-basics"), renamed)
FileUtils.rm_rf(Dir.glob(File.join(renamed, "{config.d,.teuton-panel,teuton-panel.yaml}")))
system(RbConfig.ruby, File.join(renamed, "reset.rb"), out: File::NULL)
copy = Teuton::Panel::Config.new(renamed)
projects = Teuton::Panel::Projects.all(renamed)
Teuton::Panel.select_test(copy, projects)
app.set(:panel_projects, projects)
app.set(:panel_config, copy)
app.set(:panel_stores, {})
check "N.4", "renamed sample keeps its results", json(req(:get, "/teacher/results.json", ip: LOCAL)).size == 7

puts
fails = RESULTS.reject { _1[2] }
puts "#{RESULTS.size} checks, #{fails.size} failed"
fails.each { puts "  FAIL #{_1[0]} #{_1[1]} -- #{_1[3]}" }
QUEUE.kill_all
exit(fails.empty? ? 0 : 1)
