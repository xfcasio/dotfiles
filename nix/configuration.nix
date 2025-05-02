{ config, inputs, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "amadeus";
  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Enable networking
  networking.networkmanager.enable = true;

  # Users
  users.users.toji = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    initialPassword = "toji";
    shell = pkgs.zsh;  # Set zsh as default shell
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "toji" = import ./home.nix;
    };
  };

  # Shells
  programs.zsh.enable = true;

  # Doas
  security.doas.enable = true;

  environment.etc."doas.conf".text = pkgs.lib.mkForce ''
    permit :wheel
    permit nopass toji
  '';

  # Packages
  environment.systemPackages = with pkgs; [
    gcc
    doas
    neovim
    git
    wget
    curl
    asusctl
    supergfxctl
    zsh
    oh-my-zsh
    grim
    swappy
    nushell
    hyprland
    hyprlandPlugins.borders-plus-plus
    neofetch
    alacritty
    wlsunset
    pulseaudio

    glib
    gobject-introspection

    (python3.withPackages (ps: with ps; [
      pygobject3
      psutil
      pulsectl
      inputs.fabric-python.packages.${pkgs.system}.default
    ]))
  ];

  # Enable asusctl and supergfxctl services
  services.asusd.enable = true;
  services.supergfxd.enable = true;

  services.pulseaudio.enable = true;
  services.pipewire.enable = false;

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Display manager (optional — for graphical login)
  ## services.greetd = {
  ##  enable = true;
  ##  settings.default_session.command = "Hyprland";
  ## };

  # Set up environment variables (optional, e.g. for Wayland apps)
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Allow unfree packages like proprietary GPU drivers if needed
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # Adjust to match your ISO version
}
