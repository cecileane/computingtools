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
- [using](#using-packages) packages, with data frames & plotting example
- package [RCall](#package-rcall-and-the-r-mode) and the R mode
- [Pluto](#pluto-notebooks) notebooks
- [other](#other-great-packages) great packages

### environments

Julia's package manager is centered around environments.
By default, we use the `v1.5` environment, whose information
is in `~/.julia/environments/v1.5/`

```julia
shell> ls ~/.julia/environments/v1.5/
Manifest.toml	Project.toml
shell> cat ~/.julia/environments/v1.5/Project.toml   # what I already installed
shell> less ~/.julia/environments/v1.5/Manifest.toml # detailed version info
```
The file `Project.toml` lists which packages (or julia version)
need to be used, `Manifest.toml` lists which exact versions.
I will create a new environment for myself for this class,
which can be useful if we want to develop a new package
separately from an environment where I might want to use Julia
as a "simple user".

I created a new directory `julia` within my directory
for the class. From this `julia/`, start julia, enter the
"pkg" mode by typing `]`, then do this to install the
[MixedModels](https://juliastats.org/MixedModels.jl/stable/) package:

```julia
(@v1.5) pkg> activate .
Activating new environment at `~/Documents/private/st679/julia/Project.toml`

(julia) pkg> status
Status `~/Documents/private/st679/julia/Project.toml` (empty project)

(julia) pkg> add MixedModels
   Updating registry at `~/.julia/registries/General`
   Updating git-repo `https://github.com/JuliaRegistries/General.git`
  Resolving package versions...
  ...
  Installed MixedModels ──────── v3.1.0
  ...
Updating `~/Documents/private/st679/julia/Project.toml`
  [ff71e718] + MixedModels v3.1.0
Updating `~/Documents/private/st679/julia/Manifest.toml`
  [4c555306] + ArrayLayouts v0.4.10
  ...
  [8dfed614] + Test
  [cf7118a7] + UUIDs
  [4ec0a83e] + Unicode
   Building TimeZones → `~/.julia/packages/TimeZones/fr1IP/deps/build.log`

(julia) pkg> status
Status `~/Documents/private/st679/julia/Project.toml`

(julia) pkg> status --manifest
Status `~/Documents/private/st679/julia/Manifest.toml`
  [4c555306] ArrayLayouts v0.4.10
  ...
  [38e38edf] GLM v1.3.11
  ...
  [ff71e718] MixedModels v3.1.0
  ...
  [2913bbd2] StatsBase v0.33.2
  [4c63d2b9] StatsFuns v0.9.5
  [3eaba693] StatsModels v0.6.15
  ...
  [4ec0a83e] Unicode
```

press backspace to go back to the julian mode.

Later, in a different session started from any other
directory, we can use the environment we created earlier
by providing the path to our folder `julia/`:

```julia
(v1.5) pkg> activate st679/julia
 Activating environment at `~/Documents/private/st679/julia/Project.toml`

(julia) pkg> status
Status `~/Documents/private/st679/julia/Project.toml`
  [ff71e718] MixedModels v3.1.0

julia> using MixedModels # first-time compilation can take a while!
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

by the way: great tutorials on julia and mixed models
[here](https://repsychling.github.io/tutorial.html)

### using packages

install packages in pkg mode:
```julia
(julia) pkg> add RDatasets # to import data sets defined in R packages
(julia) pkg> add DataFrames
(julia) pkg> add CSV
(julia) pkg> add StatsPlots
(julia) pkg> add Plots
(julia) pkg> status # to check what package(s) you can use
```

then in julian mode:
```julia
using RDatasets
using DataFrames
# using Plots
using StatsPlots

iris = dataset("datasets", "iris")
head(iris)
ncol(iris)
nrow(iris)
describe(iris)
iris[:,5] # 5th column: copy -> no danger of modifying the iris data frame
iris[!,5] # 5th column: no copy -> can modify iris since vectors are mutable
iris[5]   # 5th column: no copy -- but deprecated
iris[:Species] #        no copy -- but deprecated
iris.Species
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
and
[Gadfly](http://gadflyjl.org/stable/)
for an equivalent to [ggplot2](https://ggplot2.tidyverse.org) in R.

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
(julia) pkg> add RCall
(julia) pkg> status
Status `~/Documents/private/st679/julia/Project.toml`
  ...
  [6f49c342] RCall v0.13.9
  ...
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
?ggplot
using RDatasets
using DataFrames
iris = dataset("datasets", "iris") # julia data set
ggplot(iris, aes(x=:SepalLength, y=:SepalWidth, color=:Species)) +
  geom_point()
ggsave("iris.pdf")
ggplot(iris, aes(x=:SepalLength, y=:SepalWidth, color=:PetalLength)) +
  geom_point(var"na.rm"=true) + facet_wrap(R"~Species")
```

note 2 things above:
- the argument `na.rm` in an R function,
  but the **dot notation** is used for accessing an object's fields
  (or module variable or function etc.) in julia.
  solution: use the `var""` macro from RCall
- `y~x` or `~x` will produce an object of class formula in R,
  but not in julia. solution: use the `R""` macro from RCall

## Pluto notebooks

```julia
using Pluto
Pluto.run()
```

then follow instructions, like:

    Opening http://localhost:1234/?secret=T3BDrOY9 in your default browser... ~ have fun!
    Press Ctrl+C in this terminal to stop Pluto

## other great packages

- use [JuliaHub](https://juliahub.com/ui/Packages) to discover
  packages on a topic of interest, access package documentation,
  and more
- [PyCall](https://github.com/JuliaPy/PyCall.jl), with `@pyimport` macro
  to import python modules and use them within julia
- [Flux](https://fluxml.ai/Flux.jl/stable/) for machine learning

---
[previous](notes1206.html) &
[next](notes1208.html)
