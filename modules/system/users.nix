{ lib, host, ... }:
let 
  inherit (lib) mkIf;

in
{
  users = {
    mutableUsers = false; # maybe true?
    users."${host.config.user.username}" = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "networkmanager" "disk" "video" "audio" ];
      password = mkIf (!host.config.is_known) "${host.config.user.password}";
      hashedPassword = mkIf (host.config.is_known) "${host.config.user.userHashedPassword}";
      openssh.authorizedKeys.keys = mkIf (host.config.is_known) [ "${host.config.user.sshPublicKey}" ];
    };
    users.root.hashedPassword = mkIf (host.config.is_known) "${host.config.user.rootHashedPassword}";
  };
}
