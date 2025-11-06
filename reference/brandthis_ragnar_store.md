# Open the ggsci knowledge store

Opens a connection to the ggsci documentation database. On first use,
this will download the database from GitHub.

## Usage

``` r
brandthis_ragnar_store(pkg = c("paletteer", "ggsci"))
```

## Arguments

- pkg:

  ggsci or paletteer

## Value

A `RagnarStore` object.
