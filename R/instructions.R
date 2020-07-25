instructions_page <- function(label, language, style = "text-align: center; margin-left: 10%; margin-right: 10%; margin-bottom: 20px;") {
  ui <- shiny::div(
    shiny::div(psychTestR::i18n(sprintf("%s_INSTRUCTIONS", label), html = TRUE)),
    if (label == "PFT") shiny::tags$img(src = sprintf("www/images/%s/%s/example.png", label, language), style = "margin-top: 10px; width: 100%; height: auto;"),
    if (label == "PFT") shiny::tags$img(src = sprintf("www/images/%s/shared/example_folding.png", label), style = "margin-top: 10px; margin-bottom: 20px; width: 100%; height: auto;"),
    shiny::p(psychTestR::trigger_button("next", psychTestR::i18n("CONTINUE"), style = "margin-top: 15px"))
  )

  psychTestR::page(ui = ui, label = label)
}

instructions <- function(label, language = "shared") {
  c(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_intro", TRUE, state)
    }),
    psychTestR::while_loop(
      test = function(state, ...) psychTestR::get_local("do_intro", state),
      logic = c(
        instructions_page(label, language),
        practice(label, language, 1)
      )
    )
  )
}
