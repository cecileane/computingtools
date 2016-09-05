---
layout: page
title: 10/25 notes
description: course notes
---
[previous](notes1020.html) & [next](notes1027.html)

---

<!-- ## homework -->

## introduction to python

[software carpentry workshop](http://swcarpentry.github.io/python-novice-inflammation/)  
ipython notebook #1: [download](../assets/python/swcarpentry1.ipynb)
or [view](https://github.com/cecileane/computingtools/blob/gh-pages/assets/python/swcarpentry1.ipynb) (input only)

## concepts summary

### basic types

int `14`, float `14.123`,
<!--
32 bits: 1 (sign) + 8 (exponent) + 23 (mantissa = fraction)
64 bits: 1 (sign) + 11(exponent) + 52 (mantissa)
-->
string `"hello"`, bool (`True` or `False`), None,
complex `3+0.5j`

to convert: `int`, `float`, `str`, `bool`, and string formatting:

```python
"%s %s hello %s" % (5, 5.8, "5")
"%d %d %d world" % (5, 5.8, int("51"))
"%.2f %.2f %.1e" % (5, float(5.8), float("51.2"))
"{} hello {} world {}".format(5, "5.8", 51.2)
"{:.2f} hello {:+} world {:.1e}".format(5, 5.8, 51.2)
```

- to store multiple elements:  
  list `[10,20]`, tuple `(10,20)`,
  dictionary/hash `{"blue":10, "green":20}`, set `set([10,20])`

- a list of lists is not the same as an array. `[1,2]` to create a list.
- **mutable** (e.g. lists) versus **immutable** objects (e.g. strings, numbers, tuples)

### syntax

`:` to end starting lines, **indentation** to define blocks

```python
for xxx in collection:
    command
    command
    if condition:
        command
    elif another_condition: # optional
        command
    else: # optional
        command
    command_still_in_for_loop
```

important concepts:

- binding of a name
- scope of variables
- local namespace

### conditions

`==`, `<`, `>`, `not`, `and`, `or`.  
anything *other* than `False`, 0, `None`, empty string or empty list
is considered `True` in a boolean context.

### some useful modules

numpy, time, matplotlib.pyplot, glob, re, sys,
[argparse](https://docs.python.org/dev/howto/argparse.html)

`import module` or `import module as nickname` or
`from module import function1, function2` or
`from module import *`

### some useful functions/methods

`type`, `print`, `range`, `list`, `del`,
`len`, `abs`, `in`, `**` for power,  
`+` to concatenate strings or lists  
to check assumptions: `assert test_expression, "error message"`

- for lists: `.append(x)`, `.extend([x])`, `.insert(i,x),`
  `.reverse()`, `.pop()`, `.sort()`, `sorted()`


- list comprehension: `[xxx for y in z]` where `z` is a collection,
  `y` introduces a local variable name, and `xxx` is some
  simple function of `y` (typically)

- for strings: `.strip()`, `.split()`, `.replace()`, `.join()`,
  `.splitlines()`

---
[previous](notes1020.html) & [next](notes1027.html)
