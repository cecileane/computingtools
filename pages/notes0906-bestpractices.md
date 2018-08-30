---
layout: page
title: best practices
description: notes, links, example code and exercises
---
[previous](notes0906.html) & [next](notes0906-intro-shell.html)

---

from [Wilson et al. 2014](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745):

1. Write programs for people, not computers
    - A program should not require its readers to hold more than a handful of facts in memory at once
    - Make names consistent, distinctive, and meaningful
    - Make code style and formatting consistent
2. Let the computer do the work
    - Make the computer repeat tasks
    - Save recent commands in a file for re-use
    - Use a build tool to automate workflows
3. Make incremental changes
    - Work in small steps with frequent feedback and course correction
    - Use a version control system
    - Put everything that has been created manually in version control
4. Don't repeat yourself (or others)
    - Every piece of data must have a single authoritative representation in the system
    - Modularize code rather than copying and pasting
    - Re-use code instead of rewriting it
5. Plan for mistakes
    - Add assertions to programs to check their operation
    - Use an off-the-shelf unit testing library
    - Turn bugs into test cases
    - Use a symbolic debugger [interactive program inspector]
6. Optimize software only after it works correctly
    - Use a profiler to identify bottlenecks
    - Write code in the highest-level language possible
7. Document design and purpose, not mechanics
    - Document interfaces and reasons, not implementations
    - Refactor code in preference to explaining how it works
    - Embed the documentation for a piece of software in that software [plus documentation generator]
8. Collaborate
    - Use pre-merge code reviews
    - Use pair programming when bringing someone new up to speed and when tackling particularly tricky problems
    - Use an issue tracking tool

Python example (from [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do))

```python
EPS = 0.00001 # a small number to use when comparing floating-point values

def add(x, y):
    """Add two things together."""
    return x + y

def test_add():
    """Test that the add() function works for a variety of numeric types."""
    assert(add(2, 3) == 5)
    assert(add(-2, 3) == 1)
    assert(add(-1, -1) == -2)
    assert(abs(add(2.4, 0.1) - 2.5) < EPS)
```

Which best practices are shown here?


### Good enough practices in scientific computing

for all researchers more generally:
[Wilson et al. 2017](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005510)
on data management, programming, collaborating with colleagues,
organizing projects, tracking work, and writing manuscripts.

---
[previous](notes0906.html) & [next](notes0906-intro-shell.html)
