{ pkgs, ... }:

with pkgs.emacs25PackagesNg;
{

  programs.emacs.stanzas.elfeed.epkgs = [ elfeed ];

  programs.emacs.stanzas.elfeed.init = ''

    (setq elfeed-feeds
        '("http://nullprogram.com/feed/"
          "http://planet.emacsen.org/atom.xml"
          "http://www.taz.de/Krieg-in-Syrien-und-Irak/!t5007613;rss/"
          "https://news.ycombinator.com/rss"))
  '';

}
