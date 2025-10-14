#' Create _brand.yml
#'
#' @param prompt User prompt. May include info. about brand name, colors, fonts, and logo.
#' @param img Image URL(s) and/or path(s). Only path(s) are allowed for \code{type = "company"}.
#' @param browse Whether to browse for image(s) in the file system. Default is \code{FALSE}.
#' @param type Brand type. \code{"personal"} or \code{"company"}.
#' @param chat_fn Ellmer chat function, e.g., \code{ellmer::chat_google_gemini}.
#' @param ... Parameters of ellmer chat function.
#'
#' @returns _brand.yml object
#' @export
create_brand <- function(prompt,
                         img = NULL,
                         browse = FALSE,
                         type = c("personal", "company"),
                         chat_fn = ellmer::chat_google_gemini,
                         ...){
  type <- match.arg(type)

  img <- get_image_paths(img = img, browse = browse, type = type)

  client_brand <- make_chat(
    chat_fn,
    system_prompt = system_prompt_brand,
    ...
  )

  client_brand$register_tool(get_fonts_combination_tool)
  client_brand$register_tool(check_contrast_tool)

  if (type == "personal"){
    # Either img is NULL
    prompt <- paste0("Create a personal brand.yml. ", prompt)
    # Or img has a single URL or a single path
    if (!is.null(img)){
      vec_color <- create_palette_from_image(img = img, show = FALSE)
      prompt <- paste0(
        prompt,
        ". The initial color palette is: ",
        paste(vec_color, collapse = ", ")
      )
    }
    res <- client_brand$chat(prompt)
  } else if (type == "company"){
    prompt <- paste0("Create a company brand.yml. ", prompt)
    # Either img has one or more paths
    if (!is.null(img)){
      img_ellmer <- lapply(img, ellmer::content_image_file)
      res <- do.call(client_brand$chat, c(prompt, img_ellmer))
    } else {
      # Or img is NULL
      res <- client_brand$chat(prompt)
    }
  }

  # Make brand.yml:
  cleaned_brand_code <- sub("^```yaml\\s*", "", res)
  cleaned_brand_code <- sub("\\s*```$", "", cleaned_brand_code)

  brand.yml::as_brand_yml(as.character(cleaned_brand_code))
}
