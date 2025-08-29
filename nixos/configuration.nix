{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.kernelParams = ["nouveau.config=NvGsoRm=1"];
  boot.initrd.kernelModules = ["nvidia"];

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

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
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
                <string>NotoSansTC</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansJP</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansSC</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansKR</string>
            </edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family" compare="contains">
              <string>mono</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
                <string>JetBrainsMonoNLNerdFontMono</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansTC</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansJP</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansSC</string>
            </edit>
            <edit name="family" mode="prepend" binding="strong">
                <string>NotoSansKR</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.opentabletdriver.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

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

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig = {
      pipewire = {
        "clock" = {
          default.clock.rate = 48000;
          default.clock.allowed-rates = [44100 48000 96000];
          default.clock.min-quantum = 16;
        };
      };
    };
  };

  services.udev.packages = with pkgs; [
    platformio-core
    platformio-core.udev
    openocd
  ];

  services.envfs.enable = true;

  services.flatpak.enable = true;

  systemd.services.keymapperd = {
    enable = true;
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = ''${pkgs.keymapper}/bin/keymapperd'';
    };
  };

  users.users.elepot = {
    isNormalUser = true;
    description = "ELEPOT";
    extraGroups = ["networkmanager" "wheel" "dialout"];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  ];

  programs.nix-ld.enable = true;
  programs.niri.enable = true;
  programs.chromium.enable = true;
  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
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

  system.stateVersion = "25.05"; # Did you read the comment?
}
