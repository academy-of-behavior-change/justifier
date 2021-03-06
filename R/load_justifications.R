#' Load Justifications from a file or multiple files
#'
#' These function load justifications from the YAML fragments
#' in one (`load_justifications`) or multiple files (`load_justifications_dir`).
#'
#' `load_justifications_dir` simply identifies all files and then calls
#' `load_justifications` for each of them. `load_justifications` loads the
#' YAML fragments containing the justifications using
#' [yum::load_yaml_fragments()] and then parses the justifications
#' into a visual representation as a
#' [ggplot2::ggplot] graph and Markdown documents with
#' overviews.
#'
#' @param text,file As `text` or `file`, you can specify a `file` to read with
#' encoding `encoding`, which will then be read using [base::readLines()]. If the
#' argument is named `text`, whether it is the path to an existing file is checked
#' first, and if it is, that file is read. If the argument is named `file`, and it
#' does not point to an existing file, an error is produced (useful if calling
#' from other functions). A `text` should be a character vector where every
#' element is a line of the original source (like provided by [base::readLines()]);
#' although if a character vector of one element *and* including at least one
#' newline character (`\\n`) is provided as `text`, it is split at the newline
#' characters using [base::strsplit()]. Basically, this behavior means that the
#' first argument can be either a character vector or the path to a file; and if
#' you're specifying a file and you want to be certain that an error is thrown if
#' it doesn't exist, make sure to name it `file`.
#' @param path The path containing the files to read.
#' @param extension The extension of the files to read; files with other extensions will
#' be ignored. Multiple extensions can be separated by a pipe (`|`).
#' @param regex Instead of specifing an extension, it's also possible to specify a regular
#' expression; only files matching this regular expression are read. If specified, `regex`
#' takes precedece over `extension`,
#' @param recursive Whether to also process subdirectories (`TRUE`)
#' or not (`FALSE`).
#' @param delimiterRegEx The regular expression used to locate YAML
#' fragments
#' @param justificationContainer The container of the justifications in the YAML
#' fragments. Because only justifications are read that are stored in
#' this container, the files can contain YAML fragments with other data, too,
#' without interfering with the parsing of the justifications.
#' @param ignoreOddDelimiters Whether to throw an error (FALSE) or
#' delete the last delimiter (TRUE) if an odd number of delimiters is
#' encountered.
#' @param encoding The encoding to use when calling [readLines()]. Set to
#' NULL to let [readLines()] guess.
#' @param silent Whether to be silent (TRUE) or informative (FALSE).
# #' @param x The parsed `parsed_dct` object.
# #' @param ... Any other arguments are passed to the print command.
#'
#' @rdname load_justifications
#' @aliases load_justifications load_justifications_dir print.justifications plot.justifications
#'
#' @return An object with the [ggplot2::ggplot] graph stored
#' in `output$graph` and the overview in `output$overview`.
#'
#' @examples
#' exampleMinutes <- "
#'
#' ";
#'
#' load_justifications(text=exampleMinutes);
#'
#' \dontrun{
#' load_justifications_dir(path="A:/some/path");
#' }
#'
#' @export
load_justifications <- function(text,
                                file,
                                delimiterRegEx = "^---$",
                                justificationContainer = "justifier",
                                ignoreOddDelimiters = FALSE,
                                encoding="UTF-8",
                                silent=TRUE) {

  ###--------------------------------------------------------------------------
  ### Load the YAML fragments containing the justifications
  ###--------------------------------------------------------------------------

  if (!missing(file)) {
    justifications <-
      yum::load_yaml_fragments(file=file,
                               delimiterRegEx=delimiterRegEx,
                               select=justificationContainer,
                               ignoreOddDelimiters=ignoreOddDelimiters,
                               encoding=encoding,
                               silent=silent);
  } else if (!missing(text)) {
    justifications <-
      yum::load_yaml_fragments(text=text,
                               delimiterRegEx=delimiterRegEx,
                               select=justificationContainer,
                               ignoreOddDelimiters=ignoreOddDelimiters,
                               encoding=encoding,
                               silent=silent);
  } else {
    stop("Specify either `file` or `text` to load.");
  }

  ###--------------------------------------------------------------------------
  ### Parse justifications and return result
  ###--------------------------------------------------------------------------

  res <-
    parse_justifications(justifications);

  return(res);

}

#' #' @rdname load_justifications
#' #' @method print justifications
#' #' @export
#' print.justifications <- function(x, ...) {
#'   cat("Processed", length(x$intermediate$dctSpecs),
#'       "specifications, containing", nrow(x$intermediate$nodes),
#'       "distinct constructs. Graph and instructions for",
#'       "developing measurement instruments and manipulations and for",
#'       "coding measurement instruments, manipulations, and aspects",
#'       "are now available in the returned object, if you stored it.");
#'   invisible(x);
#' }
#'
#' #' @rdname load_justifications
#' #' @method plot justifications
#' #' @export
#' plot.justifications <- function(x, ...) {
#'   DiagrammeR::render_graph(x$output$basic_graph);
#' }


