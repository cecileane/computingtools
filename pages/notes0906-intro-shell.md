---
layout: page
title: introduction to the Unix shell
description: notes, links, example code and exercises
---
[previous](notes0906-bestpractices.html) & [next](notes0908.html)

---

GUI (graphical user interface): easy but not reproducible.  
CLI (command line interface) or REPL (read-evaluate-print loop):
steep learning curve but reproducible and powerful.  
The shell is an incredibly powerful tool:

* Gary Bernhardt:
 [Unix is like a chainsaw](http://confreaks.tv/videos/cascadiaruby2011-the-unix-chainsaw).
 Can kill trees, and people.
 The Unix shell can do great things, but power comes with danger: it's unsafe!
* [example](https://github.com/UWMadison-computingtools-master/lecture-examples/tree/master/rm-example):

```shell
$ rm -rf tmp-data/aligned-reads*
```

deletes all large alignment files `aligned-reads_1` to `aligned-reads_1000`
in old temporary directory `tmp-data`.

`rm` is to remove files & directories  
`-r` will do it recursively (enter each directory within each directory)  
`-f` will "force" removal without asking you confirmation for each individual file  
`*` in the shell will match anything

with unintended extra space:

```shell
$ rm -rf tmp-data/aligned-reads *
rm: tmp-data/aligned-reads: No such file or directory
```

deletes your entire current directory (ouch!)

Later in the semester, watch the shell script example from Gary Bernhardt's
[talk](https://www.youtube.com/watch?v=ZQnyApKysg4&feature=youtu.be&t=981)
at 16:21-18:40 : you should understand exactly how it does what it does.

### modularity

    This is the Unix philosophy: Write programs that do one thing and do it well.
    Write programs to work together. Write programs to handle text streams,
    because that is a universal interface.
    —- Doug McIlory

* modularity
* pipes: STDIN --> myprogram --> STDOUT

Advantages to modularity:

* easier to spot errors, and fix them
* experiments with alternative choices at one step in the pipeline
* choose appropriate tool for each step, e.g. C++ -> Python -> R
* modules possible reusable for other tasks later on

### text streams

to process a stream of data rather than holding it all in memory.

Example: concatenate two data files.
Open both in editor, copy one and paste into the other?

* may not have enough memory
* manual operation: error-prone and not reproducible.

Instead: print the files's content to *standard output* stream and
redirect this stream from our terminal to the file we wish to save the combined results to.

```
cd bds-files/chapter-03-remedial-unix/
cat tb1-protein.fasta
cat tga1-protein.fasta
cat tb1-protein.fasta tga1-protein.fasta
cat tb1-protein.fasta tga1-protein.fasta > zea-proteins.fasta
ls -lrt
```
`-l`: in list format  
`-r`: in reverse order  
`-t`: ordered by time

Streams process data without storing huge amounts in our computers' memory: very efficient


---
[previous](notes0906-bestpractices.html) & [next](notes0908.html)
