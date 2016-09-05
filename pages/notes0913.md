---
layout: page
title: 9/13 notes
description: notes, links, example code, exercises
---
[previous](notes0908.html) & [next](notes0915.html)

---

## logistics

- email me if you want to be added to the course mailing list
  (auditors)
- starting next Thursday (9/15), we will meet in
  133 [SMI](http://map.wisc.edu/s/dc3243ls), in which it's easier to move
  chairs & tables arounds, and tables are larger.
- do things on your own laptop: watching the screen is insufficient
  to get good at this

## homework

- create a [github](https://github.com) account: done?
  [This](http://happygitwithr.com/github-acct.html) is a great resource.

- request a "student developer pack" [here](https://education.github.com/pack),
  which includes unlimited free repositories on github.

  Click on "get your pack", then follow instructions.
  To the question "How do you plan to use "GitHub", you can say
  "for research" (my hope is that you will continue to use github for
  analyses in your dissertation), or "for learning computational tools",
  or some other appropriate description.

- email me your github username, so that I can add you to the
  github organization for the course:
  [UWMadison-computingtools](https://github.com/UWMadison-computingtools)

- [set-up git](git.html) and download the homework data

- finish the section "Working with Files and Directories" that we covered today.

## intro to the shell (con't)

We went over "Working with Files and Directories" from the
[software carpentry introduction](http://swcarpentry.github.io/shell-novice/).
Summary of commands [here](notes0908.html).

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

- some common usage: capitalize between words, or underscore, like
  `wheatSequenceAlignments` or `wheat_sequence_alignments`.

- use ASCII characters only, no space (did I mention this already?),
  no `/`, no `\` (for Windows), no `-` for the first character.

- R users: avoid dots. conventionally used for the file extension.

- file extensions:
   * not needed by the computer. for humans only.
     your computer uses `.txt` to open the file with whichever app is supposed
     to open text files. That's it.
   * explicit is better than implicit for humans.
     ex: `rice_genes.fasta` versus `rice_genes`

- choose file names to ease automation, using shell expansion

- use leading zeros: `file-0021.txt` rather than `file-21.txt`.
  lexicographic sorting files (like with `ls`) would otherwise place
  `file-1390.txt` before `file-21.txt`.

## text editor

- see [here](notes0906.html#text-editor)

## typing skills

- quick count: who had keyboarding classes in elementary school?
- it's like talking or walking: it's assumed.
- take a [test](http://www.typingtest.com/test.html)
- invest in your typing skills! it will save you time and stress.  
  allow yourself one week to be slow.

---
[previous](notes0908.html) & [next](notes0915.html)
