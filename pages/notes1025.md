---
layout: page
title: python basic types, syntax, loops, lists
description: course notes
---
[previous](notes1020.html) &
[next](notes1027.html)

---


done at home before today: software carpentry workshop's
[analyzing patient data](http://swcarpentry.github.io/python-novice-inflammation/)
and
[repeating actions with loops](http://swcarpentry.github.io/python-novice-inflammation/02-loop/)

## concepts summary

### basic types

int `14`,
<!--
64 bits: 1 (sign) + 63: coded as power of 2, so
from 0 to 2^63-1 for positives, from -1 to -2^63 for negatives
sys.maxsize
-->
float `14.123`,
<!--
32 bits: 1 (sign) + 8 (exponent) + 23 (mantissa = fraction)
64 bits: 1 (sign) + 11(exponent) + 52 (mantissa)
sys.float_info
-->
string `"hello"`, bool (`True` or `False`), None,
complex `3+0.5j`, also NoneType (`None`).

`int`s and `float`s are fundamentally different in how they are coded.
consequence: never test for exact equality of `float`s.

```python
1.0/3.0 == 1.0 - 2.0/3.0 # False!!
1.0/3.0
1.0 - 2.0/3.0
```

<!--
from math import isclose
isclose(1.0/3.0, 1.0 - 2.0/3.0) # optional: rel_tol abs_tol
-->

to convert: `int`, `float`, `str`, `bool`, and string formatting:

```python
bool(0)
bool(0.0)
bool(0.5)
bool(1.0/3.0 - (1.0 - 2.0/3.0)) # no!!!
int(4.9)
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

do section 3: [storing multiple values in lists](http://swcarpentry.github.io/python-novice-inflammation/03-lists/)
see ipython notebook #1: [download](../assets/python/swcarpentry1.ipynb)

### mutable vs immutable objects

lists are mutable:
```python
names = ['Newton', 'Darwing', 'Turing'] # typo in Darwin's name
names[1] = 'Darwin' # correct the name
print('final value of names:', names)
```

strings, numbers, tuples are immutable:
```python
name = 'Darwin'
print("letter indexed 0:", name[0])
name[0] = 'd' # error!
name = "darwin"
name
a = (13,4)
print(a)
a[1] = 100 # error!
```

How `b=a` and changes to `b` can cause (or not) changes to `a`:

```python
a = "Darwin"
b = a
print("b=",b)
b = "Turing" # does not change a, because a has immutable value
print("now b=",b,"\nand a=",a)
```

```python
a = [10,11]
b = a
b[1] = 22 # changes the value that b binds to, so changes a too
print("b=", b, "\nand a=",a)

c = [a,a] # list of lists. Not numpy array!
print(c)
a[0] = -5
print(c) # aahh!!

b = a.copy() # various alternative options
b = list(a)
import copy
a = [10,11]
b = copy.copy(a)
b[1] = 22 # changes the value that b binds to, does not change a
print("b=", b, "\nand a=",a)
```

**deep copy** versus simple (shallow) copy:

```python
a = [[10,11],[20,21]]
print(a)
b = copy.copy(a)
b[0][0] = 50
print("b=",b,"and a=",a)
b[0] = [8,9]
print("b=",b,"and a=",a)
b = copy.deepcopy(a)
print("now b is back to a: ",b)
b[0][0] = 8
print("b=",b,"and a=",a)
```

Functions that operate on mutable objects can change them in place:
this is a huge deal!

```python
def add1_scalar(x):
    """adds 1 to scalar input"""
    x += 1
    print("after add1_scalar:",x)

def add1_array(x):
    """adds 1 to the first element of array input"""
    x[0] += 1
    print("after add1_array:",x)

help(add1_scalar)
# add1_scalar? # in interactive session

a=5; print(a)
add1_scalar(a)
print("and now a =",a) # a was not modified because it is immutable
b=[5]; print(b)
add1_array(b)
print("and now b =",b) # b was modified in place because it is mutable: array
```

linked to "namespace" concept, and how arguments are passed to functions  
conclusion: functions can **change mutable arguments** in place:

- beware
- opportunities to save a lot of memory (and time)

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

do software carpentry workshop's section 5:
[making choices](http://swcarpentry.github.io/python-novice-inflammation/05-cond/)

`==`, `<`, `>`, `not`, `and`, `or`.  
anything *other* than `False`, 0, `None`, empty string or empty list
is considered `True` in a boolean context.

### tuples

tuples are immutable , unlike lists. useful for
- array sizes: `(60,40)` earlier
- types of arguments to functions: like `(float, int)` for instance
- functions can return multiple objects in a tuple
- a tuple with a single value, say 6.5, is noted like this: `(6.5,)`
- they come in very handy for exchanges:

```python
left = 'L'
right = 'R'

temp = left
left = right
right = temp
print("left =",left,"and right =",right)

left = 'L'
right = 'R'

(left, right) = (right, left)
print("left =",left,"and right =",right)

left, right = right, left
print("now left =",left,"and right =",right)
```

### some useful functions for lists

`.append(x)`, `.extend([x])`, `.insert(i,x),`
`.reverse()`, `.pop()`, `.sort()`, `sorted()`

```python
odds = [1, 3, 5, 7]
print('odds before:', odds)
odds.append(11)
print('odds after adding a value:', odds)
```
for R users, the following code does not do what you might think:
```python
odds = [odds, 11]
print('odds=',odds)
```

```python
odds = [1, 3, 5, 7, 11]
del odds[0]
print('odds after removing the first element:', odds)
odds.reverse()
print('odds after reversing:', odds)
a = odds.pop()
print('odds after popping last element:', odds)
print("this last element was",a)
a = odds.pop(1)
print("popped element number 1 (2nd element):",a)
odds
```

what `+` and `*` do to lists (and remember that lists are mutable):
```python
odds = [1, 3, 5, 7]
primes = odds
primes += [2]
print('primes:', primes)
print('odds:', odds)

counts = [2, 4, 6, 8, 10]
repeats = counts * 2
print(sorted(repeats))    # all integers
print(repeats) # unchanged
repeats.sort() # modified in place
print(repeats)
print(sorted([10,2.5,4])) # all numerical
print(sorted(["jan","feb","mar","dec"]))  # all strings
print(sorted(["jan",20,1,"dec"]))  # error
```

### list comprehension

`[xxx for y in z]` where `z` is a collection,
`y` introduces a local variable name, and `xxx` is some
simple function of `y` (typically)
```python
counts = [2, 4, 6, 8, 10]
counts + 5 # error
[num+5 for num in counts] # new object
counts
for i in range(0,len(counts)):
    counts[i] += 5 # modifies "counts" in place
counts
```

### some useful functions for strings

`.strip()`, `.split()`, `.replace()`, `.join()`, `.splitlines()`,

```python
taxon = "Drosophila melanogaster"
genus = taxon[0:10]
print("genus:", genus)
gslist = taxon.split(' ')
print(gslist)
print("after splitting at each space: genus=",
      gslist[0],", species=",gslist[1], sep="")
print(taxon) # has not changed: immutable
print(taxon.replace(' ','_'))
print(taxon) # has not changed
```

```python
mystring = "\t hello world\n \n"
mystring
print('here is mystring: "' + mystring + '"')
print('here is mystring.strip(): "' + mystring.strip() + '"')
print('here is mystring.rstrip(): "' + mystring.rstrip() + '"') # right strip (or tRailing) only
"     abc\n \n\t ".strip()
```
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


---
[previous](notes1020.html) &
[next](notes1027.html)
