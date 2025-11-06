# brandthis

![brandthis logo](inst/figures/logo.png)

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
# install.packages("remotes")
remotes::install_github("durraniu/brandthis")
```

> NOTE: {brandthis} is currently not compatible with `ggplot2` version
> 4.0.0. Please use an earlier version.

## Getting Started

{brandthis} uses LLM APIs for generating `_brand.yml` and color
palettes/scales. So, you need an API key from your favourite LLM
provider. You can find the supported APIs on the [ellmer
website](https://ellmer.tidyverse.org/).

Grab your API key (e.g., `GOOGLE_API_KEY`, `OPENROUTER_API_KEY`, etc.)
and put it in your `.Renviron` file.

## Examples

{brandthis} has three main functions:

- [`brandthis::create_brand()`](https://durraniu.github.io/brandthis/reference/create_brand.md)
  creates a `_brand.yml` for personal or company branding:

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

- [`brandthis::suggest_color_scales()`](https://durraniu.github.io/brandthis/reference/suggest_color_scales.md)
  suggests ggplot2 color scales that have palette colours similar to the
  color palette in the provided `_brand.yml` file. Suggestion is made by
  retrieving the relevant info. from a knowledge store for the
  `paletteer` or `ggsci` packages. The knowledge store is downloaded the
  first time `suggest_color_scales` is used:

``` r
suggested_scales <- brandthis::suggest_color_scales(personal_brand, "paletteer")
```

- [`brandthis::create_color_palette()`](https://durraniu.github.io/brandthis/reference/create_color_palette.md)
  creates a list of discrete, sequential, and diverging colour palettes
  from the colour palette in the provided `_brand.yml`:

``` r
color_palettes <- brandthis::create_color_palette(personal_brand)
```

## createBranding App

{brandthis} comes with a shiny app that lets you generate the
`_brand.yml` and color palettes with the benefit of reviewing the
results in the app. You can launch the app by running
[`run_brand_app()`](https://durraniu.github.io/brandthis/reference/run_brand_app.md):

![Demo](reference/figures/brandthis_gif.gif)

Demo

The `createBranding` app is built on the [brand.yml
app](shiny::runExample(%22brand.yml%22,%20package%20=%20%22bslib%22))
available in bslib and can be launched by running
`shiny::runExample("brand.yml", package = "bslib")`.

## Acknowledgements

All the credit goes to the creators of ggplot2, shiny, bslib, brand.yml,
quarto, ragnar, ellmer, and several other packages that made brandthis
possible. I am very thankful to [Garrick
Aden-Buie](https://github.com/gadenbuie) for not only creating the
awesome packages and documentation, but also patiently answering my
questions on Discord, GitHub Discussions and issues. I am also very
grateful to [Tomasz Kalinowski](https://github.com/t-kalinowski) whose
`quartohelp` R package showed me how to release knowledge stores on
GitHub and make them useful to brandthis users. I adapted several of
`quartohelp` store-related functions for brandthis (see `R/store.R` in
the package source).
