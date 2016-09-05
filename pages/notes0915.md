---
layout: page
title: 9/15 notes
description: notes, links, example code, exercises
---
[previous](notes0913.html) & [next](notes0920.html)

---

## logistics & homework

- room change: 133 [SMI](http://map.wisc.edu/s/dc3243ls)

- set up your homework/project folder as a git repository:
  [instructions](https://github.com/UWMadison-computingtools/coursedata)
- do exercise 1 of [homework 1](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw1-snaqTimeTests)  
  instructions to submit your work will follow later (after we learn about git)
- finish the [pipes & filters](http://swcarpentry.github.io/shell-novice/04-pipefilter/)
  section from the software carpentry intro  
  bring any question to Tuesdays' class

## intro to the shell (con't)

We did "Pipes and Filters" (except exercises) and started "Loops" from the
[software carpentry introduction](http://swcarpentry.github.io/shell-novice/).
Summary of commands [here](notes0908.html).

- wild cards:
  - `*` matches zero or more characters (anything).
  - `?` matches exactly 1 characters

  the shell expands the wild cards *before* running the command.
- pipes and redirection:  
 `>` to redirect the output of one command to a file  
 `|` pipes the output of one command to the input of another command: pipeline!
  very fast: uses streams only.  
 `>>` redirects output and appends to a file  
 `2>` redirects standard error  
 `&>` redirects both output and error (bash shell)

## first shell scripting: using loops

- a variable named `xxx` is later used with `$xxx`
- use all commands seen before, including wild cards
- `echo` to print info during execution of the script
- `;` to separate the pieces
- save the script in a file, say `myscript.sh`,
  then execute it with `bash myscript.sh`.

```shell
for xxx in *
do
  echo will analyze this thing next: $xxx
  ls $xxx
done
```
or on one line:
`for xxx in *; do echo will analyze this thing next: $xxx; ls $xxx; done`

examples of ways to loop:  
`for i in {1..9}; ...` or `for extension in pdf log png; ...`

how to assign a variable:  
`file=out/timetest$i` or `file=out/timetest${i}` or `file="out/timetest${i}"`.


---
[previous](notes0913.html) & [next](notes0920.html)
