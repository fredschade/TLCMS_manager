library(stringi)
use_virtualenv(file.path(getwd() ,"oc_driver", "py_virtual_env"), required=T)
ocdriverPackage <- import_from_path("OCDriver", path='oc_driver', convert = TRUE)
ocDriver <- ocdriverPackage$OCDriver() # use default config


toRSettingsTableFormat <- function(pythonDict, labels, units){
    valuesWithSpaces = as.matrix(stack(pythonDict))[, c(2, 1)][, "values"]
    values = stri_replace_all_charclass(valuesWithSpaces, "\\p{WHITE_SPACE}", "")
    f = data.frame(values, units, stringsAsFactors = FALSE)
    rownames(f) = labels
    return (f)
}


settingsTabletoPythonDict  <- function(settingsTable, pythonKeys){
    values = settingsTable[["values"]]
    return (py_to_r(py_dict(pythonKeys, values)))

}

