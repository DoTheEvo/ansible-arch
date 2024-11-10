Hyprland

First steps learning whats what.

To get it working in virtualbox

* new virtualbox VM
  * System > enable EFI<br>
    vbox ignores boot order set if EFI is enabled, use Esc during boot if need to change boot
  * Display > enable 3d acceleration
* install arch using archinstall, pick minimal or server with ssh
* install
* install ssh for easy copy paste stuff<br>
  `sudo pacman -Syu openssh`<br>
  `sudo systemctl enable --now sshd`
* snapshot

* install graphic drivers<br>
  mesa virtualbox-guest-utils-nox 
* Install Hyprland packages<br>

  sudo pacman -Syu hyprland 
  polkit 


  [[ $(tty) == /dev/tty1 ]]&&exec Hyprland
https://www.reddit.com/r/hyprland/comments/14884s5/what_greeter_display_manager_do_you_use/




https://github.com/Jakoolit/arch-hyprland
