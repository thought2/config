{ pkgs, lib, config, ... }:

let
  systemPkgs = import ../pkgs/base.nix { inherit pkgs; };
  shorthands = import ../pkgs/shorthands.nix { inherit pkgs; };
in

with pkgs;
with lib;
{
  imports = [
    ./cli.nix
    ./emacs
    ./git.nix
  ] ++ (let
    path = ../../private-config/default.nix;
  in if pathExists path then [ path ] else []);

  services.xserver = {
    enable              = true;
    exportConfiguration = true;
    xkbOptions          = "eurosign:e,caps:none";

    displayManager = {
      sessionCommands = ''
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

  environment.systemPackages = systemPkgs ++ builtins.attrValues(shorthands);

  programs.chromium = {
    enable = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";

    extensions = [
      "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
      "lmhkpmbekcpmknklioeibfkpmmfibljd" # Redux DevTools
      "bfbameneiokkgbdmiekhjnmfkcnldhhm" # Web Developer
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "dmghijelimhndkbmpgbldicpogfkceaj" # Dark Mode
      "chklaanhfefbnpoihckbnefhakgolnmc" # JSONView
      "ckkdlimhmcjmikdlpkmbgfkaikojcbjk" # Markdown Viewer
    ];
    homepageLocation = "https://duckduckgo.com";
    extraOpts = {
      TranslateEnabled = false;
      restoreOnStartup = 4;
      NewTabPageLocation = "about:blank";
      BookmarkBarEnabled = false;
    };
  };

  environment.etc.Xmodmap.text = ''
    keysym a = a A a A adiaeresis Adiaeresis
    keysym o = o O o O odiaeresis Odiaeresis
    keysym u = u U u U udiaeresis Udiaeresis
    keysym s = s S s S ssharp ssharp

    clear lock
    ! Caps Lock -> Nabla
    keycode 66 = nabla

    keycode 49 = asciicircum
  '';

}
