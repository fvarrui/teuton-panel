# frozen_string_literal: true

# Take the documentation screenshots: run the panel on a copy of
# samples/linux-files-basics, set up each state and capture every page in
# en, es and ca with a headless Chrome (or Edge).
#
# Usage: bundle exec rake docs:screenshots   (CHROME=path/to/chrome to override)

require "fileutils"
require "json"
require "net/http"
require "rbconfig"
require "uri"
require "yaml"

ROOT = File.expand_path("../..", __dir__)
WORK = File.join(ROOT, "tmp", "shots", "linux-files-basics")
OUTDIR = File.join(ROOT, "docs", "assets", "images")
PORT = 4599
LANGS = %w[en es ca]
CHROMES = [
  ENV["CHROME"],
  "C:/Program Files/Google/Chrome/Application/chrome.exe",
  "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
  "/usr/bin/google-chrome",
  "/usr/bin/chromium",
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
]

def chrome
  path = CHROMES.compact.find { File.exist?(_1) }
  if path.nil?
    warn "[ERROR] screenshots: Chrome or Edge not found. Set CHROME=path/to/browser"
    exit 1
  end
  path
end

def url(path, lang)
  joiner = path.include?("?") ? "&" : "?"
  "http://localhost:#{PORT}#{path}#{joiner}lang=#{lang}"
end

##
# Capture one page in every language
# @param name (String) File name without extension
# @param path (String) Panel path
# @param height (Integer) Window height in pixels
def shot(name, path, height = 1000)
  LANGS.each do |lang|
    target = File.join(OUTDIR, lang, "#{name}.png")
    FileUtils.mkdir_p(File.dirname(target))
    args = ["--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
      "--window-size=1280,#{height}", "--screenshot=#{target}", url(path, lang)]
    system(chrome, *args, out: File::NULL, err: File::NULL)
    puts "* Screenshot        => #{lang}/#{name}.png"
  end
end

def http(method, path, params = {})
  uri = URI("http://localhost:#{PORT}#{path}")
  request = (method == :post) ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
  request.set_form_data(params) if method == :post
  Net::HTTP.start(uri.host, uri.port, read_timeout: 300) { _1.request(request) }
end

def wait_until_idle
  300.times do
    break unless JSON.parse(http(:get, "/teacher/run.json").body).dig("scheduler", "active")

    sleep 1
  end
end

# Step 1: fresh copy of the sample with student runs allowed at once
FileUtils.rm_rf(File.dirname(WORK))
FileUtils.mkdir_p(WORK)
sample = File.join(ROOT, "samples", "linux-files-basics")
Dir.children(sample).each do |entry|
  next if %w[config.d .teuton-panel teuton-panel.yaml].include?(entry)

  FileUtils.cp_r(File.join(sample, entry), WORK)
end
system(RbConfig.ruby, File.join(WORK, "reset.rb"), out: File::NULL)
configpath = File.join(WORK, "teuton-panel.yaml")
settings = YAML.load_file(configpath, permitted_classes: [Symbol])
settings[:server] = {bind: "0.0.0.0", port: PORT, addresses: ["192.168.1.10"]} # No real addresses in public docs
settings[:student] = (settings[:student] || {}).merge(feedback: true, run_interval: 0)
File.write(configpath, settings.to_yaml)

# Step 2: start the panel
logpath = File.join(ROOT, "tmp", "shots", "panel.log")
pid = Process.spawn(RbConfig.ruby, "-I#{File.join(ROOT, "lib")}", File.join(ROOT, "bin", "teuton-panel"), "up", WORK,
  out: logpath, err: [:child, :out])
begin
  60.times do
    break if http(:get, "/students").code == "200"
  rescue Errno::ECONNREFUSED
    sleep 1
  end

  # Step 3: teacher pages
  shot "teacher-home", "/teacher", 1150
  shot "teacher-tests", "/teacher/tests?check=1", 1250
  shot "teacher-registration", "/teacher/registration", 1150
  shot "teacher-students", "/teacher/students", 900
  shot "teacher-student-edit", "/teacher/students/D5PS", 1250
  shot "teacher-run", "/teacher/run", 900
  shot "teacher-runs", "/teacher/runs", 750
  shot "teacher-run-detail", "/teacher/runs/20261007-094000-000-full", 1150
  shot "teacher-results", "/teacher/results", 900
  shot "teacher-projector", "/teacher/results?projector=1", 720
  shot "teacher-result-detail", "/teacher/results/B3MQ", 1050
  shot "teacher-readme", "/teacher/readme", 1200
  shot "teacher-settings", "/teacher/settings", 1500

  # Step 4: student pages
  shot "students-home", "/students", 1050
  shot "students-register", "/students/register", 1000
  shot "students-register-errors", "/students/register?tt_members=&tt_moodle_id=no-email&home=x", 1050
  shot "students-personal", "/students/B3MQ", 1250
  shot "students-disabled", "/students/G8SV", 900
  shot "students-run", "/students/C4NR/run", 1050
  shot "students-results", "/students/B3MQ/results", 1000
  shot "students-history", "/students/C4NR/history", 800
  shot "students-status", "/students/A2KP/status", 560
  shot "students-readme", "/students/readme", 1250

  # Step 5: a periodic run in progress
  http(:post, "/teacher/run/start", {"mode" => "every", "every" => "120"})
  sleep 3
  shot "teacher-run-active", "/teacher/run", 1000
  shot "students-run-next-pass", "/students/D5PS/run", 560
  http(:post, "/teacher/run/stop")
  wait_until_idle

  # Step 6: registration (one new student per language, removed afterwards)
  shot "students-registered", "/students/register?tt_members=Nuria%20Vidal&tt_moodle_id=nuria.vidal@example.com&home=lucia", 820
  JSON.parse(http(:get, "/teacher/students.json").body).each do |row|
    http(:post, "/teacher/students/#{row["code"]}/delete") if row["members"] == "Nuria Vidal"
  end

  # Step 7: class sessions (archiving empties the current session)
  http(:post, "/teacher/sessions/new", {"label" => "ASIR 1 - Group A"})
  shot "teacher-sessions", "/teacher/sessions", 850
  id = http(:get, "/teacher/sessions").body[%r{/teacher/sessions/(\d{8}-\d{6})}, 1]
  shot "teacher-session", "/teacher/sessions/#{id}", 950
ensure
  Process.kill("KILL", pid)
  Process.wait(pid)
end
puts "==> [INFO] Screenshots in #{OUTDIR}"
