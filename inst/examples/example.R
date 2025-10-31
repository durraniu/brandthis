library(ggplot2)
library(ggsci)
library(paletteer)

devtools::document()
devtools::load_all()

cars <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point(aes(colour = factor(cyl)))

mpgs <- ggplot(mpg, aes(displ, hwy, color = hwy)) +
  geom_point(size = 3)

divg <- ggplot(mpg, aes(displ, hwy, color = cty - hwy)) +
  geom_point(size = 3)

# res <- brandthis::create_brand("Name is Mr. Seagull",
#                                img = "https://free-images.com/md/2e8f/alfred_sisley_003.jpg", type = "personal")
res <- brand.yml::read_brand_yml("inst/examples/painting.yml")
#
# res$color |> dput()
list(foreground = "#54684C", background = "#E6EBF1",
     primary = "#54684C", secondary = "#B1A655", tertiary = "#C1B892", )


scolors <- brandthis::suggest_color_scales(res, pkg = "ggsci")
scolors2 <- brandthis::suggest_color_scales(res, pkg = "paletteer")




# scale_disc1 <- eval(parse(text = scolors$scale_name[1]))
# scale_disc2 <- eval(parse(text = scolors$scale_name[2]))
# scale_seq1  <- eval(parse(text = scolors$scale_name[3]))
# scale_seq2  <- eval(parse(text = scolors$scale_name[4]))
# scale_seq3  <- eval(parse(text = scolors$scale_name[5]))
# scale_div1  <- eval(parse(text = scolors$scale_name[6]))
# scale_div2  <- eval(parse(text = scolors$scale_name[7]))



my_theme <- quarto::theme_brand_ggplot2(res)



# discrete
cars + my_theme + scale_color_jco(palette = "default") #scale_disc1
cars + my_theme + scale_color_lancet() #scale_disc2
cars + my_theme + scale_color_paletteer_d("ggthemes::wsj_black_green",
                                          dynamic = FALSE)
cars + my_theme + scale_color_paletteer_d("calecopal::grasswet",
                                          dynamic = FALSE)


# sequential
mpgs + my_theme + scale_color_material("teal") #scale_seq1
mpgs + my_theme + scale_color_material("light-green")#scale_seq2
mpgs + my_theme + scale_color_material("brown")#scale_seq3
mpgs + my_theme + scale_color_paletteer_c("oompaBase::greenscale")
mpgs + my_theme + scale_color_paletteer_c("scico::devon")
mpgs + my_theme + scale_color_paletteer_c("pals::ocean.thermal")

# diverging
divg + my_theme + scale_color_gsea() #scale_div1
divg + my_theme + scale_color_paletteer_c("ggthemes::Red-Green Diverging")#scale_div2
divg + my_theme + scale_color_paletteer_c("ggthemes::Classic Red-White-Green")

