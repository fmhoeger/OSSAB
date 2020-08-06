#' OSSAB battery
#'
#' This function defines the OSSAB battery.
#' Use this function if you want to create a battery of tests.
#' @param title (Character scalar) Title of the test battery to be displayed at the top of the page.
#' @param tests (Vector of test functions) The tests to be included in the battery.
#' Possible values are MRT, PAT, PFT, and SRT.
#' Example: \code{OSSAB(tests = c(MRT, PFT), languages = "en")}.
#' Defaults to \code{c(MRT, PAT, PFT, SRT)}.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param dict (i18n_dict) The psyquest dictionary used for internationalisation.
#' @param admin_password (Character scalar) Password to access the admin panel.
#' @param researcher_email (Character scalar) Researcher's email; used in participant help message.
#' @param with_practice (Logical scalar) Whether to include the training phase.
#' Defaults to TRUE.
#' @param with_feedback (Logical scalar) Whether to display a feedback page.
#' Defaults to TRUE.
#' @param validate_id (Character scalar or closure) Function for validating IDs or string "auto"
#' for default validation which means ID should consist only of alphanumeric characters.
#' @param ... Further arguments to be passed to \code{\link{OSSAB}()}.
#' @export
OSSAB <- function(title = "",
                  tests = c(MRT, PAT, PFT, SRT),
                  languages = OSSAB::languages,
                  dict = OSSAB::OSSAB_dict,
                  admin_password = "sirius",
                  researcher_email = "tsigeman.es@talantiuspeh.ru or lihanov.mv@talantiuspeh.ru",
                  with_practice = TRUE,
                  with_feedback = TRUE,
                  validate_id = "auto",
                  ...) {
  tests <- tests %>% purrr::map(function(test_module) {
    test_module(languages = languages[[1]])
  })

  elts <- c(register_participant(validate_id, dict))
  elts <- append(elts, tests)
  elts <- append(elts, total_scoring())
  elts <- append(elts, c(psychTestR::elt_save_results_to_disk(complete = TRUE)))
  elts <- append(elts, if (with_feedback) feedback_page())
  elts <- append(elts,
    c(psychTestR::new_timeline(
      psychTestR::final_page(shiny::p(
        psychTestR::i18n("RESULTS_SAVED"),
        psychTestR::i18n("CLOSE_BROWSER"))
      ), dict = dict
    ))
  )

  shiny::addResourcePath("www", system.file("www", package = "OSSAB"))
  psychTestR::make_test(
    elts,
    opt = psychTestR::test_options(
      title = dict$translate("BATTERY_TITLE", languages[[1]]),
      admin_password = admin_password,
      researcher_email = researcher_email,
      demo = FALSE,
      languages = languages
    )
  )
}

total_scoring <- function() {
  psychTestR::code_block(function(state, ...) {
    results <- psychTestR::get_results(state = state, complete = FALSE)
    score <- 0

    for (label in names(results)) {
      num_of_items <- if (label == "MRT") { 16 } else { 15 }
      score <- score + results[[label]][["score"]] / num_of_items * 100
    }

    psychTestR::save_result(place = state,
                            label = "total_score",
                            value = score / length(names(results)))
  })
}

register_participant <- function(validate_id, dict) {
  psychTestR::new_timeline(
    psychTestR::get_p_id(
      prompt = psychTestR::i18n("ENTER_ID"),
      placeholder = paste(psychTestR::i18n("E.G."), "10492817"),
      button_text = psychTestR::i18n("CONTINUE"),
      validate = validate_p_id(validate_id)
    ),
    dict = dict
  )
}
