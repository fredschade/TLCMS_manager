class DART:
    def __init__(self, DART_config):
        """ head_config: dict {
        'scan_speed': number, 
        'moving_speed': number,
        'MS_status: bool'
        } """
        self.scan_speed = float(DART_config.get('scan_speed'))
        self.moving_speed = float(DART_config.get('moving_speed'))
        self.MS_status = bool(float(DART_config.get('MS_status')))

    def get_scan_speed(self):
        "speed while scan-process: mm/minute"
        return self.scan_speed

    de#!/usr/bin/env Rscript

## app_exec for OC_manager on the pi, to be call with crontab, from the pi, to allow access on the local network to the instrument

shiny::runApp("/home/pi/OC_manager/",host="0.0.0.0",port=80)f get_moving_speed(self):
        "speed while moving: mm/minute"
        return self.moving_speed

    def get_MS_status(self):
        "start time for the eluition_process in MS: s"
        return self.MS_status
