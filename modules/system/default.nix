{ inputs, pkgs, ... }:
let
  agenix = {
    imports = [ inputs.agenix.nixosModules.age ];
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.agenix ];
  };
in
{
  imports = [
    agenix
    ./networking.nix
    ./packages.nix
    ./services.nix
    ./users.nix
  ];

  system.stateVersion = "23.11";

  console.keyMap = "es";

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";

  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
