{pkgs ? import <nixpkgs> {} , shorthands, sources ? import ../nix/sources.nix}:
let
  config =
    { colors =
        { border = "#f46702";
        };
      tools = with pkgs;
        { firefox = "${firefox}/bin/firefox";
          thunderbird = "${thunderbird}/bin/thunderbird";
          rofi = "${rofi}//bin/rofi";
          sleep = "${coreutils}/bin/sleep";
          scrot = "${scrot}/bin/scrot";
          chromium = "${chromium}/bin/chromium";
          emacs = "${emacs}/bin/emacs";
          xterm = "${xterm}/bin/xterm";
          pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
          xdotool = "${pkgs.xdotool}/bin/xdotool";
          nmtui = "${pkgs.networkmanager}/bin/nmtui";
          pactl = "${pkgs.pulseaudioLight}/bin/pactl";
          showKeyboard = "${shorthands.show-keyboard}/bin/show-keyboard";
          i3lock = "${pkgs.i3lock}/bin/i3lock";
        };
    };

  xmonad-custom =
    with pkgs;
    with stdenv;
    with haskellPackages;
    import "${sources.mono}/xmonad-custom/default.nix" {
      inherit
        mkDerivation
        base
        hpack
        stdenv
        xmonad
        xmonad-contrib
        aeson
        bytestring;
    };

  configFile = pkgs.writeText "config.json" (builtins.toJSON config);

  xmonad-wrapped = pkgs.writeShellScriptBin "xmonad-wrapped" ''
      export CONFIG_PATH=${configFile}
      ${xmonad-custom}/bin/xmonad $@
    '';
in
pkgs.stdenv.mkDerivation
{ name = "xmonad";

  buildCommand = ''
    export CONFIG_PATH=${configFile}
    ${xmonad-custom}/bin/xmonad-validate

    mkdir -p $out/bin
    cp ${xmonad-wrapped}/bin/xmonad-wrapped $out/bin/xmonad
  '';
}
