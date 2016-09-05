---
layout: page
title: 12/15 notes
description: course notes
---
[previous](notes1208.html)

---

## job scheduling with slurm

by Mike Cammilleri

[slurm](https://slurm.schedmd.com): simple linux utility for resource management.  
[Instructions](http://www.stat.wisc.edu/services/hpc-cluster)
for our Stat department system.

- head node: `lunchbox.stat.wisc.edu`
- 6 `marzano` machines, each with 24 CPUs * 2 threads = 48 cores each.

The CHTC on campus uses slurm too for their high performance cluster.

file systems:

- AFS (Andrew File System) like `/u/x/x/username`:
  great for backing-up data and to share files with colleagues,
  but slow (and with expiring authentication tokens):
  bad for running things on the cluster!

- NFS (Network File System) in `/workspace`: do stuff here.
  All notes machines in the cluster have access to this directory.
  Software (R, julia, python) installed in `/workspace/software`,
  install your own packages in `/workspace/<username>/<dir>` and
  set permissions with `chmod`


### simple test example

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

`#SBATCH -t 1`: expected time, in minutes.
default is 4 days, which puts the submission at the bottom of the queue.  
`#SBATCH -n 3`: requests 3 cores; the 9 (super short) tasks
will be run one after the other.

To run the script:

```shell
sbatch echo_submit.sh
```

## main slurm commands

`sbatch` submits your batch script to the scheduler (example earlier)

`sinfo` displays current "partitions" and idle, busy, down, up states.  
partition = group of computers

- "short" partition (default): 4 days limit, 2 nodes (= 2 "marzano" servers)
- "long" partition: 2 week limit, 4 nodes
- other partitions listed for various other research groups,
  resource levels (e.g. higher memory, longer runs, etc.)

```shell
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
long         up 14-00:00:0      4   idle marzano[01-04]
short*       up 4-00:00:00      2   idle marzano[05-06]
darwin       up   infinite      9   idle darwin[00-06,12-13]
```

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

`sacct`: (account) displays your jobs, cores used, run states,
even after the jobs have finished

Other notes:

- `#SBATCH -p long`: to send jobs to the "long" partition
- QOS = quality of service.  
  max of 24 CPUs used at one time.
- if the job spawns more processes (like a Python script that runs RAxML using multiple cores): slurm does not know about that, so it's important to allocate
the appropriate number of cores with `#SBATCH -n xxx`
- in the slurm script, it can handy to redefine your home with
  `export HOME=/workspace/ane` (adapt the user name).
- to user your preferred editor (Atom?) on the remote server:
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



### example to run a bunch of julia scripts

General guideline:
**start simple** with 1 task, 1 process, 1 job. expand from there.

Below: we want to run a julia script
[`onesnaq.jl`](../assets/julia/onesnaq.jl)
240 times, each time with a different set of parameters.
To start simple:

1. We check that the julia script runs without error once,
  with 1 set of parameters, without using slurm, and on a
  slightly modified script to make it run fast.
2. To check that the slurm submission works:
  the script `onesnaq.jl` is modified so that it does *not* run the main
  time-consuming command, but only prints this command as a string.
  Writing this string to the intended output file also checks that
  output files are writable with correct path etc.
3. Finally: we modify the script `onesnaq.jl` to its final version
  to run its main time-consuming command, not just print it.

The example below shows steps 1 and 2.
Save the following script in file `onesnaq_submit.sh`:

```shell
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cecile.ane@wisc.edu
#SBATCH -o snaq/onesnaq_%a.log
#SBATCH -J onesnaq
#SBATCH --array=0-239
#SBATCH -p long

# use Julia packages in /worskpace/, not defaults in ~/.julia/ (on AFS):
export JULIA_PKGDIR="/workspace/ane/.julia"

# launch Julia script, using Julia in /workspace/ again, with full paths:
echo "slurm task ID = $SLURM_ARRAY_TASK_ID"
/workspace/software/julia-0.5.0/julia /workspace/ane/timetest/onesnaq.jl 1 30 $SLURM_ARRAY_TASK_ID
```

It will run the julia script [`onesnaq.jl`](../assets/julia/onesnaq.jl)
(last line) 240 times (from `#SBATCH --array=0-239`).  
The julia script gets 3 arguments: 1, 30, and the value of
`SLURM_ARRAY_TASK_ID` (0,1,...,239).
Julia will use this last integer argument to set an array of parameter values.

**preparation**

- copy your input file, julia file, submit file etc:

```shell
scp onesnaq* lunchbox.stat.wisc.edu:/workspace/ane/timetest/
```

- `ssh` to lunchbox and go to your folder in `workspace`.
- step1 : check that the julia script is working by running it once,
  with the 3<sup>rd</sup> argument set to 0 for instance:

```shell
export JULIA_PKGDIR="/workspace/ane/.julia"
/workspace/software/julia-0.5.0/julia onesnaq.jl 1 30 0
```

**run slurm** (step 2)

- run the slurm script for a few trials only, to run the julia script
  3 times only (not 240 times yet):

```shell
sbatch onesnaq_submit.sh --array=0-2
squeue
```

- monitor the jobs for these first few trials, predict the running time
  for the full 240 julia runs.
- run the full array of 240 jobs:

```shell
sbatch onesnaq_submit.sh
squeue
```

for step 3: we would just need to edit the Julia script
to make it run the main command not just print it, then submit
the final julia script to slurm like in step 2 above.

### converting the array task ID

single integer: but can be used to set parameter values
within your Julia/Python/R script.  
example: run this Julia command with various values
for `Nfail`, and for tolerance parameters `ftolAbs` etc.
to stop the likelihood optimization:

```julia
snaq!(startingNet, tableCF, hmax=h, Nfail=NF,
      ftolAbs=FTA, ftolRel=FTR, xtolRel=XTR, xtolAbs=XTA,
      liktolAbs=LTA, runs=runs, seed=s, filename=rootname)
```

We want to have these parameters take these values:

```julia
lFTA = [0.000001, 0.00001, 0.0001, 0.001, 0.01]
lNF    = [100, 75, 50, 25]
lRatio = [1, 100, 10000]   # controld LTA: Ratio=LTA/FTA
lXTR   = [0.001,    0.01]
lXTA   = [0.000001, 0.001]
```

It makes for a total of 5\*4\*3\*2\*2 = 240 combinations of parameter values,
so 240 calls to the `snaq!` function.
We can convert an integer in 0,...,239 into exactly one combination
with the `comb` function below.
To explain its algorithm,
imagine that we only had the first 2 parameters to vary: FTA and NF,
with a total of 5\*4 = 20 combinations. The algorithm would map:

- the first 5 integers 0,1,2,3,4 to NF=100
- the next 5 integers 5,6,7,8,9 to NF=75
- ...
- the last 5 integers 15,16,17,18,19 to NF=25.

Within each set of 5 integers, the first would get FTA=0.000001, ...,
and the 5<sup>th</sup> would get FTA=0.01.
To code this, we do the integer division of the input integer `i` by 5
(number of FTA values) using `d,r = fldmod(i,5)`

- the remainder `r` is in 0,...,4 and gives us the index for the FTA value
- the quotient `d` is in 0,...,3 (i<20) and gives us the index for the NF value.

In general, we would again divide `d` by 4 (number of values for NF), and so on.

```julia
nparams = 5
nlevels = [length(lFTA),length(lNF),length(lRatio),length(lXTR),length(lXTA)]
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
```

---
[previous](notes1208.html)
