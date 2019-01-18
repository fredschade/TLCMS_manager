PATH = "./GUI/method/"
PATH_load = paste0(PATH,"method_to_load/")

renderMethodsUI <- function (){
    ## load UI
    source(paste0 (PATH,"DART/ui.R"), local=T)
    output$methodUI <- methodsUI_DART 

    ##load event Handler
    source(paste0 (PATH,"DART/eventHandler.R"), local=T)

    # override function for each eventHandler
    step_add_Methods <<- step_add
    step_start_Methods <<- step_start
}


showInfo  <<- function(msg) {
    Method_feedback$text = msg
}

getSelectedStep  <<- function(){
    return (as.numeric(input$Method_steps))
}


## methods
observeEvent(input$Method_step_add,{
    renderMethodsUI()
    step_add_Methods()
    Method$selected = length(Method$control)
})

observeEvent(input$Method_step_delete,{
    index = getSelectedStep()
    if(index > 0) {
        Method$control[[index]] = NULL
    }
    Method$selected = length (Method$control)

})



## start
observeEvent(input$Method_step_exec,{
    step_start_Methods()
})


## save
observeEvent(input$Method_save,{
    filePath = paste0(PATH_load,input$Method_save_name,".Rdata")
    control = Method$control
    save(control,file=filePath)
    Method_feedback$text = paste0("Saved ", filePath)
})

observeEvent(input$Method_load,{
    loadMethod = input$Method_load_name
    if (!is.null(loadMethod)){
        load(paste0(PATH_load,loadMethod))
        Method$control=control
        Method_feedback$text = "Method loaded"
    }
    else{
        Method_feedback$text = "Method can't load, no file selected"
    }
    Method$selected = 1
})


observeEvent(input$Method_steps,{
    renderMethodsUI()
    Method$selected = getSelectedStep()
 })
