#' Interactive Table Containing All Episodes and Audio Files
#' @import DT
#' @import dplyr
#' @return DT table
#' @export
#'
#' @examples
#' episodes_table()

episodes_table <- function(){

  # use_package("DT")

  data_full <- podcast_data() %>%
    dplyr::select(title, date, description, guest, url) %>%
    dplyr::mutate(date = format(date, "%m-%d-%Y")) %>%
    dplyr::mutate(audio = paste0("<audio src = '", url,"' type = 'audio/mp3' autostart = '0' controls = 'TRUE'></audio>", sep = "")) %>%
    dplyr::select(Guest=guest,Title=title, Date=date,  Description=description, Audio=audio)


  tbl <- DT::datatable(
    data_full,
    escape = FALSE,
    rownames= FALSE,
    options = list(
      pageLength = 50,
      autoWidth = TRUE
    ))


  return(tbl)

}
