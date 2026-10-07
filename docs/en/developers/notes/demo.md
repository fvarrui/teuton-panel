---
title: Comments on the first demo
parent: Design notes
grand_parent: Developers
nav_order: 2
lang: en
permalink: /developers/notes/demo/
---

> Historical notes kept as they were written; the current design is in `.minispec/` and in this guide.
{: .note }

# 1. Comments on the demo

## App: teuton server

**Problem**:

* While the teacher is waiting for students to register, there is no easy way to see who is already in and who is not. Looking at the `config.d` directory only shows IPs.
* **FEATURE**: This can be solved by allowing "get /list" to show the `tt_members` and `tt_source_ip` collected so far. Enabled/disabled by the teacher.

**Problem**:

* When the config.yaml file does not exist before starting the server, the server form does not ask for the IP (host_ip), and config.yaml is not created until the server is closed. So I cannot run the tests until I close the server.
* BUT if before starting the server I create the file with the output of config itself, for example `teuton config test/ > test/config.yaml`, and then start the server, the form asks for the data proposed in the config (a very interesting approach to a dynamic form!!).
* BUT, since the proposed config did not include the include of the configs, I cannot run teuton until I stop the server.
* Once the server is stopped, it writes the include into the config, and then it can be started again; since it now has the include of config.d, new clients keep being added. And therefore I can keep running teuton run.
* Maybe the proposed config file should include the include??
* Even more, maybe if the server does not find config.yaml, it should create it directly with the basic proposal and the include.

**FEATURE**: This can be solved by creating the `config.yaml` file as soon as the server starts.

**Problem**

* The tt_members only have source_ip and no host_ip.
* A `tt_members: anonymous` shows up??
* With first-year students it is very easy for them to type their own IP wrong (it happened to me while testing :-D). I would like some option so that the IP is always taken from the connection. Maybe pre-filling the form would be enough. You already have the value, since you already write it in the form text. If field host_ip := CLIENT_IP :-D
* Maybe an auto value in config.yaml could make the form pre-fill it.

* **FEATURE**: This can be solved by defining parameters with `tt_include_params`.

```yaml
config:
  tt_include: config.d
  tt_include_params:
    tt_members: AS NAME
    tt_moodle_id: AS EMAIL
    host_ip: AUTO IP
cases: []
```

**QUESTION**

- Same thing for the logs. Maybe it would be more convenient if the log showed all the names, or something similar, after each submit.

**Problem**

* The request, the form submit, only works with POST, so from the command line it is a bit more complicated. I have some use cases where students only have an Ubuntu server, with no GUI, CLI only.
* I tried with the terminal browser lynx and it works.
* Although with students I like doing web things from the terminal with curl only at the start of the course. It disorients them quite a bit, and it is a first approach to the world of web APIs :-D
* **FEATURE**: accept http and curl

## Closing remarks

Well, I like your solution, especially the dynamic part. I think a new user must be able to use it right away, without having to write anything in config.yaml. Basically by always including the include in the proposal, and maybe adding a comment in the file itself, for more advanced teachers, saying that if all students have the same user and password, they can define them in the global section and remove them from the form.

Thanks for the integration!!!
