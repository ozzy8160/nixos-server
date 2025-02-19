# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./terminal/fonts.nix
#      ./terminal/starship.nix
    ];

  #drive mounts
  fileSystems."/mnt/vault3" = {
    device = "/dev/disk/by-uuid/dc7a1bed-2d94-47af-8b92-7b3d184025e1";
    fsType = "btrfs";
    options = [ "subvolid=257" "compress=zstd:1" "noatime" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Enable networking and set host name
  networking.networkmanager.enable = true;
  networking.hostName = "nixos-file-server"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  #hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
 };


  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  # enable opengl
  hardware.graphics = {
      # Opengl
      enable = true;
      extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      intel-compute-runtime
      intel-media-sdk
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };
  #environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
  
  # startship
  programs.starship = {
    enable = true;
   # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

#  # Enable sound with pipewire.
#  sound.enable = true;
#  hardware.pulseaudio.enable = false;
#  security.rtkit.enable = true;
#  services.pipewire = {
#    enable = true;
#    alsa.enable = true;
#    alsa.support32Bit = true;
#    pulse.enable = true;
#    # If you want to use JACK applications, uncomment this
#    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
#  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ryan = {
    isNormalUser = true;
    description = "ryan";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = ["AAAAC3NzaC1lZDI1NTE5AAAAIL2hdyohgome0xN7k3IKGVxVvWtq1i8hKQ0QrqbWciHO"];
    packages = with pkgs; [
      floorp
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    brightnessctl
    btop
    cmatrix
    dunst
    fastfetch
    fd
    fzf
    gcc
    gparted
    git
    grim
    hyprcursor
    hyprlock
    hyprpolkitagent
    libsForQt5.kdenlive
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    kitty
    lsd
    waybar
    libnotify
    rclone
    rofi-wayland
    ripgrep
    ncdu
    networkmanagerapplet
    sftpman
    sshfs
    slurp
    starship
    swww
    sway
    syncthing
    pavucontrol
    mpd
    mpv
    pulseaudio
    pipewire
    wget
    thefuck
    tldr
    timeshift
    xclip
    zip
    zoxide
  ];

  # bash stuff here
  programs = {
    command-not-found.enable = false;

    bash = {
      completion.enable = true;

      #set bash aliases here
      shellAliases = {
        b = "cd ..";
#	ls = "lsd";
	s = "ssh ryan@192.168.1.58";
	# Search command line history
	h = "history | grep ";
	#vim
	v = "nvim";
	sv = "sudo nvim";
	#nixos
	rebuild = "sudo nixos-rebuild switch --flake $(readlink -f /etc/nixos/)";
	updt = "cd /etc/nixos/ && sudo nix flake update";
	#git
	add = "git add ."; 
	
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:
  
  #jellyfin
  services.jellyfin = {
  enable = true;
  openFirewall = true;
  user = "ryan";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
    };
  };

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    userlistEnable = true;
    userlist = [ "ryan" ];
    # chrootLocalUser = true;
    allowWriteableChroot = true;
    # forceLocalDataSSL = true;
    # forceLocalLoginSSL = true;
    # rsaCertFile = "/etc/ssl/vsftpd.pem";
    extraConfig = ''
      #   secomp_sandBox=NO
      pasv_enable=YES
      pasv_min_port=56250
      pasv_max_port=56250
      '';
  };

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 21 22 ];
    allowedTCPPortRanges = [ { from = 56250; to = 56250;} ];

    connectionTrackingModules = [ "ftp" ];
  };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
