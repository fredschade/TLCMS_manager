#!/usr/bin/env Rscript

## app_exec for OC_manager on the pi, to be call with crontab, from the pi, to allow access on the local network to the instrument

shiny::runApp("/home/pi/TLCMS_manager/",host="0.0.0.0",port=80)
