class DART:
    def __init__(self, DART_config):
        """ head_config: dict {
        'scan_speed': number, 
        'moving_speed': number,
        'MS_status: bool'
        } """
        self.scan_speed = float(DART_config.get('scan_speed'))
        self.moving_speed = float(DART_config.get('moving_speed'))
        self.MS_status = bool(int(DART_config.get('MS_status')))

    def get_scan_speed(self):
        "speed while scan-process: mm/minute"
        return self.scan_speed

    def get_moving_speed(self):
        "speed while moving: mm/minute"
        return self.moving_speed

    def get_MS_status(self):
        "start time for the eluition_process in MS: s"
        return self.MS_status
