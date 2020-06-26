#' For fetching a giftwrap lexicon
#' @param lexicon The name of a giftwrap lexicon
#' @return a dataframe of lexicon
#' @export
lexicon <- function(lexicon){
  check_lexicon_name(lexicon)
  get(paste0("lexicon_", lexicon))
}
