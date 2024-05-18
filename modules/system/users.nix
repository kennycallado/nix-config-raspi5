{ host, ... }:

{
  users = {
    mutableUsers = false; # maybe true?

    # raspberry needed
    groups.gpio = { };
    groups.i2c = { };
    groups.spi = { };

    users = {

      root.hashedPassword = "${host.config.user.rootHashedPassword}";

      "${host.config.user.username}" = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" "disk" "video" "audio" ];
        hashedPassword = "${host.config.user.userHashedPassword}";
        openssh.authorizedKeys.keys = [ "${host.config.user.sshPublicKey}" ];
      };

      guest = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [ "disk" "video" "audio" ];
        initialPassword = "guest";
      };
    };
  };
}
