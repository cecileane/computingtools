---
layout: page
title: awk, parameter expansion, wget & curl
description: course notes
---
[previous](notes1011.html) &
[next](notes1018.html)

---
- [awk](#quick-text-processing-awk)
- [parameter expansion](#parameter-expansion)
- [wget](#getting-data-from-the-web-wget-and-curl) and [curl](#curl)

## quick text processing: awk

language for quick text-processing tasks on tabular data.
by Aho, Weinberger & Kernighan.  
`bioawk`: for biological formats.

- command lines: `awk pattern { action } filename`
- pattern: expression or regexp pattern (in slashes, e.g. `/^chr\d/`).  
  If true or match for a given line (record): the actions are run.  
  If no stated action: the line is printed.
- `a ~ b` true if `a` matches regexp pattern `b`. no match: `a !~ b`
- combine patterns with `&&` (and) and `||` (or)
- special patterns: BEGIN and END
- variables: `$0` for entire record (line),
  `$1` for first field (columns)'s value,
  `$2` for second field's value, etc.  
  `NR` = current record (line) number  
  `NF` = number of fields (columns) on current line
- can do arithmetic operations on field values, standard comparisons (`<=`, `==` etc.)
- extra fields can be printed
- new variables can be introduced, modified, used
  (no `$` to use them: not like shell language)
- actions: `if`, `for`, `while` statements can be used
- many built-in functions, like `exit`, `sub(regexp, replacement, string)`
  `substr(string, i, j)` or `split(string, array, delimiter)`
- default field (column) separator in input file: tab.
  For csv file: change to comma with `-F","`

examples:

```shell
awk '{ print $0 }' example.bed # like cat. No pattern: defaults to true
awk '{ print $2 "\t" $3 }' example.bed # like cut -f2,3
awk '$3 - $2 > 18' example.bed # prints lines (default action) if feature length > 18 (bed 0-based)
threshold=18
awk '$3 - $2 > $threshold' example.bed        # error: $ reserved for awk fields
awk -v t=$threshold '$3 - $2 > t' example.bed # -v option: to define awk variables
awk '$1 ~ /chr1/ && $3 - $2 > 10' example.bed
awk '$1 ~ /chr2|chr3/ { print $0 "\t" $3 - $2 }' example.bed
awk 'BEGIN{ s = 0 }; { s += ($3-$2) }; END{ print "mean: " s/NR };' example.bed # mean feature length
awk 'NR >= 3 && NR <= 5' example.bed # lines 3 to 5 only
awk -F "\t" '{print NF; exit}' Mus_musculus.GRCm38.75_chr1.bed # number of columns on 1st line
grep -v "^#" Mus_musculus.GRCm38.75_chr1.gtf | awk -F "\t" '{print NF; exit}' # deals with header (start with #) in gtf file
awk '/Lypla1/ { feature[$3] += 1 };
    END { for (k in feature)
    print k "\t" feature[k] }' Mus_musculus.GRCm38.75_chr1.gtf  | column -t
```

last example above:

- two pattern-action pairs separated by `;`
- new variable `feature` introduced: associative array.
  like list but indexed by keys (dictionaries in Python & Julia, hashes in Perl)
- `for` loop, new variable `k` inside.

If we need multiple commands, they need to be
separated by `;`. Consider a file like this:

```bash
$ cat myfile
number1 = 1234 and number2 = 1324
number1 = 999 and number2 = 1324
```
awk can count how many times number1 < 1000,
and how many times number2 > number1:
```bash
awk '
  BEGIN{ count1 = 0; count2 = 0 };
  {
   if ($3 < 1000) count1++;
   diff = $7 - $3;
   if (diff > 0) count2++;
  }
  END{ print count1 "," count2 }' myfile
```

---

## parameter expansion

use `${variable_name extra stuff}`.

```shell
var="coolname.txt.pdf.md"
i=3678
echo "var=$var and i=$i"
echo "substrings of parameter values: ${i:1} and ${var:4:5}" # :offset:length
echo "strip from the end: ${var%.*}"  # strips shortest occurrence
echo "strip from the end: ${var%%.*}" # strips longest  occurrence
echo "strip from beginning: ${var#*.}"  # strips shortest occurrence
echo "strip from beginning: ${var##*.}" # strips longest  occurrence
echo "substitute: ${var/cool/hot}"
echo "delete:     ${var/cool}"
```

---

## getting data from the web: wget and curl

### `wget`

is not available by default on Mac.
get it using Homebrew: `brew install wget`.

Example goal:
get all maize domestication trait data on the "NCRPIS" maize lines,
from [maizegdb.org](https://www.maizegdb.org/download):
follow ["FTP-style" download](https://download.maizegdb.org/),
then folder
[Maize_Domestication_Traits](https://download.maizegdb.org/Maize_Domestication_Traits/).

```shell
mkdir zmays-traits; cd zmays-traits
wget https://download.maizegdb.org/Maize_Domestication_Traits/
ls       # new file "index.html", which gives link to data files
grep -Eo 'href="[^"]+\.csv"' index.html  # links to 6 .csv files
grep -Eo 'href="[^"]+\.txt"' index.html  #            .txt files
wget -r -l 1 -nd --accept-regex '\.NCRPIS.*\.txt' https://download.maizegdb.org/Maize_Domestication_Traits/
```

`wget` can download files recursively: `-r`, but dangerous (aggressive). put limits with options:

- `-l` to limit the level, or maximum depth: `-l 1` to go only 1 link away
- `--accept-regex` to limit what's accepted using a regular expression:
  here files whose names contain `.NCRPIS` and `.txt`.

`nd` or `--no-directory`: to not re-create the directory hierarchy  
lots of other options, like: `--no-parent`, `-O`, `--user`, `--ask-password`, `--limit-rate`

The host may block your IP address if you are downloading too much too fast.  
To avoid being blocked: use `--limit-rate=50k` or `-w 1` to wait 1 second between file downloads.

----

### `curl`

is much more common for "scraping the web" than `wget`
because it can use more protocols and more authentication methods.
It does not retrieve files recursively, but each individual file request
can be much more flexible and easier.

From searching the `index.html` page above, we can get the list of
files we are interested in:

```bash
$ grep -Eo 'href="[^"]+\.txt"' index.html | grep "\.NCRPIS"
href="File%20S2.NCRPIS%20BLUEs%20SL.txt"
href="File%20S3.NCRPIS%20BLUEs%20CL.txt"
href="File%20S4.NCRPIS%20BLUEs%20KRN.txt"
```

so we could write a loop to download all these files.
The first iteration might do this:

```bash
$ curl "https://download.maizegdb.org/Maize_Domestication_Traits/File%20S2.NCRPIS%20BLUEs%20SL.txt" > 20SL.txt
```

`curl`
- writes to standard output
- can use more protocols, like `sftp`
- can follows redirected pages with `--location`
- some options: `-O`, `-o`, `--limit-rate`  
`-I` or `--head`: to get header only. On ftp files: file size  
`-s`: silent, no progress meter, no error message
`-#`: simple progress bar, no progress meter

---
[previous](notes1011.html) &
[next](notes1018.html)
