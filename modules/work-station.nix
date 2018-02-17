{ pkgs, lib, config, ... }:

let
  systemPkgs = import ../pkgs/base.nix { inherit pkgs; };
in

with pkgs;
with lib;
{
  imports = [
    ./cli.nix
    ./emacs
    ./nested-shorthands
  ] ++ (let
    path = ../../private-config/default.nix;
  in if pathExists path then [ path ] else []);

  services.xserver = {
    enable              = true;
    layout              = "macintosh_vndr/de";
    exportConfiguration = true;
    xkbOptions          = "eurosign:e,shift:both_capslock,caps:none";

    displayManager = {
      sessionCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --mode 1440x900
      '';
      };

  };

  # TODO: this should work with an overlay as well
  services.xserver.windowManager = {
    session = [{
      name = "xmonad";
      start = ''
        ${pkgs.xmonad}/bin/xmonad &
        waitPID=$!
      '';
      }];
  };

  services.illum.enable = true;

  services.emacs.enable = true;
  services.emacs.package = pkgs.emacs;

  services.unclutter.enable = true;

  sound.mediaKeys.enable = true;

  environment.systemPackages = systemPkgs ++ (builtins.attrValues pkgs.shorthands);

  programs.chromium = {
    enable = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    extensions = [
      "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
      "lmhkpmbekcpmknklioeibfkpmmfibljd" # Redux DevTools
      "bfbameneiokkgbdmiekhjnmfkcnldhhm" # Web Developer
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    ];
    homepageLocation = "https://duckduckgo.com";
    extraOpts = {
      TranslateEnabled = false;
      restoreOnStartup = 4;
      NewTabPageLocation = "about:blank";
      BookmarkBarEnabled = false;
    };
  };

  nested-shorthands =
    [
      { name = "keyboard";
        kbd = "k";
        children =
          [ rec
            { name = "de";
              kbd = "d";
              pkg = writeShellScriptBin name ''
                ${pkgs.xorg.setxkbmap}/bin/setxkbmap de -variant mac
              '';
            }

            rec
            { name = "us";
              kbd = "u";
              pkg = writeShellScriptBin name ''
                ${pkgs.xorg.setxkbmap}/bin/setxkbmap us -variant mac
              '';
            }
          ];
      }

      rec
      { name = "youtube-dl-mp3";
        kbd = "y";
        pkg = writeShellScriptBin name ''
          ${pkgs.youtube-dl}/bin/youtube-dl
          --extract-audio \
          --audio-format mp3 \
          --output "%(title)s.%(ext)s" \
          $1
        '';
      }
    ];


}
