#' A giftwrap-formatted lexicon of all AWS CLI commands
#'
#' A dataset containing all base, commands, and subcommands from the AWS CLI
#'
#' @format A data containing all base, commands, and subcommands from the AWS CLI
#' \describe{
#'   \item{base}{the base, always aws}
#'   \item{command}{the command/service, such as ec2 or s3}
#'   \item{subcommand}{the subcommand for the command/service, such as describe-instances or cp, respectively}
#'   \item{giftwrap_command}{the base, command, and subcommand together}
#'   ...
#' }
#' @source made by scraping AWS CLI help docs
"aws"
