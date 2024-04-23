# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./Modules/libvirt.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Bootloader.
  boot.loader ={

    efi = {
      canTouchEfiVariables = true;
    };

    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };

  };


  
  # Enable networking
  networking = {
    hostName = "prash-nixos";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Australia/Perth";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };




  #enable OpenGL
  hardware.opengl = {
  	enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  #nvidia driver for wayland
  services.xserver.videoDrivers = ["nvidia"];
  #XDG portals for inter porgram communication
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #rest of nvidia setup including PRIME and offload settings
  hardware.nvidia = {
  	modesetting.enable = true;
    powerManagement.enable = false;
    #advanced power saving(not tested yet)
    powerManagement.finegrained = true;
    # proprietary nvidia drivers
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  #nvidia optimus prime settings (nvidia-offload)
  hardware.nvidia.prime = {
  	offload = {
      enable = true;
      enableOffloadCmd = true;
    };

  	intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

 # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  nixpkgs.config.allowUnfree = true;

  #wayland compositer
  programs.hyprland.enable = true;
  programs.dconf.enable = true;

  #other non vital programs:
  programs.steam.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.nm-applet.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prash = {
    isNormalUser = true;
    description = "prashan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  #home manager config and adding the primary user 
  home-manager = {
	extraSpecialArgs = { inherit inputs; };
	users = {
	  "prash" = import ./home.nix;
  };
	useGlobalPkgs = true;
  };


  #authentication
  security.polkit.enable = true;
  #Pam for swaylock to be able to log back in 
  security.pam.services.swaylock = {};

  # pipewire and bluetooth audio
  security.rtkit.enable = true; 
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
  };

  sound.enable = false;
  hardware.bluetooth.enable = true;

  # Laptop power management
  powerManagement.enable = true;
  services.thermald.enable = true;  
  services.tlp.enable = true;
  powerManagement.powertop.enable = true;


  # System wide packages, user scoped pakages are defined in hoem.nix
  environment.systemPackages = with pkgs; [
     kitty
     wl-clipboard
     cliphist
     neofetch
     wget
     wireplumber
     btop
     xdg-utils
     go
     unzip
     pavucontrol
     python3
     usbutils
     brightnessctl
     wlogout
     swaylock-effects
     libxkbcommon
     cairo
     networkmanager-l2tp
     gnome.networkmanager-l2tp
     networkmanagerapplet
     dunst
     swww
     waybar
     grim
     slurp
     rofi-wayland
     swappy
     libsForQt5.kiconthemes
     libsForQt5.dolphin
     libsForQt5.kdegraphics-thumbnailers
     ffmpegthumbnailer
     kdePackages.breeze-icons
  ];

  environment.variables = { 
  WLR_NO_HARDWARE_CURSORS = 1;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
