---
layout: page
title: searching with regular expressions, grep, find
description: notes, links, example code, exercises
---

[previous](notes0915.html) & [next](notes0922-markdown.html)

---

on the
[software carpentry](http://swcarpentry.github.io/shell-novice/07-find/)
do the "finding things" section, except for "tracking a species"
(we will come back to shell scripts and more shell tools later).

---

## quotes with shell commands

Note about no quotes, double quotes and single quotes,
to control how much the shell should expand/interpret:

```bash
$ cd softwarecarpentry-data-shell/writing/
$ echo *.txt
haiku.txt
$ echo "*.txt"
*.txt
$ echo "*.txt and this is my shell: $SHELL"
*.txt and this is my shell: /bin/bash
$ echo '*.txt and this is my shell: $SHELL'
*.txt and this is my shell: $SHELL
```

This distinction between `"` and `'` is used in
other programming languages (e.g. Julia).

## finding things

- `find` to find files: whose names match simple patterns

- `grep` to find things in (text) files:
   select lines that match simple patterns

- do a **command substitution** with `$()` to pass the list of files found
  to another command, like `grep` or `wc`: `grep xxx $(find yyy)`

examples, from the "writing" directory in the
software carpentry data folder:

```shell
grep "and" haiku.txt                   # to search within a file
echo "orchestra and band" | grep "and" # to search within a string, not a file
grep -w "and" *
find . -type d
find data -name "*e*.txt"
```

Some options for `grep`:  
`-n` for line numbers  
`-i` for case-insensitive search  
`-w` for word (surrounded by word "boundaries" like spaces)  
`-v` to in**v**ert the search  
`-o` to get the match only  
`-E` to use Extended (not basic) regular expressions,
`-P` for Perl-like regular expressions (GNU only)

exercise: find the option to get the matched pattern to be colorized.

Some options for `find`:  
`-type` with `d` or `f` for directory / file  
`-name` with a shell pattern (say `'*.pdf'`)  
`-d` for depth (e.g. `-d 1` or `-d +1` or `-d -1`)  
`-mtime` for modified time

### argument versus input content: xargs

after pipe: to tell that the standard output of the first command
should serve as argument(s) to the next command, not as standard input

examples using a pipe and `xargs`
(try from the "writing" directory in the software carpentry data folder)

```shell
ls *.txt       # shows haiku.txt
ls *.txt | cat # shows haiku.txt instead of showing the content of haiku.txt
ls *.txt | xargs cat # show the content of the file instead of the filename
find . -name '*.txt' | wc -l # does not work: indicates 4 lines
find . -name '*.txt' | xargs wc -l # xargs runs "wc -l xxx" where xxx = input (from find) as arguments to wc
find . -name '*.txt' | xargs -n 1 wc -l # to analyze each file with wc one at a time, parallelized
wc -l $(find . -name '*.txt')
```

last line: command substitution `$()` instead of a pipe (and `xargs`)

### GNU vs BSD command-line tools

Mac users: you have BSD tools (do `man grep` for instance
and look at the title, to check, or do `grep --version`).
They differ slightly from the GNU tools, which are generally better.
Install the GNU tools with [homebrew](http://brew.sh):

```shell
brew install coreutils # basic tools like ls, cat, head, tail etc.
brew install grep      # to get GNU grep, not included in basic tools
brew install gnu-sed   # to get GNU sed, also not included in basic
```

then use `gcat` instead of `cat`, `ggrep` instead of `grep` etc.
type `ggrep --version` to check.

<!--
`brew update` first, if brew installed some time ago
`brew doctor` if coreutils didn't link: gives command to change owner of folders
in which brew wants to install core utilities

`brew --prefix coreutils` showed me `/usr/local/opt/coreutils`
in which there was `bin/` with all the "g" tools (like gls, gcat, gecho, ...).
ggrep and gsed were not there.

to use these commands with their normal names,
add a "gnubin" directory to your PATH from your bashrc like: PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

for grep:
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"

for sed:
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
-->

## regular expressions: "regexp"

We need lots of practice on this!
For help: `man re_format`,
get an explanation of your expression (and debug it)
on [regexp101](https://regex101.com) or
[debuggex](https://www.debuggex.com),  
and a nice [cheatsheet](https://www.keycdn.com/support/regex-cheatsheet)

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
|`\s` | any white space character: single space, `\t` (tab), `\n` (line feed) or `\r` (carriage return: see [below](#new-lines)). also `[[:space:]]`. opposite: `\S` |
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

To get more practice, we will use data from the
"Bioinformatics Data Skills" book by Vince Buffalo.
We will use these data for other purposes later in the course.
Firt navigate to a place where you want to store the data.
**Make sure you are not in any git repository**.
For this, type `git status`, and make sure you get
the following message:
```
$ git status
fatal: not a git repository (or any of the parent directories): .git
```
Then you can download the [data](https://github.com/vsbuffalo/bds-files)
extremely easily with git: just type
```shell
git clone git@github.com:vsbuffalo/bds-files.git
```

Exercise:
use `grep` to find whether and where the file `tb1.fasta`
(see below) has
non-nucleotide characters.
Nucleotides are ACGT or their lower-case versions, acgt.
The first line is a header.


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

Explanation of output: Y means pYrimidine: either C or T.
Y is used to denote uncertainty, here, about the exact base.

<!--
```shell
grep -v "^>" tb1.fasta | grep --color -i "[^ATCG]"
```

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
echo ^abc a g ef$ g | grep --color '\^a' # match. ^ had to be escaped to mean a real ^
echo ^abc a g ef$ g | grep --color '^^a' # match. No need to escape the second ^, because when it's not first, it cannot mean the start of the line!
```

What would `grep '^$' filename` do?  
How to match lines with white spaces only?

dot, words, digits:

```shell
cd classroom-repos/hw1/
cat out/timetest9_snaq.out
grep "Elapsed time" out/timetest9_snaq.out #  Elapsed time: 34831.465925074 seconds in 10 successful runs
grep -o "Elapsed time." out/timetest9_snaq.out # . matches any one character
grep -o "Elapsed time. \d+" out/timetest9_snaq.out # no match: need Extended regexp
grep -oE "Elapsed time. \d+" out/timetest9_snaq.out # \d = digit, +: one or more
grep -oE "Elapsed time. \d+\.\d" out/timetest9_snaq.out # need to escape the dot to match "."
```

- with GNU grep (Linux), replace option `E` by `P` above: `\d` is Perl syntax
- document your code: say which platform was used (GNU versus BSD)
- or avoid Perl-like patterns: e.g. avoid `\d` and use `[0-9]` instead.
  The following works with both GNU and BSD grep:

```bash
grep -oE "Elapsed time. [0-9]+\.[0-9]" out/timetest9_snaq.out
```

#### exercise

write a one-liner to count the number of
"Subsets" whose "Best Model" is GTR+G in this file:
[partitionfinder_bestscheme.txt](https://osf.io/z3pqm/)

<!-- (68 out of 95) -->

### more practice with find

find and delete annoying hidden files.  
example: Mac creates `.DS_Store` files and hides them very well,
but annoying with git.  
let's do it step by step, to see the process of building a safe one-liner:

```bash
find ~ -name ".DS_Store" # to see all files named ".DS_Store" in my home directory. Do ^C if there are too many.
find ~ -name ".DS_Store" | wc -l # just count how many
find ~ -name ".DS_Store" -d 2 | wc -l # depth 2 only
find ~ -name ".DS_Store" -d 2 # view them all if there is a small number of them
find ~ -name ".DS_Store" -d 2 | xargs rm # check that it works
find ~ -name ".DS_Store" | xargs rm # delete all of them (beyond depth 2)
find / -name ".DS_Store" | wc # more ambitious: starting from the root
sudo find / -name ".DS_Store" -d 2 | wc # need super-user permission to list files near the root
sudo find / -name ".DS_Store" | xargs rm
```

above: fails on files that contain spaces...  
alternative that works if file / directory names contain spaces:
use the `-exec` option of `find` to execute a command on each file that was found

```bash
sudo find / -name ".DS_Store" -exec rm {} \;
```

### new lines

Windows: `\r\n` also denoted as CR-LF or CRLF (carriage return - line feed).  
Mac and Linux: `\n` only, or LF.

**Use an editor that shows you the type of line endings!!**
So many weird errors are caused by line endings.
These errors tend to be incomprehensible cryptic errors that make no sense,
because line endinds are typically invisible. We don't "see" what's going on.
But text editors can tell you. In VSCode: near the bottom right corner.

```julia
ngenes=15
for i in 1:ngenes
  sleep(0.5) # as if we did something complicated for the data from gene i
  result = rand()
  print("summary for ",i,": $result\n")   # \n = new line on Mac or Linux systems
  # println("summary for ",i,": $result") # println alternative: adapts to operating system
end
# same, but screen won't be cluttered
for i in 1:ngenes
  sleep(0.5) # as if we did something complicated for the data from gene i
  result = rand()
  print("summary for ",i,": $result\r") # \r to "return carriage" only: re-write on same line
end
```

---
[previous](notes0915.html) & [next](notes0922-markdown.html)
