---
layout: page
title: 10/20 notes
description: course notes
---
[previous](notes1018.html) & [next](notes1025.html)

---

<!-- ## homework -->


## introduction to python

We started "programming with Python" from the [software carpentry workshop](http://swcarpentry.github.io/python-novice-inflammation/),
and covered the first section ("analyzing patient data") through the
paragraph "not all functions have input".  
software carpentry's [python reference](http://swcarpentry.github.io/python-novice-inflammation/reference)

first goal: basic programming concepts, not much about python itself.

- basic **types**: integers `int` vs. numbers with decimals `float`,
  and their binary representations
- **dot** notation: `module.function` or `object.method`  
  *No dots in variable names!*
- python is **0-indexed** (unlike R, but like C, Perl, Java).
  index: offset from first value, or # steps  
  slice 0:4 has 0,1,2,3: 4-0=4 elements. think of it as [0-4[.  
  last index: -1, second to last: -2
- [row, column] for numpy arrays

- how to **get help**:
  * `module.<tab>`, `variable.<tab>`,
 `dir(variable)`to list available functions / methods
  * `help(function_name)` or `?function_name` or `?variable.method_name`



first: basic python interpreter, *not* the notebook

```shell
$ cd softwarecarpentry-data-python
$ python
Python 3.5.2 |Anaconda 4.2.0 (x86_64)| (default, Jul  2 2016, 17:52:12)
[GCC 4.2.1 Compatible Apple LLVM 4.2 (clang-425.0.28)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> 1+2
3
>>> quit()
$ head -n 2 inflammation-01.csv
0,0,1,3,1,2,4,7,8,3,3,3,10,5,7,4,7,7,12,18,6,13,11,11,7,7,4,6,8,8,4,4,5,7,3,4,2,3,0,0
0,1,2,1,2,1,3,2,2,6,10,11,5,9,4,4,7,16,8,6,18,4,12,5,12,7,11,5,11,3,3,5,4,4,5,5,1,1,0,1
```

python code:

```python
import numpy
numpy.loadtxt(fname='inflammation-01.csv', delimiter=',')
weight_kg = 55
weight_kg
print(weight_kg)
print('weight in pounds:', 2.2 * weight_kg)
weight_kg = 57.5
print('weight in kilograms is now:', weight_kg)
weight_lb = 2.2 * weight_kg
print('weight in kilograms:', weight_kg, 'and in pounds:', weight_lb)
weight_kg = 100.0
print('weight in kilograms is now:', weight_kg, 'and weight in pounds is still:', weight_lb)
%whos
quit()
```

last line: does not work with python, requires an "interaction" python
like ipython

```
ipython
$ ipython
Python 3.5.2 |Anaconda 4.2.0 (x86_64)| (default, Jul  2 2016, 17:52:12)
Type "copyright", "credits" or "license" for more information.

IPython 5.1.0 -- An enhanced Interactive Python.
?         -> Introduction and overview of IPython's features.
%quickref -> Quick reference.
help      -> Python's own help system.
object?   -> Details about 'object', use 'object??' for extra details.

In [1]: 1+2
Out[1]: 3

In [2]: 3*5
Out[2]: 15

In [3]: quit()
$
```

now let's use the jupyter lab (notebook otherwise).
ipython notebook #1: [download](../assets/python/swcarpentry1.ipynb)
or [view](https://github.com/cecileane/computingtools/blob/gh-pages/assets/python/swcarpentry1.ipynb)

to use it:

- save it in a convenient folder, such as in the same folder where
  you got the software carpentry data for this module
- from this directory, run: `jupyter notebook`, which will open
  a browser. Alternatively, install `jupyterlab` like this:
  `conda install -c conda-forge jupyterlab`, then run jupyter like this:
  `jupyter lab` (has many more features than the "notebook").

about jupyter:

- [blog](http://arogozhnikov.github.io/2016/09/10/jupyter-features.html?utm_content=bufferb0c6b&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer) showing lots of features of IPython notebooks, like key bindings.
- can run many many more "kernels" than just Python --like Julia
- integrate a shell, editor for notebooks, kernels, etc.
- learn key shortcuts to talk to jupyter


---
[previous](notes1018.html) & [next](notes1025.html)
