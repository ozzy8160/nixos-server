#common program packages for all my machines 
{ config, pkgs, ... }:
 {
  environment.systemPackages = with pkgs; [
  	arduino
#    neovim 
#  #brightnessctl
#    btop
#  #dunst
#    fastfetch
#    fd
#    fzf
#    gcc
#    gparted
#    git
#    grim
#    hyprcursor
#    hyprlock
#    hyprpolkitagent
#    kdePackages.kdenlive
#    jellyfin
#    jellyfin-web
#    jellyfin-ffmpeg
#    kitty
#    lsd
#    waybar
#    libnotify
#    rclone
#    rofi
#    ripgrep
#    ncdu
#    networkmanagerapplet
#    sftpman
#    sshfs
#    slurp
#    starship
#    swww
#    sway
#    syncthing
#    pavucontrol
#    pulseaudio
#    pipewire
#    wget
#    tldr
#    timeshift
#    xclip
#    zip
#    zoxide
    ];
  }



