messagef <- function(...) message(sprintf(...))
printf <- function(...) print(sprintf(...))

is.scalar.character <- function(x) {
  is.character(x) && is.scalar(x)
}

is.scalar.numeric <- function(x) {
  is.numeric(x) && is.scalar(x)
}

is.scalar.logical <- function(x) {
  is.logical(x) && is.scalar(x)
}

is.scalar <- function(x) {
  identical(length(x), 1L)
}

tagify <- function(x) {
  stopifnot(is.character(x) || is(x, "shiny.tag"))
  if (is.character(x)) {
    stopifnot(is.scalar(x))
    shiny::p(x)
  } else x
}

is.null.or <- function(x, f) {
  is.null(x) || f(x)
}

# p_id validation
validate_p_id <- function(validate) {
  if (is.function(validate)) {
    validate
  } else if (identical(validate, "auto")) {
    function(answer, ...) {
      if (is_p_id_valid(answer)) TRUE else describe_valid_p_id()
    }
  } else stop("Unrecognised validation method.")
}

is_p_id_valid <- function(p_id) {
  stopifnot(is.scalar.character(p_id))
  n <- nchar(p_id)
  n > 0L && n <= 100L
}

describe_valid_p_id <- function() {
  paste0(
    "Participant IDs must be between 1 and 100 characters long.")
}
