#' Create a chat object for generating _brand.yml
#'
#' @param chat_fn Ellmer chat function, e.g., \code{ellmer::chat_google_gemini}.
#' @param ... Parameters of ellmer chat function.
#'
#' @returns An ellmer chat object
#' @export
chat_brand <- function(chat_fn = ellmer::chat_google_gemini, ...){

  client_brand <- make_chat(
    chat_fn,
    system_prompt = system_prompt_brand,
    ...
  )

  client_brand$register_tool(get_fonts_combination_tool)
  client_brand$register_tool(check_contrast_tool)


  client_brand
}





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
#' @examples
#' \dontrun{
#' # Create a personal _brand.yml with a local image
#' personal_brand <- create_brand(
#'   "My name is Katniss Everdeen",
#'   browse = TRUE,
#'   type = "personal",
#'   chat_fn = ellmer::chat_google_gemini
#' )
#'
#' # Create a personal _brand.yml with an image URL
#' personal_brand <- create_brand(
#'   "My name is Paul Blart",
#'   img = "https://free-images.com/md/7687/blue_jay_bird_nature.jpg",
#'   type = "personal",
#'   chat_fn = ellmer::chat_google_gemini
#' )
#'
#' # If no info. is provided, you will be asked to provide some:
#' brand_no_input <- create_brand(
#'   "",
#'   img = NULL,
#'   type = "personal",
#'   chat_fn = ellmer::chat_google_gemini
#' )
#' # I can help with that! To create your personal
#' # `_brand.yml` file, I'll need a bit more
#' # information. Please provide the following:
#' #
#' # *   **Brand Name** (e.g., John Doe, or a short/full
#' # name) and **Website(s)** (e.g., personal portfolio,
#' # social media links)
#' # *   **Brand Colors** or a **Color Palette** (e.g.,
#' # "I like blue, green, and a touch of orange," or
#' # specific hex codes)
#' # *   **Heading, Base, and Monospace Fonts** (e.g.,
#' # "I'd like Roboto for headings, Open Sans for base
#' # text, and Fira Code for monospace," or you can ask
#' # me to suggest some)
#' # *   **Logo information** (e.g., "I have a logo at
#' # this URL," or "I'd like a placeholder for now")
#'
#' # Create a company _brand.yml with multiple image paths:
#' company_brand <- create_brand(
#'   "Company name is Walmart",
#'   img = c("walmart-font.png",
#'           "walmart-palette.jpeg",
#'           "walmart-logo.png"),
#'   type = "company",
#'   chat_fn = ellmer::chat_google_gemini
#' )
#' }
create_brand <- function(prompt,
                       img = NULL,
                       browse = FALSE,
                       type = c("personal", "company"),
                       chat_fn = ellmer::chat_google_gemini,
                       ...){

  client_brand <- chat_brand(chat_fn, ...)

  type <- match.arg(type)

  img <- get_image_paths(img = img, browse = browse, type = type)

  call_chat <- function(...) {
    tryCatch(
      client_brand$chat(...),
      error = function(e) {
        msg <- paste(
          "Error occurred in chat() call:",
          conditionMessage(e)
        )
        warning(msg)
        structure(
          list(result = NULL, error = msg),
          class = "chat_error"
        )
      }
    )
  }

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
    res <- call_chat(prompt)
  } else if (type == "company"){
    prompt <- paste0("Create a company brand.yml. ", prompt)
    # Either img has one or more paths
    if (!is.null(img)){
      img_ellmer <- lapply(img, ellmer::content_image_file)
      res <- do.call(call_chat, c(prompt, img_ellmer))
    } else {
      # Or img is NULL
      res <- call_chat(prompt)
    }
  }


  if (!grepl("meta", res)){
    return(res)
  }

  # Make brand.yml:
  cleaned_brand_code <- res
  if (grepl("^```yaml", cleaned_brand_code)) {
    cleaned_brand_code <- sub("^```yaml\\s*", "", cleaned_brand_code)
  }
  if (grepl("```\\s*$", cleaned_brand_code)) {
    cleaned_brand_code <- sub("\\s*```\\s*$", "", cleaned_brand_code)
  }

  brand.yml::as_brand_yml(as.character(cleaned_brand_code))
}




