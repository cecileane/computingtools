---
layout: page
title: job scheduling with slurm
description: course notes
---
[previous](notes1209.html)

---

<!-- notes were first based on Mike Cammilleri's guest lecture on 2018-12-12 -->

jump to
- what is [slurm](#slurm-and-the-statistics-hpc-cluster)
- where to run things: [file system](#file-system)
- a first simple [example](#simple-test-example)
- other examples using various [slurm options](#examples-with-multiple-cpus-or-array-of-tasks)
- main slurm [commands](#main-slurm-commands)
- [srun](#srun-to-diagnose-issues) to trouble-shoot issues
- example for a [simulation study](#example-to-run-a-bunch-of-julia-scripts)
  in julia
  * how to convert a [slurm array ID](#converting-a-slurm-array-id-to-a-combination-of-parameters)
    to a combination of parameter values

## slurm and the statistics HPC cluster

high performance computing cluster:
- 2 head nodes: `lunchbox` and `jetstar` , both `.stat.wisc.edu`
- 13 compute nodes (called `marzano` etc.), each with 24 CPUs * 2 hybrid threads
  = 48 threads each (sometimes people would say 48 "cores")
  and more (GPU node, storage nodes)
- a ton of memory

[Instructions](https://kb.wisc.edu/stat/internal/page.php?id=106361)
for our Stat department system (requires a netID).
(see more general help
[here](https://kb.wisc.edu/stat/internal/page.php?id=105902)
and older
[examples](https://stat.wisc.edu/users-guide/submitting-jobs/tutorials-and-examples/))

[slurm](https://slurm.schedmd.com): simple linux utility for resource management
- the CHTC on campus uses slurm too for their high performance cluster
- many universities are using slurm and have online user's guides,
  but beware that many online examples are wrong
  or not adapted to our system.
- there are many different ways of doing the same thing

resource allocation is extremly important:
we need to know what our application needs,
e.g. whether it can use multiple threads, how long each task will take, etc.  
note: R is not multi-threaded by itself

## file system

- AFS (Andrew File System) like `/u/x/x/username`:
  great for backing-up data and to share files with colleagues,
  but slow (and with expiring authentication tokens):
  bad for running things on the cluster!

- NFS (Network File System) in `/workspace/username` or
  `/workspace2/username`: do stuff here.
  All machines in the cluster have access to this directory.
  Software (R, julia, python) installed in `/workspace/software`,
  install your own packages in `/workspace/<username>/<dir>` and
  set permissions with `chmod`


## simple test example

This slurm script, in file `myRstuff_submit.sh`, asks
to run the R script `myRstuff.r` in batch mode:

```shell
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user.name@wisc.edu
#SBATCH -J myjobname
#SBATCH -t 60:00
#SBATCH --mem-per-cpu=1000M

module load R/R-4.0.1
R CMD BATCH --nosave myRstuff.r
```

`#SBATCH` with no space between `#` and `SBATCH`
is *not* be interpreted as a comment, but as an option for slurm.
`# SBATCH whatever` would be a comment, because of the space.
Here we asked for:
- a report by email when the job is finished:
  it might finish successfully, or not; the email will tell us.
- all information will refer to our job using the name `myjobname`
- 60 minutes to run the job (the job would be killed after 60 minutes
  if it didn't terminate before).  
  format: `minutes:seconds` or `hours:minutes:seconds` or `days-hours:minutes:seconds`  
  The longer we ask for, the more at the bottom of the queue our job will go.
- 1000 MB = 1 gigabytes of memory. memory must be specified:
  if not, it will default to 50 megabytes only,
  and your job might take a lot longer than expected...  
  max is 2.6G/CPU (that's what available per CPU under current configuration)

The `module` line loads software that is properly installed for the cluster,
in `/workspace/software/` (not on AFS in particular), and loads the correct
path to that software and its libraries.
If we wanted to run a python script, we would do
`module load python/python3.6.7` for instance.
Do `module avail` to see what modules are available.

To run the script:

```shell
sbatch myRstuff_submit.sh
```

## examples with multiple CPUs or array of tasks

To launch a julia script that will itself use multiple CPUs,
we should tell slurm to allocate multiple CPUs (=threads here) for
our 1 julia job. Our file `myJuliastuff_submit.sh` would look like this:

```shell
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user.name@wisc.edu
#SBATCH -J myjobname
#SBATCH -t 7:00:00
#SBATCH --cpus-per-task=8 # same as: -c 8
#SBATCH -p long

julia -p 8 myJuliastuff.jl # this is 1 task
```

new option here: `--cpus-per-task=8` or simply `-c 8`. default: 1 CPU per task

For julia (and most applications): all these 8 requested CPUs need to be on
the same node (same machine) because they need to share memory and
communicate with each other.
Each of the 13 nodes has 48 CPUs, so `-c 48` is the max we should ask for.
The more we ask for, the more difficult it will be to get
many CPUs available *all* on the same node and at the same time.

another new option above: `-p long` to ask for the "long" partition of the cluster.
Nodes (machines) are divided into various partitions,
each with its own configuration: to allow different priorities of users;
see more with `sinfo` [below](#main-slurm-commands).
by default, if we didn't specify a partition,
our job would go in the `debug` partition.

other example to run an **array** of jobs:
the following slurm script, in file `echo_submit.sh`,
asks for a pair of `echo` commands to be run 10 times:

```shell
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user.name@wisc.edu
#SBATCH -J echo
#SBATCH -t 1:00           # 1 minute max here: because super simple "echo"s
#SBATCH --mem-per-cpu=1M  # only 1M: super simple "echo"s
#SBATCH --array=0-9
#SBATCH -o screen/echo_%a.log

# launch the "echo" script
echo "slurm task ID = $SLURM_ARRAY_TASK_ID"
echo "today is $(date)" > output/echo_$SLURM_ARRAY_TASK_ID.out
```

The key line that makes 10 repeats is `#SBATCH --array=0-9`.
This line also creates a shell variable `SLURM_ARRAY_TASK_ID`,
which is used as we would any other shell variable.  
The first `echo` command produces standard output written to
a file `screen/echo_?.log`.  
The second `echo` produces an output file `output/echo_?.out`.

Slurm is asked to capture the screen output to `screen/echo_*.log`,
so we need to create the `screen/` directory prior to running the script.
Also, for the second `echo` command to run successfully, we need to create
the directory `output/` prior to running the slurm script.

When we use a slurm array with `--array=0-9`,
it's like if we hit `sbatch` 10 times:
each iteration of the each array is a single job (single task);
although we'll get only 1 email in the end.

With `-c 8`, each individual iteration would get 8 cores.
We do *not* need this for our simple echo commands: each one is 1 task
and will be allocated its own CPU.
But we would need `-c 8` if our job did
`julia -p 8 myJuliastuff.jl` instead of our simple `echo`s.

To run the script, again:

```shell
sbatch echo_submit.sh
```

for more on resource allocations, such as node/task/CPU/core/threads,
or number of tasks and number of CPUs per tasks:
read
[this](https://kb.wisc.edu/stat/internal/page.php?id=106413).

<!--
```shell
#SBATCH ...
#SBATCH -n 10 # for n=10 tasks. or --ntasks

# R CMD BATCH --nosave myRstuff.r     # this is one "task"
srun R CMD BATCH --nosave myRstuff.r  # 10 (identical) tasks
```

above: `srun` within a batch script is slurm's version of MPI run.
will run same thing 10 times because we said `-n 10`

Matlab using the parallel tool kit would use options correctly.
-->

## main slurm commands

`sbatch` submits a batch script to the scheduler (shown earlier)

`sinfo` displays current "partitions" and idle, busy, down, up states.  
partition = group of computers

- "debug" partition (default): 2 hours limit
- "short" partition: 4 days limit (this is quite long actually!)
  <!-- 3 nodes (= 3 "marzano" servers) -->
- "long" partition: 8 days limit
- other partitions listed for various other research groups or
  resource levels

```shell
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug*       up    2:00:00      1   idle marzano01      # idle: all cores available
short        up 4-00:00:00      3    mix marzano[02-04] # mix: some jobs are running
long         up 8-00:00:00      9    mix marzano[05-13]
gpu          up 14-00:00:0      1   idle gpu02
hipri        up 5-00:00:00     12    mix marzano[02-13] # high priority: won't be nice to others
```
<!-- darwin       up   infinite      9   idle darwin[00-06,12-13] -->

`squeue` displays jobs currently running or queued  
`squeue -u username` for your own jobs only

```shell
$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           1002004     debug   elnet1    saeid PD       0:00      1 (PartitionTimeLimit) # PD = pending: waiting for resources
     1375816_[1-3]     debug combined     smin PD       0:00      1 (DependencyNeverSatisfied)
           1375817     debug answer_a     smin PD       0:00      1 (Dependency)
               ...
  1519371_[73-666]     short    0.003   shengw PD       0:00      1 (Resources)
   1519409_[1-666]      long     0.05   shengw PD       0:00      1 (Priority) # has priority over other jobs
        1477676_27      long      ppr  fanchen  R 1-19:12:02      1 marzano05 # R = running
       1517717_460      long      iGP  tzuhung  R    2:28:58      1 marzano10
       1517717_462      long      iGP  tzuhung  R    2:25:09      1 marzano11
               ...
       1517717_503      long      iGP  tzuhung  R      33:06      1 marzano09
        1519371_72     short    0.003   shengw  R      38:47      1 marzano03
               ...
        1519371_38     short    0.003   shengw  R      58:37      1 marzano04
        1519371_37     short    0.003   shengw  R      58:54      1 marzano04
```

`scontrol` to see info on currently running jobs  
`sstat` useful too, to get precise information about specific jobs

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

`sacct` or `sacct -u username`: (account) displays the user's jobs, cores used,
run states,
even after the jobs have finished

```shell
$ sacct -u mikec
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
6813933            bash      debug      mikec          8  COMPLETED      0:0 
6813934      submit_ho+      debug      mikec          4  COMPLETED      0:0 
6813934.bat+      batch                 mikec          4  COMPLETED      0:0 
...
```


Other notes:

- QOS = quality of service.  
  max of 24 CPUs used at one time.
  "normal" would not be high priority.
- if the task spawns more processes
  (e.g. Python script that runs IQ-TREE using multiple cores):
  slurm does not know about that, so it's important to allocate
  the appropriate number of cores with `#SBATCH -c xxx`
- in the slurm script, it can be handy to redefine your home with
  `export HOME=/workspace/username`.
<!--
- to use your preferred editor (e.g. VS Code) on the remote server:
  try sshfs (links for [Ubuntu](https://help.ubuntu.com/community/SSHFS)
  or [Mac](http://stuff-things.net/2015/05/20/fuse-and-sshfs-on-os-x/))
  or: https://code.visualstudio.com/docs/remote/ssh
-->

## srun: to diagnose issues

how do I know that my job has the resources it need?
why is my job failing?
- start small, check email report for how much memory was used
- use `srun` to trouble-shoot interactively

`srun` is the command-line version of `sbatch <submit-file-name>`, but might
need to wait and sit without being able to close the laptop, to actually run
a job.  
"SBATCH" options go on the `srun` command line.

below: we simply run `bash`, hopefully on the same machine as the job
we are trying to trouble-shoot:

```shell
srun --pty /bin/bash # start interactive session: will put me on some (unpredicted) node
hostname # to see where I landed
top # to check jobs on the machine where I happened to land
# ... things to see what's going on with our jobs on that machine
printenv | grep SLURM # environment variables not defined under submit node
exit
```

`pty` = pseudo terminal

`printenv` prints the environment variables:
regular environment variables plus all others set by slurm,
like `SLURM_JOB_PARTITION=debug` `SLURMD_NODENAME=marzano01` etc.  
Alternative to above, to see variables defined
by slurm when a submit script is run: `srun --pty printenv`

another example to get an interactive session with 8 cores, 1G memory per CPU:

```shell
srun --pty -c 8 --mem-per-cpu=1000M /bin/bash
```

<!-- If `scontrol` shows that our problematic job is running
on "marzano05", it would be great to run bash on that machine with
`srun --pty -w marzano05 /bin/bash`
but no longer works
-->

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
# ... function definitions ...
rep, samplesize, nrarecat, mu = arrayID_to_parameters(arrayID, Nreps)
# ...
# run simulation. use arrayID as seed: will be different for each replicate
pearson, gstat, p_pearson, p_gstat = onesimulation(samplesize, nrarecat, mu, arrayID)

# save the result in tiny csv-formatted file
# (later, all these files will be concatenated with "cat")
outputfile = joinpath(resultdirectory, "simulation_" * @sprintf("%04d", arrayID) * ".csv")
open(outputfile, "w") do g
  write(g, "$arrayID,$rep,$samplesize,$nrarecat,$mu,") # input
  write(g, "$pearson,$gstat,$p_pearson,$p_gstat\n")    # output
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
#SBATCH --mail-user=user.name@wisc.edu
#SBATCH -t 2:00               # we should need way less than 2 min per task
#SBATCH --mem-per-cpu=100M    # probably much more than needed: adjust after small trials
#SBATCH -o simresults/simulation_%a.log
#SBATCH -J sims
#SBATCH --array=1-240         # --array=1-2 for short trial
#SBATCH -p short

# warning: onesimulation.jl (below) and the -o option (above) assume that
# simresults/ has already been created

# use Julia packages in /worskpace/, not defaults in ~/.julia/ (on AFS):
export JULIA_DEPOT_PATH="/workspace/ane/.julia"

echo "slurm task ID = $SLURM_ARRAY_TASK_ID"

# launch Julia script, using Julia in /workspace/ and with full paths:
/workspace/software/julia-1.5.1/bin/julia /workspace/ane/st679simulations/onesimulation.jl $SLURM_ARRAY_TASK_ID 20
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
/workspace/software/julia-1.5.1/bin/julia onesimulation.jl 14 2
```

**run slurm quickly** (step 2)

- run the slurm script for a few trials only, to run the julia script
  2 times only (not 240 times yet) by editing to `#SBATCH --array=3-4`
  and make slurm `echo` the julia command, *not* run it. After editing
  the slutm submit script, run it:

```shell
sbatch simulations_submit.sh
squeue
```

- if all goes well, edit the submit script again to execute the julia
  command, not just echo it, then run again; but still for 3 trials only.
- look at the email report, and memory efficiency:
  adjust memory requirement accordingly. ideal: a bit below 100% efficiency
- monitor the jobs for these first few trials, predict the running time
  for the full 240 julia runs.

Here is an example email from a small run with `--array=3-4`:

    Job ID: 1519914
    Array Job ID: 1519914_4
    Cluster: marzano
    User/Group: ane/ane
    State: COMPLETED (exit code 0)
    Cores: 1
    CPU Utilized: 00:01:38
    CPU Efficiency: 70.00% of 00:02:20 core-walltime
    Job Wall-clock time: 00:02:20
    Memory Utilized: 44.01 MB
    Memory Efficiency: 88.02% of 50.00 MB

based on this report: change slurm options to use a max of 15 minutes only
and bump memory usage to 70MB perhaps (instead of the default 50M) for safety:
```
#SBATCH -t 15:00
#SBATCH --mem-per-cpu=70M
```

**run slurm** for the full simulation (step 3)

edit the script again to `#SBATCH --array=1-240` and
run the full array of 240 jobs, and submit like in step 2 above:

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
total of 3×2×2 = 12 combinations. A linear ID for parameter combinations
would run from 1 to 12. But what does combination 10 correspond to, for example?

```julia
julia> mus = [0.1, 1., 2.]; # parameters of interest: 3 values for mu
julia> samplesizes = [30, 1000]; # 2 values for samplesize
julia> nrarecats = [1, 2];       # 2 values for nrarecats

julia> indices = CartesianIndices( (3,2,2) ) # like a 3-dimensional array
3×2×2 CartesianIndices ...
[:, :, 1] =
 CartesianIndex(1, 1, 1)  CartesianIndex(1, 2, 1)
 CartesianIndex(2, 1, 1)  CartesianIndex(2, 2, 1)
 CartesianIndex(3, 1, 1)  CartesianIndex(3, 2, 1)

[:, :, 2] =
 CartesianIndex(1, 1, 2)  CartesianIndex(1, 2, 2)
 CartesianIndex(2, 1, 2)  CartesianIndex(2, 2, 2)
 CartesianIndex(3, 1, 2)  CartesianIndex(3, 2, 2)

julia> for i in 1:6
        @show i, indices[i]
       end
(i, indices[i]) = (1, CartesianIndex(1, 1, 1))
(i, indices[i]) = (2, CartesianIndex(2, 1, 1))
(i, indices[i]) = (3, CartesianIndex(3, 1, 1))
(i, indices[i]) = (4, CartesianIndex(1, 2, 1))
(i, indices[i]) = (5, CartesianIndex(2, 2, 1))
(i, indices[i]) = (6, CartesianIndex(3, 2, 1))

julia> A = reshape(112:-1:101, (3,2,2))
3×2×2 ...
[:, :, 1] =
 112  109
 111  108
 110  107

[:, :, 2] =
 106  103
 105  102
 104  101

julia> for i in 1:6
         println("A[indices[$i]] = $(A[indices[i]])")
       end
A[indices[1]] = 112
A[indices[2]] = 111
A[indices[3]] = 110
A[indices[4]] = 109
A[indices[5]] = 108
A[indices[6]] = 107

julia> A[10]
103

julia> A[1,2,2]
103

julia> indices[10]
CartesianIndex(1, 2, 2)

julia> indices[10].I
(1, 2, 2)

julia> mus[indices[10].I[1]]         # combination 10, parameter 'mu'
0.1

julia> samplesizes[indices[10].I[2]] # combination 10, parameter 'samplesize'
1000

julia> nrarecats[indices[10].I[3]]   # combination 10, parameter 'nrarecat'
2
```

---
[previous](notes1209.html)
