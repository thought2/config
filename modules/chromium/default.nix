{ pkgs ? import <nixpkgs> {}, ... }:

with pkgs;

let
  chrome-set-search-engines =
    let
      pkg = (import ./chrome-set-search-engines {}).package;
      main = pkg + "/lib/node_modules/chrome-set-search-engines/dist/chrome-set-search-engines.js";
    in
    writeShellScriptBin "chrome-set-search-engines" ''
      ${pkgs.nodejs}/bin/node \
        ${main} \
        --sqliteCmd ${pkgs.sqlite}/bin/sqlite3 \
        --data-file ${./search-engines.json} \
        $@
      '';
in
{
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
      "hdokiejnpimakedhajhdlcegeplioahd" # LastPass
      "cfhdojbkjhnklbpkdaibdccddilifddb" # Adblock Plus
    ];
    homepageLocation = "https://duckduckgo.com";
    extraOpts = {
      TranslateEnabled = false;
#      restoreOnStartup = 4;
      NewTabPageLocation = "about:blank";
      BookmarkBarEnabled = false;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      chromium = super.writeShellScriptBin "chromium" ''
        ${super.chromium}/bin/chromium \
          --no-first-run \
          --no-default-browser-check \
          $@
      '';
      })
  ];

  environment.systemPackages = [ chrome-set-search-engines ];
}
