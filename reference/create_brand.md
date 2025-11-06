# Create \_brand.yml

Create a personal/company `_brand.yml` file using your favourite LLM.

## Usage

``` r
create_brand(
  prompt,
  img = NULL,
  browse = FALSE,
  type = c("personal", "company"),
  chat_fn = ellmer::chat_google_gemini,
  ...
)
```

## Arguments

- prompt:

  User prompt. May include info. about brand name, colors, fonts, and
  logo.

- img:

  Image URL(s) and/or path(s). Only path(s) are allowed for
  `type = "company"`. Default is `NULL`.

- browse:

  Whether to browse for image(s) in the file system. Default is `FALSE`.

- type:

  Brand type. `"personal"` or `"company"`. See Details.

- chat_fn:

  [Ellmer](https://ellmer.tidyverse.org/#providers) chat function.
  Default is
  [`ellmer::chat_google_gemini`](https://ellmer.tidyverse.org/reference/chat_google_gemini.html).

- ...:

  Parameters of ellmer chat function.

## Value

\_brand.yml object

## Details

Generating \_brand.yml requires info. about your brand name, colors,
typography, and logos. If no info. is provided, `create_brand` will ask
for it. Brand name and image(s) or colors are required at a minimum.
`create_brand` will use a random combination of Google Fonts if no
typography info. is provided.

Personal Branding: You may provide a single image path or a URL that
`create_brand` will use to extract colors as the first step. These
colors will then be used by an LLM to generate the color palette and
semantic colors for the \_brand.yml. If an image is not provided, the
LLM will use info. from the `prompt`.

Company Branding: You may provide one or more image paths of company
branding guidelines that an LLM will extract info. from for creating the
\_brand.yml. Image URLs are not allowed. If no image(s) are provided,
`create_brand` will rely on the `prompt`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a personal _brand.yml with a local image
personal_brand <- create_brand(
  "My name is Katniss Everdeen",
  browse = TRUE,
  type = "personal",
  chat_fn = ellmer::chat_github,
  model = "gpt-4.1"
)

# Create a personal _brand.yml with an image URL
personal_brand <- create_brand(
  "My name is Paul Blart",
  img = "https://free-images.com/md/7687/blue_jay_bird_nature.jpg",
  type = "personal",
  chat_fn = ellmer::chat_google_gemini
)

# If no info. is provided, you will be asked to provide some:
brand_no_input <- create_brand(
  "",
  img = NULL,
  type = "personal",
  chat_fn = ellmer::chat_google_gemini
)
# I can help with that! To create your personal
# `_brand.yml` file, I'll need a bit more
# information. Please provide the following:
#
# *   **Brand Name** (e.g., John Doe, or a short/full
# name) and **Website(s)** (e.g., personal portfolio,
# social media links)
# *   **Brand Colors** or a **Color Palette** (e.g.,
# "I like blue, green, and a touch of orange," or
# specific hex codes)
# *   **Heading, Base, and Monospace Fonts** (e.g.,
# "I'd like Roboto for headings, Open Sans for base
# text, and Fira Code for monospace," or you can ask
# me to suggest some)
# *   **Logo information** (e.g., "I have a logo at
# this URL," or "I'd like a placeholder for now")

# Create a company _brand.yml with multiple image paths:
company_brand <- create_brand(
  "Company name is Walmart",
  img = c("walmart-font.png",
          "walmart-palette.jpeg",
          "walmart-logo.png"),
  type = "company",
  chat_fn = ellmer::chat_google_gemini
)
} # }
```
