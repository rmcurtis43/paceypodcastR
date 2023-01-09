
#' Pacey Podcast Data
#' @import dplyr
#' @import lubridate
#' @import rvest
#' @import stringr
#' @import xml2
#' @import purrr
#' @return dataframe
#' @export
#'
#' @examples
#' podcast_data()
podcast_data <- function(){


  # use_package("dplyr")
  # use_package("lubridate")
  # use_package("rvest")
  # use_package("stringr")
  # use_package("xml2")
  # use_package("purrr")

  # define url for RSS feed XML file
  URL <- 'https://feed.podbean.com/Paceyperformancepodcast/feed.xml'

  # define XML tags of interest
  css_tags <- c('title', 'pubDate', 'description', 'itunes\\:duration')
  col_names <- c('title', 'date', 'description', 'duration')



  # load XML feed and extract items nodes
  podcast_feed <- xml2::read_xml(URL)
  items <- rvest::html_elements(podcast_feed, 'item')
  enclosure <- rvest::html_elements(podcast_feed, 'enclosure')


  # extract html attributes from enclosure node
  url_data = enclosure %>%
    rvest::html_attr("url") %>%
    dplyr::as_tibble() %>%
    dplyr::rename(url=value)



  # extracts from an item node the content defined by the css_tags
  extract_element <- function(item, css_tags) {
    element <- rvest::html_element(item, css_tags) %>% xml_text
    element
  }


  podcast_df <- sapply(css_tags, function(x) {
    extract_element(items, x)}) %>%
    as_tibble()


  names(podcast_df) <- col_names # set new column names



  #extract date
  suppressWarnings({
    podcast_df2 <- podcast_df %>%
      dplyr::bind_cols(url_data) %>%
      dplyr::mutate(date = stringr::str_sub(date, 5, 16)) %>%
      dplyr::mutate(date = lubridate::dmy(date)) %>%
      dplyr::mutate(duration = dplyr::case_when(
        nchar(duration) <= 5 ~ as.numeric(hm(duration))/60/60,
        nchar(duration) >= 8 ~ as.numeric(hms(duration))/60,
        TRUE ~ as.numeric(NA_real_)
      )) %>%
      dplyr::mutate(guest = gsub(r"{\s*\([^\)]+\)}","",title)) %>%
      dplyr::mutate(guest = sub('.*\\with ', '', guest)) %>%
      dplyr::mutate(guest = sub('.*\\ with', '', guest)) %>%
      dplyr::mutate(guest = sub('.*\\ - ', '', guest)) %>%
      dplyr::mutate(guest = sub('.*\\ugly ', '', guest)) %>%
      dplyr::mutate(guest = case_when(
        guest == "Baar" ~ "Keith Barr",
        guest == "D'Amelio" ~ "Keith D'Amelio",
        TRUE ~ as.character(guest)
      )) %>%
      dplyr::mutate(description_clean = gsub("<[^>]+>", "", description)) %>%
      purrr::map_df(rev) %>%
      dplyr::mutate(show_num = dplyr::row_number()) %>%
      dplyr::mutate(show_type = case_when(
        grepl("Bitesize", title) ~ "Bitesize",
        TRUE ~ as.character("Full")
      )) %>%
      dplyr::mutate(year = lubridate::year(date),
                    week = lubridate::isoweek(date),
                    weekday = weekdays(date))
  })

  return(podcast_df2)

}
