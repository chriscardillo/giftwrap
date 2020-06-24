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
"lexicon_aws"

#' A giftwrap-formatted lexicon of all git commands
#'
#' A dataset containing all base, commands, and subcommands from git
#'
#' @format A dataset containing all base, commands, and subcommands from git
#' \describe{
#'   \item{base}{the base, always git}
#'   \item{command}{the command, such as init, pull, or status}
#'   \item{subcommand}{NA for git lexicon}
#'   \item{giftwrap_command}{the base, command, and subcommand together}
#'   ...
#' }
#' @source made by scraping git help docs
"lexicon_git"

#' A giftwrap-formatted lexicon of all docker commands
#'
#' A dataset containing all base, commands, and subcommands from docker
#'
#' @format A dataset containing all base, commands, and subcommands from docker
#' \describe{
#'   \item{base}{the base, always docker}
#'   \item{command}{the command/service, such as ps or image}
#'   \item{subcommand}{the subcommand for the command/service, such as ls}
#'   \item{giftwrap_command}{the base, command, and subcommand together}
#'   ...
#' }
#' @source made by scraping docker help docs
"lexicon_docker"

#' A giftwrap-formatted lexicon of all Salesforce developer tools (sfdx force) commands
#'
#' A dataset containing all base, commands, and subcommands from Salesforce developer tools (sfdx force)
#'
#' @format A dataset containing all base, commands, and subcommands from Salesforce developer tools (sfdx force)
#' \describe{
#'   \item{base}{the base, always 'sfdc force'}
#'   \item{command}{the command/service, such as data}
#'   \item{subcommand}{the subcommand for the command/service, such as bulk:upsert}
#'   \item{giftwrap_command}{the base, command, and subcommand together, specially formatted for sfdx}
#'   ...
#' }
#' @source made by scraping docker help docs
"lexicon_sfdx_force"
