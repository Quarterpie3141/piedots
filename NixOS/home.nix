{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "prash";
  home.homeDirectory = "/home/prash";
  programs.git = {
    enable = true;
    userName = "Notme";
    userEmail = "placeholder@nowhere";
  };
  
  fonts.fontconfig.enable = true;
  
  gtk ={
    enable = true;
    cursorTheme = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Ink";
    };
  };

  qt ={
    enable = true;
    platformTheme = "qtct";
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "RobotoMono" ]; })
    pkgs.firefox
    pkgs.discord-screenaudio
    pkgs.discord
    pkgs.winetricks
    pkgs.wineWowPackages.waylandFull
    pkgs.slurp
    pkgs.grim
    pkgs.rofi-wayland
    pkgs.dunst
    pkgs.swww
    pkgs.waybar
    pkgs.obs-studio
    pkgs.vlc
    pkgs.swappy

    pkgs.libsForQt5.kiconthemes
    pkgs.libsForQt5.dolphin
    pkgs.libsForQt5.kdegraphics-thumbnailers
    pkgs.ffmpegthumbnailer
    pkgs.kdePackages.breeze-icons
    
    pkgs.freecad
    pkgs.onlyoffice-bin_latest
    pkgs.gh
  ];


  home.file = {

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
