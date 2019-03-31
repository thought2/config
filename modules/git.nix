{ pkgs, ... }:

with pkgs;

let
  globalGitignore = writeText "global-gitignore" ''
    \#*#
    \.#*
  '';
in
{
  environment.variables = {
    GIT_EDITOR = "${pkgs.emacs}/bin/emacs";
  };

  environment.systemPackages = [ pkgs.git pkgs.gitAndTools.gitflow ];

  environment.extraInit = ''
    ${git}/bin/git config \
      --global core.excludesfile ${globalGitignore}
  '';
}
