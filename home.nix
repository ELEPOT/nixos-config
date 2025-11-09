{
  config,
  pkgs,
  inputs,
  functions,
  ...
}: {
  imports = [] ++ functions.ifExists ./../device-specific/home.nix;

  home.username = "elepot";
  home.homeDirectory = "/home/elepot";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # cli tools
    htop
    wev # keytester
    wget
    rsync # better cp
    ntfs3g # ntfs disk fixer
    progress
    toybox
    nmap
    libnotify
    alejandra # .nix formatter
    file
    unzip
    murmur
    fontconfig
    libguestfs-with-appliance # mount vhdx
    ffmpeg
    yt-dlp
    libheif
    tree
    lm_sensors
    mutter
    pciutils
    wlr-randr

    # tui

    # gui
    inputs.zen-browser.packages.${system}.default
    obsidian
    (blender-hip.override {cudaSupport = true;})
    swayimg
    bottles
    krita
    xorg.xeyes
    chromium
    lunar-client
    prismlauncher
    anki-bin
    bc
    mumble
    appeditor
    mpv-unwrapped
    godot-mono
    obs-studio
    protonvpn-gui
    audacity
    gnome-software
    jetbrains-toolbox
    vscode
    codeblocks
    betterdiscordctl
    gparted

    keymapper
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    gnome-tweaks
    adw-gtk3
    wl-clipboard

    # gnome extensions
    gnomeExtensions.kimpanel
    gnomeExtensions.workspaces-indicator-by-open-apps
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.paperwm

    # dev
    poetry


    faudio
  ];

  home.file = {
    "./scripts" = {
      source = "${inputs.assets}/scripts";
      recursive = true;
    };

    "./.local/share/backgrounds/bg.jpg" = {
      source = "${inputs.assets}/bg.jpg";
    };

    "./.config/godot/text_editor_themes" = {
      source = "${inputs.assets}/godot-themes";
      recursive = true;
    };
  };

  home.sessionVariables = {
  };

  xdg.desktopEntries = {
    codeblocks = {
      name = "Code::Blocks IDE";
      exec = "nix-shell -p gcc --command codeblocks %F";
      icon = "codeblocks";
      mimeType = [
        "application/x-codeblocks"
        "application/x-codeblocks-workspace"
      ];
    };

    "org.gnome.Nautilus" = {
      name = "n 檔案";
      exec = "nautilus --new-window %U";
      icon = "org.gnome.Nautilus";
      mimeType = ["inode/directory" "application/x-7z-compressed" "application/x-7z-compressed-tar" "application/x-bzip" "application/x-bzip-compressed-tar" "application/x-compress" "application/x-compressed-tar" "application/x-cpio" "application/x-gzip" "application/x-lha" "application/x-lzip" "application/x-lzip-compressed-tar" "application/x-lzma" "application/x-lzma-compressed-tar" "application/x-tar" "application/x-tarz" "application/x-xar" "application/x-xz" "application/x-xz-compressed-tar" "application/zip" "application/gzip" "application/bzip2" "application/x-bzip2-compressed-tar" "application/vnd.rar" "application/zstd" "application/x-zstd-compressed-tar"];
      actions = {
        "new-window" = {
          name = "New Window";
          exec = "nautilus --new-window";
        };
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "advanced-alt-tab@G-dH.github.com"
          "kimpanel@kde.org"
          "paperwm@paperwm.github.com"
          "workspaces-by-open-apps@favo02.github.com"
        ];
        disabled-extensions = [];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = "orange";
        enable-hot-corners = false;
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/elepot/.local/share/backgrounds/bg.jpg";
        picture-uri-dark = "file:///home/elepot/.local/share/backgrounds/bg.jpg";
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [];
        switch-input-source-backward = [];
        activate-window-menu = [];
      };

      "org/gnome/shell/extensions/paperwm/keybindings" = {
        close-window = ["<Super>x"];
        switch-left = ["<Super>h"];
        switch-right = ["<Super>l"];
        switch-up = ["<Super>k"];
        switch-down = ["<Super>j"];
        move-left = ["<Control><Super>h"];
        move-right = ["<Control><Super>l"];
        move-up = ["<Control><Super>k"];
        move-down = ["<Control><Super>j"];
        live-alt-tab = [];
        slurp-in = ["<Super>semicolon"];
        barf-out = ["<Shift><Super>quotedbl"];
        barf-out-active = ["<Super>quotedbl"];
        switch-up-workspace = ["<Super>i"];
        switch-down-workspace = ["<Super>u"];
        move-up-workspace = ["<Control><Super>i"];
        move-down-workspace = ["<Control><Super>u"];
        switch-monitor-right = ["<Super>o"];
        switch-monitor-left = ["<Super>y"];
        move-monitor-right = ["<Control><Super>o"];
        move-monitor-left = ["<Control><Super>y"];
      };

      "org/gnome/shell/extensions/paperwm" = {
        animation-time = 0.0;
        disable-topbar-styling = true;
        show-focus-mode-icon = false;
        show-open-position-icon = false;
        minimap-scale = 0.0;
        minimap-shade-opacity = 0;
        vertical-margin = 10;
        vertical-margin-bottom = 10;
        horizontal-margin = 10;
      };

      "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
        switcher-popup-show-if-no-win = true;
        app-switcher-popup-fav-apps = false;
        app-switcher-popup-include-show-apps-icon = false;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = ["${inputs.alacritty-catppuccin}/catppuccin-mocha.toml"];
      };
      font.normal = {
        family = "JetBrainsMonoNLNerdFontMono";
        style = "Regular";
      };
      window = {
        decorations = "None";
        opacity = 1;
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
  };

  programs.git = {
    enable = true;
    userName = "ELEPOT";
    userEmail = "elepotmail0@gmail.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.chromium.enable = true;

  programs.firefox.enable = true;

  programs.home-manager.enable = true;
}
