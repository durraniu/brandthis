# Updates the ggsci knowledge store

Downloads the latest version of the store from the brandthis GitHub
repository and builds the search index locally.

## Usage

``` r
update_store(pkg = c("paletteer", "ggsci"))
```

## Arguments

- pkg:

  ggsci or paletteer

## Value

`NULL` invisibly.

## Details

The download location can be configured with a few environment
variables:

- `BRANDTHIS_STORE_URL`: a custom URL to download the store from. The
  default is to download the latest store from the `durraniu/brandthis`
  repository in the `store-v1` release.

- `BRANDTHIS_STORE_RELEASE`: the release tag to download the store from.
  Defaults to `store-v1`.

- `BRANDTHIS_STORE_REPOSITORY`: the repository to download the store
  from. Defaults to `durraniu/brandthis`.
