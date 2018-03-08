{ pkgs, ... }:
{
  environment.variables = {
    GIT_EDITOR = "${pkgs.emacs}/bin/emacs";
  };

  environment.systemPackages = [ pkgs.git pkgs.gitAndTools.gitflow ];
}
