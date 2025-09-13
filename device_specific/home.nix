{
  config,
  pkgs,
  inputs,
  functions,
  ...
}: {
  home.file = {
    "./.config/keymapper.conf" = {
      text = ''
        Alt{Space{Any}} >> Alt{Any}
        Alt{Space{Shift{Any}}} >> Alt{Shift{Any}}
        Control{Alt{Space{Any}}} >> Control{Alt{Any}}
        Control{Shift{Alt{Space{Any}}}} >> Control{Shift{Alt{Any}}}

        Alt{Space} >> Alt{Space}
        Alt{Shift{Space}} >> Alt{Shift{Space}}

        Alt >> Meta

        PageDown >> $(sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+") ^
        PageUp   >> $(sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-") ^
      '';
    };

    "./.profile" = {
      text = ''
        keymapper -u &
      '';
    };
  };
}
