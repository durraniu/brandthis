## code to prepare `ggsci.ragnar.duckdb`

library(ragnar)

# Using ggsci documentation and palettes
pages <- c(
  "https://nanx.me/ggsci/articles/ggsci.html",
  "https://raw.githubusercontent.com/nanxstats/ggsci/refs/heads/master/R/palettes.R",
  "https://raw.githubusercontent.com/nanxstats/ggsci/refs/heads/master/R/palettes-iterm.R"
)

store_location <- "inst/extdata/ggsci.ragnar.duckdb"

# embeddinggemma model was used for creating embeddings
store <- ragnar_store_create(
  store_location,
  embed = \(x) ragnar::embed_ollama(x, model = "embeddinggemma")
)


for (page in pages) {
  message("ingesting: ", page)
  chunks <- page |> read_as_markdown() |> markdown_chunk()
  ragnar_store_insert(store, chunks)
}


ragnar_store_build_index(store)
