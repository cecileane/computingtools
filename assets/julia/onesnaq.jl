#!/usr/bin/env julia

# Julia script to run SNaQ! on a test data set with 3 input parameters:
# - a given number of hybridizations
# - a given number of independent runs
# - a integer that will be mapped to a combination of other parameters.

# This is to be used with slurm, which defines a shell variable SLURM_ARRAY_TASK_ID.
# This variable will serve as the 3rd integer argument to the script,
# to determine the combination of parameters that each slurm task will run.

#---------------------------------------#
#         read script arguments         #
#---------------------------------------#

if length(ARGS)<3
  error("need 3 parameters: h (# hybrids), r (# runs) and combination ID")
end
h = parse(Int, ARGS[1]);
runs = parse(Int, ARGS[2]);
id = parse(Int, ARGS[3]);
println("h: ",h,", number of runs: ",runs,", combination id: ",id)

using PhyloNetworks # package that has the function snaq!

#---------------------------------------#
#         set function parameters       #
#         from last integer argument    #
#---------------------------------------#

# lists of parameter values for all parameters to be varied:
lFTA = [0.000001, 0.00001, 0.0001, 0.001, 0.01]
lNF    = [100, 75, 50, 25]
lRatio = [1, 100, 10000]   # controld LTA: Ratio=LTA/FTA
lXTR   = [0.001,    0.01]
lXTA   = [0.000001, 0.001]
# 5 parameters, with a total of 5*4*3*2*2 = 240 combinations
nparams = 5
nlevels = [length(lFTA),length(lNF),length(lRatio),length(lXTR),length(lXTA)]

# parameter fixed to a single value
FTR = 0.00001

"""
comb(index of parameter combination)

Take an integer as input, return a tuple of parameter values. 
External objects are used: nparams, nlevels, and lFTA etc.
The integer input should be between 0 and 239, or
between 0 and the total # combinations -1 in general.
index 0 -> first values of all parameters
index 239 -> last values of all parameters
"""
function comb(combID)
  paramID = Vector{Int}(nparams)
  d = combID
  for par in 1:nparams
    d,r = fldmod(d, nlevels[par]) # combid = d * nlevels + r
    paramID[par] = r+1 # indexing in parameter list starts at 1, not 0
  end
  println("parameter levels: ",paramID)
  return lFTA[paramID[1]], lNF[paramID[2]], lRatio[paramID[3]], lXTR[paramID[4]], lXTA[paramID[5]]
end

FTA, NF, Ratio, XTR, XTA = comb(id)
LTA = FTA*Ratio;

#---------------------------------------#
#         read input, set seed          #
#---------------------------------------#

## modify the 2 lines below for the real run, which requires input files:
## replace dummy strings by what was commented out
tableCF = "data"  # readTableCF("tableCF.txt")
startingNet = "net" # readTopology(string("h",h,"BestStartingTree.out"))

# next: control the seed for the generation of random numbers, to make
#       the results reproducible (or to restart the analysis if some fail)
srand(h+1);
for i in 0:id
  global s = round(Int,floor(rand()*100000))
  # seed used below, each combination of parameter will have its own
end

#---------------------------------------#
#    set output file name and           #
#    run main command (or pretend)      #
#---------------------------------------#

rootname =  string("snaq/h",h,"nf",NF,"xta",XTA,"xtr",XTR,"fta",FTA,"ftr",FTR,"lta",LTA);
snaq_cmd = parse( # remove this line and triple quotes to run the real stuff
"""
snaq!(startingNet, tableCF, hmax=h, Nfail=NF, ftolAbs=FTA, ftolRel=FTR, xtolRel=XTR,xtolAbs=XTA, liktolAbs=LTA, runs=runs, seed=s, filename=rootname)
""")
println("real stuff: unquote and run this SNaQ command:")
println("       ", snaq_cmd)

println("trial: arguments to SNaQ command written to output file:")
println("       ", rootname)
open(rootname,"w") do fout # fout for File OUTput
  for arg in snaq_cmd.args[4:end]
    write(fout, arg.args[1],"=", string(eval(arg.args[2])),"\n")
  end
end # closes fout

info("all done, end of STDOUT")
