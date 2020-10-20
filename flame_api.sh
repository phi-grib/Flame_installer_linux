#!/bin/bash

cd $HOME/flame_core/flame_API/flame_api
source $HOME/.bashrc
conda init bash
source activate flame
pypath=$(which python)
settings=${HOME}/flame_core/flame_API/flame_api/
echo "------ Using Flame `which flame` -----------"
flame -c config
python manage.py runserver --noreload --pythonpath ${pypath}  --settings ${settings}  | xdg-open "http://127.0.0.1:8000/"