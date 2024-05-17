{ pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 1080 ];

  services._3proxy = {
    enable = true;
    services = [
      {
        type = "socks";
          auth = [ "strong" ];
          acl = [ {
            rule = "allow";
            users = [ "kenny" ];
          }
        ];
      }
    ];
    usersFile = "/etc/3proxy.passwd";
  };

  environment.etc = {
    "3proxy.passwd".text = ''
      kenny:CL:cartman
      guest:CR:$1$JJ5mXOCy$V3umkH.V1lSAMb.Dn3dTT0
    '';
  };

  systemd.services.tunnel-3proxy = {
    enable = true;
    description = "Bore tunnel for 3proxy";

    after = [ "network.target" "3proxy.service" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig = { Type = "Simple"; };

    serviceConfig = {
      ExecStart = "${pkgs.bore-cli}/bin/bore local 1080 --port 6510 --to bore.kennycallado.dev --secret secreto";
      Restart = "always";
      RestartSec = "60";
      KillSignal = "SIGTERM";
      StandardOutput = "journal";
      StandardError = "journal";
      # StandardOutput = "file:/home/kenny/tunnel-sshd.log"; # temp
    };
  };
}
