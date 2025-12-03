{
  config,
  pkgs,
  system,
  inputs,
  functions,
  ...
}: {
  imports = [] ++ functions.ifExists ./../device-specific/configuration.nix;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Taipei";

  i18n.defaultLocale = "zh_TW.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_TW.UTF-8";
    LC_IDENTIFICATION = "zh_TW.UTF-8";
    LC_MEASUREMENT = "zh_TW.UTF-8";
    LC_MONETARY = "zh_TW.UTF-8";
    LC_NAME = "zh_TW.UTF-8";
    LC_NUMERIC = "zh_TW.UTF-8";
    LC_PAPER = "zh_TW.UTF-8";
    LC_TELEPHONE = "zh_TW.UTF-8";
    LC_TIME = "zh_TW.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-table-extra
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
          Name = "boshiamy";
        };

        "Groups/0/Items/3" = {
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
        "Hotkey/EnumerateForwardKeys"."0" = "Alt+space";
        "Hotkey/EnumerateBackwardKeys"."0" = "Alt+Shift+space";
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];

    fontDir.enable = true;

    fontconfig = {
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family" compare="not_contains">
              <string>mono</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansCJKTC</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansCJKJP</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansCJKSC</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansCJKKR</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.opentabletdriver.enable = true;

  services.xserver.enable = true;

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [pkgs.mutter];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';
  };

  services.xserver.xkb = {
    layout = "tw";
    variant = "";
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL-1210W";
        deviceUri = "http://192.168.1.170";
        model = "brother-HL1210W-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];

    ensureDefaultPrinter = "Brother_HL-1210W";
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.cups-brother-hl1210w];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    #    alsa.enable = true;
    #    alsa.support32Bit = true;
    #    pulse.enable = true;
    extraConfig = {
      pipewire = {
        "clock" = {
          default.clock.rate = 48000;
          default.clock.allowed-rates = [44100 48000 96000 192000];
          default.clock.min-quantum = 16;
        };
      };
    };
  };

  security.rtkit.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core
    platformio-core.udev
    openocd
  ];

  services.envfs.enable = true;

  services.flatpak.enable = true;

  services.fwupd.enable = true;

  users.users.elepot = {
    isNormalUser = true;
    description = "ELEPOT";
    extraGroups = ["networkmanager" "wheel" "dialout" "audio"];
  };

  users.users.guest = {
    isNormalUser = true;
    description = "guest";
    extraGroups = ["networkmanager" "wheel" "dialout" "audio"];
  };

  programs.nix-ld.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  environment.variables = {
    EDITOR = "nvim";
    SYSTEMD_EDITOR = "nvim";
    VISUAL = "nvim";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    ELECTRON_OZONE_PLATFORM_HINT = "";
    COGL_ATLAS_DEFAULT_BLIT_MODE = "framebuffer";
    GSK_RENDERER = "ngl";
  };

  stdenv.hostPlatform.system.stateVersion = "25.11"; # Did you read the comment?
}
