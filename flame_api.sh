#!/bin/bash

cd $HOME/flame_core/flame_API/flame_api
source $HOME/.bashrc
conda init bash
source activate flame
echo "------ Using Flame `which flame` -----------"
flame -c config
python manage.py runserver --noreload | xdg-open "http://127.0.0.1:8000/"
