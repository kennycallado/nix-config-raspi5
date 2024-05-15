{ host, ... }:

{
  imports = [
    # ./raspberry-pi.nix
    ./${if (host.config.known) then host.config.name else "unknown" }
  ];
}
