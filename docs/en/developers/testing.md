---
title: Testing
parent: Developers
nav_order: 3
lang: en
permalink: /developers/testing/
---

# Testing
{: .no_toc }

1. TOC
{:toc}

## Unit and web tests

```bash
bundle exec rake test
bundle exec ruby -Itest -Ilib test/teuton/panel/app_test.rb -n "/register/"
```

Tests use test-unit and Rack::Test. `runner_test.rb` and `app_test.rb` run the real `teuton` command on the sandbox test, so the suite takes a minute or two. Rack::Test lets a test pretend to come from another IP (`"REMOTE_ADDR" => "192.168.1.50"`), which is how the teacher-only area is tested.

## Use-case run

```bash
bundle exec rake usecases
```

`test/usecases/run.rb` copies the sample challenge, starts the app in-process and plays every teacher and student use case (T1–T12, S1–S10 and the situations listed in [Use cases]({{ site.baseurl }}/use-cases/)) through Rack, with the real `teuton` command: about 90 checks. It exits with status 1 when a check fails, so it can run in CI.

## Screenshots

```bash
bundle exec rake docs:screenshots
```

`docs/_scripts/screenshots.rb` starts the real panel on a copy of the sample, prepares each state (a periodic run, a registration with errors, a disabled student, an archived session…) and captures every page in English, Spanish and Catalan with a headless Chrome or Edge (`CHROME=path` to choose). Run it after any visual change.

## Lint

The project follows [Standard Ruby](https://github.com/standardrb/standard) (`bundle exec rake standard`).
