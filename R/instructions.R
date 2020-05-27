instructions_page <- function(key, label, style = "text-align: center; margin-left: 10%; margin-right: 10%; margin-bottom: 20px;") {
  ui <- shiny::div(
    shiny::div(psychTestR::i18n(key, html = TRUE)),
    if (label == "PFT") shiny::tags$img(src = sprintf("www/images/%s/example.png", label), style = "margin-top: 10px; width: 468px; display: block;"),
    if (label == "PFT") shiny::tags$img(src = sprintf("www/images/%s/example_folding.png", label), style = "margin-top: 10px; margin-bottom: 20px; width: 468px; display: block;"),
    shiny::p(psychTestR::trigger_button("next", psychTestR::i18n("CONTINUE"), style = "margin-top: 15px"))
  )

  psychTestR::page(ui = ui, label = label)
}

instructions <- function(label) {
  c(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_intro", TRUE, state)
    }),
    psychTestR::while_loop(
      test = function(state, ...) psychTestR::get_local("do_intro", state),
      logic = c(
        instructions_page("INSTRUCTIONS", label),
        practice(label, 1)
      )
    )
  )
}
