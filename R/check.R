#' Check to see if needed parameters are missing
#' 
#' @param list a list to check
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

#' Checks lexicon name passed to \code{lexcion}
#' @param lexicon_name the lexicon name passed to \code{lexcion}
#' @return error and message if lexicon not in available lexicons
check_lexicon_name <- function(lexicon_name){
  available_lexicons <- c("aws", "az", "brew", "docker",
                          "gcloud", "gh", "git",
                          "heroku", "kubectl", "sfdx")
  if(!lexicon_name %in% available_lexicons){
    stop(paste("Please pick an available lexicon: ", paste(available_lexicons, collapse = ", ")))
  }
  
}
