---
layout: page
title: distributed computing with julia
description: course notes
---
[previous](notes1208.html) &
<!-- [next](notes1215.html) -->

---

- run things on multiple processes, separate memory domains
- process providing the interactive prompt: `id` 1
- "workers": processes used for parallel operations
- if only 1 process: process 1 = worker  
  otherwise, workers = all processes other than 1

to tell julia to use `n` = 4 worker processes on the local machine:

```julia
using Distributed
addprocs(4)
```

or: start julia with option `-p n`, e.g. `julia -p 4`  
and then we **don't** need to do `using Distributed`.  
typically `n` = number of CPU threads, or logical cores

let's check our workers and give them some work:

```julia
nprocs()
procs()
workers()
nworkers()
myid()
remotecall_fetch(() -> myid(), 3)
pmap(i -> println("I'm worker $(myid()), working on i=$i"), 1:10)
@sync @distributed for i in 1:10
  println("I'm worker $(myid()), working on i=$i")
end
```

`pmap` is to be preferred when each operation is long,  
`@distributed for` is better when each operation is short

issue: each worker has its own memory domain, for safety

```julia
a = Array{Int}(undef, 10)
a
@sync @distributed for i in 1:10
  println("working on i=$i")
  a[i] = i^2
end
a
```

nothing changed in `a`!! `a` is made available to each worker,
but it's basically for "reading" because a whole copy of `a`
is sent to the memory space of each worker.

functions are not sent to each worker, though:

```julia
printsquare(i) = println("working on i=$i: its square it $(i^2)")
@sync @distributed for i in 1:10
  printsquare(i) # error
end
```

for this to work, we need to export functions
and packages `@everywhere`:

```julia
@everywhere printsquare(i) = println("working on i=$i: its square it $(i^2)")
@sync @distributed for i in 1:10
  printsquare(i)
end
```

**Warning** 1 worker ≠ 1 CPU core or thread:
if we ask for 50 processors and our machine only has 8,
we will see that we have 50 workers, but several workers
will be sharing the same CPU (but different memory domains).
It will slow us down compared to asking for 8 workers only.

### simulation example

real example, more complex to show how to
- use packages and extra functions
- non-standard environment
- shared arrays to let workers share common memory
- simulate from various distributions
- do probability calculations (tail probability for p-value)
- run code that's in a file

copy the chunk below to a new file, say `runsimulations.jl`,
or download [it](../assets/julia/runsimulations.jl)
with more documentation

```julia
@everywhere begin
  using Pkg
  Pkg.activate("juliaenv")
  using Distributions
  using SharedArrays
end

@everywhere function onesimulation(N,nrarecat,mu)
  p = mu/N
  @assert p>=0.0 && p<=0.5 "the rare category/ies cannot have a negative or >.5 probability"
  if nrarecat==1
    probs = [p,(1.0-p)/2,(1.0-p)/2]
    @assert p<=1.0
  else
    probs = [p, p, (1.0-2p)]
  end
  df = 2 # because 3 categories
  observed = rand(Multinomial(N,probs), 1) # 3x1 array
  phat = observed./N # estimated probabilities of the 3 categories
  pearson = N * sum((phat - probs).^2 ./probs)
  Qlog = 0.0
  for i in 1:3
    if observed[i] == 0 continue; end # no need to do xxx / log(0) = 0.0
    ratio = phat[i]/probs[i]
    ratio ≉ 1.0 || continue
    dev = ratio - 1.0 # deviation on ratio scale
    # if ratio ≈ 1 then dev/log(ratio) ≈ 1, but NaN if ratio = 1 exactly
    Qlog += probs[i] * dev^2 / log(ratio)
  end
  Qlog *= 2N
  # cdf = cumulative distribution function: P(random value <= x)
  # ccdf = complementary cdf:               P(random value >  x)
  p_pearson = ccdf(Chisq(df), pearson)
  p_Qlog    = ccdf(Chisq(df), Qlog)
  return pearson,Qlog, p_pearson,p_Qlog
end

nreps = 200 # start with nreps=2 only
samplesizes = [30, 100, 1000]
nrarecats = [1, 2]
mus = [0.1, 1., 2.]

Nssize    = length(samplesizes)
Nnrarecat = length(nrarecats)
Nmu       = length(mus)

ntotal = nreps * Nssize * Nnrarecat * Nmu

samplesize = SharedArray(repeat(samplesizes, inner = nreps, outer = Nnrarecat * Nmu))
nrarecat = SharedArray(repeat(nrarecats,     inner = nreps * Nssize, outer = Nmu))
mu = SharedArray(repeat(mus,                 inner = nreps * Nssize * Nnrarecat))
# hcat(samplesize, nrarecat, mu) # to double-check, when nreps=2

pearson   = SharedArray{Float64}(ntotal)
qlog      = SharedArray{Float64}(ntotal)
p_pearson = SharedArray{Float64}(ntotal)
p_qlog    = SharedArray{Float64}(ntotal)

@sync @distributed for i in 1:ntotal
  res = onesimulation(samplesize[i], nrarecat[i], mu[i])
  #@show samplesize[i], nrarecat[i], mu[i] # when nreps = 2
  pearson[i], qlog[i], p_pearson[i], p_qlog[i] = res
end

# save results, to analyze later interactively
using DataFrames
using CSV
df = DataFrame(
  samplesize = samplesize,
  numrarecategories = nrarecat,
  numrareexpected = mu,
  pearson = pearson,
  qlog = qlog,
  pval_pearson = p_pearson,
  pval_qlog = p_qlog
)
CSV.write("runsimulations_$(nreps)replicates.csv", df)
```

Run this code by starting julia with multiple cores,
say `julia -p 4` and then:

```julia
include("runsimulations.jl")

hcat(pearson, qlog)
quantile(p_pearson, 0.05)
quantile(p_qlog, 0.05)

using RCall
@rlibrary ggplot2
ggplot(df, aes(x=:pval_pearson)) + geom_histogram() +
  facet_grid(R"numrareexpected~numrarecategories")
ggplot(df, aes(x=:pval_qlog))    + geom_histogram() +
  facet_grid(R"numrareexpected~numrarecategories")

by(df, [:numrarecategories, :numrareexpected],
   d->quantile(d.pval_pearson,.05))
by(df, [:numrarecategories, :numrareexpected],
   d->quantile(d.pval_qlog,   .05))
```

---
[previous](notes1208.html) &
<!-- [next](notes1215.html) -->
