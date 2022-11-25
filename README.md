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

* install ansible and git<br>
  `sudo pacman -S ansible git`
*  clone this repo<br>
  `git clone https://github.com/DoTheEvo/ansible-arch.git`
* enter the directory<br>
  `cd ansible-arch`
* run the playbooks you want
    * `ansible-playbook -u $USER -K playbook_core.yml`
    * `ansible-playbook -u $USER -K playbook_zsh.yml`
    * `ansible-playbook -u $USER -K playbook_docker.yml`

yes, you write `$USER` there, which puts in the user you are logged in <br>
the `-K` is short for `--ask-become-pass` which will prompt for password

# Playbooks

[executing_playbook.webm](https://user-images.githubusercontent.com/1690300/196008623-278f5928-bb4d-4931-af5c-0acb03f4ab7f.webm)

### [playbook_core.yml](https://github.com/DoTheEvo/ansible-arch/blob/main/playbook_core.yml)

useful terminal progams, settings, maintance services 

* arch update/upgrade, equivalent of `pacman -Syu`
* install:<br>
  nano, micro, git, curl, wget, rsync, nnn, bat, tree, unarchiver, duf, ncdu,
  htop, iotop, glances, nmap, gnu-netcat, iproute2, bind, nload, sysfsutils,
  borg, fuse, python-llfuse, python-pip, python-setuptools, python-pexpect
* install yay to have access to AUR
* in pacman.conf enable color and enable parallel downloads
* in makepkg.conf disable compression and enable parallel compilation
* `noatime` set in fstab to avoid unnecessary writes of `relatime`
* increased allowed failed login attemps to 10 before lock out
* enable members of wheel group to sudo
* no sudo password needed for nnn editor
* services installed and enabled
    * ssh - remote access
    * plocate - file search locate
    * cronie - cron time scheduler
    * fstrim - weekly ssd trim
    * trash-cli - delete to trash
    * paccache - weekly clearing of pacman cache
    * reflector - weekly update of mirrorlist - !!change the country codes!!
* install neofetch
* check if in virtual machine and if vmware, hyperv, or virtualbox then
  install and enable supporting services
* install micro text editor, copy config, keybinds, syntax highlight
  set micro as the default editor in `.bashrc`

### [playbook_zsh.yml](https://github.com/DoTheEvo/ansible-arch/blob/main/playbook_zsh.yml)

![steeef-theme](https://i.imgur.com/ZAvdYSU.png)

* install zsh shell
* copy bash history in to .zhistory
* change the default shell from bash to zsh for the user
* install zimfw using its own script
* change the theme to `steeef`
* copy .myownrc with various predefined stuff
* source `.myownrc` in `.zshrc`

### [playbook_docker.yml](https://github.com/DoTheEvo/ansible-arch/blob/main/playbook_docker.yml)

* install docker, docker-compose, ctop
* enable and start docker service
* add the current user to the docker group to avoid need for sudo

### Local deployment

This is for a local deployment.
Meaning the machine is *changing* itself,
as oppose to more typical ansible use, where you run playbooks on one machine
to *change* 143 virtual machines somewhere on the cloud.

To go from local to remote, edit inventory, replace local entries
with IPs of machines you want to *change*.

# Useful

bunch of linux commands

* `sudo journalctl -p 3 -xb`
* `sudo journalctl -b -r`
* `sudo systemctl --failed`
* `sudo systemctl list-units --type=service --state=active`
* `sudo systemctl list-units --type=timer --state=active`
* `sudo systemctl list-timers`
* `sudo journalctl -u borg.timer`
* `cat /proc/cmdline`
* `lsmod`
* `lspci -k`
* `rsync -ah --info=progress2 ./minecraft /mnt/bigdisk/backup`
* `sudo dd bs=4M if=arch.iso of=/dev/sdX status=progress oflag=direct`
* `ss -tulpn` - shows what uses which port
* `sudo nc -vv -l -p 8789` - netcat starts tiny server listening at port 8789,<br>
   do port forwarding on router/firewall, then test on
   [https://www.grc.com/x/portprobe=8789](https://www.grc.com/x/portprobe=8789)
* `sudo nc -vv -u -l -p 8789` netcat server now in udp mode<br>
  can be tested with another netcat instance running `nc <ip> 8789`<br>
  writing something and pressing enter shows the text on the server

encountered issues when running arch linux server

* **in vmware issue with an error in journal** - piix4_smbus SMBus
  Host Controller not enabled<br>
  solution - in `/etc/modprobe.d/blacklist.conf` add `blacklist i2c_piix4`,
  reboot<br>
  check - `sudo journalctl -p 3 -xb` and `lsmod | grep i2c`
