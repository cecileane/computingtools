---
layout: page
title: Running Linux on a Chromebook
description: chromebook, hardware requirements
---

I got the Acer Chromebook 14 ($300) because it has an Intel chip, 32GB disk space and 4GB RAM.

install Linux
-------------
I used Crouton to instal Linux on it. See
[this](https://www.linux.com/learn/how-easily-install-ubuntu-chromebook-crouton)
and [this](https://github.com/dnschneid/crouton).
I choose the light Ubuntu 12.04 LTS (also called "precise") with Xfce4.

Once in Ubuntu, the first issue was the mouse. It was barely working, I had to press
really hard. In the terminal I did this to fix the sensitivity of the touchpad:
`synclient FingerLow=1 FingerHigh=5`.

I updated the system just to make sure:

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install

Afterwards, it was time to install a bunch of things.

<!--
Later, I downloaded the crouton extension and ran this in the chromeOS shell
to be able to use Ubuntu within ChromeOS's browser:
`sudo sh -e ~/Download/crouton -u -t xiwi`. To check what I had installed, I did
`sudo edit-chroot -al` (from the ChromeOS shell). To revert back to the `xorg`
method to handle windows instead of xiwi, I did
`sudo sh -e ~/Download/crouton -u -t x11`.
-->

install git
-----------
for version control, we'll use it a lot in the course.
very easy: `sudo apt-get install git` in the terminal.

install gedit
-------------
Oh my, there was no text editor. So I got `gedit` like this:
`sudo apt-get install gedit`.

I used it to add the line `synclient FingerLow=1 FingerHigh=5`
at the end of my bash profile configuration file: `.bashrc`.

install qpdfview
----------------
to view pdf files, supposed to be light and fast.
I did this to install `add-apt-repository`:

    sudo apt-get install software-properties-common
    sudo apt-get install python-software-properties

then this to install `qpdfview` itself:

    sudo add-apt-repository ppa:b-eltzner/qpdfview
    sudo apt-get update
    sudo apt-get install qpdfview

install Nautilus
----------------

Nautilus is a file browser that makes it really easy to connect to a server
(like the stat servers), access remote files and edit these files remotely without
having to store them locally.

I installed it with `sudo apt-get install nautilus`. It can be open by
clicking on a folder, or simply typing in the terminal: `nautilus .`

Go to `File` then `Connect to server` and enter the information from one
of the statistics servers (using SSH). Clicking on a text file to open
with gedit, and you can edit the remote file directly.


install Atom
------------
great [text editor](https://github.com/atom/atom).
might be too heavy for a chromebook though (?).
has a bunch of dependencies.

- First I tried the easy way: downloaded Atom v1.8.0
[here](https://github.com/atom/atom/releases/download/v1.8.0/atom-amd64.deb) and ran

      sudo dpkg --install atom-amd64.deb

  But it complained about unmet dependencies.

- Next I tried building the package from source, using instructions
[here](https://github.com/atom/atom/blob/master/docs/build-instructions/linux.md),
which start by getting dependencies (many are essential tools anyway) with this:

      sudo apt-get install build-essential libgnome-keyring-dev fakeroot

  but their own dependencies were not met, like `g++`, `make` and `dpkg-dev`.
So I ran this to get them: ```sudo apt-get -f install``` and then again

      sudo apt-get install build-essential libgnome-keyring-dev fakeroot 

  I ran another update of the system: ```sudo apt-get update``` then got `curl` like this:
```sudo apt-get install curl```

  Another of `atom`'s dependency is `Node.js`:
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
then
    sudo apt-get install -y nodejs
Then I followed the build instructions to build `atom`, in a new directory that I called
`apps`: 

    mkdir apps
    cd apps
    git clone https://github.com/atom/atom

  etc. But the build failed in the end.

- So I retried the installation using the pre-built package downloaded earlier,
hoping that the dependencies that were missing earlier would now be taken care of:

        sudo dpkg --install ~/Downloads/atom-amd64.deb

  This time, it worked. I could finally launch my text editor by doing `atom`.

tips
----
- at boot up: skip the (scary) developer mode message by pressing Ctrl+D.
- switching between ChromeOS and Ubuntu ("chroot") is a struggle.
  I don't have a fix for it yet, other than re-boot or do Ctrl-C in the ChromeOS shell.
- I disabled the screen saver in Ubuntu (app menu, settings, screen daver, mode) to see if
  that might help.
