{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  users.users.elepot.packages = with pkgs; [
    # cli tools
    htop
    wev # keytester
    wget
    git
    rsync # better cp
    ntfs3g # ntfs disk fixer
    progress
    pamixer
    toybox
    nmap
    libnotify
    alejandra # .nix formatter
    gnome-session
    python3Minimal
    file
    zenity
    unzip

    # tui
    neovim

    # gui
    inputs.zen-browser.packages.${system}.default
    obsidian
    (blender.override {cudaSupport = true;})
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
    onlyoffice-desktopeditors

    # desktop
    #    eww
    wl-clipboard
    #    labwc
    #    xwayland-satellite
    #    fuzzel # app launcher
    keymapper
    #    dunst # notification handler
    #    inputs.swww.packages.${system}.swww # bg manager
    #    xdg-desktop-portal
    #    kdePackages.xdg-desktop-portal-kde
    #    xsettingsd
    gnome-tweaks
    adw-gtk3
    xpra
    xdg-desktop-portal
    mumble
    murmur
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  #  i18n.inputMethod = {
  #    enable = true;
  #    type = "ibus";
  #    ibus.engines = with pkgs.ibus-engines; [
  #      chewing
  #      anthy
  #    ];
  #  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chewing
      fcitx5-anthy
      fcitx5-gtk
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  fonts.fontDir.enable = true;

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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
  };

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
    extraGroups = ["networkmanager" "wheel"];
  };

  programs.niri.enable = true;
  programs.chromium.enable = true;
  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.onlyoffice.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
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
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
