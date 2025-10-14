library(ggplot2)

cars <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point(aes(colour = factor(cyl)))

res <- brandthis::create_brand("Name is Big Head", browse = TRUE)

brandthis::suggest_color_scales(res)
# *   **Discrete palette:**
#   *   `pal_d3(palette = "category10")`
# *   `scale_color_d3(palette = "category10")` or
# `scale_fill_d3(palette = "category10")`
# *   **Sequential palettes:**
#   1.  `pal_material(palette = "deep-orange")`
# *   `scale_color_material(palette = "deep-orange")` or
# `scale_fill_material(palette = "deep-orange")`
# 2.  `pal_material(palette = "blue")`
# *   `scale_color_material(palette = "blue")` or
# `scale_fill_material(palette = "blue")`
# *   **Diverging palette:**
#   *   `pal_gsea(palette = "default")`
# *   `scale_color_gsea(palette = "default")` or
# `scale_fill_gsea(palette = "default")`


my_theme <- quarto::theme_brand_ggplot2(res)

cars + my_theme
cars + my_theme + ggsci::scale_color_d3(palette = "category10")
