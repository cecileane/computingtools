---
layout: page
title: 9/20 notes
description: notes, links, example code, exercises
---

[previous](notes0915.html) & [next](notes0922.html)

---

## homework

- for Thursday:
  * edit your readme files for exercise 1,
  to add metadata and documentation
  * finish the section on [Loops](http://swcarpentry.github.io/shell-novice/05-loop/):
  exercices (in orange)
  * do the exercise to [practice grep](notes0922.html#more-practice-with-grep)
- for Tuesday next week: do exercise 2 of [homework 1](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw1-snaqTimeTests)  
  document your new work in your readme file, save your work

## the shell

We finished "Loops" (except for exercises) from the
[software carpentry introduction](http://swcarpentry.github.io/shell-novice/).  
We skipped the section on "Shell Scripts" because we will cover this
topic differently (to write safe scripts) later.
We started finding things with "grep" and regular expressions.
We will continue with "find" next. see [summary](notes0922.html#finding-things).

Summary of [commands](notes0908.html) and of [wild cards](notes0915.html).


## more on redirection

```shell
ls -d * unknownfile
```
What is this command doing?  
It gives both: some output and some error.
Let's try to capture the output and the error separately.

```shell
ls -d * unknownfile > outfile
cat outfile
rm outfile
ls -d * unknownfile 2> errfile
cat errfile
rm errfile
ls -d * unknownfile > outfile 2> errfile
cat outfile
cat errfile
rm outfile errfile
ls -d * unknownfile &> outerrfile
cat outerrfile
rm outerrfile
```

What would `2>>` do?

each open file has a "file descriptor"

- standard input: 0, standard output: 1, standard error: 2
- `>` does the same as `1>`

How could `tail -f` (f=follow) be useful to check status
of a program that takes very long to finish? example (see
[here](https://github.com/UWMadison-computingtools/coursedata/tree/master/example-mrbayes)
to reproduce it):

```shell
cd ~/Documents/private/st679/coursedata/ex-mrbayes
mb mrBayes-run.nex
```

What if a program generates a whole lot of "standard output"
to the screen, which we are not interested in?
(interesting output might go to a file)? We can redirect the
screen output (STDOUT) to a "fake" disk `/dev/null` (black hole):

```shell
myprogram > /dev/null
```

## processes

let's repeat this "long" analysis:

```shell
cd ~/Documents/private/st679/coursedata/ex-mrbayes
mb mrBayes-run.nex
```

how to pause/restart/monitor/kill processes:

- **Control-Z** to pause a job (zzz... sleep, or suspend)
- `fg` to resume in the foreground; `bg` to resume, but in the background

- **Control-C** to cancel the job

- `jobs` to see the list of jobs
- `&` added at the end of a command to run it in the *background*,
  and get the shell back to do other things
- `ps` to see the list of current processes PID = process ID
- `kill` to send a signal to a process: like to kill it
  (signal 9). `man kill` to see other signals.
  `kill -9 12167` to kill process # 12167.
- `top` to see all processes, refreshed, shows CPU and memory consumption.

warning: closing the terminal kills the processes started from that terminal:
sends a *hangup* signal to its child processes before closing.
We will see `tmux` later to avoid this.

- unrelated: **Control-D** to say "done": end of standard input.
  Explain what happens when you type this:

```shell
grep "on"
oh my, what is going on?
how to stop this?
^D
```
- unrelated again: **Control-A** to go to beginning of the line,
  and **Control-E** to the end.

## less and man

- `man ls` to get help on `ls`
- other very standard option: `--help`
- the result of `man` is actually passed on to the "viewer" `less`
- try `more` on a long file: shows more and more, one page at a time
- `less` is similar, but much better. Name from "less is more".
  Power of text streams: can read very long files without having
  to load the whole thing in memory.

some commands for `less` (there are many more!):

|       |    |
|:------|:---|
| q     | quit             |
| enter | show next line   |
| space | show next "page" |
| d     | down next half-page |
| b     | back one page |
| y     | back (yp?) one line |
| g or < | go to first line. 4g or 4G: go to 4th line |
| G or > | Go to last line   |
| /pattern | search forward  |
| ?pattern | search backward |
| n        | next: repeat previous search |
|----------|------------|
|         |   |
{: rules="groups"}

- use these commands for `less` to search a manual page and
  navigate fast between the top, bottom, marked positions,
  and searched keywords: `man less`
- how to search for anything that does *not* match a pattern?

---
[previous](notes0915.html) & [next](notes0922.html)
