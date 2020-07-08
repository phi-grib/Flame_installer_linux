#!/bin/bash

conda info -a
conda init
source activate flame
apidir=$(locate -b flame_API)
cd "${apidir}/flame_api"
python manage.py runserver &
sleep 5
xdg-open "http://127.0.0.1:8000/"
