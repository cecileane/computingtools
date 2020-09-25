---
layout: page
title: installing python
description: python, conda, anaconda, jupyter
---

install **python 3** and the
[conda](http://conda.pydata.org/) package management
if you don't already have it.

- do `which python` and `python --version` to see if you already have python
  installed, and if so, what version you have. Versions 3.x are not
  back-compatible with version 2.x. We will work with version 3.
  If you see that you have version 2.x (like 2.7.16), then you will need
  to install python 3.

- it's easy to have python installed in many different places
  on the same machine (without knowing it).
  say one python installed with `homebrew`,
  one installed with `conda`,
  one installed with `pip`.
  and it's okay (but best to know it).
  So if you already have python 2.x on your laptop and
  follow the instructions below to get python 3.x
  with anaconda, you will have both versions:
  it's okay. You will learn how to know
  which version you use by default, and how to switch.

- follow instructions from
  [software carpentry](https://uw-madison-datascience.github.io/2020-08-17-uwmadison-swc/#python),
  with anaconda.
  * make sure to choose **python 3.x** and not Python 2.7.
  * read below on [miniconda](#miniconda)
    if you want a lighter installation that uses less memory
  * if you have a Windows machine using Linux with WSL,
    then do *not* use the software carpentry instructions:
    you need to install python in a place that your Linux subsystem can use.
    Python comes with Ubuntu, which you probably chose as your
    Linux distribution when you installed WSL: try `which python`
    and `which python3`. To install python packages, you could
    - install [conda](https://gist.github.com/kauffmanes/5e74916617f9993bc3479f401dfec7da),
      then do `conda install x` to install package `x`
    - or install [pip](https://linuxize.com/post/how-to-install-pip-on-ubuntu-20.04/)
      then do `pip install x` to install package `x`.

- test that the installation worked,
  by checking which version you have, and checking that
  you can import the `numpy` package, for instance:

  ```shell
  $ conda --version
  conda 4.8.3
  $ conda list | grep numpy  
  numpy                     1.18.5           py38h1da2735_0  
  numpy-base                1.18.5           py38h3304bdc_0  
  numpydoc                  1.1.0                      py_0
  $ which python
  /Users/ane/opt/anaconda3/bin/python
  $ python --version
  Python 3.8.3
  $ python
  >>> import numpy
  >>> quit() # or just control-D
  ```

  If you don't get anything or not a python 3.x version, exit your shell,
  open it again, and try `python --version` again.
  Also do `conda list` to see what conda installed for you.

- to update, later: `conda update conda` to update the package manager,
  then `conda update python` to update python,
  then `conda update anaconda` to update packages that are shipped
  with anaconda.

### miniconda

- Anaconda installs for you several things: the conda package manager,
  python, ipython notebook, and many python libraries like numpy and scipy.
  (minimum 3 GB disk space required). If you want a lighter installation,
  install [miniconda3](http://conda.pydata.org/miniconda.html) instead.
  Then test that your installation worked (see above).

- Miniconda gets you python 3 and the
  [conda](http://conda.pydata.org/docs/intro.html) package manager.
  With conda you can install any other packages later,
  as you need them.

- Please install the numpy library with: `conda install numpy`.

- The [jypyterlab](https://github.com/jupyter/jupyterlab) package can be
  installed from the [conda-forge](https://conda-forge.github.io) channel with:
  `conda install -c conda-forge jupyterlab`.  

- To learn how to work with conda and manage different versions of Python
  (if you come to need Python 2, for instance), read about conda
  environments in the conda
  [doc](https://conda.io/docs/user-guide/getting-started.html).

<!--
- jupyter: some students using Bash (Ubuntu) on Windows had errors running jupyter.
  This Windows [bug report](https://github.com/Microsoft/BashOnWindows/issues/185)
  has a fix that worked for some:
  `conda install -c jzuhone zeromq=4.1.dev0`
-->

next: [intro to python](notes1020.html)
