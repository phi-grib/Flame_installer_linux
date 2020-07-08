#!/bin/bash
#Checking flame presence

flamedir="source activate flame"
$flamedir

if [ $? -eq 0 ]; 
	then
    		echo "Flame is present, no need to install"

else
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
