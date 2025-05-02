{ config, pkgs, ... }: let 
  fontsDir = builtins.attrNames (builtins.readDir ./dotfiles/fonts);
  customFonts = builtins.listToAttrs (map (name: {
    name = ".local/share/fonts/${name}";
    value.source = ./dotfiles/fonts/${name};
  }) fontsDir);

  binsDir = builtins.attrNames (builtins.readDir ./dotfiles/bin);
  customBins = builtins.listToAttrs (map (name: {
    name = ".local/bin/${name}";
    value.source = ./dotfiles/bin/${name};
  }) binsDir); in
{
  home.username = "toji";
  home.homeDirectory = "/home/toji";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.file = {
    #".zshrc".source = ./dotfiles/zshrc;
    ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
    ".config/fabric".source = ./dotfiles/fabric;
    ".config/hypr".source = ./dotfiles/hypr;
    ".config/iamb".source = ./dotfiles/iamb;
    ".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;
    ".config/neofetch".source = ./dotfiles/neofetch;
    ".config/nushell".source = ./dotfiles/nushell;
    ".config/nvim".source = ./dotfiles/nvim;
    ".config/rofi".source = ./dotfiles/rofi;
    ".config/Vencord".source = ./dotfiles/Vencord;

    ".cargo".source = ./dotfiles/.cargo;
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
    initContent = ''source ~/nixos/dotfiles/zshrc'';

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
