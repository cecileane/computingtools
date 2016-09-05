---
layout: page
title: 11/15 notes
description: course notes
---
[previous](notes1110.html) & [next](notes1117.html)

---

## homework

[homework 2](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw2-datamerge)
due today.
Commit and push your work to github, then open a github
[issue](https://github.com/UWMadison-computingtools/coursedata#commit-push-and-submit-your-work)
as before.

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

### about characters:

Unicode: code that maps more than 120,000 characters to integers,
which then need to be coded with 0/1 bits.
UTF-8 encoding uses 1 byte for any ASCII character, but up to 4 bytes
in general.

byte strings: each character coded with 1 byte only (8 bits), i.e.
as integer in 0-255. `ord("0")` gives integer 48, `chr(48)` gives
character '0', `ord("\t")` gives 9.
Try `bstr = bytes(b"01239abc\n")` then `bstr[8]`.

hexadecimal/hex: "numbers" in base 16=2<sup>4</sup>: to represent a "nibble"
(4 bits, half a byte). 0-9, a-f
(recall git commit SHAs, e.g "bec2817eb21e17c49a355878de577a91b9c6c5b6").  
Try: `0x0`, `0x9`, `0xb`, `0xf`, `0x0f`, `0x2b` (2\*16+11), `0xff` (15\*16+15).  
To write in base 2, use `0b` instead of `0x`, like `0b101011` (32+8+2+1).  
To get the binary or hexadecimal representation: `bin(43)` or `hex(43)`.

## python classes and methods

object-oriented programming:

- define new "types" of objects: classes
- each object type has its own data *attributes* and *methods*.  
- special method: `__init__` to create a new object of the class
- `self`: name of new object
- special method: `__str__` to convert an object into a string,
  used to `print` the object

<!--
see Karl's
[lecture](http://kbroman.org/Tools4RR/assets/lectures/13_python_withnotes.pdf)
for a cool example
-->

example: class to code graphs, or trees, made of nodes and edges.

- Tree class
- Edge class

Edge class attributes:

- `parent`: index for parent node
- `child`: index for child node

Copy this to a new file, named `tree.py`:

```python
#!/usr/bin/env python

class Edge:
    """Edge class, to contain a directed edge of a tree or directed graph.
    attributes parent and child: index of parent and child node in the graph.
    """

    def __init__ (self, parent, child, length=None):
        """create a new Edge object, linking nodes
        with indices parent and child."""
        print("starting __init__ for new Edge object/instance")
        self.parent = parent
        self.child = child
        self.length = length

    def __str__(self):
        res = "edge from " + str(self.parent) + " to " + str(self.child)
        return res
```

let's use it, in a new python session:
(if not in same directory, add the file's path to python's path:
`import sys` then `sys.path.append("path/to/tree/dot/py/file")`.)

```python
import tree
e1 = tree.Edge(0,1)
e2 = tree.Edge(0,2)
e3 = tree.Edge(2,3)
e4 = tree.Edge(2,4)
e4
print(e4)
```

Tree class attributes:

- `edge`: list of Edge objects
- methods `add_edge()` to add an existing edge to the list,
  `new_edge()` to create and add a new edge

```python
class Tree:
    """ Tree, described by its list of edges."""
    def __init__(self, edgelist):
        """create a new Tree object from a list of existing Edges"""
        self.edge = edgelist

    def __str__(self):
        res = "parent -> child:"
        for e in self.edge:
            res += "\n" + str(e.parent) + " " + str(e.child)
        return res

    def add_edge(self, ed):
        """add an edge to the tree"""
        self.edge.append(ed)

    def new_edge(self, parent, child):
        """add to the tree a new edge from parent to child (node indices)"""
        self.add_edge( Edge(parent,child) )
```

after edits to `tree.py`, the class should be reloaded with:

```python
import importlib
importlib.reload(tree)
tre = tree.Tree([e1,e2])
tre
print(tre)
tre.add_edge(e3)
tre.new_edge(2,4)
print(tre)
```

---
[previous](notes1110.html) & [next](notes1117.html)
