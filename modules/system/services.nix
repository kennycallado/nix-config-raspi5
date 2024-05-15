{ config, ... }:

{
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     UseDns = true;
  #     PasswordAuthentication = true;
  #     # X11Forwarding = true;
  #     # setXAuthLocation = true;
  #     # KbdInteractiveAuthentication = false;
  #   };
  # };

  # services.xrdp = {
  #   enable = true;
  #   defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
  #   openFirewall = true;
  # };

  services.blueman.enable = config.hardware.bluetooth.enable;
}
