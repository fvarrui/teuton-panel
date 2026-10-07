---
title: History of the project
parent: Design notes
grand_parent: Developers
nav_order: 1
lang: en
permalink: /developers/notes/history/
---

> Historical notes kept as they were written; the current design is in `.minispec/` and in this guide.
{: .note }

# History

`teuton-panel` is the idea for a new library (gem) in the Teuton ecosystem.

At first we only thought about adding new features to `teuton`, but after some trials we decided it would be better to group those features and create an independent project. `teuton` is about tests: running them, reviewing them, etc. The new features we had in mind, however, are more about adding an extra layer of functionality around the way people interact with Teuton itself. It would be a kind of improved interface for Teuton.

# 1. Context

* The ebotas story
* Earlier pending ideas

# 2. Ebota use case

First I describe my use case in more detail, since it is what I compare the server you built against.

* Right now I am teaching basic terminal usage.
* Creating folders and files, cp, paths, filters... the students work only with the terminal.
* Their client has no GUI (it actually does, but I make them connect through an SSH terminal).

## 2.1 Ebota class session process

1. I start my cheap little server.
2. I run teuton every minute (`watch -n 60 teuton run test`).
3. On the projector (half of the screen) I show a browser with the `/list` page, which shows all users and refreshes every 10 seconds (I added the refresh after sending it to you).
4. On the other half of the projector I show the teuton run. Luckily the results table is visible when running `watch -n 60 teuton run test`, and it is re-run every minute.

With this I can walk around the classroom helping students without worrying about anything on the server. I look at the projector to find those with the lowest grades and help them, and I congratulate those who are finishing. I can even easily see who is in class but has not even registered on the server yet.

If a student arrives late, they simply register on the server, and they appear on the scoreboard in the next teuton run. I don't have to do anything on the server.
