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
  If you see that you have version 2.x (like 2.7.10), then you will need
  to install python 3.

- follow instructions from
  [software carpentry](https://uw-madison-datascience.github.io/2020-08-17-uwmadison-swc/#python),
  with Anaconda. Make sure to choose **python 3.x** and not Python 2.7.
  Read below if you want a lighter installation that uses less memory.

- test that the installation worked,
  by checking which version you have, and checking that
  you can import the `numpy` package, for instance:

  ```shell
  $ python --version
  Python 3.7.0
  $ python
  >>> import numpy
  >>> quit()
  ```

  If you don't get anything or not a python 3.x version, exit your shell,
  open it again, and try `python --version` again.
  Also do `conda list` to see what conda installed for you.

- to update, later: `conda update conda` to update the package manager,
  then `conda update python` to update python,
  then `conda update anaconda` to update packages that are shipped
  with anaconda.

- Anaconda installs for you several things: the conda package manager,
  python, ipython notebook, and many python libraries like numpy and scipy.
  (minimum 3 GB disk space required). If you want a lighter installation,
  install [miniconda3](http://conda.pydata.org/miniconda.html) instead. It gets you python 3 and the [conda](http://conda.pydata.org/docs/intro.html)
  package manager. With conda you can install all these other packages later:
  as you need them. For instance, the numpy library would
  be installed with: `conda install numpy`.
  The [jypyterlab](https://github.com/jupyter/jupyterlab) package could be
  installed from the [conda-forge](https://conda-forge.github.io) channel with:
  `conda install -c conda-forge jupyterlab`.  
  If you installed miniconda instead of anaconda, do a
  [test drive](https://conda.io/docs/user-guide/getting-started.html).

<!--
- jupyter: some students using Bash (Ubuntu) on Windows had errors running jupyter.
  This Windows [bug report](https://github.com/Microsoft/BashOnWindows/issues/185)
  has a fix that worked for some:
  `conda install -c jzuhone zeromq=4.1.dev0`
-->

next: [intro to python](notes1020.html)
