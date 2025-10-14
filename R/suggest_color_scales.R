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



#' Suggest ggsci color palettes and scales
#'
#' @param brand_yml _brand.yml object
#' @param chat_fn Ellmer chat function, e.g., \code{ellmer::chat_google_gemini}.
#' @param ... Parameters of ellmer chat function.
#'
#' @returns Suggested palettes and scales
#' @export
suggest_color_scales <- function(brand_yml,
                                 chat_fn = ellmer::chat_google_gemini,
                                 ...){
  semantic_colors_list <- semantic_colors_as_hex_codes(brand_yml$color)
  # Make one string
  semantic_colors <- paste(names(semantic_colors_list), semantic_colors_list, sep = "=", collapse = ", ")

  client_scs <- make_chat(
    chat_fn,
    system_prompt = system_prompt_scs,
    ...
  )

  ragnar::ragnar_register_tool_retrieve(client_scs, store, top_k = 10)

  client_scs$chat(semantic_colors)
}


