#!/bin/bash

open_browser () {
  sleep 5
  xdg-open "http://127.0.0.1:8000/"

}

FLAME_DIR="$HOME/flame_core/flame_API/flame_api"
cd "$FLAME_DIR"
source $HOME/.bashrc
conda init bash
source activate flame
open_browser &
python manage.py runserver --noreload