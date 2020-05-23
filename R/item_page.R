trigger_img_button <- function (inputId, item_id, img_src, width, height, margin = height / 10){
  inputId <- htmltools::htmlEscape(inputId, attribute = TRUE)
  style <- sprintf("width: %dpx; height: %dpx; margin: %dpx; background: url('%s'); background-size: %dpx %dpx; background-position: center center;", width, height, 4, img_src, width, height)
  shiny::actionButton(inputId = paste0("button-", inputId),
                      class = paste0("img-button-", item_id),
                      label = "",
                      style = style,
                      icon = NULL,
                      onclick = "set_choice_value(this.id.split('-')[1]);")
}

NAFC_page_with_img <- function(label,
                               prompt,
                               item_id,
                               choices,
                               button_text,
                               timeout_in_msec = NULL,
                               save_answer = TRUE,
                               get_answer = NULL,
                               response_ui_id = "response_ui",
                               on_complete = NULL,
                               admin_ui = NULL) {
  stopifnot(purrr::is_scalar_character(label))

  question_image_width <- if (label %in% c("MRT", "SRT")) { "268px" } else { "468px" }
  next_button_display <- if (item_id == "p1") { "block" } else { "none" }

  ui <- shiny::div(
    tagify(prompt),
    shiny::tags$img(id = item_id, src = sprintf("www/images/%s/%s/%s_question.png", label, item_id, item_id), style = paste0("margin-top: 10px; width: ", question_image_width)),
    shiny::div(choices, id = response_ui_id),
    shiny::p(psychTestR::trigger_button(paste0("no-id-", item_id), psychTestR::i18n("FORWARD"), style = "display: block; margin-top: 12px;", class = paste(paste0("forward-button-", item_id), "shiny-bound-input"), disabled = TRUE)),
    shiny::tags$script(shiny::HTML(sprintf("function set_choice_value(id) { var forward_buttons = document.getElementsByClassName('forward-button-%s'); for (var i=0, len=forward_buttons.length; i<len; i++) { forward_buttons[i].id = id; forward_buttons[i].disabled = false; } }", item_id, item_id))),
    shiny::tags$script(shiny::HTML(sprintf("window.setTimeout(\"var image_buttons = document.getElementsByClassName('img-button-%s'); for (var i=0, len=image_buttons.length; i<len; i++) { image_buttons[i].style.display='none'; } var forward_buttons = document.getElementsByClassName('forward-button-%s'); for (var i=0, len=forward_buttons.length; i<len; i++) { forward_buttons[i].style.display='none'; }\", %d)", item_id, item_id, timeout_in_msec))),
    shiny::tags$script(shiny::HTML(sprintf("window.setTimeout(\"document.getElementById('%s').style.display='none'; \", %d)", item_id, timeout_in_msec))),
    shiny::p(psychTestR::trigger_button("next", button_text, class = paste0("next-", item_id), style = paste0("margin-top: 15px; display: ", next_button_display))),
    shiny::tags$script(shiny::HTML(sprintf("window.setTimeout(\"var next_buttons = document.getElementsByClassName('next-%s'); for (var i=0, len=next_buttons.length; i<len; i++) { next_buttons[i].style.display='block'; } \", %d)", item_id, timeout_in_msec)))
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
  img_src <- file.path("www/images", label, item_id, sprintf("%s_choice_%s.png", item_id, choice_id))

  if (as_image_button) {

    trigger_img_button(inputId = choice_id,
                       item_id = item_id,
                       img_src = img_src,
                       width = width,
                       height = height,
                       margin = height / 10)
  } else {
    shiny::actionButton(paste0("button-", choice_id), psychTestR::i18n(sprintf("QUESTION_%d_CHOICE_%s", item_number, choice_id)), style = "display: block; margin-top: 12px;", class = paste0("img-button-", item_id), onclick = "set_choice_value(this.id.split('-')[1]);")
  }
}

get_answer_block <- function(label,
                             item_prefix,
                             item_number,
                             choice_ids,
                             as_image_button = TRUE,
                             width = 550,
                             height = 100,
                             ...) {
  n <- length(choice_ids)
  ncols = length(choice_ids)
  rows <- list()
  for (i in seq_len(n)) {
    button <- get_answer_button(label, item_prefix, item_number, choice_ids[i], as_image_button, index = i)
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
                 item_prefix,
                 item_number,
                 answer,
                 prompt = "",
                 button_text = "",
                 timeout_in_msec = NULL,
                 save_answer = TRUE,
                 get_answer = NULL,
                 on_complete = NULL) {

  page_prompt <- shiny::div(prompt)

  # TODO
  choice_ids = c()
  as_image_button <- TRUE
  if (label == "MRT") {
    choice_ids <- c("A", "B", "C")
    as_image_button <- FALSE
  } else {
    choice_ids <- c("A", "B", "C", "D", "E")
  }

  item_id <- sprintf("%s%d", item_prefix, item_number)
  choices <- get_answer_block(label, item_prefix, item_number, choice_ids, as_image_button)

  NAFC_page_with_img(label = label,
                     prompt = page_prompt,
                     item_id = item_id,
                     choices = choices,
                     button_text = button_text,
                     timeout_in_msec = timeout_in_msec,
                     save_answer = save_answer,
                     get_answer = get_answer,
                     on_complete = NULL)
}

