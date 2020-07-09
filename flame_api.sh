#!/bin/bash

apidir=$(find $HOME/flame_core -type d -name flame_API)
cd "${apidir}/flame_api"
conda init
source activate flame
python manage.py runserver --noreload | xdg-open "http://127.0.0.1:8000/"
