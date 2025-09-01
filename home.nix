{
  config,
  pkgs,
  inputs,
  ...
}: {
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
    pamixer
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
    memtester

    # tui

    # gui
    inputs.zen-browser.packages.${system}.default
    obsidian
    (blender-hip.override {cudaSupport = true;})
    alacritty # terminal
    vesktop # discord client
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
    godot
    aseprite
    obs-studio
    protonvpn-gui
    audacity
    gnome-software

    jetbrains.rider
    jetbrains.clion
    jetbrains.pycharm-professional

    keymapper
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    gnome-tweaks
    adw-gtk3

    # gnome extensions
    gnomeExtensions.kimpanel
    gnomeExtensions.workspaces-indicator-by-open-apps
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.paperwm
  ];

  home.file = {
    "./.config/keymapper.conf" = {
      text = ''
        Alt{Space{Any}} >> Alt{Any}
        Alt{Space{Shift{Any}}} >> Alt{Shift{Any}}
        Control{Alt{Space{Any}}} >> Control{Alt{Any}}
        Control{Shift{Alt{Space{Any}}}} >> Control{Shift{Alt{Any}}}

        Alt >> Meta

        PageDown >> $(sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+") ^
        PageUp   >> $(sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-") ^

        [stage]

        Meta !Meta >> Meta{Tab{E}}

        Meta{Space} >> F13
        Meta{Shift{Space}} >> F14
      '';
    };

    "./.profile" = {
      text = ''
        keymapper -u &
      '';
    };
  };

  home.sessionVariables = {
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          kimpanel.extensionUuid
          workspaces-indicator-by-open-apps.extensionUuid
          advanced-alttab-window-switcher.extensionUuid
          paperwm.extensionUuid
        ];
      };

      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/desktop/wm/keybindings".switch-input-source = [];
      "org/gnome/desktop/wm/keybindings".switch-input-source-backward = [];

      "org/gnome/desktop/interface".enable-hot-corners = false;

      "org/gnome/shell/extensions/advanced-alt-tab-window-switcher".switcher-popup-start-search = false;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chewing
      fcitx5-anthy
      fcitx5-gtk
    ];

    fcitx5.settings = {
      inputMethod = {
        "Groups/0" = {
          Name = "預設";
          "Default Layout" = "us";
          DefaultIM = "chewing";
        };

        "Groups/0/Items/0" = {
          Name = "keyboard-us";
        };

        "Groups/0/Items/1" = {
          Name = "chewing";
        };

        "Groups/0/Items/2" = {
          Name = "anthy";
        };

        GroupOrder."0" = "預設";
      };

      globalOptions = {
        "Hotkey" = {
          EnumerateWithTriggerKeys = true;
          EnumerateSkipFirst = false;
        };

        "Hotkey/TriggerKeys" = {};
        "Hotkey/AltTriggerKeys"."0" = "Shift+Shift_L";
        "Hotkey/EnumerateForwardKeys"."0" = "F13";
        "Hotkey/EnumerateBackwardKeys"."0" = "F14";
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set relativenumber

      set expandtab
      set tabstop=4 softtabstop=4 shiftwidth=4

      autocmd BufEnter *.nix set tabstop=2 softtabstop=2 shiftwidth=2
    '';
  };

  programs.git = {
    enable = true;
    userName = "ELEPOT";
    userEmail = "elepotmail0@gmail.com";
  };

  programs.home-manager.enable = true;
}
