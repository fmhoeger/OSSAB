correct_answers <- list("PAT" = "D", "PFT" = "A", "SRT" = "A")

practice <- function(label, language, num_of_examples) {
  unlist(lapply(1:num_of_examples, practice_and_feedback_pages, label=label, language=language))
}

practice_and_feedback_pages <- function(label, language, item_number) {
  list(
    practice_page(label, language, item_number),
    psychTestR::reactive_page(function(answer, ...) {
      practice_feedback_page(label, language, item_number, answer)
    })
  )
}

practice_page <- function(label, language, item_number) {
  Item(label = label,
       language = language,
       item_prefix = "p",
       item_number = item_number,
       choices = if (label == "MRT") { c("A", "B", "C") } else { c("A", "B", "C", "D", "E") },
       prompt = psychTestR::i18n(sprintf("%s_PRACTICE_QUESTION_%d", label, item_number)),
       button_text = psychTestR::i18n("SHOW_ANSWER"),
       save_answer = FALSE)
}

practice_feedback_page <- function(label, language, item_number, answer) {
  item_id <- sprintf("p%d", item_number)
  prompt <- psychTestR::i18n(sprintf("%s_PRACTICE_FEEDBACK_%d", label, item_number))
  # correctness_text <- if (answer == correct_answers[label]) { "CORRECT" } else { "INCORRECT" }

  ui <- shiny::div(
    tagify(prompt),
    # shiny::div(psychTestR::i18n(correctness_text), style = "font-weight: bold;"),
    if (label %in% c("PAT", "PFT", "SRT")) shiny::tags$img(id = item_id, src = sprintf("www/images/%s/%s/%s/%s_choice_%s.png", label, language, item_id, item_id, correct_answers[label]), style = "margin-top: 10px; margin-bottom: 15px; width: 106px;"),
    shiny::p(psychTestR::trigger_button("back", psychTestR::i18n("BACK"), style = "width: 100px; margin-top: 15px"), psychTestR::trigger_button("next", psychTestR::i18n("CONTINUE"), style = "width: 100px; margin-top: 15px"))
  )

  psychTestR::page(ui = ui,
                   label = label,
                   get_answer = function(input, ...) { input$last_btn_pressed },
                   on_complete = function(state, answer, ...) {
                     psychTestR::set_local("do_intro", identical(answer, "back"), state)
                   })
}
