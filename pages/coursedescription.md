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

Acquire a strong basis for carrying out computations for graduate research or on the job.<br>
Learn to do computations

- efficiently: possibly handling very large data sets
- automatically: using scripts to repeat tasks (and avoid manual errors)
- reproducibly: by oneself or by others
- collaboratively: sharing work with a version control system.

These skills are essential to Statistics graduate students.
They are also becoming essential to a growing number of biology PhD students who need to
analyze very large data sets using command-line pipelines created by others,
and to collaborate on these analyses with peer lab members.

Another desired learning outcome is the

- ability to adapt to change.

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
- scripting: Perl and Python
- learning a programming language: [Julia]()

hardware requirements
---------------------

Students will need to bring their own laptop, running either **Mac** or **Linux**.

This requirement reflects current practice in statistics and in computational biology.
PhD students in biology experience this requirement first-hand when working with large
molecular sequence data, to run available analysis pipelines.
Computing servers in Statistics are all Linux servers.
These servers are accessible remotely, however.

Students with a Windows machine have the following options:

- buy an Intel-based [chromebook](http://www.google.com/chromebook/) running
  [Linux](https://github.com/dnschneid/crouton).
  They start around $150-$200, so you can consider that this in lieu of a textbook.
  I will experiment with chromebooks and will report any additional advice on this,
  later in July or August.

- connect to a remote Linux server in Statistics. An important downside is the
  lack of admin (super-user) permission, which may prevent the upgrade or installation of
  necessary software.

- not recommended and not supported: install bash and a set of Unix commands on your machine.
  This will likely involve some trial-error and frustration, but see
  [here](http://uw-madison-aci.github.io/2016-06-08-uwmadison/#setup) to install
  the bash shell with git, and Python with Anaconda.

assessments
-----------

Because one cannot master computational tools without practice or without
trouble-shooting errors, the course will be primarily project-based.
All the topics above will be taught in the context of case studies in biology.
Both midterm and final projects will be collaborative in groups of 3 or 4.

- [20%] participation in class (formative assessment)
- [20%] homework exercises
- [30%] midterm project
- [30%] final project
