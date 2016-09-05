---
layout: page
title: 11/8 notes
description: course notes
---
[previous](notes1103.html) & [next](notes1110.html)

---

## homework

[homework 2](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw2-datamerge), due F 11/11. learning goals: python, git, algorithm strategy, computing
[practices](http://cecileane.github.io/computingtools/pages/notes0906.html#best-practices).
We will **use class time** R 11/10 to work on it
and to discuss strategies in small groups.

finish [dictionary](#dictionaries-hashes) section at home:
to see the methods `.get`, `.items`, `.keys` and various ways to iterate
over a dictionary.


## working with files

- disk file vs. file object (file handle)
- 3 modes to open a file: `r`, `w`, `a` (append)

```python
fh = open("newfile", 'w') # creates file handle
try:
    fh.write("hello world\n") # problem if disk quota full, etc.
finally:
    fh.close() # need to close to clean up, even if problems earlier
```

equivalent to:

```python
with open("newfile", 'w') as fh:
    fh.write("hello world\n")

# fh is closed now
```

methods for file handles: `.write()`, `.writelines()`,
`read()`, `.readline()`, `.readlines()`

example: read fasta protein files from bds data (chapter 3)

- treat sequence names differently (lines starting with ">")
- concatenate lines that are for the same sequence
- output file with protein from all fasta files, with new format:
1 sequence = 1 line, with species name preceding the sequence itself

```python
with open("tb1-protein.fasta","r") as fh:
  for line in fh:
    print("line=", line, sep="", end="")
```

equivalent to:

```python
with open("tb1-protein.fasta","r") as fh:
  linelist = fh.readlines()
  for line in linelist:
    print("line=", line, sep="", end="")

with open("tb1-protein.fasta","r") as fh:
  line = fh.readline() # header line only
  print("line=", line, sep="", end="")
  dna = ""
  while line: # will be false at the end of file: ''
    line = fh.readline()
    print("line=", line, sep="", end="")
    dna += line.strip()

print("dna=", dna, sep="", end="")
```

let's do what we need now:

```python
def reformat_onefile(fin, fout):
  """assumes fin not open, fout already open for writing."""
  with open(fin,"r") as fh:
    for line in fh:
      line = line.strip()
      if not line:
        continue # skip the rest if empty line
      if line.startswith(">"): # header line
        fout.write(line)
        fout.write("\n") # after header
      else:              # dna sequence line
        fout.write(line)
  fout.write("\n") # after end of full sequence

import sys
reformat_onefile("tb1-protein.fasta", sys.stdout) # check function

import glob
filenames = glob.glob("*-protein.fasta")
with open("all1linesequences.fasta", "w") as outfile:
  for fname in filenames:
    print("next: will reformat",fname)
    reformat_onefile(fname, outfile)
```

note: `sys.stdout` is a file handle open for writing :)

## break and continue

extremely useful!
`break` to break out of a loop:

```python
i=0
while True:
  i += 1
  print("code for i =",i,"here")
  if i >= 4:
    break
i # 4
```

`continue` to *directly* continue to the next iteration of the loop,
*bypassing* all remaining code for the current iteration:

```python
for i in range(0,10000):
  if i==3 or i >= 5:
    continue
  print("code here not bypassed, i =", i)
i # 9999
```

also: `pass` to do nothing, useful for new not-ready code: a function
must have at least 1 line.

## file manipulations

- in module `os`: `listdir`, `mkdir`, `makedirs`, `rename`, `remove`, `rmdir`,
  `chdir`, `path.exists`, `path.isdir`, `path.isfile`
- in module `shutil`: `copy`, `copytree`, `rmtree`

```python
import os
os.listdir()
os.remove(".DS_Store")
os.mkdir("try1")
os.rmdir("try1")
os.makedirs("try/data/dna")
os.listdir("try")
os.chdir("try")
os.path.isdir("data/dna")
os.path.realpath("data/dna") # absolute path
os.path.isfile("data/dna/gene1.fa")
shutil.copy("../lizard/cten_16s.fasta?sequence=1", "data/dna/cten_16s.fa")
shutil.copy("../lizard/cten_16s.fasta?sequence=1", "data/dna")
os.system("touch readme.md")
```

## dictionaries (hashes)

dictionaries are similar to lists, except that items not *unordered*.  
**items**: **key**-**value** pairs, where keys must be strings or numbers
(or of immutable types)  
like word-definition pairs in a dictionary.

examples:

```python
h = {"blue":10, "green":20}
h # may be printed in different order
h = {}
h["blue"]=10 # it's weird that we use [] here and not {}, but not my choice
h["green"]=20
h
del h["green"] # deletes element (binding)
h
h.pop["blue"] # deletes, but returns value
h
```

<!--
import random
dna = ""
for i in range(20):
  dna += random.choice(["A","C","G","T"])
-->

example:

- count the number of occurrences of k-mers (words of length k) in a string
- do not create entries for a k-mer if it does not occur
- here: use k=2

```python
dna = "TCAATAGGTGGTCGTTGTTT"
k2mer = {} # variable names cannot start with a digit
bases = ["A","C","G","T"]
for nuc1 in bases:
  for nuc2 in bases:
    mycount = dna.count(nuc1+nuc2)
    if mycount:
      k2mer[nuc1+nuc2] = mycount

k2mer
k2mer["TT"]
k2mer["GC"] # key error
k2mer.get("TT")
k2mer.get("GC") # None
k2mer.get("GC", 0) # default to 0 if key not found
for nuc1 in bases:
  for nuc2 in bases:
    print("count for " + nuc1 + nuc2 + ":", k2mer.get(nuc1+nuc2, 0))

for dinucleotide in k2mer:
  print("count for " + dinucleotide + ":", k2mer[dinucleotide])

for k,v in k2mer.items(): # k,v for key,value. (k,v) is a tuple
  print("count for " + k + ":", v)

for dinuc in sorted(k2mer.keys()): # k,v for key,value
  print("count for " + dinuc + ":", k2mer[dinuc])

for dinuc in k2mer:
  if k2mer[dinuc] == 2:
    print(dinuc, "appears twice")
```

note: why sometimes called "hash"?  
efficient implementations map keys to unique integers using a hash function,
then can use an array with these integers.

---
[previous](notes1103.html) & [next](notes1110.html)
