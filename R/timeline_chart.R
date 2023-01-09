#' Timeline For Significant Pacey Performance Podcast Dates
#' @import ggplot2
#' @import magick
#' @return ggplot2 figure
#' @export
#'
#' @examples
#' timeline_chart()
timeline_chart <- function(){

  # @import ggplot2
  # @import magick
  # use_package("ggplot2")
  # use_package("magick")
  # use_import_from("ggimage", "geom_image")
  # use_import_from("ggtext", "geom_richtext")
  # use_import_from("graphics", "symbols")

  #import data
  data <- podcast_data()


  # code adapated from: https://github.com/tashapiro/TidyTuesday/blob/master/2023/W1/tt-netflix-content.R

  suppressWarnings({

    #border function to apply with ggimage
    border_red <- function(im) {
      ii <- magick::image_info(im)
      ii_min <- min(ii$width, ii$height)

      img <- image_blank(width = ii_min, height = ii_min, color = "none")
      drawing <- image_draw(img)
      symbols(ii_min/2, ii_min/2, circles = ii_min/2.2, bg = 'red', inches = FALSE, add = TRUE)
      dev.off()

      image_composite(image_scale(drawing, "x530"), image_scale(im,500), offset = "+15+15")
    }


    #border function to apply with ggimage
    border_white <- function(im) {
      ii <- magick::image_info(im)
      ii_min <- min(ii$width, ii$height)

      img <- image_blank(width = ii_min, height = ii_min, color = "none")
      drawing <- image_draw(img)
      symbols(ii_min/2, ii_min/2, circles = ii_min/2.2, bg = 'white', inches = FALSE, add = TRUE)
      dev.off()

      image_composite(image_scale(drawing, "x530"), image_scale(im,500), offset = "+15+15")
    }

  })


  #df for labels for images
  labels = data.frame(
    x= as.Date(c("2015-04-24", "2020-03-12","2021-10-11", "2021-12-01")),
    y= c(160, 400, 250, 500),
    label=c(
      "<span>April 24, 2015<br><span style='color:#E50914;'>**First<br>Episodes<br>Released**</span></span>",
      "<span>March 12, 2021<br><span style='color:#E50914;'>**Podcast <br> Logo Update**</span>",
      "<span>October 11, 2021 <br> Inflection Point<br><span style='color:#E50914;'>**#Bitesize Episodes Introduced** <br> **Surge in content release**</span>",
      "<span>December 19, 2021<br><span style='color:#E50914;'>**Sportsmith Launch**</span>"
    ),
    hjust=c(0.3, rep(0.5,3))
  )

  #df for dotted segment lines
  segments = data.frame(
    y = c(100, 350, 366, 450),
    yend = c(32, 283, 280, 386),
    x= as.Date(c("2015-04-24", "2020-03-12","2021-10-11", "2021-12-19")),
    xend = as.Date(c("2015-04-24", "2020-03-12","2021-10-11", "2021-12-19"))
  )


  # visualize timeline
  chart <- ggplot2::ggplot(data, aes(date, show_num)) +
    ggplot2::geom_area(color="#E50914",
                       fill = "#FF7B82",
                       alpha=0.15,
                       linewidth=1.5)+
    ggplot2::scale_y_continuous(name = "Cumulative Episides", breaks = seq(0,1000,by = 100)) +
    ggplot2::scale_x_date(name = "Date", date_breaks = "1 year",
                          date_labels = "%Y") +
    ggplot2::geom_segment(data=segments,
                          mapping=aes(x=x, xend=xend, y=y, yend=yend), color="white", linetype="dotted")+
    ggimage::geom_image(inherit.aes=FALSE,
                        mapping=aes(x=as.Date("2015-04-24"), y=100, image=system.file("figures", "ppp_image_old.png", package = "paceypodcastRdemo")), size=0.09,
                        image_fun = border_red)+
    ggimage::geom_image(inherit.aes=FALSE,
                        mapping=aes(x=as.Date("2020-03-12"), y=350, image=system.file("figures", "pacey_logo.png", package = "paceypodcastRdemo")), size=0.09,
                        image_fun = border_white)+
    ggimage::geom_image(inherit.aes=FALSE,
                        mapping=aes(x=as.Date("2021-12-19"), y=450, image=system.file("figures", "sportsmith_letter_logo.png", package = "paceypodcastRdemo")), size=0.08,
                        image_fun = border_red)+
    ggtext::geom_richtext(data=labels,
                          mapping=aes(x=x,y=y,label=label, hjust=hjust),
                          color="white",
                          label.size=NA,
                          size=5,
                          fill=NA)+
    ggplot2::theme_minimal()+
    ggplot2::theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(), axis.line = element_line(colour = "transparent"),
                   axis.title.x = element_text(size = 24, color = "darkgrey"),
                   axis.text.x = element_text(size = 24, color = "darkgrey"),
                   axis.title.y = element_text(size = 24, color = "darkgrey"),
                   axis.text.y = element_text(size = 24, color = "darkgrey"),
                   panel.background = element_rect(fill = '#252a32', colour = 'transparent'),
                   plot.background = element_rect(fill = '#252a32', colour = 'transparent'),
                   panel.grid = element_blank(),
                   panel.grid.major.x  = element_blank(),
                   panel.grid.major.y  = element_blank()
    )


  return(chart)

}
