# teuton-panel

A web panel for [Teuton](https://github.com/teuton-software/teuton) that a teacher runs on a classroom network. Students register their machines from a browser or a terminal, the panel runs Teuton for the whole class or for one student, and everybody sees the results: the teacher on a dashboard ready for the projector, each student on their own page.

Teuton does the testing; teuton-panel only drives it. It calls the `teuton` command and reads the JSON reports it writes, so any Teuton 3 test works without changes.

## Features

- **Teacher area** (only from the teacher's computer): choose the active test, define the registration fields, manage students, run the test once, several times or every few seconds, follow the runs live, see the results (with a projector mode), download `moodle.csv`, preview the statement and archive class sessions.
- **Student area** (from the classroom network): register and get a personal code, run their own test, see their grade, history and connection status, and read the test statement.
- **Browser or terminal**: every student page also exists as plain text (`.txt`, for `curl`) and JSON (`.json`).
- **The teacher decides**: each student feature and each format can be switched on and off; with no format enabled the student area is closed.
- **English and Spanish**: chosen from the browser's language, or with `?lang=en` / `?lang=es`.
- **Offline**: no internet needed; fonts and styles are served by the panel.
- **Safe by default**: students never see other students' data or any password, and the teacher area answers only the teacher's computer.

## Requirements

- Ruby 3.2.8 or newer (on Windows, RubyInstaller; the MSYS2 devkit is not needed).
- The `teuton` gem 3.x (installed with the panel).
- A Teuton test: a directory with `start.rb` (create one with `teuton new DIRECTORY`).
- Student machines reachable from the teacher's computer, as Teuton needs (usually SSH).

## Installation

```bash
gem install teuton-panel
```

From the source code:

```bash
git clone https://github.com/dvarrui/teuton-panel
cd teuton-panel
bundle install
gem build teuton-panel.gemspec
gem install teuton-panel-*.gem
```

## Quick start

```bash
teuton-panel up PATH/TO/TESTS     # or just: teuton-panel PATH/TO/TESTS
```

The panel looks for every directory with a `start.rb` under `PATH/TO/TESTS` (the current directory by default) and prints where to connect:

```
------------------------------------------------------------
teuton-panel 0.1.0
Base dir    : /home/teacher/tests
Active test : network-basics
Teacher     : http://localhost:4567/teacher
Students    : http://192.168.1.10:4567/students
  curl help : curl http://192.168.1.10:4567/students.txt
------------------------------------------------------------
```

1. Open the **teacher** address on your computer.
2. If there are several tests, activate one in **Tests**.
3. Check the fields students will fill in under **Registration**.
4. Project or write the **students** address for the class.
5. When students have registered, go to **Run** and start a run (for example, every 60 seconds).
6. Follow the class in **Results**, or open **Projector mode** for the screen.

Stop the panel with `Ctrl+C`; running Teuton processes are stopped too.

## How a class works

- **Registration**: a student opens `/students/register` (or runs the `curl` command) and fills in the fields you defined. The panel writes their case to the test's `config.d/<code>.yaml` and gives them a **personal code**, for example `K7QH`. Their page is `/students/K7QH`. Teuton reads `config.d/` by itself, so the student is included in the next run.
- **Runs**: the teacher runs the whole class or a selection; a student can run only their own case (at most one at a time and, by default, once every 30 seconds). While the teacher has a periodic run going, students are told when the next pass will happen.
- **Results**: the panel keeps the latest result of each student, whichever run produced it, so a student's own run never hides the rest of the class.
- **Sessions**: at the end of a class, **Sessions → New session** archives registrations, results and runs and starts empty. Archived sessions keep their results and `moodle.csv`.

A student who forgets their code asks the teacher, who sees every code in **Students**.

## Student commands

Students without a graphical desktop use `curl`. Commands use the `.txt` suffix to get plain text:

```bash
curl http://192.168.1.10:4567/students.txt                                      # help
curl "http://192.168.1.10:4567/students/register.txt?tt_members=Ana&answer=4"   # register (fields as defined by the teacher), prints the code
curl http://192.168.1.10:4567/students/K7QH.txt                                 # my page
curl http://192.168.1.10:4567/students/K7QH/run.txt                             # run my test
curl http://192.168.1.10:4567/students/K7QH/results.txt                         # my results
curl http://192.168.1.10:4567/students/K7QH/history.txt                         # my grade history
curl http://192.168.1.10:4567/students/K7QH/status.txt                          # did the panel reach my machine?
curl http://192.168.1.10:4567/students/readme.md                                # test statement
```

The same addresses with `.json` return JSON; without a suffix they return the web page.

## Registration fields

The fields of the registration form are stored in `teuton-panel-params.yaml`, next to the test's `config.yaml`, and can be edited in **Registration**. Each field is filled in one of these ways:

| Mode | Meaning |
| --- | --- |
| `AS NAME` | Asked to the student, labelled as their name (use it for `tt_members`) |
| `AS EMAIL` | Asked and checked as an email (use it for `tt_moodle_id` to get `moodle.csv`) |
| `ASK` | Asked as free text |
| `AUTO IP` | Not asked: the IP of the machine the student registers from |
| any other value | Not asked: the same fixed value for everybody (for example a common username) |

Example:

```yaml
tt_members: "AS NAME"
tt_moodle_id: "AS EMAIL"
host1_ip: "AUTO IP"
host1_username: "root"
host1_password: "ASK"
```

When a test has no params file, the panel proposes one from `teuton config`. `AUTO IP` is only right when students register from the machine that will be evaluated; otherwise make the field `ASK`. Host fields never accept the panel's own addresses, so Teuton cannot be pointed at the teacher's computer.

## Files

- **`teuton-panel.yaml`** (in the base directory): panel settings, created with defaults on the first start and saved from **Settings**.
- **`config.yaml`** (in each test): Teuton's config. The panel only adds `tt_include: config.d` (as text, keeping your comments). Cases you write in `cases:` are evaluated too.
- **`teuton-panel-params.yaml`** (in each test): registration fields.
- **`config.d/`** (in each test): one file per registered student.
- **`.teuton-panel/`** (in the base directory): run directories with Teuton's reports, the results of each student and archived sessions.

Main settings in `teuton-panel.yaml`:

```yaml
:server:
  :bind: 0.0.0.0
  :port: 4567
:language: es              # default language when the browser does not say
:teacher:
  :allow: []               # other IPs that can open the teacher area
:run:
  :every: 60               # seconds between periodic runs
  :times: 1
  :delay: 3
:runs:
  :max_parallel: 4         # student runs at the same time
:student:
  :register: true
  :list: true
  :run: true
  :results: true
  :feedback: false         # show each target's result to students
  :history: true
  :status: true
  :readme: true
  :formats: [html, txt, json]
  :run_interval: 30
```

## Access and security

- The teacher area answers only the teacher's computer (localhost or its own addresses) and the IPs in `:teacher: :allow:`. To manage the panel from another machine, add its IP there or use an SSH tunnel (`ssh -L 4567:localhost:4567 server`).
- The student area has no passwords: it is meant for a classroom network. A personal code is a convenience, not strong authentication.
- Students never see passwords, other students' codes or Teuton's raw reports, and the projector mode hides commands and outputs.

## Troubleshooting

- **Students cannot open the address**: check the computer's firewall allows incoming connections on port 4567 and that students use one of the addresses printed at startup.
- **A student always gets 0 with a connection problem**: open their status page; the machine may be off, its IP may be wrong (fix it in **Students → Edit**) or SSH may reject the username or password.
- **"teuton 3.x is required"**: install it with `gem install teuton -v "~> 3.0"`.
- **A run shows no reports**: open it in **History** to read Teuton's output; errors in `start.rb` show up there.
- **Known Teuton 3.0.0 issues** ([teuton#44](https://github.com/teuton-software/teuton/issues/44)): `tt_skip` and `--case` crash Teuton, and a hash value in `config.yaml` `global` breaks its reports. The panel avoids both (it never uses `tt_skip` or `--case` and keeps its data out of `config.yaml`), but do not add them by hand.

## Development

```bash
bin/setup                                   # bundle install
bundle exec rake                            # tests + Standard
bundle exec ruby -Itest -Ilib test/teuton/panel/app_test.rb
ruby .claude/skills/teuton-sandbox/scripts/create_sandbox.rb   # sample test in tmp/sandbox
ruby teuton-panel up tmp/sandbox            # development launcher
```

Some tests run the real `teuton` command on the sandbox test, so the full suite takes a minute or two. Design notes and decisions live in `.minispec/` and `docs/`.

## License

[MPL-2.0](LICENSE). Bundled fonts (Atkinson Hyperlegible, Bricolage Grotesque, JetBrains Mono) are under the SIL Open Font License; their licenses are in `lib/teuton/panel/public/fonts/`.

## Contact

Bug reports and pull requests are welcome on GitHub at https://github.com/dvarrui/teuton-panel. Email: `teuton.software@protonmail.com`.
