{ ... }:

{
  imports = [
    ./xorg.nix
  ];

  services.xserver = {
    enable = true;
    layout = "es";
    xkbVariant = "";
  };
}
