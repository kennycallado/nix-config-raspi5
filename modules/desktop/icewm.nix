{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.desktops.icewm;

in
{
  options.desktops.icewm = {
    enable = mkEnableOption "Icewm window manager";
    default = mkEnableOption "Make Icewm the default session";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      picom
      feh # for setting the wallpaper
    ];

    services.xserver = {
      windowManager.icewm.enable = true;

      displayManager.defaultSession = mkIf cfg.default "icewm-session";

      displayManager.session = [{
        manage = "desktop";
        name = "icewm-session";
        start = ''
          exec icewm-session &
          waitPID=$!
        '';
      }];
    };
  };
}
