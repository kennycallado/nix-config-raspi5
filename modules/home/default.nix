{ host, pkgs, agenix, ... }:

{
  imports = [
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

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    fd
    fzf
    bat
    lsd
    # dillo
    # wezterm
    joshuto
    ripgrep
    cmatrix
    # firefox
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;

    # bashrcExtra = ''source ~/.config/bash/bashrc'';
    # interactiveShellInit = (builtins.readFile ~/.config/bash/bashrc);

    # initExtra = ''
    #   eval "$(starship init bash)" # already done by starship
    # '';

    profileExtra = ''
      # maybe my .config/bash
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #fi
    '';

    sessionVariables = { };

    shellAliases = {
      lf = "joshuto";
      lv = "lvim";
      xc = "nix-collect-garbage && nix-collect-garbage -d";
      xcs = "sudo nix-collect-garbage && sudo nix-collect-garbage -d";
      xcb = "sudo /run/current-system/bin/switch-to-configuration boot";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      lal = "lsd -al";
      ".." = "cd ..";
    };

    historyIgnore = [ "yt-dpl *" "mpv *" ];
    # historyIgnore = ["$'*([\t ])+([-%+,./0-9\:@A-Z_a-z])*([\t ])'"];

    logoutExtra = ''
      sed -i '/.*mp4.*$/d' ~/.bash_history && sed -i '/^yt-dlp/d' ~/.bash_history && sed -i '/^mpv/d' ~/.bash_history
    '';
  };

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
