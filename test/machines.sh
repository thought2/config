: ${CONFIG_DIR:?}

MACHINES_DIR=$CONFIG_DIR/machines

CONFIG_FILES=($MACHINES_DIR/*/configuration.nix)

SEP1="=====================================================================\n"
SEP2="---------------------------------------------------------------------\n"

RESULTS=()

# Header

echo -e "Building virtual machines from the following files:\n"

for file in "${CONFIG_FILES[@]}"
  do
    echo $file
  done

echo -e $SEP1


# Body

i=0

for file in "${CONFIG_FILES[@]}"
  do
    echo -e "Building VM for machine in file $file\n"
    export NIXOS_CONFIG=$file; nixos-rebuild build-vm;
    RESULTS[i]=$?
    echo -e $SEP2

    i=$i+1
  done

echo -e $SEP1


# Footer

#TODO: Print results
