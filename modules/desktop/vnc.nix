{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.desktops.xrdp;

in
{

  options.desktops.vnc = {
    enable = mkEnableOption "Enable VNC server.";
    tunnel = {
      enable = mkEnableOption "Enable bore tunnel for VNC.";
      headless = mkOption { type = lib.types.bool; default = false; };
      server = mkOption { type = lib.types.str; };
      pass = mkOption { type = lib.types.str; };
      port = mkOption { type = lib.types.int; };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 5900 ];

    environment.systemPackages = with pkgs; [
      xvfb-run
      x11vnc
    ];

    systemd.services.vnc-session = mkIf cfg.tunnel.headless {
      enable = true;
      description = "VNC Session for headless";

      after = [ "multi-user.target" ];
      wantedBy = [ "vnc-server.service" ];

      path = with pkgs; [
        alacritty
        firefox
      ];

      environment = { HOME = "/home/guest"; };

      serviceConfig = {
        User = "guest";
        Group = "users";
        Type = "exec";
        ExecStart = ''${pkgs.xvfb-run}/bin/xvfb-run -n 90 -s '-screen 0 1024x576x24' ${pkgs.icewm}/bin/icewm-session -d :90'';
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };


    systemd.services.vnc-server = mkIf cfg.tunnel.headless {
      enable = true;
      description = "VNC Server for hiddenVnc";

      after = [ "vnc-session.service" ];

      serviceConfig = {
        User = "guest";
        Group = "users";
        Type = "exec";
        ExecStart = ''${pkgs.x11vnc}/bin/x11vnc -display :90 -shared -forever'';
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.services.tunnel-vnc = mkIf cfg.tunnel.enable {
      enable = true;
      description = "Bore tunnel for vnc";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bore-cli}/bin/bore local 5900 --port 6510 --to bore.kennycallado.dev --secret secreto";
        Restart = "always";
        RestartSec = "60";
        KillSignal = "SIGTERM";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
