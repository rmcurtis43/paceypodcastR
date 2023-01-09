#' Chart of Episode Duration by Show Type (i.e., Full vs. Bitesize)
#' @import ggplot2
#' @param episode_type  character string. Full and/or Bitesize
#'
#' @return ggplot2 chart
#' @export
#'
#' @examples
#' duration_show_type_chart(episode_type = c("Full"))

duration_show_type_chart <- function(episode_type = c("Full", "Bitesize")){
  # @import ggplot2
  # use_package("ggplot2")

  #load data
  data <- podcast_data() %>%
    dplyr::filter(show_type %in% c(episode_type))

  # visualize show duration by show type
  suppressWarnings({

    ggplot2::ggplot(data, aes(date, duration, group = show_type, color = show_type)) +
      ggplot2::geom_line() +
      ggplot2::geom_smooth(span = 0.4) +
      ggplot2::scale_y_continuous(name = "Duration (min)", breaks = seq(0,100,by = 10)) +
      ggplot2::scale_x_date(name = "Date", date_breaks = "1 year",
                            date_labels = "%Y") +
      ggplot2::labs(color='Show Type') +
      ggplot2::theme_minimal()+
      ggplot2::theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "transparent"),
                     axis.title.x = element_text(size = 16, color = "darkgrey"),
                     axis.text.x = element_text(size = 16, color = "darkgrey"),
                     axis.title.y = element_text(size = 16, color = "darkgrey"),
                     axis.text.y = element_text(size = 16, color = "darkgrey"),
                     panel.background = element_rect(fill = '#252a32', colour = 'transparent'),
                     plot.background = element_rect(fill = '#252a32', colour = 'transparent'),
                     panel.grid = element_blank(),
                     panel.grid.major.x  = element_blank(),
                     panel.grid.major.y  = element_blank(),
                     legend.text = element_text(color = "darkgrey"),
                     legend.title = element_text(color = "darkgrey")
      )

  })


}
