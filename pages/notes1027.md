---
layout: page
title: regular expressions in python
description: course notes
---
[previous](notes1025.html) &
[next](notes1101.html)

---

<!--
content was previously in ipython notebook #2:
[download](../assets/python/swcarpentry2.ipynb)
-->

## simple patterns and tools

useful functions on **strings** for simple things:
 `.strip`, `.split`, `.join`, `.replace`, `.index`, `.find`, `.count`,
 `startswith`, `.endswith`, `.upper`, `.lower`,

```python
a = "hello world"
print(a.startswith("h"))
print(a.startswith("he"))
print("h" in a)
print("low" in a)
print("lo w" in a)
```

```python
print("aha".find("a"))
print("hohoho".find("oh"))
mylist = ["AA","BB","CC"]
"coolsep".join(mylist)
```

and see `dir("")` for string methods (because `""` is a string).
```python
print(type(""))
print(dir(""))
```

## regular expressions

use the **re library** and its functions
`re.search`, `re.findall`,  `re.sub`, `re.split` etc.  
recall regular expression
[syntax](notes0922.html#regular-expressions-regexp)

- `r''` to write the regular expression pattern, for "raw" strings:
  to read a \n as slash and an n, not as a newline character.
- multipliers are greedy by default: `*`, `+`, `?`. Add `?` to make them non-greedy
- info from match objects: `.group`, `.start`,  `.end`  
  when pattern not found: match object is `None`: False when converted to a boolean

```python
import glob
filenames = glob.glob('*.csv')
print(filenames)

import re
mo = re.search(r'i.*n',filenames[0]) # multiplier * is greedy
print(mo)  # match object, stores much info. search: first instance only.
print(mo.group()) # what matched
print(mo.start()) # where match starts: indexing start at 0
print(mo.end())   # where it ends: index *after*!

mo = re.search(r'i.*?n',filenames[0])
print(mo)
print(mo.group())
print(mo.start())
print(mo.end())
```

When there is no match, the matched object is None and interpreted as False in boolean context:

```python
sequences = ["ATCGGGGATCGAAGTTGAG", "ACGGCCAGUGUACN"]
for dna in sequences:
    mo = re.search(r'[^ATCG]', dna)
    if mo:
        print("non-ACGT found in sequence",dna,": found", mo.group())
```

by the way, compare with the less efficient code:

```python
for dna in sequences:
    if re.search(r'[^ATCG]', dna):
        mo = re.search(r'[^ATCG]', dna)
        print("non-ACGT found in sequence",dna,": found", mo.group())
```

finding all instances:

```python
print(re.findall(r'i.*n',filenames[0])) # greedy. non-overlapping matches
mo = re.findall(r'i.*?n',filenames[0])  # non-greedy
print(mo)
mo
```

```python
for f in filenames:
    if not re.search(r'^i', f): # if no match: search object interpreted as False
        print("file name",f,"does not start with i")
```

## search and replace: `re.sub`

- capture with parentheses in the regular expression  
- captured elements in `.group(1)`, `.group(2)` etc. in the match object
- recall captured elements with `\1`, `\2` etc. in a regular expression,
  to use them in a replacement for example

```python
re.sub(r'^(\w)\w+-(\d+)\.csv', r'\1\2.csv', filenames[0])
```
```python
for i in range(0,len(filenames)):
    filenames[i] = re.sub(r'^(\w)\w+-(\d+)\.csv', r'\1\2.csv', filenames[i])
print(filenames)
```
```python
taxa = ["Drosophila melanogaster", "Homo sapiens"]
for taxon in taxa:
    mo = re.search(r'^([^\s]+) ([^\s]+)$', taxon)
    if mo:
        genus = mo.group(1)
        species = mo.group(2)
        print("genus=" + genus + ", species=" + species)

print(taxon)
print(mo) # variables defined inside "for" are available outside
print(mo.start(1))
print(mo.start(2))
```

next: abbreviate genus name to its first letter, and replace space by underscore:
```python
taxa_abbrev = []
for taxon in taxa:
    taxa_abbrev.append(
        re.sub(r'^(\S).* ([^\s]+)$', r'\1_\2', taxon)
    )
print(taxa_abbrev)
```

## split according to a regular expression

- removes the matched substrings
- returns an array

```python
coolstring = "Homo sapiens is pretty super"
re.split(r's.p', coolstring)
re.split(r's.*p', coolstring)
re.split(r's.*?p', coolstring)
```


---
[previous](notes1025.html) &
[next](notes1101.html)
