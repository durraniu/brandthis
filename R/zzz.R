.onLoad <- function(libname, pkgname) {
  # Brand yml
  system_prompt_brand <- system.file("prompts", "system_prompt_brand.md", package = pkgname)
  if (file.exists(system_prompt_brand)) {
    assign("system_prompt_brand", paste(readLines(system_prompt_brand), collapse = "\n"), envir = parent.env(environment()))
  } else {
    warning("inst/prompts/system_prompt_brand.md file not found.")
  }

  # ggsci duckdb
  # store_path <- system.file("extdata", "ggsci.ragnar.duckdb", package = pkgname)
  # if (file.exists(store_path)) {
  #   assign("store", ragnar::ragnar_store_connect(store_path, read_only = TRUE), envir = parent.env(environment()))
  # }

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
