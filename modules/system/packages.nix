{ host, lib, pkgs, ... }:
let
  inherit (lib) getName;

in
{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
      "google-chrome"
    ];
  };

  programs.dconf.enable = true; # needed for gtk theme on home-manager

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.git.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    jq
    curl
    wget
    tree
    file
    htop
    unar
    p7zip
    unzip
    killall
    joshuto
    # lm_sensors
    cryptsetup

    # bluez
    # bluez-tools
  ] ++ host.extraPackages;

  environment.variables = {
    PAGER = "less";
  };
}
