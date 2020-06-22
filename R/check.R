#' Check to see if needed parameters are missing
#' 
#' @param ... named items to check
#' @return error if list is not named
check_named <- function(list){
    if(is.null(names(list))){stop("Please only pass named arguments to this function")}
    if("" %in% names(list)){stop("Please only pass named arguments to this function")}
}

#' Check to see if needed parameters are missing
#' 
#' @param ... named items to check
#' @return error if null
check_null <- function(...){
    items <- list(...)
    check_named(items)
    for(item in names(items)){
        if(is.null(items[[item]])){
            stop(sprintf('No %s set.\n  Add %s to the function arguments.', item, item))
        }
    }
}

#' Ensure specificity for certain functions
#' 
#' @param v named items to check
#' @return error if list is not named
check_specific <- function(v, name = NULL){
    if(length(v) > 1){stop(paste("argument", name, "should be of length 1. Found many."))}
    if(length(v) < 1){stop(paste("argument", name, "should be of length 1. Found none."))}
}

#' Ensure specificity for certain functions
#' 
#' @param lexicon a lexicon to be evaluated
#' @return error if lexicon is not properly formatted
check_lexicon <- function(lexicon){
    columns <- c("base", "command", "subcommand", "giftwrap_command")
    if(!all(columns %in% colnames(lexicon))){
        stop(paste("Please pass a lexicon with the proper column names:", paste(columns, collapse = ", ")))
    }
    if(nrow(unique(lexicon)) != nrow(lexicon)){
        stop("Please pass a lexicon with unique rows only.")
    }
}
