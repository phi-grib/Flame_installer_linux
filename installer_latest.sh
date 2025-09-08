#!/bin/bash

# Copyright 2020 Universitat Pompeu Fabra (UPF), Barcelona, Spain.
# Eric March, Ismael Rodríguez-Espigares
# Under CC BY-SA 3.0 license (https://creativecommons.org/licenses/by-sa/3.0/legalcode)

DESKTOP_DIR="$HOME"/Desktop

# Get script directory PATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
SCRIPT_DIR="$DIR"

# Checking miniconda/conda presence
if ! command -v conda &> /dev/null; then
    echo "conda is not present. Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash $HOME/miniconda.sh -b -p $HOME/miniconda3
    export PATH="$HOME/miniconda3/bin:$PATH"
    echo "Miniconda has been installed. Please restart your terminal."
else
    echo "Conda is present."
    # Update conda to ensure it's up to date
    conda config --set always_yes yes
    conda update -q conda
fi

# Checking flame presence
if [ -d "$HOME/flame_core" ]; then
    echo "Flame directory already exists. Updating to the latest version..."
    
    # Update Flame core
    cd $HOME/flame_core/flame
    git pull
    pip install -e .

    # Update Flame API
    cd $HOME/flame_core/flame_API
    git pull
    
    echo "Flame and Flame API have been updated to the latest version."
else
    # Downloading Flame and Flame API
    echo "Flame is not present. Installing the latest version from the main branch."
    mkdir -p "$HOME/flame_core"
    cd "$HOME/flame_core"
    
    git clone https://github.com/phi-grib/flame.git
    git clone https://github.com/phi-grib/flame_API.git
    
    cd flame
    echo "------- Creating conda environment `pwd` -------"
    conda env create -f environment.yml
    
    # Activate the environment and install
    eval "$(conda shell.bash hook)"
    conda activate flame
    
    echo "------- Current env: $CONDA_DEFAULT_ENV -------"
    pip install -e .
    echo "------ Using Flame `which flame` -----------"
    flame -c config -a silent
fi

# Adding Flame executable to the desktop and applications menu
if [ -f "$SCRIPT_DIR/exec/Flame.desktop" ]; then
    sed -i "s?\/home\/eric\/Flame_installer_linux?$SCRIPT_DIR?" "$SCRIPT_DIR/exec/Flame.desktop"
    cp "$SCRIPT_DIR/exec/Flame.desktop" "$DESKTOP_DIR"
    cp "$SCRIPT_DIR/exec/Flame.desktop" "$HOME/.local/share/applications"
    echo "Flame launcher added to Desktop and Applications menu."
fi