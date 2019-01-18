setApplicationConf  <- function(DART_config, plate_config, number_of_tracks, step){
    Method$control[[step]] = list(type="DART",
                                  DART_config=DART_config,
                                  plate_config = plate_config,
                                  number_of_tracks = number_of_tracks)
}

toPythonTableDARTFormat  <- function(tableDARTConf) {
    keysTable = c("MS_status","scan_speed","moving_speed")
    return (settingsTabletoPythonDict(tableDARTConf, keysTable))
}

toPythonTablePlateFormat  <- function(tablePlateConf) {
    keysPlate = c("relative_band_distance_y", "relative_band_distance_x"  , "plate_height_y" , "plate_width_x","band_length","gap")
    return (settingsTabletoPythonDict(tablePlateConf, keysPlate))
}

getPlateConfigFromTable <- function (){
    plateTable = hot_to_r(input$plate_config)
    return (toPythonTablePlateFormat(plateTable)) 
}

getDARTConfigFromTable <- function (){
    DARTTable = hot_to_r(input$DART_config)
    return (toPythonTableDARTFormat(DARTTable)) 
}


step_add  <- function(){
    DARTConf = DART_driver$get_default_DART_config()
    plateConf = DART_driver$get_default_plate_config()
    number_of_tracks = as.numeric(getNumberOfTracks())
    step = length(Method$control) + 1
    
    setApplicationConf(DARTConf, plateConf, number_of_tracks, step)

    showInfo("Please configure your sample application proccess")
}


step_start <- function(){
    withProgress(message = paste0('Scanning tracks'), value =0, {
        DART_driver$start_application()
       })
    
}


observeEvent(input$DART_settings_update,{
    step = getSelectedStep()
    pyPlate = getPlateConfigFromTable()
    pyDART = getDARTConfigFromTable()
    
    number_of_tracks = as.numeric(input$number_of_tracks)
    DART_driver$update_settings(plate_config=pyPlate,DART_config=pyDART,number_of_tracks=number_of_tracks)

    setApplicationConf(pyDART, pyPlate, number_of_tracks, step)
})

