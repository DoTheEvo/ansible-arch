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
After running the playbooks it be good to remove the ansible package
and bunch of its dependencies. Saves \~600MB and noise during updates.

* `sudo pacman -Rns ansible`

# Playbooks

You are expected to click on those playbooks yml links,
to see how simple and nicely readable it all is.

[executing_playbook.webm](https://user-images.githubusercontent.com/1690300/196008623-278f5928-bb4d-4931-af5c-0acb03f4ab7f.webm)

### [playbook_core.yml](https://github.com/DoTheEvo/ansible-arch/blob/main/playbook_core.yml)

useful terminal programs, settings, maintenance services 

* arch update/upgrade, equivalent of `pacman -Syu`
* install:<br>
  nano, micro, man-db, git, curl, wget, rsync, nnn, fd, fzf, bat, tree,
  unarchiver, fastfetch, duf, ncdu, htop, btop, iotop, glances, nmap, gnu-netcat,
  tcpdump, inetutils, net-tools, iperf3, iproute2, bind, nload, sysfsutils, lsof,
  fuse, arch-install-scripts, python-llfuse, python-pip, python-setuptools,
  python-pexpect, sqlite
* install yay to have access to AUR<br>
  set - remove make dependencies, always clean builds, cleanup after
* in pacman.conf enable color
* in makepkg.conf disable compression and enable parallel compilation
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
* check if in virtual machine and if vmware, hyperv, or virtualbox then
  install and enable supporting services
* network setup changes
  * change systemd network config, using mac insted of interface name,
    this avoids issues on hardware changes
  * disable DNSSEC that was enabled in september 2025
  * 
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


### Micro copy paste when SSH

* Micro needs in the *settings.json*: `"clipboard": "terminal"`<br>
  **root** also requires that in the config, or when using sudo copy paste
  would not work.
* The terminal that you use must support [OSC 52](https://github.com/zyedidia/micro/blob/master/runtime/help/copypaste.md).<br>
  I use Alacritty and the support needs to be enabled, in the *alacritty.toml*:

  ```
  [terminal]
  osc52 = "CopyPaste"
  ```

After that ctrl+c and ctr+v just work.<br>
The `playbook_core.yml` takes care of setting up micro,
for the user and for the root.

# Useful

bunch of linux commands

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
* `sudo iotop -ao` - disk activity
* `sudo blktrace -d /dev/sdd -o - | blkparse -i -` - disk activity

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

# dd commands

* create bootable usb and dont want ventoy for some reason<br>
  `sudo dd bs=4M if=archlinux-2023.12.01-x86_64.iso of=/dev/sdX status=progress oflag=direct`

sure as hell I am not using dd to backup stuff, but in case...

* backup<br>
  `dd if=/dev/sdc conv=noerror | pv | dd of=~/backup.img`
* restore<br>
  `dd if=~/backup.img conv=noerror | pv | dd of=/dev/sdc`


https://www.reddit.com/r/archlinux/comments/1fykml6/some_aliases_ive_found_to_be_useful_for_arch/


# devices and drivers info

* `lspci -k` - which device which driver
* `lshw -C network` - network info
* `lspci -vvv | grep --color ASPM` - list pci devices info and highlight aspm

# useful

* [journalctl guide](https://betterstack.com/community/guides/logging/how-to-control-journald-with-journalctl)

# Manual interventions during updates

* 2025 - [community repo merged with extra](https://archlinux.org/news/cleaning-up-old-repositories/)<br>
  `/etc/pacman.conf` - comment out community repo and the include under it
* 2025 - [nvidia firmware thing](https://archlinux.org/news/linux-firmware-2025061312fe085f-5-upgrade-requires-manual-intervention/)<br>
  `sudo pacman -Rdd linux-firmware`<br>
  `sudo pacman -Syu linux-firmware`
* 2025 - careful about [DNSSEC](https://www.reddit.com/r/archlinux/comments/1nlg0wf/latest_update_break_dns_for_anyone_else/)
  being enabled by default

# to do

* switch from nnn to yazi 

Yazi workflow

* run with `zz` or `yy`, I picked z cuz its easier<br>
  starts in `~/docker` if it exists
* run with `zzz` or `yyy` to run as root with current user variables
* to search in yazi, I mostly use f-filter and z - for fzf
  * `/` - classical search in current pane, `n` goes to next result
  * `f` - filter, only leaves results fitting the pattern visible
  * `z` - opens fzf with fd, for search in current directory and all its subdirectories
  * `s` - search using fd
* press `g` - go-to dialogue to see bookmarked places 
* zoxide integration
  * install zoxide
  * for my zsh+zimfw I need to<br>
    `echo "zmodule kiesman99/zim-zoxide" >> ~/.zimrc`
  * exit and log in back
  now one would need to start using `z` instead of `cd`,
  but entire point of file manger is that you dont really do cd much anyway

