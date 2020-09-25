---
layout: page
title: python functions and scripts
description: course notes
---
[previous](notes1027.html) &
[next](notes1108.html)

---


syntax similar to `if/else` statements and `for` loops:
colon to end the function name/argument names,
and indentation of the function body.

```python
def function_name(arguments):
    """docstring here: to explain what the function does"""
    command indented
    indented command
    return value # returns None if no return statement
```

arguments can be named, can have default values:

```python
def foo(arg1, arg2=0):
  """
  Return arg1 -1 + arg2.
  arg2 is optional, 0 by default.
  good practice: include examples.
  Examples:

  >>> foo(5)
  4
  >>> foo(5,8)
  12
  >>> foo(5, arg2=2)
  6
  """
  assert type(arg1)==int, "error message: here arg1 should be an integer"
  res = arg1 - 1 + arg2
  return res
```

example:

```python
def startswithi(str):
    """Return True if the input string starts with 'i', False otherwise.
    Require that the "re" was imported beforehand.

    note:
    - the double and single quotes inside my tripe double-quoted docstring

    Example:

    >>> startswithi("hohoho")
    False
    """
    return(bool(re.search(r'^i', str)))

help(startswithi) # or ?startswithi in interactive session
print(startswithi("iamcecile"))
print(startswithi("hohoho"))
```

#### key principle: break problem down into small parts

- write functions
- if you do some "copy-paste" of your code: you need to write a function
- functions make your code easier to debug, easier to read
- use meaningful names for functions and for variables

example where we re-use our functions:

```python
def fahr_to_kelvin(temp):
    return ((temp - 32) * (5/9)) + 273.15

print('freezing point of water:', fahr_to_kelvin(32))
print('boiling point of water:', fahr_to_kelvin(212))

def kelvin_to_celsius(temp_k):
    return temp_k - 273.15

print('absolute zero in Celsius:', kelvin_to_celsius(0.0))

def fahr_to_celsius(temp_f):
    temp_k = fahr_to_kelvin(temp_f)
    result = kelvin_to_celsius(temp_k)
    return result

print('freezing point of water in Celsius:', fahr_to_celsius(32.0))
```

example to break down:

```python
import numpy
import glob
import matplotlib
filenames = glob.glob('inflammation*.csv')

def analyze_all():
  for f in filenames[:3]:
    print(f)
    analyze(f)
    detect_problems(f)

def analyze(filename):
    data = numpy.loadtxt(fname=filename, delimiter=',')
    # commands to make the figure for one data file

def detect_problems(filename):
    data = numpy.loadtxt(fname=filename, delimiter=',')
    if (numpy.max(data, axis=0)[0] == 0 and
        numpy.max(data, axis=0)[20] == 20):
        print('Suspicious looking maxima!')
    elif numpy.sum(numpy.min(data, axis=0)) == 0:
        print('Minima add up to zero!')
    else:
        print('Seems OK!')

analyze_all()
```

## python scripts

- to use functions in a script `binomial.py` inside a python session
  as a **module**:

  `import binomial`

  then use function `foo` as `binomial.foo()`, `help(binomial)`, etc.
  alternatively, do:

  `from binomial import *`

  and then use function `foo` as just `foo` (with no need to type
  the file name first).

- If your script in not in the directory that your python session is in,
  add the script path to the list of paths that python knows about:
  `import sys` then `sys.path.append("path/to/script")`.

  * special predefined variables: try
    `binomial.__name__` and `binomial.__file__` after importing the module
  * documentation for the module: add a docstring at the beginning,
    after the shebang line if you have one
  * to reload a module that has already been loaded in same python session:

    ```python
    import binomial
    import importlib # then further edits made to 'binomial.py'
    importlib.reload(binomial)
    ```

- to **run the script** from the command line, first
  put what should be run inside a test:

  ```python
  if __name__ == '__main__':
       command1 # things to do if script called
       command2 # from the command line.
  ```

  then do `python binomial.py` to run the script.

- to run it with `./binomial.py` or simply `binomial.py`,
  change the file permission to let you execute the file, e.g. with `chmod u+x`,
  and add the "shebang" at the beginning of the file:

  `#!/usr/bin/env python`

    note: `env` is a shell command. `env python` find the path
  to the python program and runs it.
  The shebang line has to give an absolute path, and
  the path to `env` is quasi-always `/usr/bin/env`:
  so this line makes your script portable to other users
  who might not have the same path to python as you.

## test python code automatically

- test each function in your code,
  run *all* tests each time your change your code.
- big thing: new features often break older functions.
- each time you fix a bug: add a new test,
  for the situation in which the bug appeared
- there are many modules for automatic testing; one is `doctest`.

first, add examples the docstring of each function:

```python
def choose(n, k):
    """returns the binomial coefficient.
    Examples:

    >>> choose(5,3)
    10
    """
    # function body that does the calculations
```

second, call `doctest.testmod()`, for example when the
file is run as a script:

```python
if __name__ == '__main__':
    import doctest
    doctest.testmod()
```

## script arguments

script name and arguments are captured in the list `sys.argv`
after you `import sys`, but use the
[argparse](https://docs.python.org/dev/howto/argparse.html) library instead
to do things well, more easily, and with documentation.

```python
#!/usr/bin/env python
"""module with very cool functions to say 'hi'"""

import argparse
# use an Argument Parser object to handle script arguments
parser = argparse.ArgumentParser()
parser.add_argument("-n", type=int, help="number of times to say hi")
parser.add_argument("-l", "--long", action="store_true", help="whether to say 'hi' the long way")
parser.add_argument("-g", "--greetings", type=str, help="greeting message, like a name")
parser.add_argument("--test", action="store_true", help="tests the module and quits")
args = parser.parse_args()
hi = "Howdy" if args.long else "Hi"

# test argument problems early:
if not args.test and __name__ == '__main__':
    if args.n<0:
        raise Exception("argument -n must be 0 or positive")
    # no error if file imported as module

def print_greetings(extra_greetings, n=args.n):
    """
    print individualized greeting. example:
    >>> print_greetings("have a good day", 0)
    have a good day, you.
    """
    s = ""
    for i in range(0,n):
        s += hi + ", "
    if extra_greetings:
        s += extra_greetings + ", "
    s += args.greetings if args.greetings else "you"
    s += "."
    print(s)

def runTests():
    print("testing the module...")
    if args.n:
        print("ignoring n for testing purposes")
    import doctest
    doctest.testmod()
    print("done with tests.")

if __name__ == '__main__':
    if args.test:
        runTests()
    else:
        print_greetings("")
```

we could save the example above in a file `example.py` and use it in various ways
from the shell:
```shell
./example.py --help
./example.py --test
./example.py -n=1 --long -g=cecile
./example.py -n 1 --long -g cecile
```
or within python:
```python
import example
help(example)
example.print_greetings("happy halloween", 3)
```

---
[previous](notes1027.html) &
[next](notes1108.html)
