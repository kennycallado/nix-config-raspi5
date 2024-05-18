{ pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 1080 ];

  services._3proxy = {
    enable = true;
    services = [
      {
        type = "socks";
        auth = [ "strong" ];
        acl = [{
          rule = "allow";
          users = [ "kenny" "guest" ];
        }];
      }
    ];
    usersFile = "/etc/3proxy.passwd";
  };

  # hash password with `openssl passwd -1` or https://unix4lyfe.org/crypt/
  environment.etc = {
    "3proxy.passwd".text = ''
      kenny:CR:$1$MiNqgSmw$1Aic2C6P6r8QympslSTK2/
      guest:CL:guest
    '';
  };

  systemd.services.tunnel-3proxy = {
    enable = true;
    description = "Bore tunnel for 3proxy";

    after = [ "network.target" "3proxy.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      type = "exec";
      ExecStart = "${pkgs.bore-cli}/bin/bore local 1080 --port 6511 --to bore.kennycallado.dev --secret secreto";
      Restart = "always";
      RestartSec = "60";
      KillSignal = "SIGTERM";
      StandardOutput = "journal";
      StandardError = "journal";
      # StandardOutput = "file:/home/kenny/tunnel-sshd.log"; # temp
    };
  };
}
