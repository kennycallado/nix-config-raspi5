{ host, pkgs, agenix, ... }:

{
  imports = [
    ./packages
    agenix.homeManagerModules.age
  ];

  home.stateVersion = "23.11";

  home.username = "${host.config.user.username}";
  home.homeDirectory = "/home/${host.config.user.username}";

  # programs.wezterm.enable = true;
  # home.file.".config/wezterm/wezterm.lua" = {
  #   source = ./wezterm/wezterm.lua;
  # };

  programs.home-manager.enable = true;

  # programs.starship = {
  #   enable = true;
  #   settings = { };
  # };

  # home.packages = with pkgs; [
  #   fd
  #   fzf
  #   bat
  #   lsd
  #   # dillo
  #   # wezterm
  #   joshuto
  #   ripgrep
  #   cmatrix
  #   # firefox
  # ];

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };
    theme = {
      name = "Adementary-dark";
      package = pkgs.adementary-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
