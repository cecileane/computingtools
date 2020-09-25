---
layout: page
title: working with files in python
description: course notes
---
[previous](notes1101.html) &
[next](notes1115.html)

---

- [break and continue](#break-and-continue): to control flow in loops
- [read from / write to files](#working-with-files)
- [file manipulations](#file-manipulations): to create, list, remove files etc.

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

## working with files

notes:
- seeking information in files on the disk (or hard drive) is *very* slow.  
  disk = long-term memory. slow to access
- RAM = random access memory. short-term memory, but
  *way* faster to access:
  temporary storage of data between the disk and the CPU
- CPU ↔ RAM ↔ disk  
- read [this](https://biojulia.net/post/hardware/)
  to learn much *much* more, very well explained
  (using Julia to benchmark speed for illustrating concepts)

access files from python:
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

---
[previous](notes1101.html) &
[next](notes1115.html)
