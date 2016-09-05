---
layout: page
title: 12/8 notes
description: course notes
---
[previous](notes1206.html) & [next](notes1215.html)

---

## homework

install some Julia packages: from within Julia, do

```julia
Pkg.add("RCall")
Pkg.add("Gadfly")
Pkg.add("DataFrames")
Pkg.add("RDatasets")
```

## introduction to Julia (con't)

jump to:

- type [stability](#type-stability)
- [syntax](#syntax-overview) overview: functions, docstrings, tests, loops,
  list comprehension
- abstract [types](#types)
- using [packages](#using-packages)
- read & write to [files](#using-files) --with regular expression example
- running [external programs](#running-external-programs)
- [scope](#scope-of-variable-names) of variables

### type stability

- a variable keeps the same type throughout
- a function returns an output with the same type for all input of a given type

crucial to make your code fast: compilation can be more efficient.
example from [here](http://www.johnmyleswhite.com/notebook/2013/12/06/writing-type-stable-code-in-julia/):

```julia
function sumofsins1(n::Integer)  
    r = 0  
    for i in 1:n  
        r += sin(3.4)  
    end  
    return r  
end  
```
version 2 with `r` initialized at `0.0`:

```julia
function sumofsins2(n::Integer)  
    r = 0.0  
    for i in 1:n  
        r += sin(3.4)  
    end  
    return r  
end
```

let's use these functions, check output type:

```julia
sumofsins1(0)
typeof(sumofsins1(0))
sumofsins1(1)
typeof(sumofsins1(1))
typeof(sumofsins2(0))
```

and compare their running time:

```
@time sumofsins1(100_000)
@time sumofsins2(100_000)

@time [sumofsins1(100_000) for i in 1:1000]
@time [sumofsins2(100_000) for i in 1:1000]
```

Julia has tools to diagnose type instability problems:

```julia
@code_warntype sumofsins2(3)
@code_warntype sumofsins1(3)
```

### syntax overview

docstring before the function:

```julia
"""
foo(x)

calculate x+1
"""
function foo(x)
  return x+1
end
```

`if` statements for tests:

```julia
x=5; y=6.2
if x>6 || y>6
  println("x or y is >6")
end
x>6 || error("x is not greater than 6: can't continue")
x>6 || warn("oops, x not >6, is this normal?")
x>6 && info("checked: x is greater than 6")

function test(x,y)
  if x ≈ y # type \approx then TAB. Same as isapprox(x,y).
    relation = "(approx) equal to"
  elseif x < y
    relation = "less than"
  else
    relation = "greater than"
  end
  println(x, " is ", relation, " ", y, ".")
end
test(x,y)
1.1+0.1 == 1.2
test(1.1+0.1, 1.2)

isxbig = x>3 ? "yes" : "no" # ternary expression: very short if/else
```

flow control with loops:

```julia
for i in 1:10^9 # this a Range object: very small
  println("i=",i)
  if i<3
    continue
  end
  # above, same as: i<3 && continue
  println("\t2i=", 2i) # * not needed
  i<6 || break
end
i # not defined!!
nmax=100_000
n=0
while n<nmax
  print("n=",n,"\r") # \r to "return carriage" only: re-write on same line
  n += 1
end
```

list comprehension:

```julia
paramvalues = [10.0^i for i in -3:2]
[v^2 for v in paramvalues if v >= 0.1]
h = Dict("xtolrel"=>0.01, "xtolabs"=>0.001, "Nfail"=>50)
h["xtolrel"]
[h[k]*2 for k in keys(h)]
[a * 10.0^i for i in -3:2 for a in [1,2]] # 1-dim
[a * 10.0^i for i in -3:2,    a in [1,2]] # 2-dim
```

### types

abstract types are used to define broader classes,
see this [figure](https://commons.wikimedia.org/wiki/File:Type-hierarchy-for-julia-numbers.png)
from [here](https://en.wikibooks.org/wiki/Introducing_Julia/Types):

```julia
Int64 <: Integer # Int64 is concrete, Integer is abstract: no object of type Integer per se
Float32 <: AbstractFloat
Integer <: Number
isa(3, Int)
isa(3, Integer)
isa(3, Float64)
isa(3, AbstractFloat)
isa(3, Number)
```

### using packages

```julia
using DataFrames
using Gadfly # for plots
using RDatasets # to import data sets defined in R packages

iris = dataset("datasets", "iris")
head(iris)
ncol(iris)
nrow(iris)
describe(iris)
iris[:,5] # 5th column
iris[5]   # works too
iris[:Species] # by name
plot(iris, x=:SepalLength, y=:SepalWidth, color=:Species, Geom.point)
plot(iris, x=:SepalLength, y=:SepalWidth, color=:Species,
     label= :Species, Geom.point, Geom.label)
```

other cool packages:

- [MixedModels](https://github.com/dmbates/MixedModels.jl), like lme4 in R
- [RCall](https://github.com/JuliaInterop/RCall.jl) -- see
Doug Bates's [video](https://youtu.be/oOd3JnEm3c8?list=PLP8iPy9hna6SQPwZUDtAM59-wPzCPyD_S)
from his talk at JuliCon 2016, on "Julia and R"
- [Interact](https://github.com/JuliaLang/Interact.jl) with `@manipulate` macro
  to make interactive graphs with sliders: demo by William Sparks

### using files

```julia
f = open("newfile.txt", "w") # f = stream, or file handle
write(f, "hello\n")
close(f)
```

better: use `do` block to close the file even if
an error occurred with what you do with it
(similar to `with open() as` in Python):

```julia
open("newfile.txt", "a") do f
  write(f, "world!\n")
end
```

tools to read a file (from file handle/stream `f`):

- `readlines(f)` creates a full array
- `eachline(f)` iterates over lines
- `read(f)` to read a single character

```julia
open("newfile.txt") do f # open for reading by default
  for line in eachline(f)
    line = strip(line)
    m = match(r"([lw]+)o", line)
    if m != nothing
      print(m.match, ": ", m.captures[1],"\n")
    end
  end
end
```

note: example of regular expression above: `r"([lw]+)o"`
of type `Regex` (unlike in Python).

### running external programs

backticks, and functions `run`, `readstring` and `pipeline`:

```julia
a = `date +%B` # of type Cmd
m = run(a) # does not capture output
m
m == nothing
m = readstring(a) # captures output as string
m
run(`ps -u ane | grep jupyter`)            # error
run(pipeline(`ps -u ane`, `grep jupyter`)) # pipe by julia. worked 2nd time, not 1st. why??
```

to call a Julia script from the shell:
[ArgParse](http://argparsejl.readthedocs.io/en/latest/argparse.html) package
to pass command-line arguments to the script.
usage/behavior similar to the `argparse` Python module.

### scope of variable names

- (hard) local inside functions and type definitions
- soft local inside `for` & `while` blocks, list comprehensions, `try/catch`:

before trying this below, `quit()` and re-open Julia.

```julia
for i in 1:10
  newvar = i
end
i
newvar
i=5
for i in 1:10
  newvar = i
end
i
newvar
for i in 1:10
  global newvar = i
end
newvar
```

### cool functions

`@show` macro: very useful to debug scripts.

```julia
a=Array{Int8}(3,4)
a[2,4]=18; a[1,2]=18
@show a;
```

`findin`, `findfirst`, `map!`, `map`

```julia
findin(a, 18)
findfirst(a,18)
map(x->2x, a)
a
map!(x->2x, a) # possible InexactError
map!(x->x-3, a)
b = Array{Int64}(3,4)
map!(x->2x, b, a)
```

`less`: to see the julia code for a function

```julia
a = [12,4,68]
pop!(a)
a
less(pop!, (Array{Int,1},) ) # function name, tuple of argument types
```

This last line opens the pager "less" to view the file where
the code is defined, for the particular function on the particular types
of input. also shows file name & path.

<!--
things I would have liked to cover with Julia:
- try/except/finally and their scope
- create new exceptions
- class inheritance

**fixit**: at end of semester, look back at older hw and projects,
to see that it's hard to look at one's own code just 1 month later.
-->

---
[previous](notes1206.html) & [next](notes1215.html)
