---
layout: page
title: connecting to remote machine to run long jobs
description: course notes
---
[previous](notes1013.html) &
[next](notes1020.html)

---

## connecting to remote machines: ssh, scp

`ssh`: secure shell

```shell
ssh ane@desk22.stat.wisc.edu # need to authenticate. password: # characters not shown
hostname
logout
hostname # just in case I switch a lot and don't remember
```

message after first login to a machine:

```
RSA key fingerprint is SHA256:xxx.
Are you sure you want to continue connecting (yes/no)?
```

if yes, information stored in `~/.ssh` folder:

```shell
less -S ~/.ssh/known_hosts
ssh desk22.stat.wisc.edu # login name not needed if same as on local machine
cd private/st679/
ls
emacs -nw notes/statservers.md # or nano or vim: no new window. ^X^C to quit emacs.
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
scp -p ane@desk22.stat.wisc.edu:private/st679/notes/statservers.md notes/
ls -l notes/statservers.md
scp -r desk22.stat.wisc.edu:private/st679/classroom-repos/hw1/log .
ls -l
ls -l log/
echo "hi Cecile" > coolfile
scp coolfile ane@desk22.stat.wisc.edu:private/ # works both directions
```

slight difference between cp and scp:  
`cp -r log/ target/path/` copies the *content* of the `log/` directory  
`cp -r log  target/path/` copies the directory itself *and* its content

```shell
rm -r log
scp -r desk22.stat.wisc.edu:private/st679/classroom-repos/hw1/log/ .
ls
rm -r log
cp -r classroom-repos/hw1/log .
ls
rm -r log
cp -r classroom-repos/hw1/log/ .
ls
rm *.log
```

## long-running jobs: nohup

Previous example of long-running job: get data and link to program
[here](https://github.com/UWMadison-computingtools/coursedata/tree/master/example-mrbayes)

```shell
cd classroom-repos/lecture-examples/mrbayes-example/
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
cd private/st679/classroom-repos/lecture-examples/mrbayes-example/
mb mrBayes-run.nex > screenlog &
logout

ssh desk22.stat.wisc.edu
ps -u ane | grep mb # gone
cd private/st679/classroom-repos/lecture-examples/mrbayes-example/
tail screenlog
```

let's do this again but with `nohup` before our command:

```shell
rm -f alignedDNA.nex.* screenlog # clean up
nohup mb mrBayes-run.nex > screenlog &
logout

ssh desk22.stat.wisc.edu
ps -u ane | grep mb # still there if lucky
cd private/st679/classroom-repos/lecture-examples/mrbayes-example/
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
cd private/st679/classroom-repos/lecture-examples/mrbayes-example/
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

- [ACI](https://aci.wisc.edu/resources/#research-computing-beyond-desktop)
  (advanced computing initiative) and
  [CHTC](http://chtc.cs.wisc.edu) (center for high-througput computing)
  with HTCondor for job scheduling
- [HPC](http://www.stat.wisc.edu/services/hpc-cluster1/overview)
  cluster "lunchbox" in Statistics: uses [slurm](http://slurm.schedmd.com)
  for job scheduling


---
[previous](notes1013.html) &
[next](notes1020.html)
