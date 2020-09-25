#=
if non-default environment, do this in the shell first:
export JULIA_PROJECT="/path/to/environment"
after done: unset this shell variable with:
unset JULIA_PROJECT

packages to add beforehand: CSV, DataFrames, Distributions
=#

@everywhere begin
  # using Pkg; Pkg.activate("/path/to/environment")
  # line above: doesn't quite work with julia v1.5.2
  # use the JULIA_PROJECT shell variable instead, if non-default environment
  using Distributions
  using SharedArrays
end

"""
    onesimulation(N, n_rare_cat, mu)

Simulate data from a multinomial distribution with 3 categories
and `N` units total.
- `n_rare_cat` = 1 or 2 rare categories, with very small probabilities
- `mu`: expected (or mean) number of observations in each rare category.
  The probability that each observation is in a given rare category is
  `p=mu/N`.

With 2 rare categories, the probabilities are [p,p,1-2p].
With 1 rare category, the probabilities are [p,(1-p)/2,(1-p)/2].

The data (counts in each categories) are then analyzed for a
goodness-of-fit test:
1. first using the Pearson test statistics: sum of (oi - ei)^2 / ei
   where ei = expected count in category i, oi = observed count
2. second using Qlog statistics: 2 * sum of L(ni,ei) * (oi - ei)/ei
   where L(x,y) is the logarithmic mean of x and y:
   L(x,y) = (x-y) / (log(x)-log(y)).
   L(x,y) is always between x and y, as expected for a mean.
   See for example Lorenzen (1995) for a justification for using Qlog.

Both test statistics are compared to a chi-square distribution
with 2 degrees of freedom to obtain p-values.

output: (pearson_stat, Qlog_stat, pearson_pvalue, Qlog_pvalue)

examples:

```julia
onesimulation( 50, 1, 0.1)
onesimulation(500, 2, 2.0)
```
"""

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
