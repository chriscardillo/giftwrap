#' Create an argument with shell formatting
#'
#' @param x the argument to be passed to the shell command. Both named arguments and unnamed arguments work.
#' @return a shell-formatted argument
format_arg <- function(x){
    if(!is.null(names(x)) && names(x) != ""){
        trimws(sprintf("--%s %s", gsub("_", "-", names(x)), paste(x[[1]], collapse = " ")))
    } else {
        paste(x[[1]], collapse = " ")
    }
}

#' giftwrap a base command and its arguments from R to shell
#'
#' @param base_command a shell command
#' @param ... named and unnamed arguments to be giftwrapped
#' @return a shell-formatted command with shell-formatted arguments
giftwrap_command <- function(base_command, ...){
    args <- list(...)
    args_formatted <- c()
    # boo hoo a for loop
    if(length(args) > 0){
        for(i in 1:length(args)){
            if(!is.null(args[[i]])){
                args_formatted[i] <- format_arg(args[i])
            }
        }
    }
    args_formatted <- args_formatted[which(!is.na(args_formatted))]
    paste(base_command, paste(args_formatted, collapse = " "))
}

#' Run command
#'
#' @param command a shell command
#' @param collect whether the output of the shell command should be collected in R
#' @return messages from the running command, errors if failure
run_command <- function(command, collect=FALSE){
    message(command)
    if(collect){
        results <- system(command, intern=collect)
        results
    } else {
        results <- system(command)
        if(results != 0){stop(sprintf("Command failed. Exit status: %s", results))}
    }
}

#' The caller function that will live inside of factory function
#'
#' @param base_command a shell command
#' @param giftwrap_collect a logical if the output of the shell command should be captured in R
#' @param ... named and unnamed arguments to be giftwrapped
#' @return messages from the running command, errors if failure
giftwrap <- function(base_command, ..., giftwrap_collect=F){
    command <- giftwrap_command(base_command, ...)
    run_command(command, collect=giftwrap_collect)
}

#' giftwrap factory function
#' @importFrom utils capture.output
#' @param command the shell command to be converted into an R function
#' @param env the environment in which the function should be created
#' @param base_remove remove the base from the function name by adding the base name here
#' @return A function exported to the specified environment
#' @export
create_giftwrap <-function(command, env, base_remove=NULL){
    if(class(env) != "environment"){
        stop("Please pass an environment to the env arugment.")
    }
    function_name <- gsub("[- ]+", "_", command)
    if(!is.null(base_remove)){
        function_name <- gsub(paste(paste0("^", paste0(base_remove, "_")), collapse = "|"), "", function_name)
    }
    fun <- eval(parse(text = paste0("function(..., giftwrap_collect=F){\n\tgiftwrap('", command,"', ..., giftwrap_collect=giftwrap_collect)\n}")))
    assign(function_name, fun, pos = env)
    if(grepl("namespace", capture.output(env))){
        namespaceExport(env, function_name)
    }
}

#' Load a functions from a lexicon into an environment
#' @param lexicon a dataframe containing columns for base, command, subcommand, and giftwrap_command (the full command)
#' @param commands regex filtering for any commands in the lexicon
#' @param subcommands regex filtering for any subcommands in the lexicon
#' @param drop_base drop the base-level command from the caller function
#' @param env the environment into which the giftwrap functions should be exported
#' @return Functions exported to the specified environment
#' @export
load_lexicon <-function(lexicon, commands=NULL, subcommands=NULL, drop_base=F, env){
    check_lexicon(lexicon)
    force(create_giftwrap)
    if(!is.null(commands)){
        lexicon <- lexicon[grep(paste(commands, collapse = "|"), lexicon$command), ]
    }
    if(!is.null(subcommands)){
        lexicon <- lexicon[grep(paste(subcommands, collapse = "|"), lexicon$subcommand), ]
    }
    # boo hoo a for loop
    if(drop_base){
        for(giftwrap_command in unique(lexicon$giftwrap_command)){
            create_giftwrap(giftwrap_command, env, base_remove = unique(lexicon$base))
        }
    } else {
        for(giftwrap_command in unique(lexicon$giftwrap_command)){
            create_giftwrap(giftwrap_command, env)
        }
    } 
}
