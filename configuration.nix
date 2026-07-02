{
  config,
  pkgs,
  pkgs-master,
  system,
  inputs,
  functions,
  ...
}: {
  imports = [inputs.steam-presence.nixosModules.steam-presence] ++ functions.ifExists ./../device-specific/configuration.nix;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

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
      fcitx5-mcbopomofo
      fcitx5-table-extra
      fcitx5-anthy
      fcitx5-gtk
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      cascadia-code
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
        deviceUri = "http://192.168.1.114";
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
    # alsa.enable = true;
    # alsa.support32Bit = true;
    # pulse.enable = true;
    # jack.enable = true;
    # wireplumber.enable = true;
  };

  # musnix.enable = true;

  security.rtkit.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core
    platformio-core.udev
    openocd
  ];

  services.envfs.enable = true;

  services.flatpak.enable = true;

  services.fwupd.enable = true;

  virtualisation.docker.enable = true;

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

    presence = {
      enable = true;
      steamApiKeyFile = "/run/secrets/steam_api_key";
      userIds = ["elepot404"];
    };
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  environment.systemPackages = with pkgs; [
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
    iw
    fastfetch
    steam-run
    git
    vim
    xdg-terminal-exec
    lshw
    docker
    gdtoolkit_4
    alsa-utils

    # tui
    opencode

    # gui
    inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default
    obsidian
    discord
    swayimg
    xeyes
    chromium
    lunar-client
    prismlauncher
    anki-bin
    bc
    mumble
    appeditor
    mpv-unwrapped
    gdtoolkit_4
    proton-vpn
    audacity
    gnome-software
    jetbrains-toolbox
    vscode
    codeblocks
    betterdiscordctl
    gparted
    openutau
    reaper
    vital
    godot
    blender
    osu-lazer-bin
    handbrake
    (let
      loPython = libreoffice-unwrapped.python.withPackages (ps: with ps; [pygments catppuccin]);
    in
      libreoffice.override {
        extraMakeWrapperArgs = [
          "--prefix"
          "PYTHONPATH"
          ":"
          "${loPython}/${loPython.sitePackages}"
        ];
      })
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
    (gcc // {meta.priority = 1;})
    nodejs_24
    faudio
    alsa-lib
    mission-center
    coolercontrol.coolercontrol-gui
    pavucontrol
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
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
