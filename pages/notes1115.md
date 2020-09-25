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
d = {"blue":10, "green":20}
d # may be printed in different order
d = {}
d["blue"]=10 # it's weird that we use [] here and not {}
d["green"]=20
d
# access the value of a key, or simply check if a key exists
"blue" in d
d.get("blue")
d["blue"]
"red" in d
d["red"] # oops
d.get("red")
d.get("red") == None
d.get("red", 5)
# remove things
del d["green"] # deletes element (binding)
d
a = d.pop("blue") # deletes, but returns value
d
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

trimer_count = {} # variable names cannot start with a digit
bases = ["A","C","G","T"]
for i in range(0,(len(dna)-2)):
  trimer = dna[i:(i+3)]
  if trimer in trimer_count:
    trimer_count[trimer] += 1
  else:
    trimer_count[trimer] = 1

trimer_count
trimer_count["TTT"]
trimer_count["GCC"] # key error
trimer_count.get("GCC", 0) # default to 0 if key not found

for trinucleotide in trimer_count:
  print("count for " + trinucleotide + ":", trimer_count[trinucleotide])

for k,v in trimer_count.items(): # k,v for key,value. (k,v) is a tuple
  print("count for " + k + ":", v)

for tn in sorted(trimer_count.keys()): # k,v for key,value
  print("count for " + tn + ":", trimer_count[tn])

for tn in trimer_count:
  if trimer_count[tn] == 2:
    print(tn, "appears twice")
```

dictionary sometimes called "hash": why?  
efficient implementations map keys to unique integers using a hash function,
then can use an array with these integers.  
consequence: **key** advantage of dictionaries over lists:
"immediate" lookup of a value, independent of the size of the dictionary.

## sets

like dictionaries, but keys only, no values

```python
s1 = {"blue","green"}
for color in s1:
  print(color)
s1.add("green") # was already there: no change
s1
s1.add("orange")
s1
"red" in s1
"blue" in s1
s1.remove("green")
a = s1.pop()
s
s2 = s1.union({"green","blue"})
s3 = {"green","purple"}
s2.intersection(s3)
s2.difference(s3) # s2 \ s3

set(trimer_count.keys())
```

## more on list comprehension

concise notation, usually easy to read (for a human)  

```python
[xxx for y in z]
[xxx for y in z if uuu]
```
where `z` is a list, dictionary, "range" or other iterable;
`xxx` and `uuu` typically depend on `y`.  

```python
[k for k in trimer_count] # list of keys, here list of trimers present in the sequence
[k for k,v in trimer_count.items() if v>1] # trimers appearing 2+ times

paramvalues = [10 ** i for i in range(-3,2)] # from "range" object
[v**2 for v in paramvalues]
[v**2 for v in paramvalues if v >= 0.1] # from list, with condition

d = {'xtolrel':0.01, 'xtolabs':0.001, 'Nfail':50} # d for dictionary
d # note possibly different order
[d[k]*2 for k in d] # k for key
[d[k]*2 for k in d if k.startswith("xtol")] # with condition
[[k, v*2] for k,v in d.items()] # k for key, v for value. returns a list

# extract a subset of values
x = [18, 1, 54, 0, 2, 72]
wanted = [True, True, False, False, True, False]
[x[i] for i in range(len(x)) if wanted[i]]
```

works to creates dictionaries or sets too:

```python
dict( [[k, v*2] for k,v in d.items()] ) # wasteful
{ k:v*2 for k,v in d.items() } # same result
{ k for k,v in d.items() } # set: like a dict but keys only, no values
{ k for k in d } # same as above
set(d.keys())    # same result
{ k for k in d if re.search(r'tol',k)}
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
type(res)
res.decode("utf-8")
res = subprocess.check_output("ps -u ane | grep python", shell=True)
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
res = subprocess.run(["ls", "wrong/path"], stdout=subprocess.PIPE) # stderr to screen
res = subprocess.run(["ls", "wrong/path"], capture_output=True)) # stderr captured too
```

### about characters

Unicode: code that maps more than 120,000 characters to integers,
which then need to be coded with *some* number of 0/1 bits.

| unicode | character | binary |   | hexadecimal |   | utf-8 |
|--------:|:---------:|-------:|---|------------:|---|:-----:|
|  0 | null ~ string terminator | 0 |  | 0 |  | 00000000 |
|  4 | end of file | 100 |  | 4 |  | 00000100 |
|  9 | tab \t |    1001 |  |  9 |  | 00001001 |
| 10 | newline \n |    1010 |  |  a |  | 00001010 |
| 48 | 0  |  110000 |  | 30 |  | 00110000 |
| 65 | A  | 1000001 |  | 41 |  | 01000001 |
|---------|---|---|---|---|---|---|
|         |   |---|---|---|---|---|
{: rules="groups"}

The first 2⁷ = 128 unicode characters are the ASCII characters: need at least 7 bits  
[UTF-8](https://www.utf8-chartable.de) encoding uses
1 byte (8 bits) for ASCII characters,
but up to 4 bytes (32 bits) in general.

byte strings: each character coded with 1 byte only (8 bits), i.e.
as integer in 0-255. `ord("0")` gives integer 48, `chr(48)` gives
character '0', `ord("\t")` gives 9.
Try `bstr = bytes(b"01239abc\n")` then `bstr[8]`.

```python
ord("\0") # null character
ord("\n")
ord("\r")
ord("é")  # unicode character number 233
ord("🙂") # 128578
len(bytes("🙂", encoding='utf-8')) # 4 bytes
a = bytes("é", encoding='utf-8')
len(a) # coded with 2 bytes using UTF8 encoding
a      # b'\xc3\xa9'
a[0]   # 195 = 12*16 + 3 > 128: not ASCII
a[1]   # 169 = 10*16 + 9
bin(a[0]) # 0b11000011
bin(a[1]) # 0b10101001
# so UFT-8 code for é is: 1100001110101001
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
