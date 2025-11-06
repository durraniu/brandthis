# Suggest paletteer or ggsci color palettes and scales

Suggest paletteer or ggsci color palettes and scales

## Usage

``` r
suggest_color_scales(
  brand_yml,
  pkg = c("paletteer", "ggsci"),
  top_k = 8L,
  chat_fn = ellmer::chat_google_gemini,
  ...
)
```

## Arguments

- brand_yml:

  \_brand.yml object.

- pkg:

  paletteer or ggsci

- top_k:

  Number of excerpts to request from the knowledge store for each
  retrieval

- chat_fn:

  Ellmer chat function, e.g.,
  [`ellmer::chat_google_gemini`](https://ellmer.tidyverse.org/reference/chat_google_gemini.html).

- ...:

  Parameters of ellmer chat function.

## Value

Suggested palettes and scales

## Examples

``` r
if (FALSE) { # \dontrun{
personal_brand <- create_brand(
  "My name is Paul Blart",
  img = "https://free-images.com/md/7687/blue_jay_bird_nature.jpg",
  type = "personal",
  chat_fn = ellmer::chat_google_gemini
)
suggested_scales <- suggest_color_scales(personal_brand)
} # }
```
