

observeEvent(input$test_ink_cmd_button,{
    fineControlDriver$customCommand(toupper(input$test_ink_cmd))

})

observeEvent(input$xleft,{
    fineControlDriver$goXLeft()
})
observeEvent(input$xhome,{
    fineControlDriver$goXHome()
})

observeEvent(input$xright,{
    fineControlDriver$goXRight()
})

observeEvent(input$yup,{
    fineControlDriver$goYUp()
})

observeEvent(input$yhome,{
    fineControlDriver$goYHome()
})

observeEvent(input$ydown,{
    fineControlDriver$goYDown()
})

observeEvent(input$stop,{
    fineControlDriver$stop()
})


#----------------------------------------------------------------------------------------
#Gcode
observeEvent(input$test_ink_gcode_file_action,{
    ocDriver$send_from_file(input$test_ink_gcode_file$datapath)
})

#----------------------------------------------------------------------------------------




