---
layout: page
title: python dictionaries & list comprehension; running external programs
description: course notes
---
[previous](notes1108.html) &
[next](notes1117.html)

---

- [dictionaries](#dictionaries-hashes)
- more on [list comprehension](#more-on-list-comprehension)
- run [external program](#running-external-programs) from within python
- about [characters](#about-characters)

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
h.pop("blue") # deletes, but returns value
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

## more on list comprehension

concise notation, usually easy to read (for a human)  

```python
[xxx for y in z]
[xxx for y in z if uuu]
```
where `z` is a list, dictionary, "range" or other iterable;
`xxx` and `uuu` typically depend on `y`.  

```python
paramvalues = [10 ** i for i in range(-3,2)] # from "range" object
[v**2 for v in paramvalues if v >= 0.1] # from list, with condition
h = {'xtolrel':0.01, 'xtolabs':0.001, 'Nfail':50} # h for hash
h # note possibly different order
[h[k]*2 for k in h] # k for key.
[h[k]*2 for k in h if k.startswith("xtol")] # with condition
[[k, v*2] for k,v in h.items()] # k for key, v for value. returns a list
# extract a subset of values
x = [18, 1, 54, 0, 2, 72]
wanted = [True, True, False, False, True, False]
[x[i] for i in range(len(x)) if wanted[i]]
```

works to creates dictionaries or sets too:

```python
dict( [[k, v*2] for k,v in h.items()] )
{ k:v*2 for k,v in h.items() } # same result
{ k for k,v in h.items() } # set: like a dict but keys only, no values
{ k for k in h } # same as above
set(h.keys())    # same result
{ k for k in h if re.search(r'tol',k)}
```

nested for loops in list comprehension:

```python
paramvalues = [a * (10 ** i) for i in range(-3,2) for a in [1,2]]
```

## running external programs

module `subprocess`: more portable than `os.system()`.
<!--
they recommend .run method
[here](https://docs.python.org/3/library/subprocess.html#subprocess.run)
-->

```python
import subprocess

subprocess.call("date -u", shell=True) # return exist status: 0 if good
```

to capture the output within python as a string:

```python
subprocess.check_output("date")
res = subprocess.check_output(["date", "+%B"])
res
res.decode("utf-8")
res = subprocess.check_output("ps -u ane | grep jupyter", shell=True)
res
print(res.decode("utf-8"))
```

better, e.g. to capture standard output and standard error separately:

```python
print(subprocess.run("/bin/date")) # does not capture output
res = subprocess.run("/bin/date +%B", shell=True, stdout=subprocess.PIPE)
res = subprocess.run(["/bin/date", "+%B"],        stdout=subprocess.PIPE)
print("return code: ", res.returncode,
      "\nstdout: ", res.stdout,
      "\nstderr:", res.stderr)
```

### about characters

Unicode: code that maps more than 120,000 characters to integers,
which then need to be coded with 0/1 bits.
UTF-8 encoding uses 1 byte for any ASCII character, but up to 4 bytes
in general.

byte strings: each character coded with 1 byte only (8 bits), i.e.
as integer in 0-255. `ord("0")` gives integer 48, `chr(48)` gives
character '0', `ord("\t")` gives 9.
Try `bstr = bytes(b"01239abc\n")` then `bstr[8]`.

```python
ord("é") # unicode character number 233
bytes("é", encoding='utf-8')
len(a) # coded with 2 bytes using UTF8 encoding
a      # b'\xc3\xa9'
a[0]   # 195 = 12*16 + 3 > 128: not ASCII
a[1]   # 169 = 10*16 + 9
```

hexadecimal/hex: "numbers" in base 16=2<sup>4</sup>: to represent a "nibble"
(4 bits, half a byte). 0-9, a-f
(recall git commit SHAs, e.g "bec2817eb21e17c49a355878de577a91b9c6c5b6").  
Try: `0x0`, `0x9`, `0xb`, `0xf`, `0x0f`, `0x2b` (2\*16+11), `0xff` (15\*16+15).  
To write in base 2, use `0b` instead of `0x`, like `0b101011` (32+8+2+1).  
To get the binary or hexadecimal representation: `bin(43)` or `hex(43)`.

---
[previous](notes1108.html) &
[next](notes1117.html)
