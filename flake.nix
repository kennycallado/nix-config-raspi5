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
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, raspberry-pi-nix, home-manager, agenix, deploy-rs }:
    let
      inherit (nixpkgs.lib) nixosSystem;

      conf.name = "raspi5";
      conf.known = false;
      conf.extraPackages = with inputs.nixpkgs.legacyPackages.aarch64-linux; [ firefox ];

      host =
        if (conf.known)
        then (import ./hosts/${conf.name}/config.nix)
        else (import ./hosts/raspi5/config.nix)
          // { extraPackages = conf.extraPackages; };

      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlay # or deploy-rs.overlays.default
          (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
        ];
      };

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
            proxy = host.config.proxy;
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

      deploy.nodes.raspi5 = {
        hostname = "raspi5";
        remoteBuild = true;
        magicRollback = false;
        # interactiveSudo = false; # WARNING: true breaks the deploy
        sshOpts = [ "-t" "-oControlMaster=no" ];

        profiles.system = {
          user = "root";
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.raspi5;
        };
      };

      # it compiles linux : because boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      # formatter.${host.config.arch} = inputs.nixpkgs.legacyPackages.${host.config.arch}.nixpkgs-fmt;
      formatter."x86_64-linux" = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
