#!/bin/bash

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
    		echo "Flame is present, no need to install"

else
	#Downloading Flame and Flame API
	echo "Flame is not present"
	mkdir $HOME/flame_core
	cd $HOME/flame_core
	git clone https://github.com/phi-grib/flame.git
	git clone https://github.com/phi-grib/flame_API.git
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

