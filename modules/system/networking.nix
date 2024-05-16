{ host, ... }:

{
  networking = {
    useDHCP = true;
    hostName = "${host.config.name}";

    interfaces = { wlan0.useDHCP = true; };
    firewall.allowedTCPPorts = [ 8000 ];
  };
}
