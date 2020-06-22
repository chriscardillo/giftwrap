# giftwrap
`giftwrap` is a lightweight package for wrapping shell commands in R. This allows R developers to immediately interface in R with any command line tool of their choosing. In short, you give giftwrap a shell command and an R environment in which to export that command, and giftwrap creates an R function for that shell command.

Plus, any function created with giftwrap will convert named arguments into shell arguments.

giftwrap employs two functions which we'll cover in more detail below:

- `create_giftwrap` - For wrapping a single shell command into an R function
- `load_lexicon` - For generating multiple R functions out of multiple shell commands

Once a giftwrap function has been generated, users can just call the shell command from R. Messages from the shell will be passed directly to the console, and users even have the option to collect any output from a shell command using the argument `giftwrap_collect = T`.

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
echo("hello world")
```

If we wanted to collect the output of this shell command, we would just add the argument `giftwrap_collect = T`.

```r
echo("hello world", giftwrap_collect = T)
```

## Loading in AWS Functions

**This section assumes you are familiar with [AWS](https://aws.amazon.com/), [CloudFormation](https://aws.amazon.com/cloudformation/), and have the AWS CLI [installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) on your local machine.**

As mentioned, giftwrap ships with a lexicon of the 7,000+ available AWS CLI functions, a data frame called `aws`. I'd recommend against loading them all. Fortunately, you have two options for loading your desired functions:

1) Simply use your favorite data manipulation tool (most likely `dplyr`) to filter for the AWS CLI commands you wish to load, and pass the filtered lexicon to `load_lexicon`.

2) `load_lexicon` has `commands` and `subcommands` arguments that accept regex, so you can filter for commands and subcommands directly in your call to `load_lexicon`.

Let's take advantage of the `commands` and `subcommands` arguments to filter for just a handful of AWS EC2 and S3 commands. Also note we are specifying a global environment, and we will drop the base ('aws') from the R functions generated using `drop_base = T`.

```r
load_lexicon(aws,
             commands = c("s3$", "ec2$"),
             subcommands = c("^ls$", "^cp$", "^describe-instances$"),
             env = globalenv(),
             drop_base = T)
```

You should now have a few AWS functions, like `s3_ls` in your global R environment. You can run the command `s3_ls("help")` to get the AWS CLI help page for this command, or any others. Otherwise, you can now just pass in your arguments and use the AWS CLI from R.

## Making Your Own Lexicon

Here is a quick example of creating a small lexicon for [docker](http://docker.io/).

```r
library(giftwrap)
library(tidyverse)

tibble(base = "docker",
       command = "image",
       subcommand = c("ls", "build"),
       giftwrap_command = paste(base, command, subcommand)) %>%
  load_lexicon(env = globalenv())
```

Now you have a few docker commands in your R global environment!

## Adding giftwrap Functions to Packages

If you are familiar with creating R packages, you may know you can specify actions to be taken when the package is loaded using the `.onLoad` function, in a file typically called `zzz.R` in the R folder of your package directory.

The following is a short code snippet you may place in `zzz.R` that allows you to load in giftwrapped functions from the aws lexicon.

```r
#' Generates functions on load
#' @importFrom rlang env_parents
#' @importFrom giftwrap load_lexicon aws
.onLoad <- function(libname, pkgname) {
    ns_package <- rlang::env_parents()[[1]]
    giftwrap::load_lexicon(giftwrap::aws,
                           commands = c("s3$"),
                           env = ns_package,
                           drop_base = T)
}
```

## Useful Environment Tip: Session Namespaces

It can be annoying to have too many functions floating around your global environment, but fortunately you can utilize giftwrap alongside the `namespace` package to confine your giftwrapped functions to a local namespace. 

Here is a small code snippet using the `namespace` package (available on CRAN) and giftwrap's aws lexicon to get you started:

```r
library(giftwrap)
library(namespace)

local_cli <- makeNamespace("local_cli")

load_lexicon(aws,
             commands = c("s3$", "ec2$"),
             subcommands = c("^ls$", "^cp$", "^describe-instances$"),
             env = local_cli,
             drop_base = T)

local_cli::s3_ls("help")
```

-----

Happy giftwrapping!
