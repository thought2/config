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
    ./git.nix
  ] ++ (let
    path = ../../private-config/default.nix;
  in if pathExists path then [ path ] else []);

  services.xserver = {
    enable              = true;
    layout              = "macintosh_vndr/de";
    exportConfiguration = true;
    xkbOptions          = "eurosign:e,caps:none";

    displayManager = {
      sessionCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --mode 1440x900
        ${pkgs.xorg.xmodmap}/bin/xmodmap /etc/Xmodmap
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
    # "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
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
      { name = "nix";
        kbd = "n";
        children =
          [ rec
            { name = "search";
              kbd = "s";
              interact = "sPkg: ";
              pkg = writeShellScriptBin name ''
                nix-env -qa --description -P '.'*$1'.*' | cat
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

      rec
      { name = "notify-play";
        kbd = "x";
        pkg =
          let
            soundFile = pkgs.fetchurl
              { url = "https://notificationsounds.com/notification-sounds/plucky-550/download/mp3";
                name = "plucky.mp3";
                sha256 = "0qvg85zvlx5dcp4fbngpqa4ml3nd62lyyldhnwb00i1q1w4p82cp";
              };
          in
            writeShellScriptBin name ''
              ${pkgs.sox}/bin/play -t mp3 ${soundFile}
            '';
      }
    ];

  environment.etc.Xmodmap.text = ''
    keysym a = a A a A adiaeresis Adiaeresis
    keysym o = o O o O odiaeresis Odiaeresis
    keysym u = u U u U udiaeresis Udiaeresis
    keysym s = s S s S ssharp ssharp

    clear lock
    ! Caps Lock -> Nabla
    keycode 66 = nabla
  '';

}
