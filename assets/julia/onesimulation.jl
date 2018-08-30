#!/usr/bin/env julia

# julia script to run 1 simulation
# argument: integer that will be mapped to a combination of parameters
# assumption: directory "simresults/" created prior to running the script

# This is to be used with slurm, which defines a shell variable SLURM_ARRAY_TASK_ID.
# This variable will serve the integer argument to the script,
# to determine the combination of parameters that each slurm task will run.

# example use, with default of 2 replicates per parameter combination, combination 14:
# julia onesimulation.jl 14
# or simply:
# ./onesimulation.jl 14
# then look at result file in the result directory

# example use with 200 replicates per parameter combination:
# julia onesimulation.jl 14 200


resultdirectory = "simresults"

"""
    onesimulation(N, n_rare_cat, mu, seed)

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
function onesimulation(N, nrarecat, mu, seed)
  Random.seed!(seed)
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

"""
    arrayID_to_parameters(arrayID, total_n_reps)

Convert a single integer into 4 parameters to be used for the simulation:
`sample_size, n_rare_categories, mu, replicate_number`.
The integer is meant to be used as the "array ID" when submitting all these
simulations with slurm and with a slurm array.

Assumption: parameters vary in
- sample_size: 30, 1000
- n_rare_categories: 1, 2
- mu: 0.1, 1.0, 2.0
- replicate_number: from 1 to total_n_reps (input: to start small when developing the script)
"""
function arrayID_to_parameters(arrayID::Int, Nrep::Int)
  # start with Nrep = 2 to develop the julia script + slurm script,
  # then ramp up to Nrep = 200 or more
  samplesizes = [30, 1000]
  nrarecats = [1, 2]
  mus = [0.1, 1., 2.]

  Nssize    = length(samplesizes)
  Nnrarecat = length(nrarecats)
  Nmu       = length(mus)

  ntotal = Nrep * Nssize * Nnrarecat * Nmu
  @assert arrayID <= ntotal "ID must be between 1 and $ntotal"
  I = CartesianIndices( (Nrep,Nssize,Nnrarecat,Nmu) )
  I = I[arrayID].I # coordinates corresponding to the linear index arrayID
  rep = I[1]
  samplesize = samplesizes[I[2]]
  nrarecat = nrarecats[I[3]]
  mu = mus[I[4]]
  return rep, samplesize, nrarecat, mu
end

#---------------------------------------#
#  finally: read script argument        #
#           and run the simulation      #
#---------------------------------------#

# parse the integer argument
@assert length(ARGS)>0 "need 1 parameters: arrayID"
arrayID = parse(Int, ARGS[1])
if length(ARGS)==1
  Nreps = 2
  @info "number of replicates will be 2 by default"
else
  Nreps = parse(Int, ARGS[2])
  @info "number of replicates: $Nreps"
end
rep, samplesize, nrarecat, mu = arrayID_to_parameters(arrayID, Nreps)
@info ""  arrayID replicate=rep samplesize number_rare_categories=nrarecat mu

# load the packages that the simulation function needs
using Distributions # needs to be installed prior
using Random        # no install: standard library
using Printf        # standard library

# run the simulation. use arrayID as seed: will be different for each simulation
pearson, qlog, p_pearson, p_qlog = onesimulation(samplesize, nrarecat, mu, arrayID)

# save the result in tiny csv-formatted file
# (later, all these files will be concatenated with "cat")
outputfile = joinpath(resultdirectory, "simulation_" * @sprintf("%04d", arrayID) * ".csv")
open(outputfile, "w") do g
  write(g, "$arrayID,$rep,$samplesize,$nrarecat,$mu,") # input
  write(g, "$pearson,$qlog,$p_pearson,$p_qlog\n")      # output
end
@info "ID $arrayID is done"
