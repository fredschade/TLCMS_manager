import drivers.gcodes as GCODES
from config.plate_config import Plate
from config.DART_config import DART


class DARTDriver():

    PLATE_CONFIG_DEFAULT = {
        'gap': 2,
        'plate_width_x': 100,
        'plate_height_y': 100,
        'band_length': 80,
        'relative_band_distance_x': 10,
        'relative_band_distance_y': 10
    }

    DART_CONFIG_DEFAULT = {
        'scan_speed': 3000,
        'moving_speed': 3000,
        'MS_status': 0,
    }


    def __init__(self, communication,
                 plate_config=PLATE_CONFIG_DEFAULT, \
                 DART_config = DART_CONFIG_DEFAULT,
                 number_of_tracks = 5):
        self.update_settings(plate_config, DART_config, number_of_tracks)
        self.communication = communication

    def update_settings(self, plate_config, DART_config, number_of_tracks):
        self.DART_config = DART(DART_config)
        self.plate = Plate(plate_config, calibration_x=0, calibration_y=0)
        self.number_of_tracks = int(number_of_tracks)
        self.generate_tracks()

    def calculate_track_length(self):
        track_length = self.plate.get_plate_width_x() - \
        2 * self.plate.get_relative_band_distance_x()
        self.plate.set_band_length(track_length)
        return (track_length)

    def get_track_length(self):
        return self.plate.get_band_length()

    def generate_tracks(self):
        track_y = self.plate.get_band_offset_y()
        tracks = []
        gap = self.plate.get_gap()
        for i in range(self.number_of_tracks):
            tracks.append(track_y)
            track_y += gap
        self.track_config = tracks

    def generate_gcode(self):
        gcode_start = GCODES.fan_power(True) + GCODES.START + GCODES.go_speed(
            self.DART_config.get_moving_speed())
        gcode_for_tracks = GCODES.new_lines(self.tracks_to_gcode())
        gcode_end = GCODES.END
        return (gcode_start + "\n" + gcode_for_tracks + "\n" + gcode_end)

    def get_default_DART_config(self):
        return self.DART_CONFIG_DEFAULT

    def get_default_plate_config(self):
        return self.PLATE_CONFIG_DEFAULT

    def tracks_to_gcode(self):
        track_length = self.plate.get_band_length()
        track_start_x = self.plate.get_band_offset_x()
        plate_x = self.plate.get_plate_width_x()
        track_end_x = track_start_x + track_length
        gcode_for_tracks = []
        scan_speed = self.DART_config.get_scan_speed()
        moving_speed = self.DART_config.get_moving_speed()
        MS_status = self.DART_config.get_MS_status()
        for track_y in self.track_config:
            gcode_for_tracks.append(self.generate_gcode_for_MS(MS_status))
            gcode_for_tracks.append(GCODES.DART_track_scan(track_y, track_start_x, track_end_x, \
                                                            scan_speed, moving_speed))
            gcode_for_tracks.append(
                GCODES.DART_track_return(plate_x, moving_speed))

        return gcode_for_tracks

    def generate_gcode_for_MS(self, MS_status):
        if (MS_status):
            return GCODES.mass_spectrometer_power(True) + GCODES.wait(20) + \
        GCODES.mass_spectrometer_power(False)
        else:
            return ""

    def generate_gcode_and_send(self):
        gcode = self.generate_gcode()
        print(gcode)
        gcode_list = gcode.split('\n')
        self.communication.send(gcode_list)

    def start_application(self):
        self.generate_gcode_and_send()
