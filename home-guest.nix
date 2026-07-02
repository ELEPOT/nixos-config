{
  config,
  pkgs,
  pkgs-master,
  inputs,
  functions,
  ...
}: {
  imports = [] ++ functions.ifExists ./../device-specific/home.nix;

  home.username = "guest";
  home.homeDirectory = "/home/guest";

  home.stateVersion = "25.05";

  home.file = {
    "./scripts" = {
      source = "${inputs.assets}/scripts";
      recursive = true;
    };

    "./.local/share/backgrounds/bg.jpg" = {
      source = "${inputs.assets}/bg.jpg";
    };
  };

  home.sessionVariables = {
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal = {
        family = "JetBrainsMonoNLNerdFontMono";
        style = "Regular";
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set relativenumber

      set expandtab
      set tabstop=4 softtabstop=4 shiftwidth=4

      set clipboard=unnamedplus

      autocmd BufEnter *.nix set tabstop=2 softtabstop=2 shiftwidth=2
    '';

    withRuby = true;
    withPython3 = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.chromium.enable = true;

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

  programs.home-manager.enable = true;
}
