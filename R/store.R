# This is from: https://github.com/t-kalinowski/quartohelp/blob/main/R/store.r
brandthis_cache_dir <- function(...) {
  root <- tools::R_user_dir("brandthis", "cache")
  normalizePath(file.path(root, ...), mustWork = FALSE)
}

brandthis_store_path <- function(pkg = c("paletteer", "ggsci")) {
  pkg = match.arg(pkg)
  if (pkg == "ggsci"){
    cache_dir <- brandthis_cache_dir("ggsci.ragnar.duckdb")
  }
  if (pkg == "paletteer"){
    cache_dir <- brandthis_cache_dir("paletteer.ragnar.duckdb")
  }
  cache_dir
}

#' Open the ggsci knowledge store
#'
#' Opens a connection to the ggsci documentation database. On first use,
#' this will download the database from GitHub.
#'
#' @param pkg ggsci or paletteer
#'
#' @return A `RagnarStore` object.
#' @keywords internal
brandthis_ragnar_store <- function(pkg = c("paletteer", "ggsci")) {
  pkg = match.arg(pkg)
  path <- brandthis_store_path(pkg)
  if (!file.exists(path)) {
    update_store(pkg)
  }
  ragnar::ragnar_store_connect(path, read_only = TRUE)
}

#' Updates the ggsci knowledge store
#'
#' Downloads the latest version of the store from the brandthis GitHub
#' repository and builds the search index locally.
#'
#' The download location can be configured with a few environment variables:
#' - `BRANDTHIS_STORE_URL`: a custom URL to download the store from. The default is to download the latest store
#' from the `durraniu/brandthis` repository in the `store-v1` release.
#' - `BRANDTHIS_STORE_RELEASE`: the release tag to download the store from. Defaults to `store-v1`.
#' - `BRANDTHIS_STORE_REPOSITORY`: the repository to download the store from. Defaults to `durraniu/brandthis`.
#'
#' @param pkg ggsci or paletteer
#'
#' @return `NULL` invisibly.
#' @export
update_store <- function(pkg = c("paletteer", "ggsci")) {
  pkg = match.arg(pkg)
  path <- brandthis_store_path(pkg)
  fs::dir_create(dirname(path))

  tmp <- withr::local_tempfile()
  utils::download.file(brandthis_store_url(pkg), destfile = tmp, mode = "wb")

  fs::file_move(tmp, path)

  # store <- ragnar::ragnar_store_connect(path, read_only = FALSE)
  # on.exit(DBI::dbDisconnect(store@con), add = TRUE)
  # ragnar::ragnar_store_build_index(store)
  invisible(NULL)
}

brandthis_store_url <- function(pkg = c("paletteer", "ggsci")) {
  pkg = match.arg(pkg)
  url <- Sys.getenv("BRANDTHIS_STORE_URL", "")
  if (nzchar(url)) {
    return(url)
  }
  release <- Sys.getenv("BRANDTHIS_STORE_RELEASE", "store-v1")
  repository <- Sys.getenv(
    "BRANDTHIS_STORE_REPOSITORY",
    "durraniu/brandthis"
  )
  sprintf(
    "https://github.com/%s/releases/download/%s/%s.ragnar.duckdb",
    repository,
    release,
    pkg
  )
}

