# giftwrap

<!-- badges: start -->
![R-CMD-check](https://github.com/chriscardillo/giftwrap/workflows/R-CMD-check/badge.svg)
<!-- badges: end -->

## Overview
`giftwrap` is a lightweight package for wrapping shell commands in R, allowing R developers to interface with command line tools from services like AWS, Salesforce, Docker, git, and more. Here's how it works: 

First, `wrap_commands` helps us wrap a shell command. Here we will wrap `echo`.

```r
wrap_commands("echo", env = globalenv())
```

giftwrap takes the shell command and turns it into an R function in your global environment. Now you can use the `echo` function to execute the shell command.

```r
echo("hello world")
```

You can capture the status, stdout, and stderr from your call to the shell using variable assignment.

```r
output <- echo("hello world")
output$status
output$stdout
```

Below covers how to utilize giftwrap with some more popular command line tools.

-----

## Installing the Package

giftwrap is not currently available on CRAN.

```r
devtools::install_github("chriscardillo/giftwrap")
library(giftwrap)
```

## Loading a lexicon

To help kickstart your deveopment, giftwrap contains **lexicons**. Lexicons are dataframes containing information about different command line tools. For instance the lexicon `lexicon_aws` contains over 7,000 commands available in the AWS CLI. 

giftwrap's `load_lexicon` function is designed to help you create a subset of commands to wrap. Here is a code chunk that loads all of the AWS CLI's `s3` commands into a dediacated namespace called "aws":

```r
library(giftwrap)

wrap_lexicon(lexicon_aws,
             commands = "s3$",
             use_namespace = "aws",
             drop_base = T)
```

Now, you can use any of these AWS CLI commands in R using the following syntax:

```r
aws::s3_ls("your-s3-bucket-name-here")
```

`wrap_lexicon` accepts regex for `commands` and `subcommands`.

**Please note that giftwrapped functions will only work if you have the corresponding command line tool installed on your machine.**

## Current lexicons

giftwrap currently comes with the following lexicons:

  - `lexicon_aws` - <a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html" target="_blank">Amazon Web Services Command Line Interface</a>
  - `lexicon_docker` - <a href="https://docs.docker.com/get-started/" target="_blank">Docker</a>
  - `lexicon_git` - <a href="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git" target="_blank">git</a>
  - `lexicon_sfdx_force` - <a href="https://developer.salesforce.com/blogs/2018/02/getting-started-salesforce-dx-part-3-5.html" target="_blank">Salesforce CLI (Developer Tools)</a>

Using `lexicon_aws` as an example, each lexicon contain columns for:

  - **base:**  the base command, which is always the same (in this case, 'aws')
  - **command:** the command after base (in this case, a service like 's3')
  - **subcommand:** the subcommand associated with the command (in this case, an s3 action like 'ls' or 'cp')
  - **giftwrap_command:** the full command to be called by the giftwrap function

If you follow the format of an existing lexicon, you will likely be able to use `wrap_lexicon` with any command line tool of your choosing.

Note that all of the functionality in `wrap_lexicon` is identical to that of `wrap_commands`. `wrap_lexicon` just works with a dataframe, formatted as previously discussed. The hope is that `wrap_lexicon` will allow you to keep your command line commands organized, accessible, and reproducible.

## Adding giftwrap functions to packages

If you are familiar with creating R packages, you may know you can specify actions to be taken when the package is loaded using the `.onLoad` function, in a file typically called `zzz.R` in the R folder of your package directory.

The following is a short code snippet you may place in `zzz.R` that allows you to load in giftwrapped functions from the aws lexicon.

```r
#' Generates functions on load
#' @importFrom rlang env_parents
#' @importFrom giftwrap wrap_lexicon
.onLoad <- function(libname, pkgname) {
    ns_package <- rlang::env_parents()[[1]]
    giftwrap::wrap_lexicon(giftwrap::lexicon_aws,
                           commands = "s3$",
                           subcommands = "^ls$|^cp$|^describe-instances$",
                           env = ns_package,
                           drop_base = T)
}
```
-----

Happy giftwrapping!
