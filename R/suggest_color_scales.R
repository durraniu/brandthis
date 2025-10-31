#' Suggest paletteer or ggsci color palettes and scales
#'
#' @param brand_yml _brand.yml object.
#' @param chat_fn Ellmer chat function, e.g., \code{ellmer::chat_google_gemini}.
#' @param ... Parameters of ellmer chat function.
#' @param pkg paletteer or ggsci
#' @param top_k Number of excerpts to request from the knowledge store for each retrieval
#'
#' @returns Suggested palettes and scales
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
#' suggested_scales <- suggest_color_scales(personal_brand)
#' }
suggest_color_scales <- function(brand_yml,
                                 pkg = c("paletteer", "ggsci"),
                                 top_k = 8L,

                                 chat_fn = ellmer::chat_google_gemini,
                                 ...){
  pkg = match.arg(pkg)
  if (pkg == "ggsci"){
    system_prompt_scs <- system_prompt_scs_ggsci
  }
  if (pkg == "paletteer"){
    system_prompt_scs <- system_prompt_scs_paletteer
  }
  semantic_colors_list <- semantic_colors_as_hex_codes(brand_yml$color)
  # Make one string
  semantic_colors <- paste(names(semantic_colors_list), semantic_colors_list, sep = "=", collapse = ", ")

  client_scs <- make_chat(
    chat_fn,
    system_prompt = system_prompt_scs,
    ...
  )

  ragnar::ragnar_register_tool_retrieve(client_scs, brandthis_ragnar_store(pkg), top_k = top_k)

  client_scs$chat(semantic_colors)

  # palette_suggestion_type <- ellmer::type_object(
  #   scale_name = ellmer::type_string("The name of the ggplot2 scale, e.g. scale_color_nejm('default')"),
  #   palette_name = ellmer::type_string("The name of the palette function and argument, e.g. pal_nejm('default')"),
  #   description = ellmer::type_string("Short description, including which brand color(s) match.")
  # )
  #
  # palette_suggestion_list_type <- ellmer::type_object(
  #   discrete = ellmer::type_array(items = palette_suggestion_type),
  #   sequential = ellmer::type_array(items = palette_suggestion_type),
  #   diverging = ellmer::type_array(items = palette_suggestion_type)
  # )
  #
  # scolors <- client_scs$chat_structured(
  #   semantic_colors,
  #   type = palette_suggestion_list_type,
  #   echo = FALSE
  # )
  #
  # dplyr::bind_rows(
  #   lapply(names(scolors), function(cat) {
  #     if(length(scolors[[cat]])) {
  #       dplyr::bind_rows(scolors[[cat]]) |>
  #         dplyr::mutate(category = cat, .before = scale_name)
  #     }
  #   })
  # )
}


