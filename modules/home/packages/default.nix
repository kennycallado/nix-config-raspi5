{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./neovim.nix
  ];

  programs.starship = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    fd
    fzf
    bat
    dua
    lsd
    dufs # droopy replacement
    ripgrep
    cmatrix
  ];
}
