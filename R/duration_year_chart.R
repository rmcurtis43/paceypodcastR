#' Display Episode Trend by Year
#' @import ggplot2
#' @return ggplot2 chart
#' @export
#'
#' @examples
#' duration_year_chart()
duration_year_chart <- function(){

  data <- podcast_data()

  suppressWarnings({
    # year
    year_data <- data %>%
      dplyr::filter(date > min(date)) %>%
      dplyr::group_by(year_year = floor_date(date, "1 year")) %>%
      dplyr::summarize(count = n(),
                       duration = sum(duration)) %>%
      dplyr::mutate(year_num = row_number()) %>%
      dplyr::mutate(year = year(year_year))

    # year
    reg_line_data <- data %>%
      dplyr::filter(date > min(date)) %>%
      dplyr::group_by(year_year = floor_date(date, "1 year")) %>%
      dplyr::summarize(count = n(),
                       duration = sum(duration)) %>%
      dplyr::mutate(year_num = row_number()) %>%
      dplyr::mutate(year = year(year_year)) %>%
      filter(year < max(year))
    # year plot

    chart <- ggplot2::ggplot(year_data , aes(x = year, y = duration)) +
      ggplot2::geom_col(fill = "#617a89") +
      ggplot2::geom_smooth(data = reg_line_data, aes(x=year, y=duration), span = 0.5, color = 'red', method = "loess") +
      ggplot2::scale_y_continuous(name = "Duration (min)",
                                  #breaks = seq(0,500,by = 100)
      ) +
      ggplot2::scale_x_continuous(name = "Year", breaks = seq(min(year_data$year),max(year_data$year),by = 1)) +
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


  return(chart)

}
