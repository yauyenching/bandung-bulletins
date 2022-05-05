library(tidyverse)

bandung_data <- read.csv("bandung_data.csv", na.strings="")
bandung_data$text <- str_to_lower(bandung_data$text)

purpose <- bandung_data |> filter(topic=="purpose")
general <- bandung_data |> filter(topic=="general")
communique <- bandung_data |> filter(topic=="communique")
press <- bandung_data |> filter(topic=="press")
address <- bandung_data |> filter(topic=="address")

library(tm)
create_df <- function(data) {
  text <- data$text
  docs <- Corpus(VectorSource(text))
  docs <- docs %>%
    tm_map(removeNumbers) %>%
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace)
  docs <- tm_map(docs, content_transformer(tolower))
  docs <- tm_map(docs, removeWords, stopwords("english"))
  
  dtm <- TermDocumentMatrix(docs) 
  matrix <- as.matrix(dtm) 
  words <- sort(rowSums(matrix),decreasing=TRUE) 
  df <- data.frame(word = names(words),freq=words)
  df
}

purpose_df <- create_df(purpose)
general_df <- create_df(general)
communique_df <- create_df(communique)
press_df <- create_df(press)
address_df <- create_df(address)

write.csv(df, "bandung_all.csv")

df_test <- df |> left_join(purpose_df, by = "word", suffix = c(".all", ".purpose"))
df_test <- df_test |> left_join(general_df, by = "word")
df_test <- df_test |> rename(freq.general = freq)
df_test <- df_test |> left_join(communique_df, by = "word")
df_test <- df_test |> rename(freq.communique = freq)
df_test <- df_test |> left_join(press_df, by = "word")
df_test <- df_test |> rename(freq.press = freq)

write.csv(df_test, "df_test2.csv")
