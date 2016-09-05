---
layout: page
title: getting started with git
description: git, github, getting started
---

## why git?

track and share versions of a project.  
what does git do?

- you take snapshots of your project once in a while. one "commit" = one snapshot
- git stores the changes between snapshots, not the whole files
- git stores its data (changes) in a special `.git` directory
- you can easily restore the whole project to a previous snapshot, then
  get back to the latest snapshot
- each collaborator has the project on her/his local machine, and
  another remote copy of the project is on GitHub.
  Collaborators can "pull" from GitHub and "push" to GitHub.

Let's browse [this git repository](https://github.com/crsl4/PhyloNetworks.jl),
click on:

- commits: see changes, see commit "name" (sha), browse file at earlier point
- graphs: see contributors, network of commits
- issues: for discussions between collaborators, to track bugs, next steps, etc.

## install git

Check to see if it's already installed:
`which git` (tells you where the git program is) or
`git --version`(tells you which version you have) or
`git --help` or `man git` to get help.

- to install git on Mac OSX:
  * get [homebrew](http://brew.sh) if you don't have it already.
    check with `which brew`.
  * install git through homebrew: run `brew install git`

- to install git on Linux:
  * Ubuntu or Debian: use the package manager "apt" (advanced packaging tools)
    and run `apt-get install git` or `sudo apt-get install git`
    (sudo = super-user do)
  * Fedora or RedHat: `sudo yum install git`

[Here](http://happygitwithr.com/install-git.html) is a another resource.

## configure git

run `git config -l` to list the current configuration for git.
Most likely, git doesn't know about your name etc. Set it like this,
but substitute my info with your own info:

```shell
git config --global user.name "Cecile Ane"
git config --global user.email "cecile.ane@wisc.edu"
git config --glabal github.user "cecileane"
git config --global color.ui true
```

The email above *must* be the email that you used to create your github account.
The last line is to get colors in the terminal when git will
to show changes (red for deletions, green for modifications).

Then run `git config -l` again to check that your git configuration is good.

## communicate with github

After you get work done on your project locally (on your laptop),
you will want to "push" this work to github. To avoid having to type
your github password over and over, we will use "ssh keys".
The steps below follow the github
[help](https://help.github.com/articles/generating-an-ssh-key/) on ssh keys.
Lots of details on the process [here](http://happygitwithr.com/ssh-keys.html) too.


1. check to see if you already generated a key pair earlier, in your hidden
  directory `.ssh` (recall that `~` is a shortcut for your home directory):

        $ ls -l ~/.ssh
        total 32
        -rw-------  1 ane  staff  1679 Dec 10  2015 id_rsa
        -rw-r--r--  1 ane  staff   397 Dec 10  2015 id_rsa.pub
        -rw-r--r--  1 ane  staff  5643 Jun 30 17:17 known_hosts

2. if you don't see a pair of files like `id_rsa` (private key)
  and `id_rsa.pub` (public key), then you need to generate one.
  To do so, run this, but substitute with your own address of course:

        ssh-keygen -t rsa -b 4096 -C "cecile.ane@wisc.edu"

    when prompted, keep the default options and do *not* enter any passphrase
  (just press "enter"). Then make sure your ssh authentication is working and
  that it knows about your new key:

        $ eval "$(ssh-agent -s)"
        Agent pid 12584
        $ ssh-add ~/.ssh/id_rsa

3. tell github about your new key:
  run `cat ~/.ssh/id_rsa.pub` to view your public key,
  copy it to your clipboard and paste it into github’s form.
  To get this form: go to github, click on your profile photo (top right corner),
  click "Settings" then "SSH and GPG keys" on the side bar, then
  "New SSH key". Paste your key into the "Key" field. For the title,
  pick a tile that describes your laptop. Each laptop / desktop / server
  that you use will need its own key. Click "Add SSH key" to finish.

4. finally, check that git, on your laptop, can communicate with github:
  `ssh -T git@github.com`

## get data from github

Data for the first homework is on [github](https://github.com/UWMadison-computingtools/coursedata//tree/master/hw1-snaqTimeTests),
you can see it easily in a browser. To get it on your laptop:

- navigate to where you want the data to go
  (this should **not** be inside any current git repository!)
- run this

      git clone git@github.com:UWMadison-computingtools/coursedata.git

    You should see a new directory `coursedata`. Do `ls` to check and
  `ls coursedata` to see what's in there.
- follow the instructions in the coursedata
  [readme.md](https://github.com/UWMadison-computingtools/coursedata/blob/master/readme.md)
  to set up a git repository to submit your homework. You should have downloaded
  this readme.md file along with the data, so take a look at it to
  get examples of the markdown format.
