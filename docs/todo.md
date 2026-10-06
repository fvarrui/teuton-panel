[<< back](../index.md)

# teuton-panel

`teuton-panel` is the idea for a new library (gem) in the Teuton ecosystem.

At first we only thought about adding new features to `teuton`, but after some trials we decided it would be better to group those features and create an independent project. `teuton` is about tests: running them, reviewing them, etc. The new features we had in mind, however, are more about adding an extra layer of functionality around the way people interact with Teuton itself. It would be a kind of improved interface for Teuton.

# 1. New teuton-panel gem (v2.0.0)

> See the `teuton-panel` repository. IN PROGRESS!!!

This TO-DO should live in the new gem's own repo.

* Create the new `teuton-panel` gem (v2), which will replace the current obsolete version.
* Modify/extend the `teuton config` functions to make `teuton-panel`'s work easier.
    * tt_include
    * tt_include_params
    * flatten/unflatten the config file.
* In the trials we used `sinatra` to implement it.

Web interface features:

* config cases:
    * config/remote:
      * accept-remote-config: enable/disable remote configurations
      * Accept form POST and GET via curl with a route.
    * config/list: show a list with student info
    * Choose where configurations are stored
* run:
    * Run by the teacher
        * All
        * A selection of cases
        * every: loop repetitions of I iterations, every T time.
    * The student requests their own run via curl
    * Choose where reports are stored
    * Show a list of results at the end of each run
* readme/doc:
    * enable automatic "teuton doc" to a web page for students.
* config panel:
    * panel/new: create the panel configuration file
    * panel/save: save the panel configuration

# 2. Usage

* Run the `teuton-panel` command.
* Find available "teuton tests".
    - If none is found, there is no point in starting the "panel".
* Find the `teuton-panel.yaml` configuration file.
    - It is created if it does not exist.
* To continue:
    - We have found a teuton test to work on.
    - We have found the panel configuration file to save the settings.

Options available in the panel

* tests: manage the tests
    - See the list of available tests (`/tests/list`)
    - Activate a test
        - A configuration file with `tt_include`, etc. is required.
* cases: manage the cases of the active test
    - Enable/disable cases (`tt_skip: true/false`)
* run: Run the selected test
    - Run once (`/run/once`)
    - Run several times (`/run/times/N`)
    - Run periodically (`/run/every/N`)
        - Time between runs
        - Deadline date/time
    - Enable/disable remote "run" (`/run`)
* panel:
    - Enable/disable http and/or curl remote access
    - Enable/disable showing the cases list (`/cases/list`)
    - Enable/disable showing the readme (`/readme`)
    - Enable/disable remote config (`/config`)

As a result, the student will have access to:

* `/config`
* `/run`
* `/list`
* `/readme`

# 5. tt_include

```yaml
global:
  tt_include: config.d
  tt_params:
    tt_members: AS NAME
    tt_moodle_id: AS EMAIL
    host_ip: AUTO IP
```
