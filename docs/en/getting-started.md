---
title: Getting started
nav_order: 2
lang: en
permalink: /getting-started/
---

# Getting started
{: .no_toc }

1. TOC
{:toc}

## Requirements

- Ruby 3.2.8 or newer. On Windows, [RubyInstaller](https://rubyinstaller.org/) is enough; the MSYS2 devkit is not needed.
- The `teuton` gem 3.x, installed with the panel.
- A Teuton test: a directory with a `start.rb`. Create one with `teuton new DIRECTORY` or use the sample below.
- Student machines reachable from the teacher's computer, as Teuton needs (usually by SSH).

## Install

teuton-panel is not published on RubyGems yet, so `gem install teuton-panel` does not work. Install the `.gem` file attached to the [latest release](https://github.com/fvarrui/teuton-panel/releases/latest); its dependencies (`teuton`, `sinatra`…) come from RubyGems as usual:

```bash
# Linux / macOS
curl -LO https://github.com/fvarrui/teuton-panel/releases/latest/download/teuton-panel.gem
gem install teuton-panel.gem
```

```powershell
# Windows (PowerShell)
Invoke-WebRequest https://github.com/fvarrui/teuton-panel/releases/latest/download/teuton-panel.gem -OutFile teuton-panel.gem
gem install teuton-panel.gem
```

`gem install` does not accept a URL: download the file first. The `latest` link always gives the newest release, so the same two lines also update the panel. For a specific version, download its file from the [releases page](https://github.com/fvarrui/teuton-panel/releases) (`teuton-panel-<version>.gem`).

{: .note }
If the `teuton-panel` command is not found after installing, the gem's executable directory is not in your `PATH`. Find it with `gem env` ("EXECUTABLE DIRECTORY") and add it.

## Start the panel

```bash
teuton-panel up PATH/TO/TESTS
```

`PATH/TO/TESTS` is a directory that contains one or more Teuton tests (directories with a `start.rb`); the current directory is used when you leave it out. `teuton-panel PATH/TO/TESTS` does the same.

The panel checks that Teuton 3 is installed, creates its settings file (`teuton-panel.yaml`) and prints where to connect:

```
------------------------------------------------------------
teuton-panel 0.3.1
Base dir    : /home/teacher/tests
Active test : network-basics
Teacher     : http://localhost:4567/teacher
Students    : http://192.168.1.10:4567/students
  curl help : curl http://192.168.1.10:4567/students.txt
------------------------------------------------------------
```

Open the **Teacher** address on your own computer and give the **Students** address to the class. Stop the panel with `Ctrl+C`; running Teuton processes are stopped too.

## Try it with the sample challenge

The source code includes a ready-to-try challenge with seven invented students and an invented class history. It runs on `localhost`, so no student machines are needed:

```bash
git clone https://github.com/fvarrui/teuton-panel
cd teuton-panel
ruby samples/linux-files-basics/reset.rb
teuton-panel up samples/linux-files-basics
```

All the screenshots in this guide were taken with this sample. Run `reset.rb` again whenever you want to start the demo from scratch.

## A class in five steps

1. Start the panel and open the teacher area ([Start the panel]({{ site.baseurl }}/teacher/start/)).
2. Activate the test and check the registration fields ([Tests]({{ site.baseurl }}/teacher/tests/), [Registration fields]({{ site.baseurl }}/teacher/registration/)).
3. Show the student address; students register and get their personal code ([Registering]({{ site.baseurl }}/students/register/)).
4. Start a periodic run ([Running the test]({{ site.baseurl }}/teacher/runs/)).
5. Follow the class on the projector ([Results]({{ site.baseurl }}/teacher/results/)) and archive the session at the end ([Class sessions]({{ site.baseurl }}/teacher/sessions/)).
