{ config, pkgs, inputs, ... }:

{
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
    gnome-session
    file
    zenity
    unzip
    murmur
    fontconfig
    libguestfs-with-appliance # mount vhdx
    ffmpeg
    yt-dlp
    memtester
    gnome-randr

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

    # desktop
    eww
    wl-clipboard
    labwc
    xwayland-satellite
    fuzzel # app launcher
    keymapper
    dunst # notification handler
    inputs.swww.packages.${system}.swww # bg manager
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    xsettingsd
    gnome-tweaks
    adw-gtk3
    xpra
    xdg-desktop-portal
    mutter

    # gnome extensions
    gnomeExtensions.kimpanel
  ];

  home.file = {
    "./.config/keymapper.conf" = {
      enable = true;
      text = ''
        Alt{Space{Any}} >> Alt{Any}
        Alt{Space{Shift{Any}}} >> Alt{Shift{Any}}
        Control{Alt{Space{Any}}} >> Control{Alt{Any}}
        Control{Shift{Alt{Space{Any}}}} >> Control{Shift{Alt{Any}}}
        Alt{Space} >> Alt

        Alt >> Meta

        [stage]
#        Meta{Any} >> Meta{Any} 
#        Meta{Shift{Any}} >> Meta{Shift{Any}}
#
#        !Meta ButtonLeft >> ButtonLeft
#        !Meta ButtonMiddle >> ButtonMiddle
#        !Meta ButtonRight >> ButtonRight
#
#        (Meta ButtonLeft) >> (Meta ButtonLeft)
#        (Meta ButtonMiddle) >> (Meta ButtonMiddle)
#        (Meta ButtonRight) >> (Meta ButtonRight)
#
#        Meta Escape >>
#        Meta Meta >>
#
#        Meta T >> $(sh -c "alacritty")
#        Meta D >> $(sh -c "vesktop &")
#        Meta Z >> $(sh -c "zen &")
#        Meta O >> $(sh -c "obsidian &")
#
#        Meta Shift{Period} >> $(sh -c "fuzzel &")

        PageDown >> $(sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+") ^ 
        PageUp   >> $(sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-") ^
      '';
    };

    "./.config/niri/config.kdl" = { 
      text = ''
        output "DP-3" {
            mode "3840x2160@59.997"
            scale 1.5
            transform "normal"
            position x=0 y=0
        }

//        output "HDMI-A-1" {
//            mode "3840x2400@59.950"
//            scale 1
//            transform "270"
//            position x=-1920 y=0
//        }

        layout {
            gaps 16
            center-focused-column "never"
            always-center-single-column
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }

            focus-ring {
                off
            }
        }

        spawn-at-startup "swww-daemon"
        spawn-at-startup "keymapper" "-u"

        window-rule {
            geometry-corner-radius 12
            clip-to-geometry true
        }

        window-rule {
            match is-focused=true
            
            focus-ring {
                on
                width 4
                active-color "#fcead6"
            }
        }

        window-rule {
            match app-id="^zen-" title="^Picture-in-Picture$"

            open-floating true
            open-on-output "HDMI-A-1"
            open-focused false
            max-width 1200
            default-floating-position x=0 y=5 relative-to="bottom-left"

            focus-ring {
                off
            }
        }

        binds {
            Mod+Q { spawn "alacritty"; }
            
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+X { close-window; }

            Mod+Left  { focus-column-left; }
            Mod+Down  { focus-window-down; }
            Mod+Up    { focus-window-up; }
            Mod+Right { focus-column-right; }
            Mod+H     { focus-column-left; }
            Mod+J     { focus-window-down; }
            Mod+K     { focus-window-up; }
            Mod+L     { focus-column-right; }

            Mod+Ctrl+Left  { move-column-left; }
            Mod+Ctrl+Down  { move-window-down; }
            Mod+Ctrl+Up    { move-window-up; }
            Mod+Ctrl+Right { move-column-right; }
            Mod+Ctrl+H     { move-column-left; }
            Mod+Ctrl+J     { move-window-down; }
            Mod+Ctrl+K     { move-window-up; }
            Mod+Ctrl+L     { move-column-right; }

            Mod+Y          { focus-monitor-left; }
            Mod+O          { focus-monitor-right; }
            Mod+Ctrl+Y     { move-column-to-monitor-left; }
            Mod+Ctrl+O     { move-column-to-monitor-down; }

            Mod+U              { focus-workspace-down; }
            Mod+I              { focus-workspace-up; }
            Mod+Ctrl+U         { move-column-to-workspace-down; }
            Mod+Ctrl+I         { move-column-to-workspace-up; }

            Mod+BracketLeft  { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }

            Mod+Comma  { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }

            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

            Mod+Shift+Q { quit; }
            Ctrl+Alt+Delete { quit; }

            Mod+Shift+P { power-off-monitors; }
        }

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
        ];
      };

      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/desktop/wm/keybindings".switch-input-source = [];
      "org/gnome/desktop/wm/keybindings".switch-input-source-backward = [];
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
        "Hotkey/EnumerateForwardKeys"."0" = "Super+space";
        "Hotkey/EnumerateBackwardKeys"."0" = "Super+Shift+space";
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
