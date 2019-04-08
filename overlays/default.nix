{config, ...}:
self: super:
let
  node2nixPkgs = import ../pkgs/node2nix {};
  shorthands = import ../pkgs/shorthands.nix { pkgs = self; inherit config; };
in
{
  chamber =
    super.latestMaster.buildGoModule rec {
      name = "chamber-${version}";
      version = "2.3.2";

      src = super.fetchFromGitHub {
        owner = "segmentio";
        repo = "chamber";
        rev = "v${version}";
        sha256 = "0qzqak1g3gwi6sn8y4nf97c3zg0jfy6xqgfiv9fp8x7hra286rr5";
      };

      modSha256 = "08wx3ipv3r5xl2y45f7ydpfajr90zc9h0is0vkrj8rbnzvyn2imv";

      subPackages = [ "." ];

      meta = with super.lib; {
        description = "Chamber is a tool for managing secrets. Currently it does so by storing secrets in SSM Parameter Store, an AWS service for storing secrets.";
        homepage = https://github.com/segmentio/chamber;
        license = licenses.mit;

        platforms = platforms.linux;
      };
    };

  chalk = node2nixPkgs.chalk-cli;

  emacs-client = let
    lispExpr = ''
      (progn
        (shell (concat "shell-" (car (split-string (shell-command-to-string "uuidgen")))))
        (delete-other-windows))
    '';
  in
    super.writeShellScriptBin "emacs-client" ''
      ${super.emacs}/bin/emacsclient --create-frame -e '${lispExpr}'
    '';

  xmonad = import ./xmonad { pkgs = self; };

  pythonExt = self.python3Packages.python.withPackages (p: [ p.notebook p.grip p.virtualenvwrapper ]);

  chromium = super.writeShellScriptBin "chromium" ''
    ${super.chromium}/bin/chromium \
      --no-first-run \
      --no-default-browser-check \
      $@
  '';

  inherit shorthands;
  inherit node2nixPkgs;
}
