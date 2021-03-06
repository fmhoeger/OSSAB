trigger_img_button <- function (label, inputId, item_id, img_src, width, height, margin = height / 10){
  inputId <- htmltools::htmlEscape(inputId, attribute = TRUE)
  style <- sprintf("width: %dpx; height: %dpx; margin: %dpx; background: url('%s'); background-size: %dpx %dpx; background-position: center center;", width, height, 4, img_src, width, height)
  shiny::actionButton(inputId = paste0("button-", inputId),
                      class = paste0(label, "-img-button-", item_id),
                      label = "",
                      style = style,
                      icon = NULL,
                      onclick = "set_choice_value(this)")
}

NAFC_page_with_img <- function(label,
                               language,
                               prompt,
                               item_id,
                               answer_block,
                               button_text,
                               timeout_in_msec = NULL,
                               save_answer = TRUE,
                               get_answer = NULL,
                               response_ui_id = "response_ui",
                               on_complete = NULL,
                               admin_ui = NULL) {
  stopifnot(purrr::is_scalar_character(label))

  question_image_style <- paste0("margin-top: 10px; ", if (label %in% c("MRT", "SRT")) { "width: 256px;" } else { "width: 100%; height: auto;" })
  next_button_display <- if (item_id == "p1") { "block" } else { "none" }
  item_id_with_label <- paste0(label, "-", item_id)

  ui <- shiny::div(
    tagify(prompt),
    shiny::tags$img(id = item_id_with_label, src = sprintf("www/images/%s/%s/%s/%s_question.png", label, language, item_id, item_id), style = question_image_style),
    shiny::div(answer_block, id = response_ui_id, style="width: fit-content;"),
    shiny::p(psychTestR::trigger_button(paste0(label, "-no-id-", item_id), psychTestR::i18n("FORWARD"), style = "display: block; margin-top: 22px;", class = paste(paste0(label, "-forward-button-", item_id), "shiny-bound-input"), enable_after = 86400)),
    shiny::tags$script(shiny::HTML(sprintf("function set_choice_value(elem) { var id = elem.id.split('-')[1]; var forward_buttons = document.getElementsByClassName('%s-forward-button-%s'); var image_buttons = document.getElementsByClassName('%s-img-button-%s'); for (var i=0, len=forward_buttons.length; i<len; i++) { forward_buttons[i].id = id; forward_buttons[i].disabled = false; }; for (var i=0, len=image_buttons.length; i<len; i++) { image_buttons[i].classList.remove('active_button'); }; elem.classList.add('active_button') }", label, item_id, label, item_id))),
    shiny::tags$script(shiny::HTML(sprintf("window.setTimeout(\"var image_buttons = document.getElementsByClassName('%s-img-button-%s'); for (var i=0, len=image_buttons.length; i<len; i++) { image_buttons[i].style.display='none'; } var forward_buttons = document.getElementsByClassName('%s-forward-button-%s'); for (var i=0, len=forward_buttons.length; i<len; i++) { forward_buttons[i].style.display='none'; }\", %d)", label, item_id, label, item_id, timeout_in_msec))),
    shiny::tags$script(shiny::HTML(sprintf("window.setTimeout(\"document.getElementById('%s').style.display='none'; \", %d)", item_id_with_label, timeout_in_msec))),
    shiny::p(psychTestR::trigger_button("next", button_text, class = paste0(label, "-next-", item_id), style = paste0("margin-top: 15px; display: ", next_button_display))),
    shiny::tags$script(shiny::HTML(sprintf("window.setTimeout(\"var next_buttons = document.getElementsByClassName('%s-next-%s'); for (var i=0, len=next_buttons.length; i<len; i++) { next_buttons[i].style.display='block'; } \", %d)", label, item_id, timeout_in_msec))),
    shiny::tags$style(shiny::HTML(".active_button { box-shadow: 2px 2px 2px #111; }"))
  )
  if (is.null(get_answer)) {
    get_answer <- function(input, ...) input$last_btn_pressed
  }
  validate <- function(answer, ...) !is.null(answer)
  psychTestR::page(ui = ui, label = item_id, get_answer = get_answer, save_answer = save_answer,
       validate = validate, on_complete = on_complete, final = FALSE,
       admin_ui = admin_ui)
}

get_answer_button <- function(label,
                              item_prefix,
                              item_number,
                              choice_id,
                              as_image_button = TRUE,
                              width = 80,
                              height = 80,
                              index) {
  item_id <- sprintf("%s%d", item_prefix, item_number)
  img_src <- file.path("www/images", label, "shared", item_id, sprintf("%s_choice_%s.png", item_id, choice_id))

  if (as_image_button) {
    trigger_img_button(label = label,
                       inputId = choice_id,
                       item_id = item_id,
                       img_src = img_src,
                       width = width,
                       height = height,
                       margin = height / 10)
  } else {
    shiny::actionButton(paste0("button-", choice_id), psychTestR::i18n(sprintf("%s_QUESTION_%d_CHOICE_%s", label, item_number, choice_id)), style = "margin: 8px 6px 0px 6px;", class = paste0(label, "-img-button-", item_id), onclick = "set_choice_value(this)")
  }
}

get_answer_block <- function(label,
                             item_prefix,
                             item_number,
                             choices,
                             as_image_button = TRUE,
                             width = 550,
                             height = 100,
                             ...) {
  n <- length(choices)
  ncols = length(choices)
  rows <- list()
  for (i in seq_len(n)) {
    button <- get_answer_button(label, item_prefix, item_number, choices[i], as_image_button, index = i)
    rows[[i]] <- button
  }

  ret <- list()
  nrows <- floor(n / n)
  for (i in seq_len(nrows)) {
    ret[[i]] <- shiny::div(rows[(i - 1) * ncols + (1:ncols)])
  }
  ret
}

Item <- function(label,
                 language,
                 item_prefix,
                 item_number,
                 choices,
                 prompt = "",
                 button_text = "",
                 timeout_in_msec = NULL,
                 save_answer = TRUE,
                 get_answer = NULL,
                 on_complete = NULL) {
  page_prompt <- shiny::div(prompt)
  as_image_button <- if (label == "MRT") { FALSE } else { TRUE }
  item_id <- sprintf("%s%d", item_prefix, item_number)
  answer_block <- get_answer_block(label, item_prefix, item_number, choices, as_image_button = as_image_button)

  NAFC_page_with_img(label = label,
                     language = language,
                     prompt = page_prompt,
                     item_id = item_id,
                     answer_block = answer_block,
                     button_text = button_text,
                     timeout_in_msec = timeout_in_msec,
                     save_answer = save_answer,
                     get_answer = get_answer,
                     on_complete = NULL)
}
