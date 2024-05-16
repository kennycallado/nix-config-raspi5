{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.desktops;

in
{
  imports = [
    ./xrdp.nix
    ./icewm.nix
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "es";
      xkbVariant = "";

      libinput.enable = true;

      displayManager.lightdm.enable = true;
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };

    fonts.packages = with pkgs; [
      ocr-a
      noto-fonts
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    environment.systemPackages = with pkgs; [
      xorg.xf86inputlibinput # ??
      alacritty
      rustdesk # ?? should
      libinput # ??
      xclip
    ];
  };
}
