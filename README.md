# giftwrap
`giftwrap` is a lightweight package for wrapping shell commands in R. This allows R developers to immediately interface in R with any command line tool of their choosing. In short, you give giftwrap a shell command and an R environment in which to export that command, and giftwrap creates an R function for that shell command.

Plus, any function created with giftwrap will convert named arguments into shell arguments.

giftwrap employs two functions which we'll cover in more detail below:

- `create_giftwrap` - For wrapping a single shell command into an R function
- `load_lexicon` - For generating multiple R functions out of multiple shell commands

Once a giftwrap function has been generated, users can just call the shell command from R. Messages from the shell will be passed directly to the console. All output from the command, such as status and stdout, can be captured by saving the giftwrapped function's output to a variable.

Please see below from some examples and use cases. Note that giftwrap ships with a lexicon for the AWS CLI, and it is very easy to make your own lexicon for your favorite command line tools.

-----

## Installing the Package

giftwrap is not currently available on CRAN.

```r
devtools::install_github("chriscardillo/giftwrap")
library(giftwrap)
```

## Hello World

To illustrate how the pacakge works, we'll create a giftwrap for our shell's `echo` command, and export this command into R's global environment.

```r
create_giftwrap(command = "echo", env = globalenv())
```

Now our shell's `echo` command is available for us to use in R.

```r
echo("hello world")
```

If we wanted to collect the output of this shell command, we would just save the output to a variable.

```r
command_output <- echo("hello world")
```

Now, we have can access different outputs, such as status and stdout from the command using `command_output$status` or `command_output$stdout`, respectively.

## Loading in AWS functions

**This section assumes you are familiar with [AWS](https://aws.amazon.com/) and have the AWS CLI [installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) on your local machine.**

As mentioned, giftwrap ships with a lexicon of the 7,000+ available AWS CLI functions, a data frame called `lexicon_aws`. I'd recommend against loading them all. Fortunately, you have two options for loading your desired functions:

1) Simply use your favorite data manipulation tool (most likely `dplyr`) to filter for the AWS CLI commands you wish to load, and pass the filtered lexicon to `load_lexicon`.

2) `load_lexicon` has `commands` and `subcommands` arguments that accept regex, so you can filter for commands and subcommands directly in your call to `load_lexicon`.

Let's take advantage of the `commands` and `subcommands` arguments to filter for just a handful of AWS EC2 and S3 commands. Also note we are specifying a global environment, and we will drop the base ('aws') from the R functions generated using `drop_base = T`.

```r
library(giftwrap)

load_lexicon(lexicon_aws,
             commands = c("s3$", "ec2$"),
             subcommands = c("^ls$", "^cp$", "^describe-instances$"),
             env = globalenv(),
             drop_base = T)
```

You should now have a few AWS functions, like `s3_ls` in your global R environment. You can run the command `s3_ls("help")` to get the AWS CLI help page for this command, or any others. Otherwise, you can now just pass in your arguments and use the AWS CLI from R.

## Making your own lexicon

Here is a quick example of creating a small lexicon for [docker](http://docker.io/), which we assume you have [installed](https://docs.docker.com/get-docker/).

```r
library(giftwrap)
library(dplyr)

tibble(base = "docker",
       command = "image",
       subcommand = c("ls", "build"),
       giftwrap_command = paste(base, command, subcommand)) %>%
  load_lexicon(env = globalenv())
```

Now you have a few docker commands in your R global environment!

## Adding giftwrap functions to packages

If you are familiar with creating R packages, you may know you can specify actions to be taken when the package is loaded using the `.onLoad` function, in a file typically called `zzz.R` in the R folder of your package directory.

The following is a short code snippet you may place in `zzz.R` that allows you to load in giftwrapped functions from the aws lexicon.

```r
#' Generates functions on load
#' @importFrom rlang env_parents
#' @importFrom giftwrap load_lexicon lexicon_aws
.onLoad <- function(libname, pkgname) {
    ns_package <- rlang::env_parents()[[1]]
    giftwrap::load_lexicon(giftwrap::lexicon_aws,
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
  load_lexicon(env = getRegisteredNamespace("docker"),
               drop_base = T)

docker::image_ls()
```

-----

Happy giftwrapping!
