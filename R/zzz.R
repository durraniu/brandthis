.onLoad <- function(libname, pkgname) {
  # Brand yml
  system_prompt_brand <- system.file("prompts", "system_prompt_brand.md", package = pkgname)
  if (file.exists(system_prompt_brand)) {
    assign("system_prompt_brand", paste(readLines(system_prompt_brand), collapse = "\n"), envir = parent.env(environment()))
  } else {
    warning("inst/prompts/system_prompt_brand.md file not found.")
  }

  system_prompt_ccp <- system.file("prompts", "system_prompt_create_color_palette.md", package = pkgname)
  if (file.exists(system_prompt_ccp)) {
    assign("system_prompt_ccp", paste(readLines(system_prompt_ccp), collapse = "\n"), envir = parent.env(environment()))
  } else {
    warning("inst/prompts/system_prompt_ccp file not found.")
  }

   # ggsci suggest scales
  system_prompt_scs_ggsci <- system.file("prompts", "system_prompt_suggest_color_scales1.md", package = pkgname)
  if (file.exists(system_prompt_scs_ggsci)) {
    assign("system_prompt_scs_ggsci", paste(readLines(system_prompt_scs_ggsci), collapse = "\n"), envir = parent.env(environment()))
  } else {
    warning("inst/prompts/system_prompt_suggest_color_scales1.md file not found.")
  }


  # paletteer suggest scales
  system_prompt_scs_paletteer <- system.file("prompts", "system_prompt_suggest_color_scales2.md", package = pkgname)
  if (file.exists(system_prompt_scs_paletteer)) {
    assign("system_prompt_scs_paletteer", paste(readLines(system_prompt_scs_paletteer), collapse = "\n"), envir = parent.env(environment()))
  } else {
    warning("inst/prompts/system_prompt_suggest_color_scales2.md file not found.")
  }
}
