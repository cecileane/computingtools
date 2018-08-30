---
layout: page
title: job scheduling with slurm
description: course notes
---
[previous](notes1209.html)

---

[slurm](https://slurm.schedmd.com): simple linux utility for resource management.  
[Instructions](http://www.stat.wisc.edu/services/hpc-cluster1/about)
for our Stat department system (check the menu on the right).

- head node: `lunchbox.stat.wisc.edu`
- 13 compute nodes (called `marzano` etc.), each with 24 CPUs * 2 threads = 48 cores each.

The CHTC on campus uses slurm too for their high performance cluster.

file systems:

- AFS (Andrew File System) like `/u/x/x/username`:
  great for backing-up data and to share files with colleagues,
  but slow (and with expiring authentication tokens):
  bad for running things on the cluster!

- NFS (Network File System) in `/workspace`: do stuff here.
  All machines in the cluster have access to this directory.
  Software (R, julia, python) installed in `/workspace/software`,
  install your own packages in `/workspace/<username>/<dir>` and
  set permissions with `chmod`


## simple test example

This slurm script, in file `echo_submit.sh`,
runs a pair of `echo` commands 10 times:

```shell
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
```

`#SBATCH` with no space between `#` and `SBATCH`
is *not* be interpreted as a comment, but as an option for slurm.
`# SBATCH whatever` would be a comment, because of the space.

The key line that makes 10 repeats is `#SBATCH --array=0-9`.
This line also creates a shell variable `SLURM_ARRAY_TASK_ID`,
which is used as we would with any other shell variable.  
The first `echo` command produces standard output written to
a file `screen/echo_?.log`.  
The second `echo` produces an output file `output/echo_?.out`.

Slurm is asked to capture the screen output to `screen/echo_*.log`,
so we need to create the `screen/` directory prior to running the script.
Also, for the second `echo` command to run successfully, we need to create
the directory `output/` prior to running the slurm script.

`#SBATCH -t 1`: expected time, in minutes.
default is 4 days, which puts the submission at the bottom of the queue.  
`#SBATCH -n 3`: requests 3 cores; the 9 (super short) tasks
will be run one after the other.

To run the script:

```shell
sbatch echo_submit.sh
```

## main slurm commands

`sbatch` submits a batch script to the scheduler (example earlier)

`sinfo` displays current "partitions" and idle, busy, down, up states.  
partition = group of computers

- "short" partition (default): 4 days limit, 2 nodes (= 2 "marzano" servers)
- "long" partition: 2 week limit, 4 nodes
- other partitions listed for various other research groups,
  resource levels (e.g. higher memory, longer runs, etc.)

```shell
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug*       up    2:00:00      1   idle marzano01
short        up 2-00:00:00      1    mix marzano03
short        up 2-00:00:00      2  alloc marzano[02,04]
long         up 8-00:00:00      8    mix marzano[05-09,11-13]
long         up 8-00:00:00      1  alloc marzano10
hipri        up 5-00:00:00      9    mix marzano[03,05-09,11-13]
hipri        up 5-00:00:00      3  alloc marzano[02,04,10]
```
<!-- darwin       up   infinite      9   idle darwin[00-06,12-13] -->

`squeue` displays jobs currently running or queued

`scontrol` to see info on currently running jobs

`scancel` to cancel a submission

```shell
$ sbatch submit.sh # submits something
$ squeue           # we see this 'something' is running
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
              7347     short submit.s    mikec  R       0:06      1 marzano05
$ scontrol show job 7347
...
(a lot of information)
...
$ scancel 7347     # to kill the submitted something
$ squeue # the job should be gone: no output here
```

`sacct`: (account) displays the user's jobs, cores used, run states,
even after the jobs have finished

Other notes:

- `#SBATCH -p long`: to send jobs to the "long" partition
- QOS = quality of service.  
  max of 24 CPUs used at one time.
- if the job spawns more processes (like a Python script that runs RAxML using multiple cores): slurm does not know about that, so it's important to allocate
the appropriate number of cores with `#SBATCH -n xxx`
- in the slurm script, it can handy to redefine your home with
  `export HOME=/workspace/ane` (adapt the user name).
- to use your preferred editor (e.g. VS Code) on the remote server:
  try sshfs (links for [Ubuntu](https://help.ubuntu.com/community/SSHFS)
  or [Mac](http://stuff-things.net/2015/05/20/fuse-and-sshfs-on-os-x/))


On `srun`:

- `printenv` prints the environment variables. To see variables defined
  by slurm when a submit script is run, do: `srun printenv`.
  It will print regular environment variables plus all others set by slurm.
- `srun` is the command-line version of `sbatch <submit-file-name>`, but might
  need to wait and sit without being able to close the laptop.
- to understand why a job might cause trouble: run bash on the machine using
  `srun`. If `scontrol` shows that the job is running
  on "marzano05": run bash on that machine with
  `srun --pty -w marzano05 /bin/bash` (pty = pseudo terminal).
  See what's going on there with `top` etc., then exit bash with `exit`.



## example to run a bunch of julia scripts

General guideline:
**start simple** with 1 task, 1 process, 1 job. expand from there.

Below: we want to run a julia script
[`onesimulation.jl`](../assets/julia/onesimulation.jl)
many times (e.g. 240 times or 2400 times),
each time with a different set of parameters.

The main section of the julia script does this:

```julia
# parse the integer argument
@assert length(ARGS)>0 "need 1 parameters: arrayID"
arrayID = parse(Int, ARGS[1])
# ...
rep, samplesize, nrarecat, mu = arrayID_to_parameters(arrayID, Nreps)
# ...
# run the simulation. use arrayID as seed: will be different for each simulation
pearson, qlog, p_pearson, p_qlog = onesimulation(samplesize, nrarecat, mu, arrayID)

# save the result in tiny csv-formatted file
# (later, all these files will be concatenated with "cat")
outputfile = joinpath(resultdirectory, "simulation_" * @sprintf("%04d", arrayID) * ".csv")
open(outputfile, "w") do g
  write(g, "$arrayID,$rep,$samplesize,$nrarecat,$mu,") # input
  write(g, "$pearson,$qlog,$p_pearson,$p_qlog\n")      # output
end
```

To start simple:

1. We check that the julia script runs without error once,
   with 1 set of parameters, without using slurm.
   If necessary, run a slightly modified script to make it run fast.
2. To check that the slurm submission works:
   the slurm (or "submit") script or the main julia script is modified so
   that it does *not* run the time-consuming command,
   but only prints this command as a string.
   Writing this string to the intended output file also checks that
   output files are writable with correct path etc.
3. Finally: modify the submit script or the julia script to its final version
   to run the main time-consuming command, not just print it.

The example below shows steps 1 and 2.
Save the following script in file [`simulations_submit.sh`](../assets/julia/simulations_submit.sh):

```shell
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

echo "slurm task ID = $SLURM_ARRAY_TASK_ID"

# launch Julia script, using Julia in /workspace/ and with full paths:
/workspace/software/julia-1.0.1/bin/julia /workspace/ane/st679simulations/onesimulation.jl $SLURM_ARRAY_TASK_ID 20
```

It will run the julia script [`onesimulation.jl`](../assets/julia/onesimulation.jl)
(last line) 240 times (from `#SBATCH --array=1-240`).  
The julia script gets 2 arguments: the value of `SLURM_ARRAY_TASK_ID` (1,...,240)
and the number of replicates per parameter combination.
Julia will use the first integer argument to set an array of parameter values.

**preparation**

- copy the input file, julia file, submit file etc to the slurm server:

```shell
scp onesimulation.jl simulations_submit.sh username@lunchbox.stat.wisc.edu:/workspace/ane/st679simulations/
```

- `ssh` to lunchbox and go to your folder in `/workspace/<username>/xxx`.
- make sure all the packages are installed in the non-default "depot", that is,
  in `/workspace/`: do `export JULIA_DEPOT_PATH="/workspace/ane/.julia"`,
  launch `/workspace/software/julia-1.0.1/bin/julia` and within julia:
  `using Pkg; Pkg.add("Distributions")` then `using Distributions`
  to precompile the package, and simply quit julia.

- step1 : check that the julia script is working by running it once,
  with arguments that make it run fast:

```shell
export JULIA_PKGDIR="/workspace/ane/.julia"
/workspace/software/julia-1.0.1/bin/julia onesimulation.jl 14 2
```

**run slurm quickly** (step 2)

- run the slurm script for a few trials only, to run the julia script
  2 times only (not 240 times yet) by editing to `#SBATCH --array=1-2`
  and make slurm `echo` the julia command, *not* run it. After editing
  the slutm submit script, run it:

```shell
sbatch simulations_submit.sh
squeue
```

- if all goes well, edit the submit script again to execute the julia
  command, not just echo it, then run again; but still for 3 trials only.
- monitor the jobs for these first few trials, predict the running time
  for the full 240 julia runs.

**run slurm** for the full simulation (step 3)

edit the script again to `#SBATCH --array=1-240` and
run the full array of 240 jobs, and sumit like in step 2 above:

```shell
sbatch simulations_submit.sh
squeue
wc simresults/*.csv # to check progress in output files
wc simresults/*.log # to check for any error message by slurm
```

### converting a slurm array ID to a combination of parameters

The julia script above converts the slurm array ID (between 1-240) to a combination
of parameters. This is done in the function `arrayID_to_parameters`
(check it out!). The gist is to use a `CartesianIndex` to map linear integers
to coordinates (or indices) in a matrix or in a higher dimentional array.

Below is a simple example (with 1 less dimension than in the simulation file)
with 3 parameters of interest, taking between 2 or 3 values each, for a
total of 2\*2\*3 = 12 combinations. A linear ID for parameter combinations
would run from 1 to 12. But what does combination 5 correspond to, for example?

```julia
samplesizes = [30, 1000] # parameters of interest
nrarecats = [1, 2]
mus = [0.1, 1., 2.]

I = CartesianIndices( (2,2,3) )
for i in 1:6
 @show I[i]
end
A = reshape(12:-1:1, (2,2,3))
for i in 1:6
  @show A[I[i]]
end
A[5]
A[1,1,2]
I[5]
I[5].I

samplesizes[I[5].I[1]] # combination 5, parameter 1
nrarecats[I[5].I[2]]   # combination 5, parameter 2
mus[I[5].I[3]]         # combination 5, parameter 3
```

---
[previous](notes1209.html)
