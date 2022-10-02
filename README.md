# Ansible Arch

![Logo](https://i.imgur.com/yAyr3S2.png)

[Learning ansible?](https://www.youtube.com/watch?v=goclfp6a2IQ&list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)

# Overview

The objective is to have an easy way to have fresh arch instalation setup
the way one desires. Reliably and with the least amount of effort.
For this Ansible is used.

Ansible is an automation platform.<br>
It executes tasks from `playbooks` on machines listed in `inventory`.
Open source, developed by Red Hat.
Written and dependent on python. Uses YAML configuration files.
Agent-less, controled machines need just ssh+python (linux) or
winrm+powershell (windows).<br>
Praised for simplicity.

For now this repo aims at just server deployment of arch.
Terminal stuff, no xorg.

# How to execute

install arch linux, log in to a non root account that can sudo

* `sudo pacman -S ansible git` - install ansible and git
* `git clone https://github.com/DoTheEvo/ansible-arch.git` - clone this repo
* `cd ansible` - enter the directory
* run the playbooks you want
    * `ansible-playbook -u $USER -K playbook_core.yml`
    * `ansible-playbook -u $USER -K playbook_zsh.yml`
    * `ansible-playbook -u $USER -K playbook_docker.yml`

yes, you write `$USER` there, which puts in the user you are logged in <br>
the `-K` is short for `--ask-become-pass` which will prompt for password

# Playbooks

### playbook_core.yml

useful terminal progams, settings, maintance services, 

* arch upgrade, equivalent of `pacman -Syu`
* install:<br>
  nano, micro, git, curl, wget, rsync, nnn, bat, tree, unarchiver, duf, ncdu,
  htop, iotop, glances, nmap, iproute2, bind, borg, fuse,
  python-llfuse, python-pip, python-setuptools, python-pexpect, 
* install yay to have access to AUR
* color enabled in pacman.conf
* `noatime` set in fstab to avoid unnecessary writes of `relatime`
* increased allowed failed login attemps to 10 before lock out
* no sudo password needed for nnn editor
* services installed and enabled
    * ssh - remote access
    * plocate - file search locate
    * cronie - cron time scheduler
    * fstrim - weekly ssd trim
    * trash-cli - delete to trash
    * paccache - weekly clearing of pacman cache
    * reflector - weekly update of mirrorlist (change country codes)
* install micro text editor, copy configs,
  set micro as the default editor in `.bashrc`
* install neofetch
* check if in virtual machine and if vmware, hyperv, or virtualbox then
  install and enable supporting services

### playbook_zsh.yml

![steeef-theme](https://i.imgur.com/ZAvdYSU.png)

* install zsh shell
* copy bash history in to .zhistory
* change the default shell from bash to zsh for the user
* install zimfw using its own script
* change the theme to `steeef`
* copy .myownrc with various predefined stuff
* source `.myownrc` in `.zshrc`

### playbook_docker.yml

* install docker, docker-compose and ctop
* enable and start docker service
* add the current user to the docker group to avoid need for sudo


### Local deployment

This is for a local deployment.
Meaning the machine is *changing* itself,
as oppose to more typical ansible use, where you run playbooks on one machine
to *change* 143 virtual machines somewhere on the cloud.

To go from local to remote, edit inventory and remove local entries
and add IP of machines you want to *change*.

# Useful

* `systemctl list-units --type=service --state=active`
* `systemctl list-units --type=timer --state=active`
* `ss -tulpn`
   show what uses which port
* `rsync -ah --info=progress2`
* `sudo dd bs=4M if=arch.iso of=/dev/sdX status=progress oflag=direct`
* `lspci -k`
* `journalctl -b -r`
* `cat /proc/cmdline`
* `sudo nc -l -p 6112` -> port forwarding on router -> https://www.grc.com/x/portprobe=6112
