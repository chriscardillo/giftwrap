#' Create an argument with shell formatting
#'
#' @param x the argument to be passed to the shell command. Both named arguments and unnamed arguments work. A list is expected.
#' @return a shell-formatted argument
format_arg <- function(x){
    if(class(x) != "list"){
        stop("x should be of class list.")
    }
    name <- NULL
    arg <- suppressWarnings({if(nchar(x[[1]])>0){x[[1]]}else{NULL}})
    if(!is.null(names(x)) && names(x) != ""){
        name <- ifelse(nchar(names(x)) == 1, sprintf("-%s", names(x)), sprintf("--%s", names(x)))
    }
    c(name, arg)
}

#' format multiple arguments
#'
#' @param ... named and unnamed arguments to be formatted
#' @return a vector of properly formatted arguments
format_args <- function(...){
    args <- list(...)
    args_formatted <- list()
    # boo hoo a for loop
    if(length(args) > 0){
        for(i in 1:length(args)){
            if(!is.null(args[[i]])){
                args_formatted[[i]] <- format_arg(args[i])
            }
        }
    }
    unlist(args_formatted)
}

#' The caller function that will live inside of factory function
#'
#' @importFrom processx run
#' @param command a shell command
#' @param ... named and unnamed arguments to be giftwrapped
#' @return messages from the running command, errors if failure
giftwrap <- function(command, ...){
    full_command <- unlist(strsplit(trimws(command), " "))
    base_command <- full_command[1]
    subcommands <- full_command[!full_command %in% base_command]
    args <- format_args(...)
    px_run_args <- c(subcommands, args)
    invisible(processx::run(command = base_command, args = px_run_args, echo_cmd = T, echo = T))
}

#' To convert shell commands into giftwrapped functions
#' @importFrom utils capture.output
#' @param ... shell commands to be turned into giftwrapped functions
#' @param env the environment in which the function should be created
#' @param base_remove remove the base from the function name by adding the base name here
#' @return A function or functions exported to the specified environment
#' @export
wrap_commands <- function(..., env=parent.frame(), base_remove=NULL){
    if(class(env) != "environment"){
        stop("Please pass an environment to the env arugment.")
    }
    functions <- list(...)
    for(i in 1:length(functions)){
        fun_list <- functions[i]
        command <- fun_list[[1]]
        fun <- eval(parse(text = paste0("function(...){\n\tgiftwrap('", command,"', ...)\n}")))
        fun_name <- gsub("[- ]+", "_", command)
        if(!is.null(names(fun_list)) && names(fun_list) != ""){
            fun_name <- names(fun_list)
        } else if(!is.null(base_remove)){
            fun_name <- gsub(paste(paste0("^", paste0(base_remove, "_")), collapse = "|"), "", fun_name)
        }
        assign(fun_name, fun, pos = env)
        if(grepl("namespace", utils::capture.output(env))){
            namespaceExport(env, fun_name)
        }
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
wrap_lexicon <-function(lexicon, commands=NULL, subcommands=NULL, drop_base=F, env=parent.frame()){
    check_lexicon(lexicon)
    if(!is.null(commands)){
        lexicon <- lexicon[grep(paste(commands, collapse = "|"), lexicon$command), ]
    }
    if(!is.null(subcommands)){
        lexicon <- lexicon[grep(paste(subcommands, collapse = "|"), lexicon$subcommand), ]
    }
    # boo hoo a for loop
    if(drop_base){
        for(giftwrap_command in unique(lexicon$giftwrap_command)){
            wrap_commands(giftwrap_command, env=env, base_remove = unique(lexicon$base))
        }
    } else {
        for(giftwrap_command in unique(lexicon$giftwrap_command)){
            wrap_commands(giftwrap_command, env=env)
        }
    } 
}
