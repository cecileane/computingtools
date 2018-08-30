#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cecile.ane@wisc.edu
#SBATCH -o screen/echo_%a.log
#SBATCH -J echo
#SBATCH --array=0-9
#SBATCH -t 1
#SBATCH -n 3

# launch the "echo" script
echo "slurm task ID = $SLURM_ARRAY_TASK_ID"
echo "today is $(date)" > output/echo_$SLURM_ARRAY_TASK_ID.out
