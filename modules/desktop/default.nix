{ pkgs, ... }:

{
  imports = [
    # ./xorg.nix
    ./icewm.nix
  ];

  services.xserver = {
    enable = true;
    layout = "es";
    xkbVariant = "";

    libinput.enable = true;

    displayManager.lightdm.enable = false;
    displayManager.gdm = {
      enable = true;
      # wayland = true;
      autoSuspend = false;
    };
  };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      # driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      ocr-a
      # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    environment.systemPackages = with pkgs; [
      xorg.xf86inputlibinput # ??
      alacritty
      libinput # ??
    ];
}
