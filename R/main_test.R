main_test <- function(label, item_bank, language = "shared", timeout_in_msec = 0) {
  key <- NULL
  elts <- c()
  keys <- item_bank %>% pull(key)
  item_numbers <- as.numeric(gsub("[^0-9]", "", keys))

  for (item_number in item_numbers) {
    choices <- strsplit(item_bank[item_bank$key == paste0("i", item_number), "choices"], ",")[[1]]

    item_page <- Item(label = label,
                      language = language,
                      item_prefix = "i",
                      item_number = item_number,
                      choices = choices,
                      prompt = psychTestR::i18n(sprintf("%s_QUESTION_%d", label, item_number), html = TRUE),
                      button_text = psychTestR::i18n("NEXT"),
                      timeout_in_msec = timeout_in_msec,
                      save_answer = TRUE)
    elts <- psychTestR::join(elts, item_page)
  }

  psychTestR::join(psychTestR::begin_module(label = label),
                   elts,
                   scoring(label, item_bank),
                   psychTestR::elt_save_results_to_disk(complete = TRUE),
                   psychTestR::end_module())
}

scoring <- function(label, item_bank) {
  correct_answer <- NULL
  correct_answers <- item_bank %>% pull(correct_answer)
  sum_correct_answers <- 0

  psychTestR::code_block(function(state, ...) {
    results <- psychTestR::get_results(state = state, complete = FALSE)
    scores_raw <- purrr::map(results, function(result) {
      result <- get(label, results)
      result
    })[[1]]

    scores <- purrr::map_dbl(1:length(scores_raw), function(i) {
      if (scores_raw[i] == correct_answers[i]) { 1 } else { 0 }
    })

    psychTestR::save_result(place = state,
                            label = "score",
                            value = sum(scores))
  })
}

get_prompt <- function(item_number, num_items) {
  shiny::div(
    paste(psychTestR::i18n(
      "PAGE_HEADER",
      sub = list(num_question = item_number,
                 num_items = if (is.null(num_items))
                   "?" else
                     num_items)), paste0("(", item_number, "/", num_items, ")")),
    shiny::p(
      psychTestR::i18n("PROMPT"),
      style = "font-weight: normal;"),
    style = "text-align: center; margin-bottom: 20px;"
  )
}
