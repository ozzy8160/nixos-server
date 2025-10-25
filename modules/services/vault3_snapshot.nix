{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vault3_SS_Service;
in
{
  options.services.vault3_SS_Service = {
    enable = mkEnableOption "Btrfs snapshot service vault3";
  };

  config = mkIf cfg.enable {
    systemd.services.vault3_SS_Service = {
      description = "A service for vault3 snapshots";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash "/home/ryan/.dotfiles/flakes/modules/services/snapshot_serrvice_nix.sh;
      };
      path = [ pkgs.bash ];
      user = "root";
    };
  };
}

