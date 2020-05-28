#' Feedback with score
#'
#' Here the participant is given textual feedback at the end of the test.
#' @param label (Character scalar) Three uppercase letter acronym of the questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @export
feedback_with_score <- function(label, dict) {
  psychTestR::new_timeline(
    c(
      psychTestR::reactive_page(function(state, ...) {
        results <- psychTestR::get_results(state = state, complete = TRUE, add_session_info = FALSE)
        num_question <- length(results[[label]]) - 1
        percentage <- round(results[[label]]$score * 100 / num_question, 3)
        sum_score <- results[[label]]$score
        text_finish <- psychTestR::i18n("COMPLETED",
                                        html = TRUE,
                                        sub = list(num_question = num_question, num_correct = sum_score))
        psychTestR::page(
          ui = shiny::div(
            shiny::p(text_finish),
            shiny::p(psychTestR::trigger_button("next", psychTestR::i18n("CONTINUE")))
          )
        )
      }
      )),
    dict = dict
  )
}

#' Feedback with graph
#'
#' The participant is given textual and graphical feedback at the end of the test.
#' @param label (Character scalar) Three uppercase letter acronym of the questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @export
feedback_with_graph <- function(label, dict) {
  psychTestR::new_timeline(
    c(
      psychTestR::reactive_page(function(state, ...) {
        results <- psychTestR::get_results(state = state, complete = TRUE, add_session_info = FALSE)
        num_question <- length(results[[label]]) - 1
        score <- results[[label]]$score
        text_finish <- psychTestR::i18n("RESULTS",
                                        html = TRUE,
                                        sub = list(num_question = num_question, num_correct = score))
        norm_plot <- feedback_graph_normal_curve(score, x_max = num_question)
        psychTestR::page(
          ui = shiny::div(
            shiny::p(text_finish, style = "font-weight: bold"),
            shiny::p(norm_plot),
            shiny::p(psychTestR::trigger_button("next", psychTestR::i18n("CONTINUE"), style = "margin-top: 15px"))
          )
        )
      }
      )),
    dict = dict
  )
}

feedback_graph_normal_curve <- function(score, x_min = 0, x_max = 16, x_mean = 8, x_sd = 2.5) {
  ratio <- score / x_max
  percentage <- round(ratio * 100, 3)
  x = NULL
  q <-
    ggplot2::ggplot(data.frame(x = c(x_min, x_max)), ggplot2::aes(x)) +
    ggplot2::stat_function(fun = stats::dnorm, args = list(mean = x_mean, sd = x_sd)) +
    ggplot2::stat_function(fun = stats::dnorm, args = list(mean = x_mean, sd = x_sd),
                           xlim = c(x_min, (x_max - x_min) * ratio + x_min),
                           fill = "lightblue4",
                           geom = "area")
  q <- q + ggplot2::theme_bw()
  title_prefix <- paste0(psychTestR::i18n("CORRECT_ANSWERS"), ":")
  title_x_of_y <- paste0(score, "/", x_max, paste0(" (", percentage, " %)"))
  x_axis_lab <- paste(psychTestR::i18n("NUMBER_OF"), tolower(psychTestR::i18n("CORRECT_ANSWERS")))
  q <- q + ggplot2::labs(x = x_axis_lab, y = "")
  q <- q + ggplot2::ggtitle(paste(title_prefix, title_x_of_y)) + ggplot2::theme(plot.title = ggplot2::element_text(size = 10))
  plotly::ggplotly(q, width = 540, height = 405) %>% plotly::config(displayModeBar = FALSE)
}

