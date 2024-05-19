{ host, ... }:

{
  networking = {
    useDHCP = true;
    hostName = "${host.config.name}";

    interfaces = { wlan0.useDHCP = true; };
    firewall.allowedTCPPorts = [ 8000 ];

    wireless = {
      enable = true;
      userControlled.enable = true;

      networks = {
        "Livebox6-F8D6" = {
          pskRaw = "c56b4bde3b6f61cfe25bbf5f8599e7f10043b295d59bfbe4d8625462b498c25d";
          priority = 1;
        };

      };
    };
  };

  # mac changer
  # https://nixos.wiki/wiki/Wpa_supplicant#Switching_Network

  # networking.wireless.networks.eduroam = {
  #  auth = ''
  #    key_mgmt=WPA-EAP
  #    eap=PWD
  #    identity="youruser@yourinstitution.edu"
  #    password="p@$$w0rd"
  #  '';
  # };

  # https://www.stura.htw-dresden.de/stura/ref/hopo/dk/nachrichten/eduroam-meets-nixos
  # networking.wireless = {
  #   enable = true;
  #   networks = {
  #     eduroam = {
  #       auth=''
  #         proto=RSN
  #         key_mgmt=WPA-EAP
  #         eap=PEAP
  #         identity="s23456@htw-dresden.de"
  #         # password="das_Passwort"
  #         password=hash:das_Passwort_als_Hash
  #         # domain_suffix_match="radius.htw-dresden.de"
  #         domain_suffix_match="radius.htw-dresden.de"
  #         anonymous_identity="69873312454253036930@htw-dresden.de"
  #         phase1="peaplabel=0"
  #         phase2="auth=MSCHAPV2"
  #         # ca_cert="/etc/ssl/certs/ca-bundle.crt"
  #         ca_cert="/etc/ssl/certs/ca-bundle.crt"
  #       '';
  #     };
  #   };
  # };
}
