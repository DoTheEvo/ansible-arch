# Ansible Arch Linux

![Logo](https://i.imgur.com/5BJIQHk.png)

[Learning ansible?](https://www.youtube.com/watch?v=goclfp6a2IQ&list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)

# Overview

Ansible is an automation platform.<br>
It executes commands from `playbooks` on machines listed in `inventory`.

Open source. Developed by Red Hat.
Written and dependent on python. Uses YAML formatting configuration.
Agent-less, just machines with ssh+python (linux) or
rdp+powershell (windows).<br>
Praised for simplicity.

# Objective

To clone a repo, execute few commands, wait,
and BAM arch is suddenly just like you want it.<br>
To have a dedicated place where to write prefered applications, services, settings,..

# How to execute

install arch linux, log in to a non root account that can sudo

* install ansible and git - `sudo pacman -S ansible-core git`
* install pacman module for ansible - `ansible-galaxy collection install community.general`
* clone this repo - `git clone https://github.com/DoTheEvo/ansible.git`
* enter the directory - `cd ansible`
* run the playbooks you want
    * `ansible-playbook -u $USER -K playbook_core.yml`
    * `ansible-playbook -u $USER -K playbook_zsh.yml`
    * `ansible-playbook -u $USER -K playbook_docker.yml`

*extra info:*<br>
the `-K` is short for `--ask-become-pass` to prompt for $USER password

# playbooks

#### playbook_core.yml

* various packages gets installed<br>
  nano, micro, git, curl, wget, nnn, htop, glances, iproute2, bind, borg, fuse, python-llfuse, python-pip, python-setuptools, python-pexpect, 
* yay to access AUR
* color is enabled in pacman.conf
* noatime time is set in fstab to avoid unnecessary writes of relatime
* some services are installed and enabled
    * cronie - cron time scheduler
    * fstrim - for weekly ssd trim
    * paccache - for weekly clearing of pacman cache
    * reflector - for weekly update of mirrorlist

#### playbook_zsh.yml

* install zsh shell
* install zimfw using its own script
* change theme to `steeef`
* copy .myownrc with some predefined hotkeys and editor
* link .myownrc in .zshrc
* change shell for the user

#### playbook_docker.yml

* install docker, docker-compose and ctop
* enable and start docker service
* add user to the docker group to avoid need for sudo




#### Local deployment

This is a local deployment.
Meaning playbooks are run on the machine that is being *changed*.
As oppose to more typical ansible use, where you run playbooks on your machine
to *change* 219 virtual machines somewhere on cloud.
