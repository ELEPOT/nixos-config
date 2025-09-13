{
  config,
  pkgs,
  system,
  inputs,
  functions,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  systemd.services.keymapperd = {
    enable = true;
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = ''${pkgs.keymapper}/bin/keymapperd'';
    };
  };
}
