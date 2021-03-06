methodsUI_DART <- renderUI({
    fluidPage(
    fluidRow(
        box(title = "Settings", width = "85%", height = "45%",status = "primary",
           uiOutput("DART_control_settings"))
    ),
    fluidRow(
    box(title = "Information", width = "85%", height = "45%",status = "primary",
        uiOutput("DART_control_infos"))
    )
    )
})


## settings
output$DART_control_settings = renderUI({
    validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
    )
  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
          fluidRow(
          column(5,box(title = "DART ", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("DART_config"))),
          column(5,box(title = "Plate Design", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("plate_config"))),
          column(2,box(title = "Update Settings", width = "33%", height = "45%",status = "warning",
          fluidRow(textInput("number_of_tracks", "Number of tracks", getNumberOfTracks(),width="100%")),
          fluidRow(actionButton("DART_settings_update","Update all",icon=icon("gears"), width="100%"))
                   ))
          )
                   )
                  )
  }
})

output$DART_control_infos = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
        column(6,box(title = "Plate Plot ", width = "33%", height = "45%",status = "warning",
        plotOutput("DART_plot",width="400px",height="400px")))
    )
  }
})




getNumberOfTracks  <- function(){
    step = getSelectedStep()
    numberOfTracks = 5
    if (!identical(step, numeric(0)))
    {
        numberOfTracks = Method$control[[step]]$number_of_tracks
    }
    return (numberOfTracks)
}

createApplicationPlot <- function ( plate_config, numberOfTracks){
    plate_width_x = as.numeric (plate_config$plate_width_x)
    plate_height_y = as.numeric (plate_config$plate_height_y)
    track_length = as.numeric (plate_config$band_length)
    relative_band_distance_x = as.numeric (plate_config$relative_band_distance_x) + 50 - plate_width_x/2
    relative_band_distance_y = as.numeric (plate_config$relative_band_distance_y) + 50 - plate_height_y/2
    gap = as.numeric (plate_config$gap)
    numberOfTracks=numberOfTracks

    plot(c(1,100),c(1,100),
         type="n",xaxt = 'n',
         xlim=c(0,100),ylim=c(0,100),
         xlab="Track direction (X)",ylab="Scan direction (Y) ")

    axis(1)
    start_track=relative_band_distance_x
    y_track = relative_band_distance_y
    for(track in seq(1,numberOfTracks)){
        end_track=start_track + track_length
        segments(x0 = y_track,
                 y0 = start_track,
                 y1 = end_track
                 )
        y_track = y_track + gap
    }
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_height_y,plate_width_x)),lty=2)
}

toTableDARTRFormat  <- function(pythonDARTConf){
    labels = c("Turn MS on","Scan Speed", "Moving Speed")
    units = c("", "mm/s", "mm/s")
    return (toRSettingsTableFormat(pythonDARTConf, labels, units))
}

toTablePlateRFormat  <- function(pythonPlateConf) {
    labels = c("Start Track [X]", "Start Track [Y]", "Plate Height [Y]", "Plate Width [X]","Length of the Track", "Track Distance")
    units = c("mm", "mm", "mm", "mm", "mm", "mm")
    return (toRSettingsTableFormat(pythonPlateConf, labels, units))
}




output$DART_plot = renderPlot({
    index = getSelectedStep()
    if (index > length(Method$control)){
        index=1
    }
    currentMethod= Method$control[[index]]
    if(!is.null(currentMethod)){
        plate_config = currentMethod$plate_config
        numberOfTracks= as.integer(getNumberOfTracks())
        createApplicationPlot(plate_config, numberOfTracks)
    }
    else{
        plot(x=1,y=1,type="n",main="Update to visualize")
    }
})

output$Method_step_feedback = renderText({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  Method$control[[as.integer(input$Method_steps)]]$info
})

output$DART_config = renderRHandsontable({  validate(
    need(length(Method$control) > 0 ,"Please add a new step (for example: Sample Application)")
  )
  index = getSelectedStep()
  config = Method$control[[index]]$DART_config
  table = toTableDARTRFormat(config)

  rhandsontable(table, rowHeaderWidth = 160) %>%
      hot_cols(colWidth = 50)  %>%
            hot_col("units", readOnly = TRUE)
})

output$plate_config = renderRHandsontable({
    if(!is.null(input$Method_steps)) {
        index = getSelectedStep()
        config = Method$control[[index]]$plate_config
        table = toTablePlateRFormat(config)
        rhandsontable(table, rowHeaderWidth = 160) %>%
            hot_cols(colWidth = 50) %>%
            hot_col("units", readOnly = TRUE)

    }
})





