# giftwrap
`giftwrap` is a lightweight package for wrapping shell commands in R, allowing R developers to interface with command line tools from services like AWS, Salesforce, Docker, git, and more. Here's how it works: 

First, `wrap` a shell command. Here we will wrap `echo`.

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

## Loading in functions from AWS

To help kickstart your deveopment, giftwrap comes with a lexicon for the AWS CLI. With over 7,000 functions, as long as you have the AWS CLI [installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) on your local machine, you'll be able to immediately copy things to S3, translate text into different languages, stand up EC2 instances, andy any anything else you can do from the AWS command line.

For filtering, you have two options for loading your desired functions:

1) Simply use your favorite data manipulation tool (most likely `dplyr`) to filter for the AWS CLI commands you wish to load, and pass the filtered lexicon to `wrap_lexicon`.

2) `wrap_lexicon` has `commands` and `subcommands` arguments that accept regex, so you can filter for commands and subcommands directly in your call to `wrap_lexicon`.

Let's take advantage of the `commands` and `subcommands` arguments to filter for just a handful of AWS EC2 and S3 commands. Also note we are specifying a global environment, and we will drop the base ('aws') from the R functions generated using `drop_base = T`.

```r
library(giftwrap)

wrap_lexicon(lexicon_aws,
             commands = c("s3$", "ec2$"),
             subcommands = c("^ls$", "^cp$", "^describe-instances$"),
             env = globalenv(),
             drop_base = T)
```

You should now have a few AWS functions, like `s3_ls` in your global R environment. You can run the command `s3_ls()` to list your s3 buckets. Otherwise, you can now just pass in your arguments and use the AWS CLI from R.

## Making your own lexicon

Here is a quick example of creating a small lexicon for [docker](http://docker.io/), which we assume you have [installed](https://docs.docker.com/get-docker/).

```r
library(giftwrap)
library(dplyr)

tibble(base = "docker",
       command = "image",
       subcommand = c("ls", "build"),
       giftwrap_command = paste(base, command, subcommand)) %>%
  wrap_lexicon(env = globalenv())
```

Now you have a few docker commands in your R global environment!

## Adding giftwrap functions to packages

If you are familiar with creating R packages, you may know you can specify actions to be taken when the package is loaded using the `.onLoad` function, in a file typically called `zzz.R` in the R folder of your package directory.

The following is a short code snippet you may place in `zzz.R` that allows you to load in giftwrapped functions from the aws lexicon.

```r
#' Generates functions on load
#' @importFrom rlang env_parents
#' @importFrom giftwrap wrap_lexicon lexicon_aws
.onLoad <- function(libname, pkgname) {
    ns_package <- rlang::env_parents()[[1]]
    giftwrap::wrap_lexicon(giftwrap::lexicon_aws,
                           commands = c("s3$"),
                           env = ns_package,
                           drop_base = T)
}
```

## Useful Environment Tip: Session Namespaces

It can be annoying to have too many functions floating around your global environment, but fortunately you can utilize giftwrap alongside the `namespace` package to confine your giftwrapped functions to a local namespace within your R session.

Here is a small code snippet using the `namespace` package (available on CRAN) and giftwrap to build on our previous example, but now our giftwrapped functions are accessed from within a local namespace called "docker".

```r
library(giftwrap)
library(dplyr)
library(namespace)

makeNamespace("docker")

tibble(base = "docker",
       command = "image",
       subcommand = c("ls", "build"),
       giftwrap_command = paste(base, command, subcommand)) %>%
  wrap_lexicon(env = getRegisteredNamespace("docker"),
               drop_base = T)

docker::image_ls()
```

-----

Happy giftwrapping!
