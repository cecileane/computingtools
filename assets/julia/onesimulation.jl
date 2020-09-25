#!/usr/bin/env julia

#= julia script to run 1 simulation
argument: integer that will be mapped to a combination of parameters
assumptions:
- directory "simresults/" created prior to running the script
- packages Distributions and StatsFuns already "added"

This is to be used with slurm, which defines a shell variable SLURM_ARRAY_TASK_ID.
This variable will serve the integer argument to the script,
to determine the combination of parameters that each slurm task will run.

example use, with default of 2 replicates per parameter combination, combination 14:
julia onesimulation.jl 14
or simply:
./onesimulation.jl 14
then look at result file in the result directory

example use with 2000 replicates per parameter combination:
julia onesimulation.jl 14 2000
=#

resultdirectory = "simresults"

"""
    onesimulation(N, n_rare_cat, mu, seed)

Simulate data from a multinomial distribution with 3 categories
and `N` units total.
- `n_rare_cat` = 1 or 2 rare categories, with very small probabilities
- `mu`: expected (or mean) number of observations in each rare category.
  The probability that each observation is in a given rare category is p=mu/N.

With 2 rare categories, the probabilities are [p,p,1-2p].
With 1 rare category, the probabilities are [p,(1-p)/2,(1-p)/2].

The data (counts in each category) are analyzed for a goodness-of-fit test:
1. using the Pearson test statistics: sum of (oi - ei)^2 / ei
   where ei = expected count in category i, oi = observed count
2. using the G statistics, or - 2 loglikelihood ratio: 2 × sum of oi × log(oi/ei)
Both test statistics are compared to a chi-square distribution
with 2 degrees of freedom to obtain p-values.

output: (pearson_stat, G_stat, pearson_pvalue, G_pvalue)

examples:

```julia
onesimulation( 50, 1, 0.1, 123)
onesimulation(500, 2, 2.0, 123)
```
"""
function onesimulation(N, nrarecat, mu, seed)
  Random.seed!(seed)
  p = mu/N
  @assert p>=0.0 && p<=0.5 "the rare category/ies cannot have a negative or >.5 probability"
  probs = ( nrarecat==1 ? [p,(1-p)/2,(1-p)/2] : [p, p, (1-2p)] )
  observed = rand(Multinomial(N,probs), 1) # 3x1 array
  phat = observed./N # estimated probabilities of the 3 categories
  pearson = N * sum((phat - probs).^2 ./probs)
  gstat  = 2N * sum(xlogy.(phat, phat ./ probs))
  # ccdf = complementary cumulative distribution function: P(random value >  x)
  p_pearson = ccdf(Chisq(2), pearson) # df=2 because 3 categories
  p_gstat   = ccdf(Chisq(2), gstat)
  return pearson,gstat, p_pearson,p_gstat
end

"""
    arrayID_to_parameters(arrayID, total_n_reps)

Convert a single integer into 4 parameters to be used for the simulation:
`replicate_number, sample_size, n_rare_categories, mu`.
The integer is meant to be used as the "array ID" when submitting all these
simulations with slurm and with a slurm array.

Assumption: parameters vary in
- sample_size: 30, 1000
- n_rare_categories: 1, 2
- mu: 0.1, 1.0, 2.0
- replicate_number: from 1 to total_n_reps (input: to start small when developing the script)
"""
function arrayID_to_parameters(arrayID::Int, Nrep::Int)
  # start with Nrep = 2 to develop the julia + slurm script
  samplesizes = [30, 1000]
  nrarecats = [1, 2]
  mus = [0.1, 1., 2.]

  Nssize    = length(samplesizes)
  Nnrarecat = length(nrarecats)
  Nmu       = length(mus)

  ntotal = Nrep * Nssize * Nnrarecat * Nmu
  @assert arrayID <= ntotal "ID must be between 1 and $ntotal"
  indices = CartesianIndices( (Nrep,Nssize,Nnrarecat,Nmu) )
  I = indices[arrayID].I # coordinates corresponding to the linear index arrayID
  rep = I[1]
  samplesize = samplesizes[I[2]]
  nrarecat = nrarecats[I[3]]
  mu = mus[I[4]]
  return rep, samplesize, nrarecat, mu
end

#-----------------------------------------------------#
#  finally: read script argument and run 1 simulation #
#-----------------------------------------------------#

# parse the integer argument
@assert length(ARGS)>0 "need 1 parameters: arrayID"
arrayID = parse(Int, ARGS[1])
# Nreps = 2nd argument. 2 reps by default, if no second argument
Nreps = (length(ARGS)==1 ? 2 : parse(Int, ARGS[2]))
rep, samplesize, nrarecat, mu = arrayID_to_parameters(arrayID, Nreps)
@info ""  arrayID replicate=rep samplesize number_rare_categories=nrarecat mu

# load the packages that the simulation function needs
using Distributions # for Multinomial, Chisq, ccdf
using StatsFuns     # for xlogy
using Random        # no install: standard library
using Printf        # standard library

# run simulation. use arrayID as seed: will be different for each replicate
pearson, gstat, p_pearson, p_gstat = onesimulation(samplesize, nrarecat, mu, arrayID)

# save the result in tiny csv-formatted file
# (later, all these files will be concatenated with "cat")
outputfile = joinpath(resultdirectory, "simulation_" * @sprintf("%04d", arrayID) * ".csv")
open(outputfile, "w") do g
  write(g, "$arrayID,$rep,$samplesize,$nrarecat,$mu,") # input
  write(g, "$pearson,$gstat,$p_pearson,$p_gstat\n")    # output
end
@info "ID $arrayID is done"
