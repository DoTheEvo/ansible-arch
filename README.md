# Ansible Arch

![Logo](https://i.imgur.com/yAyr3S2.png)

[Learning ansible?](https://www.youtube.com/watch?v=goclfp6a2IQ&list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)

# Overview

The objective is to have an easy way to have fresh arch installation setup
the way one desires. Reliably and with the least amount of effort.
For this Ansible is used.

Ansible is an automation platform.<br>
It executes tasks from `playbooks` on machines listed in `inventory`.
Open source, developed by Red Hat.
Written and dependent on python. Uses YAML configuration files.
Agent-less, controlled machines need just ssh+python (linux) or
winrm+powershell (windows).<br>
Praised for simplicity.

This repo aims to be easily customizable, playbooks being as simple as possible.
One should be able to look at them, see how stuff is done and make own changes.

# How to execute

install arch linux ([archinstall](https://github.com/archlinux/archinstall)), log in to a non root account that can sudo

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

**Removal**<br>
After running playbooks it be good to remove ansible package
and bunch of its dependencies. Saves \~600MB and noise during updates.

* `sudo pacman -Rns ansible`

# Playbooks

[executing_playbook.webm](https://user-images.githubusercontent.com/1690300/196008623-278f5928-bb4d-4931-af5c-0acb03f4ab7f.webm)

### [playbook_core.yml](https://github.com/DoTheEvo/ansible-arch/blob/main/playbook_core.yml)

useful terminal programs, settings, maintenance services 

* arch update/upgrade, equivalent of `pacman -Syu`
* install:<br>
  nano, micro, man-db, git, curl, wget, rsync, nnn, fd, fzf, bat, tree,
  unarchiver, fastfetch, duf, ncdu, htop, btop, iotop, glances, nmap, gnu-netcat,
  tcpdump, net-tools, iproute2, bind, nload, sysfsutils, lsof, borg, fuse,
  python-llfuse, python-pip, python-setuptools, python-pexpect, sqlite
* install yay to have access to AUR<br>
  set - remove make dependencies, always clean builds, cleanup after
* in pacman.conf enable color and enable parallel downloads
* in makepkg.conf disable compression and enable parallel compilation
* `noatime` set in fstab to avoid unnecessary writes of `relatime`
* increase allowed failed login attempts to 10 before lock out
* enable members of wheel group to sudo
* add current user to root group and disable need for entering sudo password
* services to install and enable
    * ssh - remote access
    * nnn - get plugins, no sudo needed
    * plocate - file search locate
    * cronie - cron time scheduler
    * archlinux-keyring - weekly update
    * fstrim - weekly ssd trim
    * trash-cli - delete to trash
    * paccache - weekly clearing of pacman cache
    * reflector - weekly update of mirrorlist - !!change the country codes!!
    * logrotate - if need to prevent logs from growing
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
* set default max logs size to 250MB and set logs rotation

### [playbook_lts_kernel.yml](https://github.com/DoTheEvo/ansible-arch/blob/main/playbook_lts_kernel.yml)

* detect bootloader - systemd or grub
* installs linux-lts package
* switch to lts kernel

After experiencing [a kernel regression](https://bbs.archlinux.org/viewtopic.php?id=288723),
it became apparent that switch to [lts kernel](https://www.kernel.org/category/releases.html)
should be the default.<br>
Archinstall script on ISO supports the choice of lts kernel during the installation.
This playbook solves it for already running machines, if they use grub or systemd-boot.

Be careful. Snapshot before you try.

### Local deployment

This is for a local deployment.
Meaning the machine is *changing* itself,
as oppose to more typical ansible use, where you run playbooks on one machine
to *change* 143 virtual machines somewhere on the cloud.

To go from local to remote, edit inventory, replace local entries
with IPs of machines you want to *change*.

### Personal workflow

The core application is `nnn` file manager.<br>
launched by `n` command, or `nnnn` to run it as root, but with user ENVS

* nnn is configured through exports in `.myownrc` file and through flags
  used in the `n` and `nnnn`
* `?` key - shows hotkeys, can also see what bookmarks are set<br>
  bookmarks are used by pressing 'b' and then one of the offered letters,
  like 'h' for home or 'e' for /etc
* `!` key - opens terminal in the current directory, to return back to `nnn`
  press `ctrl+d`, there is `N1` indication that we are in a terminal opened
  from under `nnn`
* `e` key - edits currently selected file in preset editor - micro for me
* `;f` keys - open fzf file search in current directory,
* `d` key - switches to detail view, pressing `t` and `d` shows directories size


# Useful

links

* [virtualization_type detection script](https://github.com/ansible/ansible/blob/devel/lib/ansible/module_utils/facts/virtual/linux.py)

bunch of linux commands

* `journalctl -p 3 -rb`
* `journalctl -p 3 -rxb`
* `journalctl -rb`
* `systemctl --failed`
* `systemctl list-units --type=service --state=active`
* `systemctl list-units --type=timer --state=active`
* `systemctl list-timers`
* `journalctl -ru borg.timer`
* `systemctl list-units --type=mount`
* `systemctl list-units --type=automount`
* `findmnt`
* `cat /proc/cmdline`
* `lsmod`
* `lspci -k`
* `rsync -ah --info=progress2 ./minecraft /mnt/bigdisk/backup`
* `sudo dd bs=4M if=arch.iso of=/dev/sdX status=progress oflag=direct`
* `sudo nethogs` - realtime traffic per process
* `sudo ss -tulpn` - shows what uses which port
* `host 10.0.19.2` - hostname lookup
* `curl ipinfo.io` - get current public IP
* `sudo nc -vv -l -p 8789` - netcat starts tiny server listening at port 8789,<br>
   do port forwarding on router/firewall, then test on
   [https://www.grc.com/x/portprobe=8789](https://www.grc.com/x/portprobe=8789)
* `sudo nc -vv -u -l -p 8789` netcat server now in udp mode<br>
  can be tested with another netcat instance running `nc -u <ip> 8789`<br>
  writing something and pressing enter shows the text on the server
* `sudo tcpdump -n udp port 21116` - see udp traffic on a port
* `pacman -F <path to a file>` - which package owns that file
* `grep -i upgraded /var/log/pacman.log | tac | less` - last upgraded packages
* `duf`

# Encountered issues

* **In vmware issue with an error in journal** - piix4_smbus SMBus
  Host Controller not enabled<br>
  solution - in `/etc/modprobe.d/blacklist.conf` add `blacklist i2c_piix4`,
  reboot<br>
  check - `sudo journalctl -p 3 -xb` and `lsmod | grep i2c`
* **Weekly hang-up because swap was off**. Archlinux VM docker host experienced
  [huge spike of constant disk use](https://i.imgur.com/2NWXpu8.png)
  which was cause by the lack of SWAP. After adding 6GB swap file it was rock solid.
* If **running arch without update for a long time** - `sudo pacman -Sy archlinux-keyring`
  before updating everything else with `pacman -Syu`.<br>
  Enabling `archlinux-keyring-wkd-sync.timer` will update the package weekly.
  It's part of the core playbook.<br>
  It's run history be checked - `journalctl -ru archlinux-keyring-wkd-sync.timer`
* To **update zim** zsh framework- `zimfw upgrade` and `zimfw update`.

# disk commands

* equivalent of win `diskpart` > `clean` that wipes everything<br>
  `sudo dd if=/dev/zero of=/dev/sdX bs=1M count=1`
* create clean partition<br>
  `sudo cfdisk /dev/sdX`<br>
  `sudo mkfs.ext4 /dev/sdx1`
* check uuid<br>
  `sudo lsblk -f`
* fstab entry<br>
  `UUID=e2516713-8c13-430f-84a6-3c2fefe3ec1e   /mnt/data-1   ext4  rw,noatime,nofail 0 1`
