#' Create color palettes from the provided _brand.yml
#'
#' @param brand_yml _brand.yml object.
#' @param chat_fn Ellmer chat function, e.g., \code{ellmer::chat_google_gemini}.
#' @param ... Parameters of ellmer chat function.
#'
#' @returns List of color palettes
#' @export
#'
#' @examples
#' \dontrun{
#' personal_brand <- create_brand(
#'   "My name is Paul Blart",
#'   img = "https://free-images.com/md/7687/blue_jay_bird_nature.jpg",
#'   type = "personal",
#'   chat_fn = ellmer::chat_google_gemini
#' )
#' color_palettes <- create_color_palette(personal_brand)
#' }
create_color_palette <- function(brand_yml,
                                chat_fn = ellmer::chat_google_gemini,
                                 ...){

  semantic_colors_list <- semantic_colors_as_hex_codes(brand_yml$color)
  # Make one string
  semantic_colors <- paste(names(semantic_colors_list),
                           semantic_colors_list,
                           sep = "=",
                           collapse = ", ")

  client_ccp <- make_chat(
    chat_fn,
    system_prompt = system_prompt_ccp,
    ...
  )

  palette_type <- ellmer::type_object(
    "A collection of color palettes for ggplot2",
    discrete1 = ellmer::type_array(
      "First discrete palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    ),
    discrete2 = ellmer::type_array(
      "Second discrete palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    ),
    sequential1 = ellmer::type_array(
      "First sequential palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    ),
    sequential2 = ellmer::type_array(
      "Second sequential palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    ),
    sequential3 = ellmer::type_array(
      "Third sequential palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    ),
    diverging1 = ellmer::type_array(
      "First diverging palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    ),
    diverging2 = ellmer::type_array(
      "Second diverging palette: a list of color hex codes without names or comments.",
      items = ellmer::type_string()
    )
  )

  client_ccp$chat_structured(
    semantic_colors,
    type = palette_type,
    echo = FALSE
  )

}
