{ host, ... }:

{
  networking = {
    useDHCP = true;
    hostName = "${host.config.name}";
    # useNetworkd = true;
    # networkmanager.enable = true;
    interfaces = { wlan0.useDHCP = true; };
    firewall.allowedTCPPorts = [ 8000 ];
  };
}
