{ pkgs, ... }:

{
  environment.etc = {
    "asound.conf".source = pkgs.writeText "asound.conf" ''

      pcm.!default {
        type hw
        card 1
      }

      ctl.!default {
        type hw
        card 1
      }

    '';
  };
}
