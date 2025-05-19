{ config, pkgs, ... }: let 
  fontsDir = builtins.attrNames (builtins.readDir ./amadeus/fonts);
  customFonts = builtins.listToAttrs (map (name: {
    name = ".local/share/fonts/${name}";
    value.source = ./amadeus/fonts/${name};
  }) fontsDir);

  binsDir = builtins.attrNames (builtins.readDir ./amadeus/bin);
  customBins = builtins.listToAttrs (map (name: {
    name = ".local/bin/${name}";
    value.source = ./amadeus/bin/${name};
  }) binsDir); in
{
  home.username = "toji";
  home.homeDirectory = "/home/toji";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.file = {
    #".zshrc".source = ./amadeus/zshrc;
    ".config/alacritty/alacritty.toml".source = ./amadeus/alacritty.toml;
    ".config/fabric".source = ./amadeus/fabric;
    ".config/hypr".source = ./amadeus/hypr;
    ".config/iamb".source = ./amadeus/iamb;
    ".config/kitty/kitty.conf".source = ./amadeus/kitty.conf;
    ".config/neofetch".source = ./amadeus/neofetch;
    ".config/nushell".source = ./amadeus/nushell;
    ".config/nvim".source = ./amadeus/nvim;
    ".config/rofi".source = ./amadeus/rofi;
    ".config/Vencord".source = ./amadeus/Vencord;

    ".cargo".source = ./amadeus/.cargo;
    ".local/bin/e" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        exec nvim "$@"
      '';
    };
  } // customBins // customFonts;

  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"      
        "z"
      ];
    };
    initContent = ''source ~/nixos/amadeus/zshrc'';

    plugins = [{
      name = "zsh-shift-select";
      src = (pkgs.fetchFromGitHub {
        owner = "jirutka";
        repo = "zsh-shift-select";
        rev = "master";
        sha256 = "sha256-ekA8acUgNT/t2SjSBGJs2Oko5EB7MvVUccC6uuTI/vc=";
      });
    }];
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
