{ lib, config, pkgs, ... }:
let
  cfg = config.sshd;
  inherit (lib) mkIf mkEnableOption mkOption types;
in
{

  options.sshd = {
    enable = mkEnableOption "Enable OpenSSH server.";
    tunnel = {
      enable = mkEnableOption "Enable bore tunnel for ssh server.";
      server = mkOption { type = types.str; };
      pass = mkOption { type = types.str; };
      port = mkOption { type = types.int; };
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = true; # TODO: disble
        # X11Forwarding = true;
        # setXAuthLocation = true;
        # KbdInteractiveAuthentication = false;
      };
    };

    systemd.services.tunnel-sshd = mkIf cfg.tunnel.enable {
      enable = true;
      description = "Bore tunnel for sshd";

      after = [ "network.target" "sshd.service" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = { Type = "Simple"; };

      serviceConfig = {
        ExecStart = "${pkgs.bore-cli}/bin/bore local 22 --port ${builtins.toString cfg.tunnel.port} --to ${cfg.tunnel.server} --secret ${cfg.tunnel.pass}";
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
        # StandardOutput = "file:/home/kenny/tunnel-sshd.log"; # temp
      };
    };
  };
}
