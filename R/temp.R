#' Write an object to a temporary file
#' 
#' Write an object to a temporary CSV, RDS, or raw text file, and return
#' the path to that file. This can be used, for example, as an argument to a
#' giftwrapped function.
#' 
#' @importFrom readr write_csv
#' 
#' @param x An object
#' @param ... Extra arguments passed to the relevant writing function (such as
#' \code{\link[readr]{write_csv}} for \code{temp_csv})
#' 
#' @return A string with the temporary filename containing the output. This will
#' be in the temporary per-session directory.
#' 
#' @seealso \link{tempfile}
#'
#' @name temporary
#'
#' @examples 
#' 
#' wrap_commands("cat")
#' 
#' cat(temp_csv(mtcars))
#' 
#' @export
temp_csv <- function(x, ...) {
  temp_write(x, readr::write_csv, ...)
}

#' @rdname temporary
#' @importFrom readr write_rds
#' @export
temp_rds <- function(x, ...) {
  temp_write(x, readr::write_rds, ...)
}

#' @rdname temporary
#' @importFrom readr write_lines
#' @export
temp_lines <- function(x, ...) {
  temp_write(x, readr::write_lines, ...)
}

# Internal utility
temp_write <- function(x, writer, ...) {
  tmp <- tempfile()
  writer(x, tmp, ...)
  tmp
}
