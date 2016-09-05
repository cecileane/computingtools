---
layout: page
title: 10/18 notes
description: course notes
---
[previous](notes1013.html) & [next](notes1020.html)

---

## homework

Review the solution of exercise 3 for 2 of your peers:

  * provide constructive feedback for each one via a github issue discussion,
  * by email, send me marks according the grading [rubric](https://github.com/UWMadison-computingtools/coursedata/blob/master/rubric.md) (dummy example  [here](https://github.com/UWMadison-computingtools/coursedata/blob/master/marktemplate.csv)).

**Install python 3** (and the [conda](http://conda.pydata.org/)
package management) if you don't already have it.

- do `which python` and `python --version` to see if you already have python
  installed, and if so, what version you have. Versions 3.x are not
  back-compatible with version 2.x. We will work with version 3.
  If you see that you have version 2.x (like 2.7.10), then you will need
  to install python 3.

- follow instructions from [software carpentry](http://uw-madison-aci.github.io/2016-06-08-uwmadison/#python),
  with Anaconda. Make sure to choose **python 3.5** and not Python 2.7.
  Read below if you want a lighter installation that uses less memory.

- test that the installation worked:

  ```shell
  $ python --version
  Python 3.5.2 :: Anaconda 4.2.0 (x86_64)
  ```

  If you don't get anything or not a python 3.x version, exit your shell,
  open it again, and try `python --version` again.
  Also do `conda list` to see what conda installed for you.

- Anaconda installs for you several things: the conda package manager,
  python, ipython notebook, and many python libraries like numpy and scipy.
  It took 1.4G of hard disk for me. If you want a lighter installation,
  install [miniconda3](http://conda.pydata.org/miniconda.html) instead. It gets you python 3 and the [conda](http://conda.pydata.org/docs/intro.html)
  package manager. With conda you can install all these other packages later:
  as you need them. For instance, the numpy library would
  be installed with: `conda install numpy`.
  The [jypyterlab](https://github.com/jupyter/jupyterlab) package could be
  installed from the [conda-forge](https://conda-forge.github.io) channel with:
  `conda install -c conda-forge jupyterlab`.  
  If you installed miniconda instead of anaconda, do a
  [test drive](http://conda.pydata.org/docs/test-drive.html).

- jupyter: some students using Bash (Ubuntu) on Windows had errors running jupyter.
  This Windows [bug report](https://github.com/Microsoft/BashOnWindows/issues/185)
  has a fix that worked for some:
  `conda install -c jzuhone zeromq=4.1.dev0`

---

<p></p>

## connecting to remote machines: ssh, scp

`ssh`: secure shell

```shell
ssh ane@desk22.stat.wisc.edu # need to authenticate. password: # characters not shown
hostname
logout
hostname # just in case I switch a lot and don't remember
cat ~/.ssh/known_hosts
ssh desk22.stat.wisc.edu # login name not needed if same as on local machine
cd private/st679/
ls
emacs -nw notes/statservers.md # or nano: no new window. ^X^C to quit.
logout
```

To use an editor that needs a new window: need to enable X11 forwarding.
can be a headache, and can makes things a lot slower.

To avoid typing your password each time: copy the *public* key from your laptop
(in `id_rsa.pub`) to the file `~/.ssh/authorized_keys` on the remote server.
You created a key pair earlier for github, and copied your public key to your
github profile.

`scp`: secure copy. Same as `cp`, but need to provide user name,
machine name and full path on the remote machine. works over ssh.

```shell
scp ane@desk22.stat.wisc.edu:private/st679/notes/statservers.md ../notes/
cd ..
ls -l notes/statservers.md
scp -r desk22.stat.wisc.edu:private/st679/coursedata/hw1-snaqTimeTests/log .
ls -l
ls -l log/
echo "hi Cecile" > coolfile
scp coolfile ane@desk22.stat.wisc.edu:private/ # works both directions
```

slight difference between cp and scp:  
`cp -r log/ target/path/` copies the *content* of the `log/` directory  
`cp -r log  target/path/` copies the directory itself *and* its content

```shell
rm -rf log/
cp -r coursedata/hw1-snaqTimeTests/log/ .
ls -l
cp -r coursedata/hw1-snaqTimeTests/log .
ls -l log/
rm -rf *.log log/
```

## long-running jobs: nohup

Previous example of long-running job: get data and link to program
[here](https://github.com/UWMadison-computingtools/coursedata/tree/master/example-mrbayes)

```shell
cd coursedata/example-mrbayes
ls
head -n 17 alignedDNA.nex
head mrBayes-run.nex
mb mrBayes-run.nex > screenlog &
tail -f screenlog # control-C to stop
```

Now, I want to run this on the stat servers, log out,
log back in tomorrow to get the results.

- log out: exit the terminal, all jobs started from it will be sent
  a "hang up" signal (SIGHUP), and killed.
  (recall: SIGKILL with `kill -9`, SIGINT with control-C, SIGTSTP with control-Z)
- `nohup`: will catch and ignore this hang-up signal

```shell
ssh desk22.stat.wisc.edu
cd private/st679/coursedata/example-mrbayes/
mb mrBayes-run.nex > screenlog &
logout

ssh desk22.stat.wisc.edu
ps -u ane | grep mb # gone
cd private/st679/coursedata/example-mrbayes/
tail screenlog
```

let's do this again but with `nohup` before our command:

```shell
rm -f alignedDNA.nex.* screenlog # clean up
nohup mb mrBayes-run.nex > screenlog &
logout

ssh desk22.stat.wisc.edu
ps -u ane | grep mb # still there if lucky
cd private/st679/coursedata/example-mrbayes/
ls -l
rm -f alignedDNA.nex.* screenlog
```

but `nohup` does not work well on our stat servers, actually.  
AFS  (Andrew file system): has a very strong authentication system,
uses "tokens" to grant permissions, issued from Kerberos "tickets".

```shell
tokens # has expiration date
klist  # first: ticket-granting ticket, second: AFS token
```

When I log out, I lose my token, and my permissions to write to files,
so my process runs but will have an error as soon as it will want to write to
or read from a file.

## tmux: terminal multiplexer

solves several challenges, like GNU `screen`

- `tmux` sessions can be **detached** and **reattached**:
  detach, log out, log back in, re-attach  
- **multiple windows** in a session:
  say one with an editor, and another for shell commands

do `which tmux` to see if you already have `tmux` installed. if not:
`brew install tmux` on a Mac,
`sudo apt-get update` then `sudo apt-get install tmux` on Ubuntu.

check your tmux configuration: use this
[.tmux.conf](https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-04-working-with-remote-machines/.tmux.conf) file
to change the default prefix to `^a`  
(to be the same as `screen`, otherwise default is `^b`).

```shell
cat ~/.tmux.conf   # if you don't have this file: create it
emacs ~/.tmux.conf # uncomment last 2 lines
```

In this file, I suggest that you uncomment the last 2 lines:
to split panes more intuitively.  
Now run tmux:

```shell
tmux new-session -s mb-analysis # new screen shows up
echo 'hi cecile!'
pwd
# ^a d  to detach the session
tmux list-sessions
tmux attach
# ^a d to detach again
tmux attach -t mb-analysis
# ^a d to detach yet again
logout

ssh desk22.stat.wisc.edu
tmux list-sessions    # mb-analysis still there
ps -u ane | grep tmux # still running
tmux attach
logout # to start new session (lost token)
```

### tmux windows and panes

```shell
tmux new-session -s mb-analysis
cd private/st679/coursedata/example-mrbayes/
ls
rm -f alignedDNA.nex.* screenlog # clean up things that didn't finish
emacs mrBayes-run.nex # change ngen=1000000 to 5000000
# ^a c   to create a new window
pwd # same directory as previous window
nano readme.md # document change in mb options, etc.
# ^a c   creates a 3rd window
mb mrBayes-run.nex > screenlog &
# ^a |   new pane: splits vertically
```

now let's switch between windows and between panes:

|------|-------------|
| tmux keys | action |
|:-----|:------------|
| `^a d` | detach |
| `^a c` | create new window |
| `^a |` or `^a -`| splits window vertically or horizontally (depends on config file)|
| `^a n` or `^a p` | go to next or previous window |
| `^a` left arrow | go to left pane. other arrows for right, top, bottom panes |
| `^a ?` | list all key sequences |
| `^a &`, `exit` or `logout` | kill current window |
| `^a x` | kill current pane |
|--------|------------|
|        |            |
{: rules="groups"}

then detach and check on our session.

### long jobs on stat.wisc.edu machines

See [here](https://www.stat.wisc.edu/computing-lab/how-perform-long-running-jobs),
where you can replace `screen` by `tmux`.

idea: run a `stashticket` command to maintain the AFS token before starting
a `tmux` (or `screen` session), and run an `ssh` session inside of it.

- one simple 1-window `tmux` session in which I `ssh`.
- If I need multiple windows, then run another `tmux` session inside.

## running many jobs

- high performance: one (or few) very long job(s),
  possibly requiring a lot of memory
- high throughput: very many job, each short (<24h).
  need program to distribute the jobs across very many different machines,
  and to get all output files back from these machines at the end.

resources on campus:

- [ACI](https://aci.wisc.edu/services/large-scale/)
  (advanced computing initiative) and
  [CHTC](http://chtc.cs.wisc.edu) (center for high-througput computing)
  with HTCondor for job scheduling
- new [HPC](http://www.stat.wisc.edu/services/hpc-cluster)
  cluster "lunchbox" in Statistics: uses [slurm](http://slurm.schedmd.com)
  for job scheduling


---
[previous](notes1013.html) & [next](notes1020.html)
