---
layout: page
title: julia packages
description: course notes
---
[previous](notes1206.html) &
[next](notes1208.html)

---

jump to:
- [environments](#environments) and adding packages
- [using](#using-packages) packages
- package [RCall](#package-rcall-and-the-r-mode) and the R mode
- [other](#other-great-packages) packages

### environments

Julia's package manager is centered around environments.
By default, we use the `v1.0` environment, whose information
is in `~/.julia/environments/v1.0/`

```shell
shell> ls ~/.julia/environments/v1.0/
Manifest.toml	Project.toml
```
The file `Project.toml` lists which packages (or julia version)
need to be used, and which exact versions.
I will create a new environment for myself for this class,
which can be useful if we want to develop a new package
separately from an environment where I might want to use Julia
as a "simple user".

I created a new directory `juliaenv` within my directory
for the class. From this `juliaenv/`, start julia, enter the
"pkg" mode by typing `]`, then do this to install the
[MixedModels](http://dmbates.github.io/MixedModels.jl/stable/) package:

```julia
(v1.0) pkg> activate .

(juliaenv) pkg> status
    Status `~/Documents/private/st679/juliaenv/Project.toml`
  (empty environment)

(juliaenv) pkg> add MixedModels
  Updating registry at `~/.julia/registries/General`
  Updating git-repo `https://github.com/JuliaRegistries/General.git`
 Resolving package versions...
 Installed Showoff ────────── v0.2.1
 ...
 Installed MixedModels ────── v1.1.1
  Updating `~/Documents/private/st679/juliaenv/Project.toml`
  [ff71e718] + MixedModels v1.1.1
  Updating `~/Documents/private/st679/juliaenv/Manifest.toml`
  [dce04be8] + ArgCheck v1.0.0
  ...
  [8dfed614] + Test
  [cf7118a7] + UUIDs
  [4ec0a83e] + Unicode
  Building SpecialFunctions → `~/.julia/packages/SpecialFunctions/fvheQ/deps/build.log`
  Building CodecZlib ───────→ `~/.julia/packages/CodecZlib/DAjXH/deps/build.log`

(juliaenv) pkg> status
    Status `~/Documents/private/st679/juliaenv/Project.toml`
  [ff71e718] MixedModels v1.1.1

(juliaenv) pkg> status --manifest
    Status `~/Documents/private/st679/juliaenv/Manifest.toml`
  [dce04be8] ArgCheck v1.0.0
  ...
  [a93c6f00] DataFrames v0.14.1
  [9a8bc11e] DataStreams v0.4.1
  [864edb3b] DataStructures v0.14.0
  [31c24e10] Distributions v0.16.4
  [38e38edf] GLM v1.0.1
  ...
  [e1d29d7a] Missings v0.3.1
  ...
  [2913bbd2] StatsBase v0.25.0
  [4c63d2b9] StatsFuns v0.7.0
  [3eaba693] StatsModels v0.3.1
  ...
  [4ec0a83e] Unicode
```

press backspace to go back to the julian mode.

Later, in a different session started from any other
directory, we can use the environment we created earlier
by providing the path to our folder `juliaenv/`:

```julia
(v1.0) pkg> activate st679/juliaenv

(juliaenv) pkg> status
    Status `~/Documents/private/st679/juliaenv/Project.toml`
  [ff71e718] MixedModels v1.1.1

julia> using MixedModels
[ Info: Precompiling MixedModels [ff71e718-51f3-5ec2-a782-8ffcbfa3c316]

help?> LinearMixedModel
search: LinearMixedModel GeneralizedLinearMixedModel

  LinearMixedModel

  Linear mixed-effects model representation

  Fields
  ========

    •    formula: the formula for the model
    ...
```

### using packages

install packages in pkg mode:
```julia
(juliaenv) pkg> add RDatasets # to import data sets defined in R packages
(juliaenv) pkg> add DataFrames
(juliaenv) pkg> add CSV
(juliaenv) pkg> add StatPlots
(juliaenv) pkg> add Plots
```

then in julian mode:
```julia
using RDatasets
using DataFrames
using Plots
using StatPlots

iris = dataset("datasets", "iris")
head(iris)
ncol(iris)
nrow(iris)
describe(iris)
iris[:,5] # 5th column. will create a copy in the future
iris[5]   # 5th column, no copy
iris[:Species] # by name
scatter(iris[:SepalLength], iris[:SepalWidth], group = iris[:Species])
@df iris scatter(:SepalLength, :SepalWidth, group=:Species,
   legend = :topleft,
   xlabel="sepal length", ylabel="sepal width",
   title="iris data")
@df iris marginalhist(:PetalLength, :PetalWidth)
@df iris marginalhist(:PetalLength, :PetalWidth, bins=30)
@df iris corrplot([:SepalLength :SepalWidth :PetalLength :PetalWidth],
    grid=false, bins=20)
@df iris corrplot([:SepalLength :SepalWidth :PetalLength :PetalWidth],
    grid=false, bins=20, group=:Species)
```

for plots, see many options from
[StatsPlots](https://github.com/JuliaPlots/StatPlots.jl)
and hopefully soon
[GGPlots](https://github.com/JuliaPlots/GGPlots.jl).

The [Interact](https://github.com/JuliaGizmos/Interact.jl)
package is super cool too to add interactive widgets to plots,
e.g. with the `@manipulate` macro to make interactive graphs with sliders.

<!--
(first `add Interact` and `add Blink`):
using Interact
using Blink
w = Window()
body!(w, dataviewer(iris))
-->

<!-- with Gadfly:
plot(iris, x=:SepalLength, y=:SepalWidth, color=:Species, Geom.point)
plot(iris, x=:SepalLength, y=:SepalWidth, color=:Species,
     label= :Species, Geom.point, Geom.label)
-->

## package RCall and the R mode

see Doug Bates's
[video](https://youtu.be/oOd3JnEm3c8?list=PLP8iPy9hna6SQPwZUDtAM59-wPzCPyD_S)
from his talk at JuliCon 2016, on "Julia and R",
about the
[RCall](https://github.com/JuliaInterop/RCall.jl) package

first install the package: do `]` to switch to pkg mode

```julia
(juliaenv) pkg> add RCall
(juliaenv) pkg> status
    Status `.../st679/juliaenv/Project.toml`
  [6e4b80f9] BenchmarkTools v0.4.1
  [a93c6f00] DataFrames v0.14.1
  [ff71e718] MixedModels v1.1.1
  [91a5bcdd] Plots v0.21.0
  [6f49c342] RCall v0.13.0
  [ce6b1742] RDatasets v0.6.1
  [60ddc479] StatPlots v0.8.1
```

to use this fantastic `RCall` package:
switch back to julian mode (backspace)

```julia
julia> using RCall
julia> a = 1:10
R> $a  # switch to R mode by pressing $
R> b = (10:1)^2
julia> R"b"
julia> @rget b
julia> var"b"
julia> a + @rget(b)
R> $a + b
julia> R"$a+b"
julia> R"plot($a,b, col=1:10, pch=16, main='what a figure')"
julia> R"plot"(a, @rget(b), col=1:10, pch=16, main="figure 2")
R> install.packages("ggplot2") # do this if ggplot2 not installed already
julia> @rlibrary ggplot2
```

and now we can stick to julian mode only, but use the
functions imported from ggplot, right from julia:

```julia
?qplot
a = 1:10         # range
c = (10:-1:1).^2 # array. note .^ to vectorize ^
qplot(a,c) # quick plot with ggplot2, using julia objects
ggplot(iris, aes(x=:SepalLength, y=:SepalWidth, color=:Species)) +
  geom_point()
ggsave("iris.pdf")
ggplot(iris, aes(x=:SepalLength, y=:SepalWidth, color=:PetalLength)) +
  geom_point(var"na.rm"=true) + facet_wrap(R"~Species")
```

note 2 things above:
- the argument `na.rm` in an R function,
  but the **dot notation** is used for accessing an object's fields
  (or module variable or function etc.).
  solution: use the `var""` macro from RCall
- `y~x` or `~x` will produce an object of class formula in R,
  but not in julia. solution: use the `R""` macro from RCall

## other great packages

[PyCall](https://github.com/JuliaPy/PyCall.jl), with `@pyimport` macro
to import python modules and use them within julia

---
[previous](notes1206.html) &
[next](notes1208.html)
