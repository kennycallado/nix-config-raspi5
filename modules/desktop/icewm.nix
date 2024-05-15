{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    picom
    feh # for setting the wallpaper
  ];

  services.xserver = {
    windowManager.icewm.enable = true;

    displayManager.defaultSession = "icewm-session";

    displayManager.session = [{
      manage = "desktop";
      name = "icewm-session";
      start = ''
        exec icewm-session &
        waitPID=$!
      '';
    }];
  };
}
