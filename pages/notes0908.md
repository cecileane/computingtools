---
layout: page
title: basic shell commands
description: notes, links, example code, exercises
---
[previous](notes0906-intro-shell.html) &
[next](notes0915.html)

---

## the Unix shell

from the [software carpentry introduction](http://swcarpentry.github.io/shell-novice/):
- due today:
  [setup](http://swcarpentry.github.io/shell-novice/setup.html)
  to download the data and
  [navigating files and directories](http://swcarpentry.github.io/shell-novice/02-filedir/index.html)
  * questions?
  * volunteer: relative vs absolute path

- in class:
  [working with files and directories](http://swcarpentry.github.io/shell-novice/03-create/index.html)
  * do things on your own laptop. watching ≢ practice. interrupt, ask TA

summary:

- directory structure, root is `/`
- relative versus absolute paths
  * in your code and projects: use **relative** paths as much as
    possible: it makes your code more portable, for others, and
    for yourself if you re-locate your own project folder
- shortcuts: `.`, `..`, `~`, `-`
  * `cd -` is so useful!
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
| `touch`  | create blank file, or modify time stamp of existing file |
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

## file names

so important: **no spaces!** example:

- create a directory 'raw sequences' in `data`, using a GUI (e.g. Finder)
- try to remove it from the command line:

```
cd data
ls
rm -rf raw sequences
```
lucky for us: `raw` or `sequences` didn't exist (chainsaw...)  
how can we remove this directory?

- prefer lower-case letters, especially for the first letter of a file name:
  time saver, along with tab completion

- common usage: capitalize between words, or underscores, or `-`, like
  `wheatSequenceAlignments` (camel case style) or
  `wheat_sequence_alignments` (snake case style).

- use ASCII characters only, no space (did I mention this already?),
  no `/`, no `\` (for Windows), no `-` for the first character.

- R users: avoid dots. conventionally used for the file extension.

Great [presentation](https://speakerdeck.com/jennybc/how-to-name-files) by
Jenny Bryan

- choose file names to ease automation, using shell expansion

- use leading zeros: `file-0021.txt` rather than `file-21.txt`.
  lexicographic sorting files (like with `ls`) would otherwise place
  `file-1390.txt` before `file-21.txt`.

- file extensions:
   * not needed by the computer. for humans only.
   * explicit is better than implicit for humans.
     ex: `rice_genes.fasta` versus `rice_genes`
   * used by the computer occasionally: to pick the 'default'
     app to open a file (e.g. `open xxx.pdf` or `xdg-open xxx.pdf`);
     to color parts of text by a text editor; etc.

## typing skills

- quick count: who had keyboarding classes in elementary school?
- it's like talking or walking: it's assumed.
- take a [test](http://www.typingtest.com/test.html)
- invest in your typing skills! it will save you time and stress.  
  allow yourself one week to be slow.

---
[previous](notes0906-intro-shell.html) &
[next](notes0915.html)
