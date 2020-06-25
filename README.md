# giftwrap

<!-- badges: start -->
![R-CMD-check](https://github.com/chriscardillo/giftwrap/workflows/R-CMD-check/badge.svg)
<!-- badges: end -->

## Overview

`giftwrap` takes shell commands and turns them into R functions. This enables R developers to immediately work with command lines tools like AWS CLI, Salesforce DX, Docker, git, and more.

If you have the AWS CLI [installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) on your machine, you can install giftwrap and list your S3 buckets:

```r
devtools::install_github("chriscardillo/giftwrap")
library(giftwrap)

wrap_commands("aws s3 ls")
aws_s3_ls()
```

Or, if you have Docker [installed](https://docs.docker.com/get-docker/) on your machine, you can list your running containers.

This time, we'll store our giftwrapped function in its own namespace that giftwrap creates. We'll call the namespace `gifts`.

```r
wrap_commands("docker ps", use_namespace = "gifts")
gifts::docker_ps()
```

And we can add our S3 function to that same namespace. Notice how `wrap commands` can handle multiple commands.

```r
wrap_commands(c("aws s3 ls", "docker ps"), use_namespace = "gifts")
gifts::aws_s3_ls()
```

The resulting giftwrapped functions can take any number of named or unnamed arguments, and will add those arguments to the command when the function is called. **You can wrap any command available in your shell.**

To enable a fast and standalone loading of commands, giftwrap employs the use of **lexicons**, such as `lexicon_aws` or `lexicon_docker`.

The `wrap_lexicon` function takes a lexicon, accepts filtering for commands/subcommands, and has helpful options for where the resulting functions will live and what they will look like.

Let's wrap the [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) lexicon.

```r
wrap_lexicon(lexicon_git,
             use_namespace = "git",
             commands = c("status", "reset"),
             drop_base = T)
git::status()
git::reset("origin/master")
```

`commands` and `subcommands` arguments accept regex, and `drop_base` removes the base 'git' from the R function. There is also an `env` argument to specify an environment, instead of using `use_namespace`.

-----

## Other Useful Features

#### Capture Output

You can capture the status, stdout, and stderr from your call to the shell using variable assignment.

```r
wrap_commands("echo")
output <- echo("hello world")
output$status
output$stdout
```

#### Current Lexicons

###### Lexicons

giftwrap currently comes with the following lexicons:

  - `lexicon_aws` - [Amazon Web Services Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  - `lexicon_docker` - [Docker](https://docs.docker.com/get-started/#download-and-install-docker-desktop)
  - `lexicon_git` - [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - `lexicon_heroku` - [Heroku](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
  - `lexicon_sfdx_force` - [Salesforce DX](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)

#### Making your own lexicon

Using `lexicon_aws` as an example, each lexicon contain columns for:

  - **base:**  the base command, which is always the same (in this case, 'aws')
  - **command:** the command after base (in this case, a service like 's3')
  - **subcommand:** the subcommand associated with the command (in this case, an s3 action like 'ls' or 'cp')
  - **giftwrap_command:** the full command to be called by the giftwrapped function

If you follow the format of an existing lexicon, you will likely be able to use `wrap_lexicon` with any command line tool of your choosing.

Note that all of the functionality in `wrap_lexicon` is identical to that of `wrap_commands`. `wrap_lexicon` just works with a dataframe, formatted as previously discussed. The hope is that `wrap_lexicon` will allow you to keep your command line commands organized, accessible, and reproducible.

#### Adding giftwrap functions to packages

If you are familiar with creating R packages, you may know you can specify actions to be taken when the package is loaded using the `.onLoad` function, in a file typically called `zzz.R` in the R folder of your package directory.

The following is a short code snippet you may place in `zzz.R` that allows you to load in giftwrapped functions from the aws lexicon into your package, accessible for your package users.

```r
#' Generates functions on load
#' @importFrom giftwrap wrap_lexicon
.onLoad <- function(libname, pkgname) {
    giftwrap::wrap_lexicon(giftwrap::lexicon_aws,
                           commands = "s3$|ec2$",
                           subcommands = "^ls$|^cp$|^describe-instances$",
                           use_namespace = "yourpackagenamehere",
                           drop_base = T)
}
```

Alternatively, if you only want your giftwrapped functions to be available to your package and not directly to the user, you can leverage environment caching instead.

```r
#' Generates functions on load
#' @importFrom giftwrap wrap_lexicon
.onLoad <- function(libname, pkgname) {
    aws <- new.env()
    giftwrap::wrap_lexicon(giftwrap::lexicon_aws,
                           commands = "s3$|ec2$",
                           subcommands = "^ls$|^cp$|^describe-instances$",
                           env = aws,
                           drop_base = T)
    assign("aws", aws, pos = parent.env(environment()))
}
```

Now your package can access a command like `aws s3 ls` with the syntax `aws$s3_ls()`, and you are free to develop on top of the giftwrapped function as you like.

-----

Happy giftwrapping!
