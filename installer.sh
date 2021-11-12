#!/bin/bash

#Copyright 2020 Universitat Pompeu Fabra (UPF), Barcelona, Spain.
#Eric March, Ismael Rodríguez-Espigares
#Under CC BY-SA 3.0 license (https://creativecommons.org/licenses/by-sa/3.0/legalcode) 

DESKTOP_DIR="$HOME"/Desktop

#Get script directory PATH
#Copyright 2008-2020
#       Under CC BY-SA 3.0 license (https://creativecommons.org/licenses/by-sa/3.0/legalcode) 
#       Adapted from Stack Overflow answer to Peter Mortensen (https://stackoverflow.com/users/63550/peter-mortensen) and others.
#       by Dave Dopson (https://stackoverflow.com/users/407731/dave-dopson) and others.
#       https://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
SCRIPT_DIR="$DIR"

#Checking miniconda/conda presence

condadir="which conda"
$condadir

if [ $? -eq 0 ]; 
then
	echo "Conda is present"
	export PATH="$condadir/bin:$PATH"
	conda config --set always_yes yes
	conda update -q conda
	source $HOME/.bashrc

else
	echo "conda is not present"
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
	bash $HOME/miniconda.sh -b -p $HOME/miniconda
	export PATH="$HOME/miniconda/bin:$PATH"
	conda config --set always_yes yes
	conda update -q conda
	source $HOME/.bashrc
fi

#Checking flame presence

flamedir="source activate flame"
$flamedir

if [ $? -eq 0 ]; 
then
	echo "Flame is present, checking if version is master"
	cd $HOME/flame_core/flame
	git checkout master
	if [ $? -eq 0 ];
	then
		echo "Flame is updated to last stable version"
	else
		git pull
		pip install -e .
		echo "Reseting model path"
		flame -c config -a silent
		git checkout master
	fi
	cd $HOME/flame_core/flame_API
	git checkout master
	if [ $? -eq 0 ];
	then
		echo "Flame API is updated to last stable version"
	else
		git pull
		git checkout master
	fi
	echo "Flame and Flame API have been updated to stable version master"

else
	#Downloading Flame and Flame API
	echo "Flame is not present. Installing stable version master"
	mkdir $HOME/flame_core
	cd $HOME/flame_core
	git clone https://github.com/phi-grib/flame.git --branch master --depth 1
	git clone https://github.com/phi-grib/flame_API.git --branch master --depth 1
	cd flame
	echo "------- Working dir `pwd` -------"
	conda info -a
	conda env create -f environment.yml
	conda init
	source activate flame
	echo "------- Current env $CONDA_DEFAULT_ENV -------"
	pip install -e .
	echo "------ Using Flame `which flame` -----------"
	flame -c config -a silent
fi

# Adding Flame executable in desktop
cd $SCRIPT_DIR/exec
sed -i "s?\/home\/eric\/Flame_installer_linux?$SCRIPT_DIR?" Flame.desktop
cp Flame.desktop "$DESKTOP_DIR"
cp Flame.desktop $HOME/.local/share/applications
