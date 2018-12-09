{ pkgs, lib, config, ... }:

let
  systemPkgs = import ../pkgs/base.nix { inherit pkgs; };
  shorthands = import ../pkgs/shorthands.nix { inherit pkgs; };
in

with pkgs;
with lib;
{
  imports = [
    ./cli
    ./git.nix
    ./emacs
  ] ++ (let
    path = ../private-config/default.nix;
  in if builtins.pathExists path then [ path ] else []);

  users.users.root.extraGroups = [ "audio" ];

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

  # Todo: this should work with an overlay as well
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
      "gjadajkmpgdblfochjcfpkhnnkicfapl" # Just Read
      "kdejdkdjdoabfihpcjmgjebcpfbhepmh" # Copy Link Address
      "ljobjlafonikaiipfkggjbhkghgicgoh" # Edit with Emacs
      "fjnbnpbmkenffdnngjfgmeleoegfcffe" # Stylish
      "opphlpkpklmjbglpifmecilchaknobgn" # Tab Keeper
      "kniehgiejgnnpgojkdhhjbgbllnfkfdk" # SimpleExtManager
      "cmkdbmfndkfgebldhnkbfhlneefdaaip" # WhatRuns
      "epejoicbhllgiimigokgjdoijnpaphdp" # Emmet Re:view
      "ohcpnigalekghcmgcdcenkpelffpdolg" # ColorPick Eyedropper
      "emliamioobfffbgcfdchabfibonehkme" # Page Ruler
      "ggfgijbpiheegefliciemofobhmofgce" # CSSViewer
      "ihaobgceoogckalioenpheioedgjaahk" # Fullscreenrrr
      "jlkgkebpphmaiemciejnmgccejccnpha" # simple-debug.css
      "epodomlablfiehjgajhlhbdhidlkokaj" # Outliner CSS
      "kokeihndgocdlgibnibeabeljjgehadj" # CSS debug alignment
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

    ! only for german layout
    ! keycode 49 = asciicircum
  '';

}
