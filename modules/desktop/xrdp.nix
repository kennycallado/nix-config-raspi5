{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.desktops.xrdp;

in
{

  options.desktops.xrdp = {
    enable = mkEnableOption "Enable Xrdp server.";
    tunnel = {
      enable = mkEnableOption "Enable bore tunnel for xrdp.";
      server = mkOption { type = lib.types.str; };
      pass = mkOption { type = lib.types.str; };
      port = mkOption { type = lib.types.int; };
    };
  };

  config = mkIf cfg.enable {
    # networking.firewall.allowedTCPPorts = [ 3389 ];

    services.xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
      openFirewall = true;
    };

    systemd.services.tunnel-xrdp = mkIf cfg.tunnel.enable {
      enable = true;
      description = "Bore tunnel for xrdp";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bore-cli}/bin/bore local 3389 --port ${builtins.toString cfg.tunnel.port} --to ${cfg.tunnel.server} --secret ${cfg.tunnel.pass}";
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
        # StandardOutput = "file:/home/kenny/tunnel-xrdp.log"; # temp
      };
    };
  };
}
