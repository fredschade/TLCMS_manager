########## METHOD #############################################
# load control variable
Method <<- reactiveValues(control=list(),selected = 1)
Method_feedback <<- reactiveValues(text="No feedback yet")
#load event Handler
source("./GUI/method/eventHandler.R", local=T)
# load UI
source("./GUI/method/ui.R", local=T)
# load driver
DART_driver<<-ocDriver$get_DART_driver()
