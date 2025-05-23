Hyprland

First steps learning whats what.

# virtualbox

* new virtualbox VM
  * System > enable EFI<br>
    vbox sometimes ignores boot order set if EFI is enabled,
    use Esc during boot if need to change boot
  * Display > enable 3d acceleration and increse video memory
  * Network - bridged
* start the VM and boot arch iso
* `pacman -Sy archlinux-keyring archinstall`<br>
* `archinstall` - run through the guided install script<br>
  Profile - I pick server - sshd
* chroot - no
* reboot
* check ip address
* ssh on to the new machine
* I follow [this](https://github.com/DoTheEvo/ansible-arch) core playbook and zsh playbook
  * ` sudo pacman -S ansible git`
  * `git clone https://github.com/DoTheEvo/ansible-arch.git`
  * ` cd ansible-arch`
  * `ansible-playbook -u $USER -K playbook_core.yml`
  * `ansible-playbook -u $USER -K playbook_zsh.yml`
* shutdown
* snapshot
* `sudo pacman -S hyprland hyprpaper waybar kitty dolphin wofi swaylock swayidle polkit xdg-desktop-portal-hyprland xdg-desktop-portal-wlr virtualbox-guest-utils-nox otf-font-awesome`
* install graphic drivers<br>
  `sudo pacman -Syu mesa virtualbox-guest-utils-nox` 
* Install Hyprland packages<br>
  `sudo pacman -Syu hyprland polkit` 


  `[[ $(tty) == /dev/tty1 ]]&&exec Hyprland`
https://www.reddit.com/r/hyprland/comments/14884s5/what_greeter_display_manager_do_you_use/




https://github.com/Jakoolit/arch-hyprland

https://github.com/mylinuxforwork/dotfiles
