{ host, ... }:

{
  networking = {
    useDHCP = true;
    hostName = "${host.config.name}";

    useNetworkd = true; # TEST
    networkmanager.enable = true; # TEST

    interfaces = { wlan0.useDHCP = true; };
    firewall.allowedTCPPorts = [ 8000 ];
  };
}
