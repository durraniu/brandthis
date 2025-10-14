# Following are 50 google font combinations
# SOURCE: https://www.pagecloud.com/blog/best-google-fonts-pairings
# Create vectors for heading and body fonts
heading_font <- c(
  "Playfair Display", "Playfair Display", "Quattrocento", "Quattrocento", "Oswald",
  "Fjalla One", "Lustria", "Cormorant Garamond", "Oswald", "Libre Baskerville",
  "Cinzel", "Sacramento", "Yeseva One", "Libre Baskerville", "Cardo",
  "Lora", "Spectral", "Halant", "Karla", "Lora",
  "Roboto", "Quicksand", "Ubuntu", "Montserrat", "Nunito",
  "Oswald", "Montserrat", "Montserrat", "Open Sans", "Nunito",
  "Arvo", "Abril Fatface", "Playfair Display", "Karla", "Ultra",
  "Nixie One", "Stint Ultra Expanded", "Amatic SC", "Unica One", "Philosopher",
  "Source Sans Pro", "Fjalla One", "Work Sans", "Hind", "Nunito",
  "Oxygen", "PT Sans", "Roboto Condensed", "Raleway", "Roboto"
)

body_font <- c(
  "Source Sans Pro", "Alice", "Quattrocento Sans", "Fanwood Text", "Quattrocento",
  "Libre Baskerville", "Lato", "Proza Libre", "EB Garamond", "Source Sans Pro",
  "Fauna One", "Alice", "Josefin Sans", "Montserrat", "Josefin Sans",
  "Roboto", "Karla", "Nunito Sans", "Karla", "Merriweather",
  "Nunito", "Quicksand", "Open Sans", "Hind", "Pt Sans",
  "Merriweather", "Cardo", "Crimson Text", "Open Sans Condensed", "Nunito",
  "Lato", "Poppins", "Source Sans Pro", "Inconsolata", "Slabo 27px",
  "Ledger", "Pontano Sans", "Andika", "Crimson Text", "Muli",
  "Source Serif Pro", "Cantarell", "Open Sans", "Open Sans", "Open Sans",
  "Source Sans Pro", "Cabin", "Cabin", "Open Sans", "Lora"
)

# Create the dataframe
font_pairings_df <- data.frame(
  heading_font = heading_font,
  body_font = body_font
)

font_pairings_df$fonts <- paste0("H: ", heading_font, ", B: ", body_font)
fonts <- font_pairings_df$fonts

usethis::use_data(fonts, overwrite = TRUE, internal = TRUE)
