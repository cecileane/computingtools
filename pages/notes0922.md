---
layout: page
title: 9/22 notes
description: notes, links, example code, exercises
---

[previous](notes0920.html) & [next](notes0927.html)

---

## homework

- did you do the exercises to [practice grep](#more-practice-with-grep)?
- for Tuesday next week: do exercise 2 of [homework 1](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw1-snaqTimeTests)  
  document your new work in your readme file, save your work
- finish the exercises from the "finding things"
  [software carpentry](http://swcarpentry.github.io/shell-novice/07-find/)
  section, except for "tracking a species" (we need to learn more about
  shell scripts for this).

---

We did the
[sorftware carpentry](http://swcarpentry.github.io/shell-novice/07-find/)
section on finding things, except for the exercises (to do at home).

Note about no quotes, double quotes and single quotes,
to control how much the shell should expand/interpret:

```shell
$ echo *.txt
haiku.txt
$ echo "*.txt"
*.txt
$ echo "*.txt and this is my shell: $SHELL"
*.txt and this is my shell: /bin/bash
$ echo '*.txt and this is my shell: $SHELL'
*.txt and this is my shell: $SHELL
```

## finding things

- `find` to find files: whose names match simple patterns

- `grep` to find things in (text) files:
   select lines that match simple patterns

- do a **command substitution** with `$()` to pass the list of files found
  to another command, like `grep` or `wc`: `grep xxx $(find yyy)`

examples:

```shell
grep "and" filename
echo "orchestra and band" | grep "and" # to search a string, not a file
grep -w "and" *
find . -type d
```

examples using a pipe and `xargs` instead of command substitution:
(try from the "writing" directory in software carpentry data folder)

```shell
wc -l $(find . -name '*.txt')
find . -name '*.txt' | xargs wc -l # xargs runs "wc -l xxx" where xxx = input (from find) as arguments to wc
find . -name '*.txt' | xargs -n 1 wc -l # to analyze each file with wc one at a time, parallelized
```

Some options for `grep`:  
`-n` for line numbers  
`-i` for case-insensitive search  
`-w` for whole words  
`-v` to in**v**ert the search  
`-o` to get the match only  
`-E` to use Extended (not basic) regular expressions,
`-P` for Perl-like regular expressions (GNU only)

exercise: find the option to get the matched pattern to be colorized.

Some options for `find`:  
`-type` with `d` or `f` for directory / file  
`-name` with a regular expression (say `'*.pdf'`)  
`-d` for depth (e.g. `-d 1` or `-d +1` or `-d -1`)  
`-mtime` for modified time

### GNU vs BSD command-line tools

Mac users: you have BSD tools (do `man grep` for instance, or `grep --version`).
They differ slightly from the GNU tools, which are generally better.
Install the GNU tools with [homebrew](http://brew.sh):

```shell
brew install coreutils # basic tools like ls, cat etc.
brew tap homebrew/dupes
brew install grep      # to get GNU grep, not included in basic tools
brew install gnu-sed   # to get GNU sed, also not included in basic
```

then use `gcat` instead of `cat`, `ggrep` instead of `grep` etc.

<!--
`brew --prefix coreutils` showed me `/usr/local/opt/coreutils`
in which there was `bin/` with all the "g" tools. I then checked to see if
this directory was in my PATH variable: `echo $PATH`. It wasn't. but gcat and gecho worked.
ggrep and gsed were not there.
-->

## regular expressions: "regexp"

We need lots of practice on this!
For help: `man re_format`,
get an explanation of your expression (and debug it)
on [regexp101](https://regex101.com) or [debuggex](https://www.debuggex.com)

<!-- http://v4.software-carpentry.org -->

|    |    |
|:---|:---|
|`.` | any one character |
|`^` | beginning of line (only if placed first)|
|`$` | end of line (only if placed last)|
|`\` | turns off special meaning of next symbol |
|`[aBc]` | anything in: a or B or c. Ranges: like `[0-9]`, `[a-z]`, `[a-zA-Z]` |
|`[^aBc]`| anything but: a, B, c |
|`\w` | any word character: letter, number, or "_". also `[[:alnum:]_]`. opposite: `\W`|
|`\d` | any single digit. also `[[:digit:]]` or `[0-9]`. opposite: `\D` |
|`\s` | any white space character: single space, `\t` (tab), `\n` (life feed) or `\r` (carriage return). also `[[:space:]]`. opposite: `\S` |
|`\b` | word boundary (null string). also `\<` and `\>` for start/end boundaries. opposite: `\B` |
|`+` | one or more of the previous |
|`?` | zero or one of the previous |
|`*` | zero or more of the previous |
|`{4}`| 4 of the previous |
|`{4,6}`| between 4 and 6 of the previous |
|`{4,}`| 4 or more of the previous |
|--------|------------|
|        |            |
{: rules="groups"}


<!-- from Bioinformatics Data Skills, Chapter 2 (ideas) and
     Chapter 6 (example) -->

### more practice with grep

Use `grep` to find whether and where the file below has
non-nucleotide characters.

To download the [data](https://github.com/vsbuffalo/bds-files),
navigate to where you want it on your machine, then run
`git clone git@github.com:vsbuffalo/bds-files.git`.

```shell
$ cd bds-files/chapter-03-remedial-unix/
$ cat tb1.fasta
>gi|385663969|gb|JQ900508.1| Zea mays subsp. mexicana isolate IS9 teosinte branched 1 (tb1) gene, complete cds
GCCAGGACCTAGAGAGGGGAGCGTGGAGAGGGCATCAGGGGGCCTTGGAGTCCCATCAGTAAAGCACATG
TTTCCTTTCTGTGATTCCTCAAGCCCCATGGACTTACCGCTTTACCAACAACTGCAGCTAAGCCCGTCTT
CCCCAAAGACGGACCAATCCAGCAGCTTCTACTGCTAYCCATGCTCCCCTCCCTTCGCCGCCGCCGACGC
CAGCTTTCCCCTCAGCTACCAGATCGGTAGTGCCGCGGCCGCCGACGCCACCCCTCCACAAGCCGTGATC
AACTCGCCGGACCTGCCGGTGCAGGCGCTGATGGACCACGCGCCGGCGCCGGCTACGGCTACAGAGCTGG
GCGCCTGCGCCAGTGGTGCAGAAGGATCCGGCGCCAGCCTCGACAGGGCGGCTGCCGCGGCGAGGAAAGA
CCGGCACAGCAAGATATGCACCGCCGGCGGGATGAGGGACCGCCGGATGCGGCTCTCCCTTGACGTCGCG
CGCAAATTCTTCGCGCTGCAGGACATGCTTGGCTTCGACAAGGCAAGCAAGACGGTACAGTGGCTCCTCA
ACACGTCCAAGTCCGCCATCCAGGAGATCATGGCCGACGACGCGTCTTCGGAGTGCGTGGAGGACGGCTC
CAGCAGCCTCTCCGTCGACGGCAAGCACAACCCGGCAGAGCAGCTGGGAGGAGGAGGAGATCAGAAGCCC
AAGGGTAATTGCCGCGGCGAGGGGAAGAAGCCGGCCAAGGCAAGTAAGGCGGCGGCCACCCCGAAGCCGC
CAAGAAAATCGGCCAATAACGCACACCAGGTCCCCGACAAGGAGACGAGGGCGAAAGCGAGGGAGAGGGC
GAGGGAGCGGACCAAGGAGAAGCACCGGATGCGCTGGGTAAAGCTTGCTTCAGCAATTGACGTGGAGGCG
GCGGCTGCCTCGGGGCCGAGCGACAGGCCGAGCTCGAACAATTTGAGCCACCACTCATCGTTGTCCATGA
ACATGCCGTGTGCTGCCGCTGAATTGGAGGAGAGGGAGAGGTGTTCATCAGCTCTCAGCAATAGATCAGC
AGGTAGGATGCAAGAAATCACAGGGGCGAGCGACGTGGTCCTGGGCTTTGGCAACGGAGGAGGAGGATAC
GGCGACGGCGGCGGCAACTACTACTGCCAAGAGCAATGGGAACTCGGTGGAGTCGTCTTTCAGCAGAACT
CACGCTTCTACTGAACACTACGGGCGCACTAGGTACTAGAACTACTCTTTCGACTTACATCTATCTCCTT
TCCCTCAACGTGAGCTTCTCAATAATTTGCTGTCTTAATCTATGCGTGTGTTTCTCTTTCTAGACTTCGT
AATTGGCTGTGTGACGATGAACTAAGTTTGGTCATCGCATGATGATGTATTATAGCTAGCTAGCATGCAC
TGTGGCGTTGATTCAATAATGGAATTAATCGGTGTCGTCGATTTGGTGATTTCCGAACTGAATCTCTGTG
ATGAACGAGATCAAACAGTATCCGCCGGTGACGGACGTTCATTACTATTGGCAAGCAAAGCAAGTACTAA
TGTAATTCAGCTGTTTGATGACAGAATGAAAAAAATGTTGAAGGCTGAAGCTATAACATGCTGAAAGAGA
GGCTTTTGCTAGGTAAAAGTCTAGCTCACAAGGTCAATTCCATGATGCCGTTTGTATGCATGTTAAAATC
TGCACCTAATGGCGCGGCTTTATATAGTCTTATAATTCATGGATCAAACATGCCGATC
```
Hint: first exclude non-nucleotide lines, then (pipe) find lines with
anything other than A, C, G or T (and other than a, c, g, t).

<!--
```shell
grep -v "^>" tb1.fasta | grep --color -i "[^ATCG]"
```
Y is for pYrimidine bases: C or T.
-->

beginning/end of lines, and escaping special characters:
try these below.

```shell
echo abc a g ef$ g
echo abc a g ef$ g | grep --color 'a'    # 2 matches
echo abc a g ef$ g | grep --color '^a'   # 1 match only: first one
echo abc a g ef$ g | grep --color 'g'    # 2 matches
echo abc a g ef$ g | grep --color 'g$'   # 1 match
echo abc a g ef$ g | grep --color 'f$'   # no match
echo abc a g ef$ g | grep --color 'f\$'  # match. mind the single quotes.
echo ^abc a g ef$ g | grep --color '$ '  # match
echo ^abc a g ef$ g | grep --color '^a'  # no match
echo ^abc a g ef$ g | grep --color '\^a' # match
echo ^abc a g ef$ g | grep --color '^^a' # match
```

What would `grep '^$' filename` do?  
How to match lines with white spaces only?

dot, words, digits:

```shell
cd ../../coursedata/hw1-snaqTimeTests
cat out/timetest9_snaq.out
grep "Elapsed time" out/timetest9_snaq.out #  Elapsed time: 34831.465925074 seconds in 10 successful runs
grep "Elapsed time." -o out/timetest9_snaq.out # . matches any one character
grep "Elapsed time. \d+" -o out/timetest9_snaq.out # no match: need Extended regexp
grep -E "Elapsed time. \d+" -o out/timetest9_snaq.out # \d = digit, +: one or more
grep -E "Elapsed time. \d+\.\d" -o out/timetest9_snaq.out # need to escape the dot to match "."
```

## Set up and manage an analysis project

- well organized
- well documented

key to

- collaborate with yourself in 6 months
- re-run some analyses or run some new analyses
  in 6 months because the reviewers ask to
- collaborate with others
- communicate with your advisor
- detect errors

### directory structure

- at the onset: create a few directories (`mkdir`) and
  empty `readme` files (`touch`)
- all files in a project: live in a single directory, with a **clear name**
  (don't scatter your files)
- separate directories for:
   * data
   * scripts
   * binaries (of other people's programs that you used)
   * results, or analysis
   * figures
   * manuscript
   * or even: subprojects, with its own script & analysis directories
- `data`: all in the same directory, or separate directory `data_clean`
  for intermediate data, or subdirectories `data/original` and `data/clean`.
  Never edit raw data. Use a script to clean the original data file,
  then save the resulting clean data.
- `results` or `analysis`: if the pipeline is complex, use different directories
  for different kinds of results (intermediate, or different analyses),
  or subdirectories
- `scripts`: if there are many, organize them in subdirectories.  
- use *relative paths* in scripts: you can move your entire directory somewhere
  else (e.g. on your collaborator's laptop) and things will still work.
- short scripts to double-check quality, make a quick figure, etc: may be in
  `results`.
- `figures`: not everybody will agree. Can make your life easier to
  modify a figure for a publication (if asked by reviewers) or for a
  presentation 6 months later.

recall advice on [file names](notes0908#file-names)

example: SNP calling in corn (*Zea mays*)

```shell
cd ~/Documents/private/st679
mkdir zmays-snps
cd zmays-snps
mkdir data
mkdir data/seqs scripts analysis
ls -l
```

### project documentation

document:

- data provenance (metadata): who sent which file, when, how?
  downloaded from where, when, how (e.g. MySQL vs UCSC Genome Browser)?
- binaries (programs, R packages): url, version, date installed
  (version for R, for R studio, for R packages)
- methods and workflows: **everything** that would be needed if you had
  to re-run the whole thing. Copy-paste full command lines to re-generate
  clean data files, intermediate files & results.

how:

- use **plain text readme** files. Can easily be
   * read, searched, edited from command lines (good if working on remote server)
   * portable, light
   * text files written in 1960s: still readable.  
     files from 15-year-old word processor: might be difficult to open or edit.
- Microsoft Word is **not** good for analysis project documentation
- at least one `readme` file per directory.
  Explain what is is the directory, where from & when, how it got there.

```shell
touch readme.md data/readme
```

`touch` updates the modification time of a file or
creates a file if it doesn’t already exist.

use *brace expansion* to create a directory structure in one step:

```shell
echo dog-{gone,bowl,bark}
mkdir -p zmays-snps/{data/seqs,scripts,analysis}
```

let's create some empty files to illustrate more uses of wildcards.
supposedly from 3 corn samples: A, B and C, and 2 files for each because
paired-end sequencing data: read pair R1 or R2.

```shell
cd data
touch seqs/zmays{A,B,C}_R{1,2}.fastq
ls seqs/
ls seqs/zmaysB*
ls zmays[AB]_R1.fastq
ls zmays[A-B]_R1.fastq
ls zmaysA_R{1..2}.fastq
ls -lR
```

## markdown for project notebooks

light-weight markup format. plain text, extension `.md`.
Many "dialects" e.g. R markdown `.Rmd`.
Original markdown [reference](http://daringfireball.net/projects/markdown/syntax).

interlude: advantage of plain text files for reports and data:
[Excel errors](http://www.economist.com/blogs/graphicdetail/2016/09/daily-chart-3)

- easy to read the plain text format
- easy to track changes
- easy to render as pdf, html, etc. GitHub and Dropbox do it automatically.

basic syntax:

| markdown syntax | result |
|:---|:---|
|\*emphasis\*| *emphasis* |
|\*\*bold\*\*  | **bold** |
|\`inline code\` | `inline code`|
|\<http://website.com/link\> | <http://website.com/link>|
|\[link text\]\(http://website.com/link\)|[link text](http:// website.com/link)|
|!\[text\]\(path/to/image.png\) | ![text](path/to/image.png) image with alternative text "text"|
| # chapter 1   | level-1 header |
| ## section 1.1 | level-2 header |
| ### paragraph 1.1.1 | level-3 header |
|--------|------------|
|        |            |
{: rules="groups"}

level-1 and level-2 headers can also be obtained like this:

    chapter 1
    =========

    section 1.1
    ----------

numbered or bulleted lists:

    * first point, itemized
    - second point
      2. indentation is necessary
      2. nested list
      1. numbers can be messed up, see how it's rendered below

which gives this:

* first point, itemized
- second point
  1. indentation is necessary
  2. nested list
  1. only the first number is used, see how it's rendered below

to get code blocks, indent with 4 spaces (or 8 spaces if within a list):

&nbsp;&nbsp;&nbsp;&nbsp;this will be a block.  
&nbsp;&nbsp;&nbsp;&nbsp;can be used for quotes as well.

or use 3 backticks, possibly followed by the language name:

\`\`\`r  
foo <- function(x){x+1} # R function "foo", just adds 1  
foo(2)  
\`\`\`

which gives this:

```r
foo <- function(x){x+1} # R function "foo", just adds 1
foo(2)
```

This other code block:

\`\`\`julia  
function foo(x) # Julia function "foo", just adds 1  
&nbsp;&nbsp;&nbsp;&nbsp;x+1  
end  
foo(2)  
\`\`\`

gives this:

```julia
function foo(x) # Julia function "foo", just adds 1
    x+1
end
foo(2)
```

With ```` ``` ```` instead of ```` ```julia ```` at the beginning,
the code block would be rendered without color highlights.

### rendering a markdown file to other formats

```shell
cd ~/Documents/private/st679/bds-files/chapter-02-bioinformatics-projects
less notebook.md
pandoc notebook.md
pandoc notebook.md > notebook.html
pandoc -o notebook.html notebook.md
pandoc -o notebook.pdf notebook.md
pandoc -o notebook.tex notebook.md
```

---
[previous](notes0920.html) & [next](notes0927.html)
