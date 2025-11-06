# Create color palettes from the provided \_brand.yml

Create color palettes from the provided \_brand.yml

## Usage

``` r
create_color_palette(brand_yml, chat_fn = ellmer::chat_google_gemini, ...)
```

## Arguments

- brand_yml:

  \_brand.yml object.

- chat_fn:

  Ellmer chat function, e.g.,
  [`ellmer::chat_google_gemini`](https://ellmer.tidyverse.org/reference/chat_google_gemini.html).

- ...:

  Parameters of ellmer chat function.

## Value

List of color palettes

## Examples

``` r
if (FALSE) { # \dontrun{
personal_brand <- create_brand(
  "My name is Paul Blart",
  img = "https://free-images.com/md/7687/blue_jay_bird_nature.jpg",
  type = "personal",
  chat_fn = ellmer::chat_google_gemini
)
color_palettes <- create_color_palette(personal_brand)
} # }
```
