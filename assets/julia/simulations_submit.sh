#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cecile.ane@wisc.edu
#SBATCH -o simresults/simulation_%a.log
#SBATCH -J sims
#SBATCH --array=1-240
#SBATCH -p short

# warning: onesimulation.jl (below) and the -o option (above) assume that
# simresults/ has already been created

# use Julia packages in /worskpace/, not defaults in ~/.julia/ (on AFS):
export JULIA_DEPOT_PATH="/workspace/ane/.julia"
# prior to this, packages need to have been installed in that location by
# using the same export, launching /workspace/.../julia and within julia:
# using Pkg; Pkg.add("Distributions"); using Distributions
# (the last "using Distribution" is to precompile)

echo "slurm task ID = $SLURM_ARRAY_TASK_ID"

# launch Julia script, using Julia in /workspace/ and with full paths:
/workspace/software/julia-1.0.1/bin/julia /workspace/ane/st679simulations/onesimulation.jl $SLURM_ARRAY_TASK_ID 20
