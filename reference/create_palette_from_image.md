# Create a color palette from an image

Create a color palette from an image

## Usage

``` r
create_palette_from_image(
  img = NULL,
  n = 5,
  extract_method = "median",
  show = FALSE,
  ...
)
```

## Arguments

- img:

  Image URL(s) and/or path(s).

- n:

  Number of colors. Default is 5.

- extract_method:

  Method of color extraction. Default is the `median` of the cluster
  specific RGB values. Other options are `"mean"`, `"mode"`, and
  `"hex_freq"` (most common hex colors per cluster)

- show:

  Whether to show the generated color palette. Default is `FALSE`

- ...:

  Optional arguments in
  [`colorfindr::get_colors`](https://rdrr.io/pkg/colorfindr/man/get_colors.html)

## Value

Vector of colors
create_palette_from_image("https://free-images.com/lg/871f/garden_violet_blooms_profusely_0.jpg")
