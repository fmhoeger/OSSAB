#' PFT
#'
#' This function defines a PFT module for incorporation into a
#' psychTestR timeline.
#' Use this function if you want to include the PFT in a
#' battery of other tests, or if you want to add custom psychTestR
#' pages to your test timeline.
#' For a standalone implementation of the PFT,
#' consider using \code{\link{PFT_standalone}()}.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the PFT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param timeout_in_msec Time in milliseconds until images of a test item disappear.
#' Defaults to 20000.
#' @param with_practice (Logical scalar) Whether to include the training phase.
#' Defaults to TRUE.
#' @param with_feedback (Logical scalar) Whether to display a feedback page.
#' Defaults to FALSE.
#' @param label (Character scalar) Label to give the PFT results in the output file.
#' @export
PFT <- function(dict = OSSAB::OSSAB_dict,
                item_bank = OSSAB::PFT_item_bank,
                languages = c("ru", "en"),
                timeout_in_msec = 20000,
                with_practice = TRUE,
                with_feedback = FALSE,
                label = "PFT") {
  stopifnot(purrr::is_scalar_character(label),
            purrr::is_scalar_logical(with_practice))

  psychTestR::join(
    if (with_practice) psychTestR::new_timeline(instructions(label, languages[1]), dict = dict),
    psychTestR::new_timeline(
      main_test(label = label,
                item_bank = item_bank,
                timeout_in_msec = timeout_in_msec),
      dict = dict),
    if (with_feedback) feedback_with_graph("PFT", dict)
  )
}
