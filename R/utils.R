#' Get image URL(s) and/or path(s)
#'
#' @param img Image URL(s) and/or path(s).
#' @param browse Whether to browse for image(s) in the file system. Default is \code{FALSE}.
#' @param type Brand type. \code{"personal"} or \code{"company"}.
#'
#' @returns Image URL(s) and/or path(s) as a character vector.
get_image_paths <- function(img = NULL, browse = FALSE, type = c("personal", "company")){
  # Select 1 or more images from the local file system
  if (browse && type == "personal") {
    img <- file.choose()
  } else if (browse && type == "company") {
    img <- tcltk::tk_choose.files()
  }

  # Check if the paths/URLs are of actual images
  if (!is.null(img)) {
    if (!is.character(img)) stop("'img' must be NULL or a character vector of paths/URLs.")

    # Allowed image extensions
    allowed_ext <- c("png", "jpg", "jpeg", "tif", "tiff", "bmp")

    # Extract extensions
    ext <- tolower(tools::file_ext(img))

    if (!all(ext %in% allowed_ext)) {
      stop("All files must be images (png, jpg, jpeg, tif, tiff, bmp).")
    }
  }

  img
}


#' Create a color palette from an image
#'
#' @param img Image URL(s) and/or path(s).
#' @param n Number of colors. Default is 5.
#' @param extract_method Method of color extraction. Default is the \code{median} of the cluster specific RGB values. Other options are \code{"mean"}, \code{"mode"}, and \code{"hex_freq"} (most common hex colors per cluster)
#' @param show Whether to show the generated color palette. Default is \code{FALSE}
#' @param ... Optional arguments in \code{colorfindr::get_colors}
#'
#' @returns Vector of colors
#' create_palette_from_image("https://free-images.com/lg/871f/garden_violet_blooms_profusely_0.jpg")
create_palette_from_image <- function(img = NULL, n = 5, extract_method = "median", show = FALSE, ...){
  if (is.null(img)) stop("'img' must be a character vector of paths/URLs.")

  colz <- colorfindr::get_colors(img, ...)
  pal <- colorfindr::make_palette(colz, n,
                                  extract_method = extract_method, show = show)
  pal
}




#' Get a combination of heading and base Google Fonts
#'
#' @returns Character vector with a single element containing a fonts combination
get_fonts_combination <- function(){
  sample(fonts, 1)
}


#' Make an ellmer chat object
#'
#' @param chat_fn Ellmer chat function, e.g., `chat_google_gemini`
#' @param ... Parameters of ellmer chat function
#'
#' @returns Ellmer chat object
make_chat <- function(chat_fn, ...) {
  chat_fn(...)
}


# Tool: Get Fonts Combination
get_fonts_combination_tool <- ellmer::tool(
  get_fonts_combination,
  name = "get_fonts_combination",
  description = "Returns a vector of 1 pair of google fonts. H indicates heading font and B indicates body font."
)

# Tool: Check Color foreground and Background Contrast
#' @importFrom savonliquide check_contrast
check_contrast_tool <- ellmer::tool(
  check_contrast,
  name = "check_contrast",
  description = "Returns a report of contrast ratio and accessibility result as FAILs or PASSes",
  arguments = list(
    fg_col = ellmer::type_string("Foreground Color", required = TRUE),
    bg_col = ellmer::type_string("Background Color", required = TRUE)
  )
)


#' Get hex codes of all semantic colors
#'
#' @param color_list List containing \code{palette} and semantic colors
#'
#' @returns List of hex codes for each semantic color
semantic_colors_as_hex_codes <- function(color_list) {
  sapply(color_list[!names(color_list) %in% c("palette", "light", "dark")], function(val) {
    if (val %in% names(color_list$palette)) color_list$palette[[val]] else val
  }, simplify = FALSE)
}



#' Launch Shiny App
#'
#' @export
#' @examples
#' \dontrun{
#' run_brand_app()
#' }
run_brand_app <- function() {
  app_dir <- system.file("app", package = "brandthis")

  shiny::runApp(app_dir, display.mode = "normal")
}
