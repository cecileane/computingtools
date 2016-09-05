---
layout: page
title: 11/3 notes
description: course notes
---
[previous](notes1101.html) & [next](notes1108.html)

---

## homework

[homework 2](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw2-datamerge), due F 11/11. learning goals:
experience with Python, more experience with git,
think about algorithm strategy,
set good computing habits (project organization, documentation,
[etc](http://cecileane.github.io/computingtools/pages/notes0906.html#best-practices)).

## binomial coefficients script: con't

improve on `binomial.py`:

- expand the *docstring* to state assumptions
- *check* that the input `n` is non-negative
- add an *optional argument* `k` to calculate `log(n!/k!)=log((k+1)*...*n)`,
  with default `k=0`. return log(1)=0 if k>n, with no error.
- *check* that `k` is a non-negative integer
- add associated *tests* as examples inside the docstring:
  with n=5 and some k<5, also n=k=5 (boundary), and n=5, k=6.
- write a function `choose` to calculate the log of
  choose(n,k): log( n!/k! ) - log( (n-k)! ),  
  for any integers `n>=0` and `0 <= k <= n`.  
  Start with the *docstring* that states assumptions, and with *tests*.  
  Include assertions to *check* inputs.
- add an *optional argument* to this "choose" function, to return the
  binomial coefficient itself (default) or its log otherwise.
- add a docstring for the module: right after shebang line

after edits to our file, its functions should be reloaded inside
the same python session with:

```python
import binomial
import importlib
importlib.reload(binomial)
```

## python script arguments

`sys` module: function `sys.arg` to get the script name and arguments  
module [argparse](https://docs.python.org/dev/howto/argparse.html):
to do things well, more easily, and with documentation.  
let's revise our binomial script to give it arguments:

- `-n` and `-k` values, no defaults: to get the binomial coefficient "n choose k"
- `--log` option: to get the log of the binomial coefficient
- `--test` option: to test the package instead of calculating one particular
  coefficient value. should be incompatible with n, k, log options.

```python
import argparse
# use an Argument Parser object to handle script arguments
parser = argparse.ArgumentParser()
parser.add_argument("-n", type=int, help="total number of items to choose from")
parser.add_argument("-k", type=int, help="number of items to choose")
parser.add_argument("-l", "--log", action="store_true", help="returns the log binomial coefficient")
parser.add_argument("--test", action="store_true", help="tests the module and quits")
args = parser.parse_args()
# test argument problems early:
if args.test and (args.n or args.k or args.log):
    print("ignoring n, k or log arguments")
if not (args.test or (args.n and args.k)):
    raise Exception("needs 2 integer arguments: -n and -k")
```

next add this at the end of the script:

```python
def runTests():
    print("testing the module...")
    import doctest
    doctest.testmod()
    print("done with tests")

if __name__ == '__main__':
    if args.test:
        runTests()
    else:
        res = choose(args.n, args.k, args.log)
        print(res)
```

then run the script like this:

```
$ ./binomial.py -h
usage: binomial.py [-h] [-n N] [-k K] [-l] [--test]

optional arguments:
  -h, --help  show this help message and exit
  -n N        total number of items to choose from
  -k K        number of items to choose
  -l, --log   returns the log binomial coefficient
  --test      tests the module and quits

$ ./binomial.py -n 150 -k 40
4408904561911885789946649584764715008
$ ./binomial.py -n 1500 -k 400 --log
866.1129352492226
$ ./binomial.py --test
testing the module...
done with tests
```

[here](../assets/python/binomial.py) is our final product,
with one last change (go find it!) to make the file usable as a module too.

---
[previous](notes1101.html) & [next](notes1108.html)
