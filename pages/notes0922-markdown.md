---
layout: page
title: project management & markdown format
description: notes, markdown, project organization
---
[previous](notes0922.html) &
[next](notes0927.html)

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
  empty `readme.md` files (`touch`)
- all files in a project: live in a single directory, with a **clear name**
  (don't scatter your files)
- separate directories for:
   * data
   * scripts
   * binaries (of other people's programs that you used)
   * results, or analysis
   * figures
   * manuscript
   * or even: subprojects, each with its own script & analysis directories
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

[example](https://osf.io/g4me6/) with different structure, because
many different subsets of analyses: `readme` file(s) are extremely important

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
- typically one `readme.md` file per directory.
  Explain what the directory contains, where from & when, how it got there.

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

example [readme](https://github.com/crsl4/PhyloNetworks.jl/blob/master/README.md):
click 'Raw' to see what the file truly contains (text only, no beautification)

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

to force a newline, end your line with 2 spaces

    example:  
    try to select this text
    with your mouse, to see
    where markdown would go
    to a newline.

### rendering a markdown file to other formats

Many online viewers will render markdown automatically, like
github, box, dropbox, osf. In VS Code, click on the "preview" icon.  
We can also create new files: pdf, html, etc.

```shell
cd ~/Documents/private/st679/bds-files/chapter-02-bioinformatics-projects
less notebook.md
pandoc notebook.md
pandoc notebook.md > notebook.html
open notebook.html # xdg-open on Linux
pandoc -o notebook.html notebook.md
pandoc -o notebook.pdf notebook.md
open notebook.pdf
pandoc -o notebook.tex notebook.md
less notebook.tex
```

---
[previous](notes0922.html) &
[next](notes0927.html)
