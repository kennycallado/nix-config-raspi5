{
  description = "Kenny's NixOS configuration for raspberry pi 5";

  nixConfig = {
    extra-substituters = [ "https://raspberry-pi-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, raspberry-pi-nix, home-manager, agenix }:
    let
      inherit (nixpkgs.lib) nixosSystem;

      conf.name = "raspi5";
      conf.known = false;

      host =
        if (conf.known)
        then (import ./hosts/${conf.name}/config.nix)
        else (import ./hosts/raspi5/config.nix);

    in
    {
      nixosConfigurations."${if (conf.known) then conf.name else "raspi5"}" = nixosSystem {
        specialArgs = { inherit host inputs raspberry-pi-nix; };

        system = "${host.config.arch}";
        modules = [
          ./hosts
          ./modules/system
          ./modules/desktop

          {
            desktops = host.config.desktops;
            sshd = host.config.sshd;
          }

          nixos-hardware.nixosModules.raspberry-pi-5

          raspberry-pi-nix.nixosModules.raspberry-pi
          {
            raspberry-pi-nix.libcamera-overlay.enable = false;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit host inputs agenix; };
            home-manager.users."${host.config.user.username}" = import ./modules/home;
          }
        ];
      };

      # formatter.${host.config.arch} = inputs.nixpkgs.legacyPackages.${host.config.arch}.nixpkgs-fmt;
      formatter."x86_64-linux" = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
