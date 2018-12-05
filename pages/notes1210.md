---
layout: page
title: julia types & package development
description: course notes
---
[previous](notes1209.html) &
[next](notes1215.html)

---

today: create a Julia package that implements new types

julia package: git repository  
for a good package:
- code
- tests
- license (MIT is a good one)
- documentation

Julia provides a great package manager for developers to declare
dependencies and for users to get good versions of dependencies
that work with each other, reproducibly.

## how to create a new Julia package

In pkg mode with `]`, generate the standard files for a new package
and inspect what they are:

```julia
(v1.0) pkg> generate Trees # plural: see convention for package names
Generating project Trees:
    Trees/Project.toml
    Trees/src/Trees.jl

shell> cd Trees;

shell> cat Project.toml
authors = ["Cecile Ane <cecileane@users.noreply.github.com>"]
name = "Trees"
uuid = "d3549d90-f74a-11e8-3813-3bb8358dfa17"
version = "0.1.0"

[deps]

shell> cat src/Trees.jl
module Trees

greet() = print("Hello World!")

end # module
```

Each package has its own global scope, and the package needs to have
its own environment: so we create an environment for our package.
That's how we add dependencies if our new package relies on other packages.

```julia
pkg> activate .
pkg> add StatsFuns
pkg> status
Project Trees v0.1.0
    Status `~/Documents/private/st679/newjuliapackage/Trees/Project.toml`
  [4c63d2b9] + StatsFuns v0.7.0
```

## license, readme, docs

Things should get easier when
[PkgDev](https://github.com/JuliaLang/PkgDev.jl) is upgraded
to the Julia v1.0 Pkg manager: hopefully `generate` would automatically
add a basic readme file, a licence,
and basic files for tests and documentation.

For now, the [Example](https://github.com/JuliaLang/Example.jl)
package provides a great template:
- [MIT license](https://opensource.org/licenses/MIT): great choice
- tests run on [Travis-CI](https://travis-ci.org) (you will need an account)
- documentation built via [Documenter](https://github.com/JuliaDocs/Documenter.jl)

## source code

Let's add some code to our package: all in the `src/` directory.
The main file is `Trees.jl`, but the code in this file can `include`
code from other files, to keep code organized.
For example, create `types.jl` and `treemanipulate.jl`,
which we `include` in `Trees.jl`: see on
[github](https://github.com/cecileane/Trees.jl)

types & functions in the package can be `export`ed,
but all can be used with prefix `Trees.`

to use our code:

```julia
using Trees    # reads & executes Trees.jl
tre1 = Tree()  # we could do Trees.Tree() but Tree() works because exported
addedge!(tre1, 0,1)
addedge!(tre1, 0,2, 0.22)
tre1.edge[2]
```

prefix `Trees.` for non-exported objects:

```julia
example(-1400, -1401)       # error: example() not exported
Trees.example(-1400, -1401) # okay
```

new types `Edge` and `Tree`: mutable versus non-mutable  
default constructors:

```julia
methods(Edge)   # default method and other methods as defined
Edge(18,19, missing) # uses default method
Edge(18,19, 6.9)
e = Edge(18,19) # uses extra method
e.parent
e.child
e.length
e.parent = 20   # works: because mutable
tre1
fieldnames(typeof(tre1))
tre1.foo = 20   # error: because immutable
tre1.label = Dict(1=>"human", 2=>"chimp") # error: immutable
tre1.label
push!(tre1.label, 1=>"human", 2=>"chimp")
tre1.label
tre1
```

## tests

The test suite must be in `test/runtests.jl`,
so let's create this file

```shell
mkdir test
touch test/runtests.jl
```

and then edit our `runtests.jl` file  
use testing macros `@test`, `@test_throws`, `@test_nowarn` etc.

```
using Test
@test length(tre1.edge)==2
```

To run our tests, we need extra dependencies, just for testing
(not for package users): edit the project file `Project.toml`

```toml
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

then we can run the full test suite in pkg mode:
```
(Trees) pkg> test
   Testing Trees
 Resolving package versions...
...
Test Summary:                     | Pass  Total
building trees & path to the root |   11     11
   Testing Trees tests passed
```

take the habit:
- develop a function, try it on small examples
- add these small examples in the test suite

Finally:
- push your package to github, in a repo named `Trees.jl`
  despite the fact that our folder was named `Trees`
  -- see [guidelines](https://docs.julialang.org/en/v0.6/manual/packages/#Guidelines-for-naming-a-package-1)
  for naming a package.
- if you want to make it easier for others to use your package: use
  [AttoBot](https://github.com/attobot/attobot) to register, tag and publish
  versions of your package

## other

- Profiling: to get an analysis of how much time is used by each
  function & identify the pieces of code that are the slow
  bottlenecks.  
  How: `@profile` in the [Profile](https://docs.julialang.org/en/v1/manual/profile/)
  module to generate the information, and `view` from the
  [ProfileView](https://github.com/timholy/ProfileView.jl) package
  to visualize the information in a flame graph

- Benchmarks: to track if any new changes in your code make previous
  tasks run slower or faster.  
  How: create a suite of tasks in a `benchmark/` folder and
  use [PkgBenchmark](https://github.com/JuliaCI/PkgBenchmark.jl)
  to run the suite of tasks at each commit, and compare performance
  between commits.

---
[previous](notes1209.html) &
[next](notes1215.html)
