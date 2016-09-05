---
layout: page
title: 11/1 notes
description: course notes
---
[previous](notes1027.html) & [next](notes1103.html)

---

## homework

for next class, do on your own:

- ['the old switcheroo'](http://swcarpentry.github.io/python-novice-inflammation/06-func/#the-old-switcheroo)
- the [errors and exceptions](http://swcarpentry.github.io/python-novice-inflammation/07-errors/),
the [defensive programming](http://swcarpentry.github.io/python-novice-inflammation/08-defensive/)
and the [debugging](http://swcarpentry.github.io/python-novice-inflammation/09-debugging/) sections

## python functions

ipython notebook #2: [download](../assets/python/swcarpentry2.ipynb)
or [view](https://github.com/cecileane/computingtools/blob/gh-pages/assets/python/swcarpentry2.ipynb) (input only)  
[code](https://github.com/swcarpentry/python-novice-inflammation/tree/gh-pages/code)
from software carpentry

```python
def function_name(arg1, arg2=0):
  """docstring here for documentation. optional argument arg2 is 0 by default.
  Examples:

  >>> 1+1
  2
  """
  assert type(arg1)==int, "error message: here arg1 should be an integer"
  commands
  return value # returns None if no return statement
```
in-class exercise: binomial coefficients.
learning goals (recall [best practices](http://cecileane.github.io/computingtools/pages/notes0906.html#best-practices)):

- write functions, divide a large problem into smaller problems
- use optional arguments and default argument values
- use loops and `if` statements
- use docstring to document functions
- check for assumptions
- test code automatically
- create a module: use the script to be run on the command line, or as a module

Calculating binomial coefficients is not easy numerically.
The number of ways to choose k elements among n is
`choose(n,k) = n! / (k! (n-k)!)`
where factorial n: `n! = 1*2*...*n` becomes very big very fast.
But many terms cancel each other in "n choose k",
and it is a lot easier numerically to calculate the log factorial:
`log(n!)=log(1)+...+log(n)`.

1. Write a function "logfactorial" that calculates the `log(n!)` for any integer `n>0`.
2. Add a *docstring*
3. Add *checks* on the input `n`
4. Add *tests* as examples inside the docstring.
  For the tests to be used, add a section using the **doctest** module.
5. Add an *optional argument* `k` to calculate `log(n!/k!)=log((k+1)*...*n)`, with default `k=0`. Add an associated test.
6. Write a function "choose" to calculate the log of the binomial `log(choose(n,k))` for any integers `n>=0` and `0 <= k <= n`. Start with the docstring and with a test.
7. Add an optional argument to this `choose` function, to return the binomial coefficient itself or its log. Make the function return the binomial coefficient by default, not its log.
8. Add a docstring for the module

## python scripts

- to use functions in a script `binomial.py` inside a python session
  as a **module**:

  `import binomial`

  then use function `foo` as `binomial.foo()`, `help(binomial)`, etc.
  If your script in not in the directory that python is in,
  add the script path to the list of paths that python knows about:
  `import sys` then `sys.path.append("path/to/script")`.

  * special predefined variables: try
    `binomial.__name__` and `binomial.__file__` after importing the module
  * documentation for the module: add a docstring at the beginning,
    after the shebang line if you have one

- to **run the script** from the command line, first
  put what should be run inside a test:

  ```python
  if __name__ == '__main__':
       command1 # things to do if script called
       command2 # from the command line.
  ```

  then do `python binomial.py` to run the script.
  To run it with `./binomial.py` or simply `binomial.py`,
  change its permission to let you execute the file and
  add this at the beginning of the file:

  `#!/usr/bin/env python`

note: `env` is a shell command. `env python` find the path
to the python program and runs it.
The shebang line has to give an absolute path, and
the path to `env` is quasi-always `/usr/bin/env`:
so this line makes your script portable to other users
who might not have the same path to python as you.

## test python code automatically

- test each function in your code,
  run *all* test each time your change your code.
- big thing: new features often break older functions.
- each time you fix a bug: add a new test,
  for the situation in which the bug appeared
- there are many modules for automatic testing; one is `doctest`.

first, add examples the docstring of each function:

```python
def choose(n, k):
    """returns the binomial coefficient.
    Examples:

    >>> round(choose(5,3),6)
    10.0
    """
    # function body that does the calculations
```

second, add a call to `doctest.testmod()`:

```python
if __name__ == '__main__':
    import doctest
    doctest.testmod()
```


---
[previous](notes1027.html) & [next](notes1103.html)
