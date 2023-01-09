#' Display Episode Trend by Month
#' @import ggplot2
#' @return ggplot2 figure
#' @export
#'
#' @examples
#' duration_month_chart()
duration_month_chart <- function(){

  data <- podcast_data()

  suppressWarnings({
    # month
    month_data <- data %>%
      dplyr::filter(date > min(date)) %>%
      dplyr::group_by(year_month = floor_date(date, "1 month")) %>%
      dplyr::summarize(count = n(),
                       duration = sum(duration)) %>%
      dplyr::mutate(month_num = row_number())

    # month plot
    ggplot2::ggplot(month_data , aes(x = month_num, y = duration)) +
      ggplot2::geom_col(fill = "#617a89") +
      ggplot2::geom_smooth(span = 1, color = 'red') +
      ggplot2::scale_y_continuous(name = "Monthly Episode Duration (min)",
                                  #breaks = seq(0,500,by = 100)
      ) +
      ggplot2::scale_x_continuous(name = "Month Number", breaks = seq(0,max(month_data$month_num),by = 5)) +
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
                     panel.grid.major.y  = element_blank()
      )

  })


}
