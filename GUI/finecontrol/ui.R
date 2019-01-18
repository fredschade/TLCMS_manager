output$server_Fine_control = renderUI({
  tagList(
  fluidPage(
      fluidRow(
      box(title = "Motor Control", width = "50 %", heigth ="50 %",solidHeader = TRUE,status = "primary",
      fluidRow(
      column(6,
      fluidRow(
          column(2,"X :"),
          column(2,offset=1,actionButton("xleft","",icon=icon("arrow-left"))),
          column(2,actionButton("xhome","",icon=icon("home"))),
          column(2,actionButton("xright","",icon=icon("arrow-right")))
           ),

      fluidRow(
          column(2,"Y :"),
          column(2,offset=1,actionButton("yup","",icon=icon("arrow-up"))),
          column(2,actionButton("yhome","",icon=icon("home"))),
          column(2,actionButton("ydown","",icon=icon("arrow-down")))
           )),

      column(4,
           actionButton("stop","Disable Motors")
           )),
      fluidRow(
        column(8,
           textInput("test_ink_cmd","Command","G1 X10", width = "100%"),
           actionButton("test_ink_cmd_button","Launch GCODE")
          )
        )
      )),
     fluidRow(
     box(title = "GCode upload", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
                    fileInput("test_ink_gcode_file","Upload a GCODE file"),
         actionButton("test_ink_gcode_file_action","Launch the GCODE file")
         )
     )))
     
})
