
<!-- README.md is generated from README.Rmd. Please edit that file -->

# brandthis

<img src="inst/figures/logo.png" align="right" height="138" alt="brandthis logo" />

<!-- badges: start -->

<!-- badges: end -->

The goal of {brandthis} is to quickly get you started with creating:

- `_brand.yml` file  
- `ggplot2` color scales and palettes

for your theming and visualization needs.

[`_brand.yml`](https://posit-dev.github.io/brand-yml/) helps you
consistently theme your rmarkdown, quarto, and shiny products by
specifying colors, fonts, logos, and other information in one file.

## Installation

You can install the development version of {brandthis} from GitHub with:

``` r
# install.packages("pak")
pak::pak("durraniu/brandthis")
```

## Getting Started

{brandthis} uses LLM APIs for generating `_brand.yml` and color
palettes/scales. So, you need an API key from your favourite LLM
provider. You can find the supported APIs on the [ellmer
website](https://ellmer.tidyverse.org/).

Grab your API key (e.g., `GOOGLE_API_KEY`, `OPENROUTER_API_KEY`, etc.)
and put it in your `.Renviron` file.

## Examples

{brandthis} has three main functions:

- `brandthis::create_brand()` creates a `_brand.yml` for personal or
  company branding:

``` r
# Provide your details in the prompt and optionally an image for extracting colors:
personal_brand <- brandthis::create_brand(
    prompt = "My name is John Doe.",
    img = "https://free-images.com/md/e150/eugene_louis_boudin_venice.jpg",
    type = "personal",
    chat_fn = ellmer::chat_github
)
```

``` r
# Provide multiple screenshots of company branding guidelines:
company_brand <- brandthis::create_brand(
  "Company name is Walmart",
  img = c("walmart-font.png",
          "walmart-palette.jpeg",
          "walmart-logo.png"),
  type = "company",
  chat_fn = ellmer::chat_google_gemini
)
```

- `brandthis::suggest_color_scales()` suggests ggplot2 color scales that
  have palette colours similar to the color palette in the provided
  `_brand.yml` file. Suggestion is made by retrieving the relevant info.
  from a knowledge store for the `paletteer` or `ggsci` packages. The
  knowledge store is downloaded the first time `suggest_color_scales` is
  used:

``` r
suggested_scales <- brandthis::suggest_color_scales(personal_brand, "paletteer")
```

- `brandthis::create_color_palette()` creates a list of discrete,
  sequential, and diverging colour palettes from the colour palette in
  the provided `_brand.yml`:

``` r
color_palettes <- brandthis::create_color_palette(personal_brand)
```
