---
layout: page
title: intro to julia, con't
description: course notes
---
[previous](notes1206-juliapackages.html) &
[next](notes1205.html)

---


jump to:

- [syntax](#syntax-overview) overview: functions, docstrings, tests, loops
- [scope](#scope-of-variable-names) of variables
- [list comprehensions](#list-comprehension)
- type [stability](#type-stability)
- read & write to [files](#using-files)
- [regular expressions](#regular-expressions)
- running [external programs](#running-external-programs)
- [misc](#cool-functions): to re-use memory, find things in arrays

## syntax overview

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
x>6 || error("x is not greater than 6: can't continue")
x>6 || @error "oops, x<=6. error, but not fatal (under standard logging level)"
x>6 || @warn "oops, x not >6, is this normal?"
x<6 && @info "checked: x is less than 6"
x<6 && @debug "message to help debug: x is less than 6"

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
  println("\t2i=", 2i) # * not needed
  i<6 || break
end
i # not defined!!
```

## scope of variable names

```julia
nmax=100_000
n=0 # in REPL: n is in our main's global scope
while n<nmax
  print("n=",n,"\r") # \r to "return carriage" only: re-write on same line
  n += 1 # error: n not defined!
end
while n<nmax
  print("n=",n,"\r") # \r to "return carriage" only: re-write on same line
  global n += 1 # error: n not defined!
end
```

local scopes cannot modify a variable in a global scope
(unless explicitly said to do so)

- global in the main session (REPL), or module
- local inside functions, type definitions,
  `for`, `while`, `try/catch/finally`, list comprehension
- `if` statements: **no** new scope

our `while` loop wanted to modify `n`, which is in our main session's
scope (global): not permitted by default.

before trying this below, quit and re-open Julia.

```julia
for j in 1:3
  newvar = j
end
j
newvar
j=5
for j in 1:3
  newvar = j
  println("j=",j)
end
j
newvar
for j in 1:3
  global newvar = j
end
j
newvar
```

we can use a variable from an outside scope, so long as
we don't modify it:

```julia
n=10
for i in 1:3
  println("i+n=",i+n) # n is used, not modified: all good
end
for i in 1:3
  n=i # triggers new variable n, local to "for" loop
  println("i=",i," and n=",n)
end
n
for i in 1:3
  n += 1 # error! no local "n" to start doing n = n+1
  println("i=",i," and n=",n)
end
function foo(n)
  # n is an argument: belongs in the function's scope, which is local
  for i in 1:3
    n += 1
    println("i=",i," and n=",n)
  end
  @show @isdefined i
  @show @isdefined n
  return(n)
end
foo(0)
```

## list comprehension

```julia
paramvalues = [10.0^i for i in -3:2]
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

```
@time sumofsins1(100_000);
@time sumofsins2(100_000);

@time [sumofsins1(100_000) for i in 1:1000];
@time [sumofsins2(100_000) for i in 1:1000];
```

Julia has tools to diagnose type instability problems:

```julia
@code_warntype sumofsins2(3)
@code_warntype sumofsins1(3)
```

## using files

```julia
f = open("newfile.txt", "w") # f = stream, or file handle
write(f, "hello\n")
close(f)
typeof(f)
```

better: use `do` block to close the file even if
an error occurred with what you do with it
(similar to `with open() as` in Python):

```julia
open("newfile.txt", "a") do g
  write(g, "world!\n")
end
typeof(g) # g undefined
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
    line = strip(line)
    m = match(r"([lw]+)o", line)
    if m != nothing
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
m = match(r"([lw]+)o", "Hello world") # first one only
m.captures
m = match(r"([lw]+)o", "Ho")
m === nothing # no match
occursin(r"([lw]+)o", "Hello world") # true or false
m = match(r"([lw]+)o", "Hello world", 7)    # start search at index 7
m = match(r"([lw]+)o"i, "HelLo world", )    # case Insensitive
m = match(r"([lw]+)[lo]", "Hello world")  # greedy
m = match(r"([lw]+?)[lo]", "Hello world") # non-greedy
```
to search for all matches:
```julia
for m in eachmatch(r"([lw]+)([lo])", "Hello world")
  @show m
  @show m.captures
  @show m.offsets
  println()
end
```
if we only want to know the number of matches and where they start:
```julia
[m.offset for m in eachmatch(r"([lw]+)([lo])", "Hello world")]
```

to search & replace:
```julia
replace("I love python", "python" => "julia")
replace("Hello world", r"([lw]+)([lo])" => s"\2\1" )
```

to inspect an object of unfamiliar type:
```julia
nfields(m)
fieldnames(typeof(m))
```

## running external programs

backticks, and functions `run`, `read` and `pipeline`:

```julia
a = `date +%B`
typeof(a)  # Cmd
m = run(a) # does not capture output
m
m == nothing
m = read(a) # captures output as an array of bytes. byte 0x4e is 0100 1110
m
String(m)
run(`ps -u ane | grep julia`)            # error: | illegal
run(pipeline(`ps -u ane`, `grep julia`)) # pipe by julia
run(pipeline(`ps -u ane`, `grep julia`));
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

## cool functions

`@show` macro: very useful to debug scripts

```julia
a=Array{Int8}(undef,2,4)
fill!(a,0)
a[2,4]=18; a[1,2]=18
a
@show a;
```

`@view` and important details to **re-use memory**

note the difference beween `a = ...` and `a[:]=...`
```julia
b = a
a = [1 2 3 4; 5 6 7 8]
b # has not changed: new memory was allocated for "a" above
b = a
a[:] = [0 0 0 0; 2 2 2 2]
b # b has changed: memory for "a" was reused above
a .+= 1
b
```
`.+=` reuses memory for `a` despite not using `a[:]`
because vectorized operation

```
@view a[:,3]
fill!(view(a, :, 3), 0)
a
b
```

`map!`, `map`

```julia
map(x->2x, a)
a
map!(x->2x, a, a)
a
b = Array{Int64}(undef,3,4) # too big for a
map!(x->2x, b, a)
b
a
```

why reuse memory? decrease memory usage and
save garbage collection time ("gc time" below):

```julia
function foo(n)
  a = rand(n)
  b = sort(a)
  c = reverse(b)
  d = round.(c, digits=2)
  e = unique(d)
  return e
end
function foo!(n)
  a = rand(n)
  sort!(a)
  reverse!(a)
  map!(x -> round(x, digits=2), a, a)
  unique!(a)
  return a
end
using Random
Random.seed!(1234); res1 = foo( 5)
Random.seed!(1234); res2 = foo!(5)
res1 == res2

@time [foo( 100) for i in 1:1000];
@time [foo!(100) for i in 1:1000];

using BenchmarkTools
@benchmark foo( 100)
@benchmark foo!(100)
```

`findall`, `findfirst`, `findnext`, `findmax!`, `findlast`

```julia
b = [false,true,false,true,true]
findall(b)
findfirst(b)
b = zeros(Bool,5)
findall(b)
c = findfirst(b)
c === nothing
```

works on 2d or bigger arrays too,
and to find other things than `true` values:

```julia
iszero.(a)
findall(!iszero, a)
findall(x -> x==1, a) # anonymous function x -> ...
findall(y -> y==4, a) # 4 not found: empty vector
findfirst(iszero, a)
a[CartesianIndex(1,3)]
c = findfirst(x -> x==4, a)
c === nothing
```

<!--
things I would have liked to cover with Julia:
- try/except/finally and their scope
- create new exceptions
- class inheritance

**fixit**: at end of semester, look back at older hw and projects,
to see that it's hard to look at one's own code just 1 month later.
-->

---
[previous](notes1206-juliapackages.html) &
[next](notes1205.html)
