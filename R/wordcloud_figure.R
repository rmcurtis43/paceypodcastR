#' Pacey Performance Podcast Wordcloud
#' @import tm
#' @import wordcloud
#' @import dplyr
#' @return wordcloud figure
#' @export
#'
#' @examples
#' wordcloud_figure()
wordcloud_figure <- function(){

  # use_package("tm")
  # use_package("wordcloud")
  # use_package("dplyr")
  # use_import_from("RColorBrewer", fun = c("brewer.pal"))

  suppressWarnings({
    data <- podcast_data()

    # Create text and a corpus
    txt <- iconv(data$title, to = 'utf-8')
    docs <- tm::Corpus(VectorSource(txt))

    # data cleaning
    docs <- docs %>%
      tm::tm_map(removeNumbers) %>%
      tm::tm_map(removePunctuation) %>%
      tm::tm_map(stripWhitespace)
    docs <- tm::tm_map(docs, content_transformer(tolower))
    docs <- tm::tm_map(docs, removeWords, stopwords("english"))



    dtm <- tm::TermDocumentMatrix(docs)
    matrix <- as.matrix(dtm)
    words <- sort(rowSums(matrix),decreasing=TRUE)
    df <- data.frame(word = names(words),freq=words)



    set.seed(1234) # for reproducibility

    figure <- wordcloud::wordcloud(words = df$word, freq = df$freq, min.freq = 17,scale=c(4, .5),
                                   max.words=100, random.order=FALSE, rot.per=0.35,
                                   bg = 'transparent',
                                   colors=RColorBrewer::brewer.pal(8, "Dark2"))



  })

  return(figure)

}
