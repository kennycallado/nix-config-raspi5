{ pkgs, ... }:

{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
    openFirewall = true;
  };
}
