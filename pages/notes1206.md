---
layout: page
title: introduction to julia
description: course notes
---
[previous](notes1117.html) &
[next](notes1206-juliapackages.html)

---

[install](juliainstallation.html) and
jump to:

- [modes](#modes)
- [types](#types)
- [(im)mutable](#immutable-types) types
- [abstract types](#abstract-types)
- [JIT](#compiled-just-in-time-jit) compiled: fast, type declaration not needed  
  multiple "methods" for the same function
- [view](#view-source-code) source code

### modes

- help mode: type "?" in the REPL.
  goes back to julian mode right after,
  or press backspace.
- shell mode: type ";".
  goes back to julian mode right after (or press backspace)
- package mode: type "]"; press backspace to go
  back to julian mode
- R mode (kinda): type "$", `using RCall` package.
  backspace to go back to julia mode.

many [key bindings](https://docs.julialang.org/en/v1/stdlib/REPL/#Key-bindings-1)
e.g. arrows for history,
start a command then arrows for historical commands
starting the same way,
`^D` to exit.

### types

- `Bool`: `true` and `false`
- `String` (double quotes) and `Char` (single quotes)
- floating point numbers: `Float16`, `Float32`, `Float64`;
  `Float` depends on the machine
- integers: `Int8`, `Int16`, `Int32`, `Int64`, `Int128`;
  `Int` depends on the machine
- unsigned (positive) integers: `UInt8` etc.
- arrays: somewhat like lists in Python
- tuples: like in Python, e.g. `(3,)` or `(3,"hohoho")`
- Vector (Matrix): shortcut for 1-dimensional (2-dimensional) array
- dictionaries: `Dict`

```julia
typeof(3)
Int
typeof(3.0)
typeof("hello")
a=[10,6,3,2] # Array{Int64,1}: 1-dimensional array, contains Int64 values
a[1]
push!(a,5)
push!(a,5.0) # converted 5.0 to Int to maintain type of "a"
push!(a,5.1) # error
convert(Array{Float64,1}, a) # new object
b = [1,6,3.0,2] # Array{Float64,1}: 1-dimensional, values converted to Float64
push!(b,5.1) # no problem
push!(b, "hello") # error
splice!(b,2:3)
b
c = ["hello", 3, "world", 5.1] # Array{Any,1}: contains anything possible
Vector{Int}
UInt8(4)
UInt8[8,9,10,11]
d = [1 2 3; 6 7 8] # 2-dimensional array, 2*3. note syntax
h = Dict("blue"=>10, "green"=>20)
```

julia is **1-indexed** (unlike Python, like R)  
convention: functions with a bang `!` modify one or more of their arguments.
Respect it!

```julia
b = [1,6,3,2]; # ; suppresses screen output
sort(b)
b
sort!(b) # same return value
b
pop!(b) # no pop() function
```

how to initialize arrays:

```julia
Vector{Float64}(undef, 3) # uninitialized
Vector{Union{Missing, Int}}(missing, 3)
Array{Float64}(undef, 3)  # uninitialized
a = Array{Int8,2}(undef, 3,4) # 2-dimensional array: 3x4
similar(a) # uninitialized
zeros(3) # Float by default
ones(3)
zeros(Int,3)
zeros(Bool,3)
```

see limits [here](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/)
and mind them, because potential errors otherwise:

```julia
x=2^63-1 # upper limit for Int64: 1 bit for sign and 63 bits of 1
typemax(Int64)
x*2      # wrong! overflow
```
quasi-object-oriented: new types can be defined.  
types have fields, but no methods: functions have multiple methods instead
--more below.

### (im)mutable types

mutable: arrays, composite types (typically)  
immutable: numbers, tuples, strings

### abstract types

abstract types are used to define broader classes,
see this [figure](https://commons.wikimedia.org/wiki/File:Type-hierarchy-for-julia-numbers.png)
from
[here](https://en.wikibooks.org/wiki/Introducing_Julia/Types#Type_hierarchy):

```julia
Int64 <: Integer # Int64 is concrete, Integer is abstract: no object of type Integer per se
supertype(Int)
supertype(Signed)
subtypes(Signed)
subtypes(Integer)
Float32 <: AbstractFloat
Integer <: Number
isa(3, Int)
isa(3, Integer)
isa(3, Float64)
isa(3, AbstractFloat)
isa(3, Number)
```

any object must have a concrete type

### compiled just-in-time (JIT)

<!-- example below from Steven Johnson's [video](https://www.youtube.com/watch?v=jhlVHoeB05A&list=PLYx7XA2nY5GfavGAILg08spnrR7QWLimi)
of his talk at EuroSciPy 2014 (1h11)
-->

```julia
function addone(x)
  return x+1
end

addone(x) = x+1 # one-line form
```

let's use this function on various inputs:

```julia
addone(3)   # compiles addone for Int argument
addone(7)   # re-use compiled addone(Int)
addone(7.2) # compiles a different version for Float64 arguments
code_llvm(addone, (Int,)) # inspect generated code
code_llvm(addone, (Float64,))
code_native(addone, (Int,))
code_native(addone, (Float64,))
```

by the way, we can vectorize a function by addind a `.` just before
the opening parenthesis, or just before the symbol for `+` etc.:
```julia
addone.([1,2,7,9])
addone.([1 2; 6 7])
[1,5,9] .+ 3
log.([1,2.71,10])
log.(10,[1,2.71,10]) # 10 recycled: all logs in base 10
log.([2,10], [4,10])
```

Julia uses the type of the arguments to infer which compiled version to run:
multiple dispatch

- makes it really [fast](https://julialang.org/benchmarks/)
- rare need to declare input types:

```julia
function addone(x::Number)
  return x+1
end
methods(addone)
addone(3.5)
addone([1 2; 6 7]) # error
addone.([1 2; 6 7])
```

better and no penalty because different
compiled versions for different input types anyway:

```julia
function addone(x) # no type declaration. re-defining
  return x+one(x)  # one(x) = identity element for * of same type as x
end
methods(addone)
addone(3.5)
addone([1 1; 1 1])  # matrix-wise operation
addone.([1 1; 1 1]) # element-wise operation

function addone(x::String)
  return x * " one"
end
methods(addone)
addone("take")
"take" * one("take")  # the go-to method is not used
one("take") # identity for * on strings is empty string "", not "one"
addone.(["take","make","share"])
```

### view source code

`less`: to see the julia code for a function (in a package):
need to ask for a specific method using the function signature,
tuple of Types

```julia
methods(sort)
less(sort, (AbstractArray{Int,1},)) # function name, tuple of argument types
@less sort([7,2,8]) # same result as above
```

This last line opens the viewer "less" to view the file where
the code is defined, for the particular function on the particular types
of input. also shows file name & path.

```julia
typeof(10:-1:1)
less(sort, (StepRange,)) # StepRange is an AbstractRange
@less sort(10:-1:1)      # same thing
```

---
[previous](notes1117.html) &
[next](notes1206-juliapackages.html)
