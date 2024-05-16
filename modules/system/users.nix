{ host, ... }:

{
  users = {
    mutableUsers = false; # maybe true?

    users = {

      root.hashedPassword = "${host.config.user.rootHashedPassword}";

      "${host.config.user.username}" = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" "disk" "video" "audio" ];
        # password = mkIf (!host.config.known) "${host.config.user.password}";
        hashedPassword = "${host.config.user.userHashedPassword}";
        openssh.authorizedKeys.keys = [ "${host.config.user.sshPublicKey}" ];
      };

      guest = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [ "networkmanager" "disk" "video" "audio" ];
        initialPassword = "guest";
      };
    };
  };
}
