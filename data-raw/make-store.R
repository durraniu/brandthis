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

# ragnar_store_build_index(store)
DBI::dbDisconnect(store@con)










# paletteer ------

library(ragnar)

base_url_paletteer <- "https://emilhvitfeldt.github.io/paletteer/index.html"
pages_paletteer <- ragnar_find_links(base_url_paletteer)

pp <- pages_paletteer[c(3, 5, 7, 8, 9)]
pp <- c(
  pp,
  "https://emilhvitfeldt.github.io/paletteer/reference/ggplot2-scales-continuous.html",
  "https://emilhvitfeldt.github.io/paletteer/reference/ggplot2-scales-discrete.html"
)


store_location <- "inst/extdata/paletteer.ragnar.duckdb"

store <- ragnar_store_create(
  store_location,
  embed = \(x) ragnar::embed_ollama(x, model = "embeddinggemma")
)


palettes_c <- paletteer::palettes_c_names
palettes_c_text <- paste0(
  "Continuous palette: ", palettes_c$package, "::", palettes_c$palette
)


palettes_d <- paletteer::palettes_d_names
palettes_d_text <- paste0(
  "Discrete palette: ", palettes_d$package, "::", palettes_d$palette
)

palettes_dy <- paletteer::palettes_dynamic_names
palettes_dy_text <- paste0(
  "Dynamic palette: ", palettes_dy$package, "::", palettes_dy$palette
)

ragnar_store_insert(store, markdown_chunk(palettes_c_text))
ragnar_store_insert(store, markdown_chunk(palettes_d_text))
ragnar_store_insert(store, markdown_chunk(palettes_dy_text))

for (page in pp) {
  message("ingesting: ", page)
  chunks <- page |> read_as_markdown() |> markdown_chunk()
  ragnar_store_insert(store, chunks)
}

DBI::dbDisconnect(store@con)
