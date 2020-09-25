---
layout: page
title: intro to python
description: course notes
---
[previous](notes1018.html) &
[next](notes1025.html)

---


- [install python](pythoninstallation.html) first
- "Programming with Python" from the
[software carpentry workshop](http://swcarpentry.github.io/python-novice-inflammation/):
  * [setup](https://swcarpentry.github.io/python-novice-inflammation/setup.html)
    to download the data
  * sections:
    1. [python fundamentals](https://swcarpentry.github.io/python-novice-inflammation/01-intro/index.html)
    2. [analyzing patient data](https://swcarpentry.github.io/python-novice-inflammation/02-numpy/index.html)
    3. [visualizing tabular data](https://swcarpentry.github.io/python-novice-inflammation/03-matplotlib/index.html)
    <!-- through paragraph "not all functions have input" -->
  * software carpentry's
    [python reference](http://swcarpentry.github.io/python-novice-inflammation/reference)

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
cd swc-python/data
$ python # or `winpty python` for git bash users on Windows
Python 3.8.3 (default, Jul  2 2020, 11:26:31)
[Clang 10.0.0 ] :: Anaconda, Inc. on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> 1+2
3
>>> quit() # or just type ^D: control and D at the same time
$ head -n 2 inflammation-01.csv
0,0,1,3,1,2,4,7,8,3,3,3,10,5,7,4,7,7,12,18,6,13,11,11,7,7,4,6,8,8,4,4,5,7,3,4,2,3,0,0
0,1,2,1,2,1,3,2,2,6,10,11,5,9,4,4,7,16,8,6,18,4,12,5,12,7,11,5,11,3,3,5,4,4,5,5,1,1,0,1
```

The integrated terminal is great in VS Code,
to send commands from a file to the terminal smoothly.

```shell
touch myscript.py
code myscript.py
```

then within VS Code:
- install the python extension
  (you may need to click on 'reload' VS Code),
- select your Python interpreter: see it on the status bar near the bottom left,
  click to see option & pick the conda installation
- write your python code in file `myscript.py`,
- open the command palette (Ctrl+Shift+P on Linux, Command+Shit+P on Mac),
- write and click 'Python: Start REPL' to start `python`
- then send your commands from your script file to be executed
  with Shift-Enter.

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

`%whos`: does not work with a basic python,
requires an "interactive" python like ipython

```
$ ipython
Python 3.8.3 (default, Jul  2 2020, 11:26:31)
Type 'copyright', 'credits' or 'license' for more information
IPython 7.16.1 -- An enhanced Interactive Python. Type '?' for help.

In [1]: 1+2
Out[1]: 3

In [2]: 3*5
Out[2]: 15

In [3]: weight_kg = 100.0

In [4]: %whos
Variable    Type     Data/Info
------------------------------
weight_kg   float    100.0

In [5]: quit()
```

### jupyter notebooks

<!-- ipython notebook #1: [download](../assets/python/swcarpentry1.ipynb) -->

- fantastic for data analysis projects, to do an analysis then
  to share with collaborators & show to stakeholders: a notebook contains
  * code
  * output, including graphs
  * any comments and text, formatted with markdown syntax

- **not** good for python functions or for python code that will
  need to be re-used, such as for a script. For example,
  if you write code to parse some input file & create an output file
  with a different format, this code might need to be called
  as a script to be applied many times to many files.
  Then, it's best to use a basic python intepreter (not a notebook)
  to develop and test this code.

ways to use notebooks:

1. straight with `jupyter notebook`,
  which will open a new window in your browser.
  when done, type `^C` in your terminal to shut down the notebook.
2. integrated in a larger enviroment,
   for many more features than the "notebook":
   * install `jupyterlab` like this:
     `conda install -c conda-forge jupyterlab`, then
   * run jupyter with `jupyter lab`
   * when done, type `^C` in your terminal to shut down the lab.
3. within VS Code with the "Python extension". It's pretty seamless,
   no browser, no `^C` at the end, integrated in the same environment
   with other files in the project: I recommend it.

about jupyter:

- [blog](http://arogozhnikov.github.io/2016/09/10/jupyter-features.html?utm_content=bufferb0c6b&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer) showing lots of features of IPython notebooks, like key bindings.
- for **Ju**lia **Py**thon and **R**
- can run many more "kernels" than just Python --like Julia
- integrate a shell, editor for notebooks, kernels, etc.
- learn key shortcuts to talk to jupyter


---
[previous](notes1018.html) &
[next](notes1025.html)
