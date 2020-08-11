---
layout: page
title: Course Description
description: learning objectives, topics, requirements
---

target audience
---------------

This course will be taught for entry-level graduate students in Statistics (MS and PhD),
as well as motivated PhD students in the biological sciences.
<!-- and advanced undergraduates majoring in Statistics.-->
Students will benefit most from taking this course at the beginning of their graduate program,
to use these tools for their research, during their time at UW-Madison and beyond.
Only basic statistical knowledge will be assumed.

learning objectives
-------------------

Acquire a strong basis for carrying out computations for graduate research or on the job.
More specifically, learn to

- do computations efficiently: possibly handling very large data sets
- do computations automatically: using scripts to repeat tasks (and avoid manual errors)
- build and manage a computing project reproducibly: by oneself or by others
- build and manage a computing project collaboratively: share work with a version control system
- demonstrate ability to adapt to change in computing platforms.

These skills are essential to Statistics graduate students.
They are also becoming essential to a growing number of biology PhD students who need to
analyze very large data sets using command-line pipelines created by others,
and to collaborate on these analyses with peer lab members.

Change is constant now. New computing tools appear constantly.
Assets for successful adaptation include an understanding of computing concepts
shared across platforms and programming languages,
and a mastery of several programming languages.
Students will build confidence in their adaptability,
from the experience of learning a new language rapidly drawing on known concepts.


tools and topics
----------------
(subject to change)

- the shell: power of command lines to interact with a machine
- version control and collaboration: git and [GitHub](https://github.com)
- [best practices for scientific computing](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745)
- scripting: bash/zsh, Python and
  [Julia](http://julialang.org)

hardware requirements
---------------------

Students will need to bring their own laptop, running either **Mac** or **Linux**.

This requirement reflects current practice in statistics, computational biology
and many other scientific research fields.
PhD students in biology experience this requirement first-hand when working with large
molecular sequence data, to run available analysis pipelines.
Computing servers in Statistics are all Linux servers.
These servers are accessible remotely, however.

Students without a computer have the following options,
none of which are recommended nor supported:

- Buy an Intel-based [chromebook](http://www.google.com/chromebook/) running
  [Linux](https://github.com/dnschneid/crouton).
  They start around $180, so you can consider that this in lieu of a textbook.
  I started experimenting with a chromebook, see my notes [here](chromebook.html).

- If you have a 64-bit machine running Windows 10, use the
  "Windows Subsystem for Linux". Installation instructions are
  [here](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
  "WSL 2" seems the best, to get all Linux features ("full kernel").
  Choose the "ubuntu" distribution, then follow course instructions
  as if you had a Linux machine.

- If you have an older Windows machine, install bash and a set of Unix commands.
  This will likely involve some trial-error and frustration, but see
  [here](https://uw-madison-datascience.github.io/2020-08-17-uwmadison-swc/#setup)
  to install the bash shell with git, and Python with Anaconda.
  Also install
  [Rtools](https://github.com/r-windows/docs),
  which will provide key utilities like GNU "make" and "gcc".

- Use [cygwin](http://www.cygwin.com)
  or install a desktop virtual machine like
  [Virtual Box VM](https://www.virtualbox.org/wiki/Downloads),
  but these don't work with git as well.
  Again, I will not support this option during the course.

assessments
-----------

Because one cannot master computational tools without practice or without
trouble-shooting errors, the course will be primarily project-based.
All the topics will be taught in the context of practical examples, and
case studies in biology.
The final project will be collaborative in groups of 3 or 4.

About grading and weights of assessment, please see the syllabus and more on
[canvas](https://canvas.wisc.edu/courses/217124)
