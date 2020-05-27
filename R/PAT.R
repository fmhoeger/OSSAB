#' PAT
#'
#' This function defines a PAT module for incorporation into a
#' psychTestR timeline.
#' Use this function if you want to include the PAT in a
#' battery of other tests, or if you want to add custom psychTestR
#' pages to your test timeline.
#' For a standalone implementation of the PAT,
#' consider using \code{\link{PAT_standalone}()}.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the PAT.
#' @param timeout_in_msec Time in milliseconds until images of a test item disappear.
#' Defaults to 20000.
#' @param with_practice (Logical scalar) Whether to include the training phase.
#' Defaults to TRUE.
#' @param with_feedback (Logical scalar) Whether to display a feedback page.
#' Defaults to FALSE.
#' @param label (Character scalar) Label to give the PAT results in the output file.
#' @export
PAT <- function(dict,
                item_bank,
                timeout_in_msec = 20000,
                with_practice = TRUE,
                with_feedback = FALSE,
                label = "PAT") {

  stopifnot(purrr::is_scalar_character(label),
            purrr::is_scalar_logical(with_practice))

  psychTestR::join(
    if (with_practice) psychTestR::new_timeline(instructions(label), dict = dict),
    psychTestR::new_timeline(
      main_test(label = label,
                item_bank = item_bank,
                timeout_in_msec = timeout_in_msec),
      dict = dict),
    if (with_feedback) feedback_with_graph("PAT", dict)
  )
}
