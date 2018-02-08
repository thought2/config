import <nixpkgs/nixos/tests/make-test.nix> ({ pkgs, ...} : {
  name = "test";

  nodes = {
    netcup = import ../machines/netcup/configuration.nix;
    macbook2013 = import ../machines/macbook2013/configuration.nix;
  };

  testScript =
    ''
      $netcup->waitUntilSucceeds('ping -c 1 localhost');
      $macbook2013->waitUntilSucceeds('ping -c 1 netcup');

      $macbook2013->succeed('env HOST=netcup test-webserver');
    '';
})
