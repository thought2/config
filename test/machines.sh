: ${CONFIG_DIR:?}

MACHINES_DIR=$CONFIG_DIR/machines

echo -e "Building virtual machines of all configurations.\n"

for file in $MACHINES_DIR/*/configuration.nix
  do
    echo -e "Building VM for machine in file $file\n"
    export NIXOS_CONFIG=$file; nixos-rebuild build-vm;
    echo -e "---------------------------------------------------------------------\n"
  done
