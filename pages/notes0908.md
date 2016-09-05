---
layout: page
title: 9/8 notes
description: notes, links, example code, exercises
---
[previous](notes0906.html) & [next](notes0913.html)

---

## the Unix shell

quick count: shell versus terminal? absolute versus relative path? `grep`?

We followed "Navigating Files and Directories" from the
[software carpentry introduction](http://swcarpentry.github.io/shell-novice/).
Click on 'setup' to download the data.

summary:

- directory structure, root is `/`
- relative versus absolute paths
- shortcuts: `.`, `..`, `~`, `-`
- tab completion to get program and file names
- up/down arrows and `!` to repeat commands

|          |      |
|:---------|:-----------|
| `whoami` | who am I? to get your username |
| `pwd`    | print working directory. where am I? |
| `ls`     | list. many options, e.g. `-a` (all) `-l` (long) `-lrt` (reverse-sorted by time) |
| `cd`     | change directory |
| `mkdir`  | make directory   |
| `rm`     | remove (forever). `-f` to force, `-i` to ask interactively, `-r` recursively
| `rmdir`  | remove (delete) directory, if empty |
| `mv`     | move (and rename). can overwrite existing files, unless `-i` to ask|
| `cp`     | copy. would also overwrite existing files |
| `diff`   | difference |
| `wc`     | word count: lines, words, characters. `-l`, `-w`, `-c` |
| `cat`    | concatenate |
| `less`   | because "less is more". `q` to quit. |
| `sort`   | `-n` for numerical sorting |
| `head`   | first 10 lines. `-n 3` for first 3 lines (etc.) |
| `tail`   | last 10 lines. `-n 3` for last 3 lines, `-n +30` for line 30 and up |
| `uniq`   | filters out repeated lines (consecutive). `-c` to get counts |
| `cut`    | cut and return column(s). `-d,` to set the comma as field delimiter (tab otherwise), `-f2` to get 2nd field (column) |
| `echo`   | print |
| `history`| shows the history of all previous commands, numbered |
| `!`      | `!76` to re-execute command number 76 in the history, `!$` for last word or last command |
|----------|------------|
|         |   |
{: rules="groups"}


---
[previous](notes0906.html) & [next](notes0913.html)
