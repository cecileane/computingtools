---
layout: page
title: intro to julia, con't
description: course notes
---
[previous](notes1206-juliapackages.html) &
[next](notes1205.html)

---


jump to:

- [syntax](#syntax): for functions, docstrings, tests, loops
- [scope](#scope-of-variable-names) of variables
- [list comprehensions](#list-comprehension)
- type [stability](#type-stability): for more faster code
- read & write to [files](#using-files)
- [regular expressions](#regular-expressions)
- running [external programs](#running-external-programs)
- how to be more [efficient](#how-to-be-more-efficient) with memory
- [finding things](#finding-things) in arrays

## syntax

docstring *just* before the function (nothing else in between):

```julia
"""
foo(x)

calculate x+1
"""
function foo(x)
  return x+1
end
?foo
```

`if` statements for tests:

```julia
x=5; y=6.2
if x>6 || y>6
  println("x or y is >6")
end
x<6 && @debug "message to help debug: x is less than 6"
x<6 && @info "checked: x is less than 6"
x>6 || @warn "oops, x not >6, is this normal?"
x>6 || @error "oops, x<=6. error, but not fatal (under standard logging level)"
x>6 || error("x is not greater than 6: can't continue")

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

isxbig = x>3 ? "yes" : "no"   # ternary expression: very short if/else
isxbig = (x>3 ? "yes" : "no") # same
isxbig = x>3 # don't do (test ? true : false)
```

flow control with loops:

```julia
for i in 1:10^9 # this a Range object: very small
  println("i=",i)
  if i<3
    continue
  end
  # above, same as: i<3 && continue
  println("\t2i=", 2i) # * not needed between 2 and i
  i<6 || break
end
i # not defined
```

related to logging macros `@debug` etc.,
`@show`: very useful to debug scripts

```julia
a = [0 18 0 0; 0 0 0 18]
@show a;
```

## scope of variable names

example above: `i` was local to the `for` loop,
so undefined after we exited the loop.

```julia
while true
  n = 1
  @show n
  break
end
n # undefined: was local to `while`, unknown outside
for n in 1:2
  newvar = n
  @show n
end
n      # undefined: was inside `for` only
newvar # undefined

nmax=10_000
n=0 # in REPL: n is in our main's global scope
while n<nmax
  print("n=",n,"\r") # \r to "return carriage" only: re-write on same line
  n += 1 # n, from the outside scope, can be modified inside loop
end
n # 10000
```

- global scope: main session (REPL) or module
- local scope: inside functions, list comprehension
  `for`, `while`, `try/catch/finally`, type definitions
- `if` statements: **no** new scope

local scopes cannot modify a variable in a global scope  
unless explicitly said to do so with `global`:
but this bad practice -- *don't* do it! example below.

```julia
n = 10_000
function foo(n)   # "n" binds to new local variable
  function bar(x) # bar has access to `n` from foo, outside of bar
    n += x        # and can even modify it
  end
  bar(5)
  @show @isdefined x # x undefined outside of `bar`
  y = 3
  @show n
  return nothing
end
foo(200)
n # global variable: old value 10_000
y # undefined: was inside `foo`

function foo(n)
  # "n" binds to new local variable
  function bar(x)
    global n += x # will modify global "n", not "n" local to `foo`
    @show n
  end
  @show n
  bar(5) # shows value of global n
  @show n
  return nothing
end
foo(200) # n = 200 before bar, n = 10005 during bar, n = 200 after bar
n # 10005: modified by bar, not by foo directly
```
conclusion: don't use `global` variables within functions.

tricky: `for i in xxx` creates a new local binding for `i`,  
but an assignment `i=value` doesn't always

```julia
j=50
for j in 1:3 # j local to loop: because binding defined by comprehension
  @show j
end
j # 50

j=50
for u in 1:3 # u local
  j=u        # j from outside of loop this time: because assigned a value
  @show j
end
j # 3
```

<!-- Warning: behavior above is because REPL. Same behavior in non-interactive
session so long as these snippets are within a function (see notes/scope.jl).
Different behavior if snippets in a file, outside of any other local scope -->

## list comprehension

same as in Python, except for last example below: we can build a matrix

```julia
i = 50
paramvalues = [10.0^i for i in -3:2] # new local scope for i
i # still 50: phew!
[v^2 for v in paramvalues if v >= 0.1]
h = Dict("xtolrel"=>0.01, "xtolabs"=>0.001, "Nfail"=>50)
h["xtolrel"]
[h[k]*2 for k in keys(h)]
[a * 10.0^i for i in -3:2 for a in [1,2]] # 1-dim
[a * 10.0^i for i in -3:2,    a in [1,2]] # 2-dim
```

## type stability

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

```julia
@time sumofsins1(10);
@time sumofsins2(10);

using BenchmarkTools
@benchmark sumofsins1(10) # mean time: 12.332 ns
@benchmark sumofsins2(10) # mean time:  1.755 ns
```

such an easy fix to make the function 7 times faster:
just initialize `r=0.0` instead of `r=0` here!!  
Julia has tools to diagnose type instability problems:

```julia
@code_warntype sumofsins1(3)
@code_warntype sumofsins2(3)
```

## using files

open with "w"rite permission:

```julia
f = open("newfile.txt", "w") # f = stream, or file handle
write(f, "hello\n")
close(f)

typeof(f)       # IOStream
isa(f, IO)      # true. IO for Input - Output
typeof(stdout)
isa(stdout, IO) # true
write(stdout, "hello\n"); # writes to stdout. return the number of bytes written
```

better: use `do` block to close the file even if
an error occurred with what you do with it
(similar to `with open() as` in Python):

```julia
open("newfile.txt", "a") do g # "a" to append
  write(g, "world!\n")
end
typeof(g) # g undefined
```

look at our new file, in shell mode:
```julia
shell> cat newfile.txt
hello
world!

```

(More generally, `do` blocks provide a way to define a complex
anonymous function with the usual nice syntax,
and pass this anonymous function as argument to another function.
Here our anonymous function writes "world!\n", and is passed
to `open(function, file_name, arguments...)`)

tools to read a file (from file handle/stream `f`):

- `readlines(f)` creates a full array
- `eachline(f)` iterates over lines
- `read(f)` to read a single character

```julia
open("newfile.txt") do f # open for reading by default
  for line in eachline(f)
    line = strip(line) # strips "line" from spaces on both ends
    m = match(r"([lw]+)o", line) # regular expression: see below
    if m !== nothing
      print(m.match, ": ", m.captures[1],"\n")
    end
  end
end
```

## regular expressions

used above: `r"([lw]+)o"` of type `Regex` (unlike in python)  
main functions: `occursin`, `match`, `replace`

```julia
typeof(r"([lw]+)o")
m = match(r"([lw]+)o", "Hello world") # first match only, if any
m.match    # what matched: llo
m.captures # what was captured in between parentheses: ll
m = match(r"([lw]+)o", "Ho")
m === nothing # no match
occursin( r"([lw]+)o", "Hello world") # true or false
m = match(r"([lw]+)o", "Hello world", 7)  # start search at index 7
m = match(r"([lw]+)o"i, "HelLo world", )  # case Insensitive
m = match(r"([lw]+)[lo]",  "Hello world") # greedy:     llo
m = match(r"([lw]+?)[lo]", "Hello world") # non-greedy: ll
```
to search for all matches:
```julia
for m in eachmatch(r"([lw]+)([lo])", "Hello world")
  @show m
  @show m.captures # what was captured in between ()
  @show m.offsets  # where each captured thing starts
  println()
end
```
if we only want to know the number of matches and where they start:
```julia
[m.offset for m in eachmatch(r"[lw]+[lo]", "Hello world")]
```

to search & replace:
```julia
replace("I love python", "python" => "julia")
replace("Hello world", r"([lw]+)([lo])" => s"\2\1" )
typeof(s"\2\1") # SubstitutionString{String}
```

to inspect an object of unfamiliar type:
```julia
nfields(m)
fieldnames(typeof(m))
dump(m) # could be too much, or too cryptic
```

## running external programs

backticks, and functions `run`, `read` and `pipeline`:

```julia
a = `date +%B`
typeof(a)  # Cmd
m = run(a) # does not capture output
m          # Process
m = read(a) # captures output as an array of bytes. byte 0x4e is 0100 1110
m
String(m)
run(`ps -u ane | grep julia`)             # error: | illegal
run(pipeline(`ps -u ane`, `grep julia`)); # pipe by julia. output not captured
run(pipeline(`ps -u ane`, `grep julia`, "outfile"));
```
check with `cat outfile` in shell mode

to redirect the stdout and stderr streams separately,
we need to combine all commands together:
```julia
run(pipeline(pipeline(`ps -u ane`, `grep julia`),
             stdout="outfile", stderr="errfile"));
```

check with `cat outfile` and `cat errfile` in shell mode

to call a Julia script from the shell:
[ArgParse](http://argparsejl.readthedocs.io/en/latest/argparse.html) package
to pass command-line arguments to the script.
usage/behavior similar to the `argparse` Python module.

## how to be more efficient

whenever possible: **re-use memory**. why?
- decrease memory usage and
- reduce running time, by reducing garbage collection time ("gc time" below):

note the difference beween `a = ...` and `a[:]=...` or `a .= ...`
```julia
a = Int8[0 18 0 0; 0 0 0 18]
b = a
a = [1 2 3 4; 5 6 7 8]
b # has not changed: new memory was allocated for "a" above
b = a
a[:] = [0 0 0 0; 2 2 2 2]
b # b has changed: memory for "a" was reused above
a .+= 1
b # b has changed: .+= re-uses memory
a .= [10 20 30 40; 50 60 70 80]
b # b has changed: .= re-used memory (vectorized = assignment, term by term)
```
`.+=` and `.=` reuse memory for `a` despite not using `a[:]`
because vectorized operation

`@view`: to access memory without copying values

```julia
@view a[:,3] # 3 columns, same memory as in a: values are NOT copied
fill!(view(a, :, 3), 0)
a
b # both a and b have changed: the view used the original memory
```

`map!`, `map`

```julia
map(x->2x, a)
a # no change
map!(x->2x, a, a)
a # was modified in-place
b = Array{Int64}(undef,3,4) # too big for a
map!(x->2x, b, a)
b # sub-matrix was modified in-place
a # intact
```

use "bang" functions whenever possible & appropriate.
example:

```julia
function foo(n)
  a = rand(n)
  b = sort(a)
  c = reverse(b)
  d = round.(c, digits=2)
  e = unique(d) # 5 separate arrays total. only the last one is returned
  return e
end
function foo!(n)
  a = rand(n)
  sort!(a)
  reverse!(a)
  map!(x -> round(x, digits=2), a, a)
  unique!(a) # the same memory slots are used 5 times
  return a
end
using Random
Random.seed!(1234); res1 = foo( 5)
Random.seed!(1234); res2 = foo!(5)
res1 ==  res2  # true: these 2 vectors have the same values
res1 === res2 # false: these 2 vectors don't "point" to the same address

@time foo( 1000); # 0.000072 seconds (21 allocations: 37.828 KiB)
@time foo!(1000); # 0.000058 seconds (1 allocation: 7.938 KiB) # about 5 times less memory used
using BenchmarkTools
@benchmark foo( 1000) # mean time: 55.573 μs (7.77% GC)
@benchmark foo!(1000) # mean time: 45.190 μs (1.16% GC)
```

note the lower time spent "garbage collecting" (GC)
and the lower memory usage (fewer KiB) by `foo!`.

## finding things

`findall`, `findfirst`, `findnext`, `findmax!`, `findlast`

```julia
b = [false,true,false,true,true]
findall(b)   # vector of indices
findfirst(b) # index or `nothing`
b = zeros(Bool,5)
findall(b)   # found nothing: vector of length 0
c = findfirst(b) # found `nothing`
isnothing(c)
```

works on 2d or bigger arrays too,
and to find other things than `true` values:

```julia
a = [20 40 0 80; 100 120 0 160]
iszero.(a)
findall(!iszero, a)
findall(x -> x==20, a)  # anonymous function x -> ...
findall(isequal(20), a) # same
findall(y -> y==4, a)   # 4 not found: empty vector
findfirst(iszero, a)
a[CartesianIndex(1,3)]
c = findfirst(x -> x==4, a)
c === nothing
```

<!--
things I would have liked to cover with Julia:
- try/catch/finally and their scope
- create new exceptions
- class inheritance

**fixit**: at end of semester, look back at older hw and projects,
to see that it's hard to look at one's own code just 1 month later.
-->

---
[previous](notes1206-juliapackages.html) &
[next](notes1205.html)
