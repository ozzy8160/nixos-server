{ config, pkgs, ... }:
 {
    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      font-manager
      font-awesome_5
      font-awesome
      noto-fonts-emoji
      noto-fonts
      jetbrains-mono
      powerline-fonts
      powerline-symbols
      material-icons
    ];
  }
