{ ... }:

{
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
      xc = "nix-collect-garbage && nix-collect-garbage -d";
      xcs = "sudo nix-collect-garbage && sudo nix-collect-garbage -d";
      xcb = "sudo /run/current-system/bin/switch-to-configuration boot";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      lal = "lsd -al";
      ".." = "cd ..";
      lv = "lvim";
      rvim = "NVIM_APPNAME=nvim/launch nvim";
    };

    historyIgnore = [ "yt-dpl *" "mpv *" ];
    # historyIgnore = ["$'*([\t ])+([-%+,./0-9\:@A-Z_a-z])*([\t ])'"];

    logoutExtra = ''
      sed -i '/.*mp4.*$/d' ~/.bash_history && sed -i '/^yt-dlp/d' ~/.bash_history && sed -i '/^mpv/d' ~/.bash_history
    '';
  };
}
