#' Feedback page
#'
#' Page giving the participant graphical and textual feedback at the end of the test.
#'
#' @param language (Character vector) The language the page is displayed in.
#' Used to display the title of the page in the correct language.
#' @export
feedback_page <- function(language) {
  psychTestR::new_timeline(
    c(
      psychTestR::reactive_page(function(state, ...) {
        results <- psychTestR::get_results(state = state, complete = TRUE, add_session_info = FALSE)
        final_scores <- list()
        labels <- rev(names(results))
        legends <-
          labels %>% purrr::map(function(label)
            if (label %in% c("MRT", "PAT", "PFT", "SRT"))
              shiny::p(psychTestR::i18n(paste0("LEGEND_", label)), style = "text-align: left;"))

        for (label in labels) {
          if (label %in% c("MRT", "PAT", "PFT", "SRT")) {
            num_of_items <- if (label == "MRT") { 16 } else { 15 }
            final_scores[[label]] = results[[label]][["score"]] / num_of_items * 100
          }
        }

        psychTestR::page(
          ui = shiny::div(
            psychTestR::i18n("DEBRIEF_TOP"),
            feedback_plot(final_scores),
            legends,
            shiny::br(),
            shiny::div(psychTestR::i18n("DEBRIEF_BOTTOM"), style = "text-align: left;"),
            shiny::div(psychTestR::i18n("REFERENCES"), style = "text-align: left;"),
            psychTestR::trigger_button("next", psychTestR::i18n("CONTINUE"), style = "margin-top: 15px"),
            if (length(labels) > 1) shiny::tags$script(shiny::HTML(sprintf(paste0("document.getElementById('title').innerHTML = '<h4>", OSSAB::title[[language]], "</h4>'"))))
          )
        )
      })
    ),
    dict = OSSAB::OSSAB_dict
  )
}


#' Feedback plot
#'
#' Returns a plot displaying the percentage of correct test answers.
#' @param final_scores (Named list) Contains the scores for the tests.
#' @export
feedback_plot <- function(final_scores) {
  label <- NULL
  score <- NULL
  labels <- names(final_scores)
  df <- data.frame(label = labels, score = unlist(final_scores[labels]))

  plot <- ggplot2::ggplot(df, ggplot2::aes(x = label, y = score, fill = "#3282b8"))
  plot <- plot + ggplot2::coord_flip()
  plot <- plot + ggplot2::geom_bar(stat = "identity", width = 0.1)
  plot <- plot + ggplot2::geom_col(width = 0.4)
  plot <- plot + ggplot2::geom_text(ggplot2::aes(label = round(score, 0)), hjust = 0, nudge_y = 5)
  plot <- plot + ggplot2::ggtitle(psychTestR::i18n("PLOT_TITLE"))
  plot <- plot + ggplot2::scale_fill_manual(values = rep("#3282b8", length(labels)))
  plot <- plot + ggplot2::scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 10), minor_breaks = NULL)
  plot <- plot + ggplot2::theme_classic(base_size = 16)
  plot <- plot + ggplot2::theme(axis.line = ggplot2::element_blank(),
                                axis.ticks = ggplot2::element_blank(),
                                axis.title.x = ggplot2::element_blank(),
                                axis.title.y = ggplot2::element_blank(),
                                legend.position = "none",
                                panel.grid.major.x = ggplot2::element_line(),
                                panel.grid.minor.x = ggplot2::element_line(),
                                plot.title = ggplot2::element_text(hjust = 0.5, size = 12))

  plotly::ggplotly(plot, id = "plot", width = 500, height = length(labels) * 60 + 150) %>% plotly::config(displayModeBar = FALSE)
}
