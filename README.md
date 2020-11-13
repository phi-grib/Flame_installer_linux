# Flame_installer_linux
Bash scripts for installing Flame and miniconda

Instructions:

1. `git clone https://github.com/phi-grib/Flame_installer_linux/`
2. `cd Flame_installer_linux`
3. `bash installer.sh`
4. After insallation -> `bash flame_api.sh`
               OR
   Go to Desktop -> Double click on Flame executable

It is possible that it may take a while to start. If an error appears in the browser, just refresh (F5) the window when the django server is up and running.

If you want to specify the path for your models do:<br>
`conda activate flame`<br>
`flame -c config -d /path/to/models`<br>
Then run again the executable.

You can also change the path to your custom model directory in Flame's GUI in the configuration tab.
