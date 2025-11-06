rlang::check_installed(c("shiny", "shinychat", "shinyAce", "bslib", "markdown", "dplyr", "tidyr", "tibble"))
# rlang::check_installed("future")
rlang::check_installed("ggplot2", version = "3.5.2")

# Libraries
library(shiny)
library(shinychat)
library(shinyAce)
library(bslib)
library(brand.yml)
library(quarto)
library(markdown)
library(ellmer)
library(brandthis)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)
# library(future)

# Async processing
# plan(multisession)

# Options
options(bslib.color_contrast_warnings = FALSE)

# Read _brand.yml
brand_path <- "_brand.yml"
brand <- read_brand_yml(brand_path)

# Themes -----
## bslib theme
theme_brand <- bs_theme(brand = brand_path)
## ggplot2 theme
theme_plot <- theme_brand_ggplot2(brand)
theme_set(theme_plot)
## ggplot2 font
thematic::thematic_shiny(
  font = brand_pluck(brand, "typography", "base", "family")
)

# Data
bar_data <- mtcars |>
  count(cyl) |>
  mutate(cyl = as.factor(cyl))

arrests_data <- USArrests |>
  rownames_to_column(var = "State") |>
  pivot_longer(cols = -State, names_to = "Crime", values_to = "Rate") |>
  filter(Crime != "UrbanPop")


# Error notification -----
errors <- rlang::new_environment()

error_notification <- function(context) {
  function(err) {
    time <- as.character(Sys.time())

    msg <- conditionMessage(err)
    # Strip ANSI color sequences from error messages
    msg <- gsub(
      pattern = "\u001b\\[.*?m",
      replacement = "",
      msg
    )
    # Wrap at 40 characters
    msg <- paste(strwrap(msg, width = 60), collapse = "\n")

    err_id <- rlang::hash(list(time, msg))
    assign(err_id, list(message = msg, context = context), envir = errors)

    showNotification(
      markdown(context),
      action = tags$button(
        class = "btn btn-outline-danger pull-right",
        onclick = sprintf(
          "event.preventDefault(); Shiny.setInputValue('show_error', '%s')",
          err_id
        ),
        "Show details"
      ),
      duration = 10,
      type = "error",
      id = err_id
    )
  }
}


# Helper function to pretty format a list with indentation
format_list <- function(lst, indent = 0) {
  # Start with list opening
  result <- "cp <- list(\n"
  indent <- indent + 2
  spaces <- paste(rep(" ", indent), collapse = "")

  # Process each element
  elements <- names(lst)
  for (i in seq_along(elements)) {
    name <- elements[i]
    value <- lst[[name]]

    # Add the element name
    result <- paste0(result, spaces, name, " = ")

    # Format based on the type of the value
    if (is.list(value) && !is.data.frame(value)) {
      # Recursively format nested lists
      result <- paste0(result, format_list(value, indent))
    } else if (is.data.frame(value)) {
      # Format data frames in a readable way
      df_str <- "data.frame(\n"
      df_indent <- paste(rep(" ", indent + 2), collapse = "")

      for (col in names(value)) {
        col_values <- paste(as.character(value[[col]]), collapse = ", ")
        if (is.character(value[[col]])) {
          col_values <- gsub("([^,]+)", "'\\1'", col_values)
        }
        df_str <- paste0(df_str, df_indent, col, " = c(", col_values, ")")
        if (col != utils::tail(names(value), 1)) {
          df_str <- paste0(df_str, ",")
        }
        df_str <- paste0(df_str, "\n")
      }

      df_str <- paste0(df_str, spaces, ")")
      result <- paste0(result, df_str)
    } else if (is.character(value)) {
      # Add quotes for character vectors
      char_values <- paste0("'", value, "'", collapse = ", ")
      result <- paste0(result, "c(", char_values, ")")
    } else if (length(value) > 1) {
      # Format atomic vectors
      vec_values <- paste(value, collapse = ", ")
      result <- paste0(result, "c(", vec_values, ")")
    } else {
      # Single values
      result <- paste0(result, value)
    }

    # Add comma if not the last element
    if (i < length(elements)) {
      result <- paste0(result, ",\n")
    } else {
      result <- paste0(result, "\n")
    }
  }

  # Close the list
  spaces <- paste(rep(" ", indent - 2), collapse = "")
  result <- paste0(result, spaces, ")")

  return(result)
}




# App sidebar (contains _brand.yml) ------
brand_sidebar <- sidebar(
  id = "sidebar_editor",
  position = "left",
  open = TRUE,
  width = "80%",
  bg = "var(--bs-dark)",
  fg = "var(--bs-light)",
  ### brandthis sidebar
  layout_sidebar(
    sidebar = sidebar(
      id = "chat_sidebar",
      open = FALSE,
      width = "40%",
      bg = "var(--bs-dark)",
      fg = "var(--bs-light)",
      fileInput("image_upload", h5("Upload image(s)"),
        multiple = TRUE,
        accept = c("image/png", "image/jpeg"),
        placeholder = "Drag and drop images",
        width = "100%"
      ),
      chat_ui(
        id = "chat",
        messages = "**Hello! I am here to help you make _brand.yml and ggplot2 color palettes** Please tell me: (1) the type of brand (personal/company) you want (required), (2) brand name (required) and website link(s), (3) optionally upload 1 inspiring image (for personal brand) OR multiple screenshots of company branding guidelines (for company brand), or you may also just provide me color and font info without uploading images"
      )
    ),
    ### Card containing _brand.yml
    card(
      card_header(
        class = "text-bg-secondary hstack",
        div("Edit", code("brand.yml")),
        div(
          class = "ms-auto d-flex align-items-center gap-2",
          actionLink(
            "show_chat",
            bsicons::bs_icon(
              "stars",
              size = "1.5rem",
              title = "Show/hide editor"
            ),
            class = "nav-link"
          ),
          tooltip(
            tags$a(
              class = "btn btn-link p-0",
              href = "https://posit-dev.github.io/brand-yml/brand/",
              target = "_blank",
              bsicons::bs_icon(
                "question-square-fill",
                title = "About brand.yml",
                size = "1.25rem"
              )
            ),
            "About brand.yml"
          )
        )
      ),
      aceEditor("txt_brand_yml",
        value = paste(readLines(brand_path, warn = FALSE), collapse = "\n"),
        mode = "yaml",
        theme = "xcode",
        height = "400px",
        fontSize = 14,
        wordWrap = TRUE,
        showPrintMargin = FALSE,
        highlightActiveLine = TRUE
      )
    )
  ),
  tags$style(
    HTML(
      ".bslib-sidebar-layout .sidebar-title { margin-bottom: 0 }
        #sidebar_editor .sidebar-content { height: max(600px, 100%) }"
    )
  ),
  shiny::downloadButton(
    "download",
    label = span("Download", code("_brand.yml"), "file"),
    class = "btn-outline-light"
  )
)



## In/Out page -----
page_dashboard <- nav_panel(
  "Input Output Demo",
  value = "dashboard",
  layout_sidebar(
    sidebar = sidebar(
      sliderInput("slider1", "Numeric Slider Input", 0, 11, 11),
      numericInput("numeric1", "Numeric Input Widget", 30),
      dateInput("date1", "Date Input Component", value = "2024-01-01"),
      input_switch("switch1", "Binary Switch Input", value = TRUE),
      radioButtons(
        "radio1",
        "Radio Button Group",
        choices = c("Option A", "Option B", "Option C", "Option D")
      ),
      p("Buttons"),
      actionButton("btn_default", "Default"),
      actionButton("btn_primary", "Primary", class = "btn-primary"),
      actionButton("btn_secondary", "Secondary", class = "btn-secondary"),
      actionButton("btn_success", "Success", class = "btn-success"),
      actionButton("btn_danger", "Danger", class = "btn-danger"),
      actionButton("btn_warning", "Warning", class = "btn-warning"),
      actionButton("btn_info", "Info", class = "btn-info")
    ),
    shiny::useBusyIndicators(),
    layout_column_wrap(
      value_box(
        title = "Primary Color",
        value = "100",
        theme = "primary",
        id = "value_box_one"
      ),
      value_box(
        title = "Secondary Color",
        value = "200",
        theme = "secondary",
        id = "value_box_two"
      ),
      value_box(
        title = "Info. Color",
        value = "300",
        theme = "info",
        id = "value_box_three"
      )
    ),
    # card(
    #   card_header("Plot Output"),
    #   plotOutput("out_plot")
    # ),
    layout_column_wrap(
      width = 100,
      heights_equal = "row",
      card(
        card_header("Radio Button Examples"),
        radioButtons(
          "radio2",
          "Standard Radio Group",
          choices = c("Selection 1", "Selection 2", "Selection 3")
        ),
        radioButtons(
          "radio3",
          "Inline Radio Group",
          choices = c("Option 1", "Option 2", "Option 3"),
          inline = TRUE
        )
      ),
      card(
        card_header("Checkbox Examples"),
        checkboxGroupInput(
          "check1",
          "Standard Checkbox Group",
          choices = c("Item 1", "Item 2", "Item 3")
        ),
        checkboxGroupInput(
          "check2",
          "Inline Checkbox Group",
          choices = c("Choice A", "Choice B", "Choice C"),
          inline = TRUE
        )
      ),
      card(
        card_header("Select Input Widgets"),
        selectizeInput(
          "select1",
          "Selectize Input",
          choices = c("Selection A", "Selection B", "Selection C")
        ),
        selectInput(
          "select2",
          "Multiple Select Input",
          choices = c("Item X", "Item Y", "Item Z"),
          multiple = TRUE
        )
      ),
      card(
        card_header("Text Input Widgets"),
        textInput("text1", "Text Input"),
        textAreaInput(
          "textarea1",
          "Text Area Input",
          value = "Default text content for the text area widget"
        ),
        passwordInput("password1", "Password Input")
      )
    ),
    card(
      card_header("Text Output"),
      verbatimTextOutput("out_text")
    )
  )
)



# Docs page -----
page_docs <- nav_panel(
  "Documentation",
  div(
    class = "container-sm overflow-y-auto",
    includeMarkdown("documentation.md")
  )
)


# Plots page -----
page_plots <- nav_panel(title = "Plots",
          h3("Palettes and Plots"),
          input_task_button("create_palettes",
                            "Create Palettes and Plots",
                            style = "width: 300px;"),
          aceEditor("palette_editor",
                    readOnly = TRUE,
                    value = "Palettes will appear here",
                    mode = "r",
                    theme = "xcode",
                    height = "200px",
                    fontSize = 14,
                    wordWrap = TRUE,
                    showPrintMargin = FALSE,
                    highlightActiveLine = TRUE),
          card(
            min_height = "800px",
            layout_columns(
              col_widths = c(6, 6),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Discrete Palette 1"),
                plotOutput("bar_plot")
              ),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Discrete Palette 2"),
                plotOutput("box_plot")
              )
            ),
            layout_columns(
              col_widths = c(4, 4, 4),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Sequential Palette 1"),
                plotOutput("heat1_plot")
              ),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Sequential Palette 2"),
                plotOutput("heat2_plot")
              ),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Sequential Palette 3"),
                plotOutput("s3_plot")
              )
            ),
            layout_columns(
              col_widths = c(6, 6),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Diverging Palette 1"),
                plotOutput("d1_plot")
              ),
              card(
                full_screen = TRUE,
                # min_height = "500px",
                card_header("Diverging Palette 2"),
                plotOutput("d2_plot")
              )
            )
          )

         )



# UI ------
ui <- page_navbar(
  theme = theme_brand,
  title = tagList(
    brand.yml::brand_use_logo(brand, "medium"),
    "createBranding"
  ),
  fillable = TRUE,
  sidebar = brand_sidebar,
  page_dashboard,
  page_docs,
  page_plots
)



# Server ------
server <- function(input, output, session) {

  brand_yml_text <- debounce(reactive(input$txt_brand_yml), 1000)
  brand_yml <- reactiveVal()



  # Show error when something goes wrong with _brand.yml
  observeEvent(input$show_error, {
    req(input$show_error)
    err <- get0(input$show_error, errors)

    if (is.null(err)) {
      message("Could not find error with id ", input$show_error)
      return()
    }

    removeNotification(input$show_error)
    rm(list = input$show_error, envir = errors)

    showModal(
      modalDialog(
        size = "l",
        easyClose = TRUE,
        markdown(err$context),
        pre(err$message)
      )
    )
  })

  # Show chat sidebar
  observeEvent(input$show_chat, sidebar_toggle("chat_sidebar"))

  # Make brand_yml from the yaml in the editor
  observeEvent(brand_yml_text(), {
    req(brand_yml_text())

    tryCatch(
      {
        b <- yaml::yaml.load(brand_yml_text())
        b$path <- normalizePath(brand_path)
        brand_yml(b)
      },
      error = error_notification(
        "Could not parse `_brand.yml` file. Check for syntax errors."
      )
    )
  })


  # Make the app theme based on the current brand_yml
  observeEvent(brand_yml(), {
    req(brand_yml())

    tryCatch(
      {
        theme <- bs_theme(brand = brand_yml())
        session$setCurrentTheme(theme)
      },
      error = error_notification(
        "Could not compile branded theme. Please check your `_brand.yml` file."
      )
    )
  })


  # Download current brand_yml
  output$download <- downloadHandler(
    filename = "_brand.yml",
    content = function(file) {
      validate(
        need(input$txt_brand_yml, "_brand.yml file contents cannot be empty.")
      )
      writeLines(input$txt_brand_yml, file)
    }
  )


  # PlotTask <- ExtendedTask$new(function() {
  #
  #   future({
  #     bar_data <- mtcars |>
  #       count(cyl) |>
  #       mutate(cyl = as.factor(cyl))
  #
  #     bar_plot <- ggplot(bar_data, aes(x = cyl, y = n, fill = cyl)) +
  #       geom_bar(stat = "identity")
  #
  #     bar_plot
  #   })
  # })
  #
  # observe({
  #   PlotTask$invoke()
  # })
  #
  # output$out_plot <- renderPlot({
  #   PlotTask$result()
  # })




  output$out_text <- renderText({
    "example_function <- function() {\n  return(\"Function output text\")\n}"
  })





  ## Generating _brand.yml --------
  client_brand <- brandthis::chat_brand(
    ellmer::chat_google_gemini,
    echo = TRUE
  )

  # Initialize a flag to check if images are sent
  images_sent <- reactiveVal(FALSE)

  # Variable to store image contents
  image_contents <- reactiveVal(NULL)

  brand_code <- reactiveVal(NULL)

  observeEvent(input$image_upload, {
    # Reset the flag
    images_sent(FALSE)

    # Store image contents
    image_contents(lapply(input$image_upload$datapath, content_image_file))
  })

  observeEvent(input$chat_user_input, {
    ## If images are uploaded, attach them with the chat
    if (!images_sent() && !is.null(image_contents())) {
      response_promise <- do.call(client_brand$chat_async, c(list(input$chat_user_input), image_contents()))
      images_sent(TRUE)
    } else {
      ## Otherwise just chat without images
      response_promise <- client_brand$chat_async(input$chat_user_input)
    }

    response_promise$then(function(response) {
      brand_code(response)
      chat_append("chat", response)
    })
  })

  observeEvent(brand_code(), {

    if (grepl("meta", brand_code())) {
      # Remove the backticks before and after the _brand.yml
      cleaned_brand_code <- sub("^```yaml\\s*", "", brand_code())
      cleaned_brand_code <- sub("\\s*```\\s*$", "", cleaned_brand_code)

      updateAceEditor(session, "txt_brand_yml", value = cleaned_brand_code)
    }
  })



  # Create palettes
  palettes_from_llm_edited <- reactiveVal()

  observeEvent(input$create_palettes, {
    color_palette <- brandthis::create_color_palette(
      brand.yml::as_brand_yml(input$txt_brand_yml)
      )
    palettes_from_llm_edited(color_palette)

    list_str <- format_list(color_palette)

    updateAceEditor(session, "palette_editor", value = list_str)
  })

  # Plots
  ## Bar
  output$bar_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    bar_plot <- ggplot(bar_data, aes(x = cyl, y = n, fill = cyl)) +
      geom_bar(stat = "identity")

    bar_plot + scale_fill_manual(values = cp$discrete1)
  })

  ## Box
  output$box_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    box_plot <- ggplot(ToothGrowth, aes(x = as.factor(dose),
                                        y = len, fill = as.factor(dose))) +
      geom_boxplot()

    box_plot + scale_fill_manual(values = cp$discrete1)
  })

  ## Heatmap 1
  output$heat1_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    heat_map <- ggplot(arrests_data, aes(x = Crime, y = State, fill = Rate)) +
      geom_tile()

    heat_map + scale_fill_gradientn(colors = cp$sequential1)
  })

  ## Heatmap 2
  output$heat2_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    heat_map <- ggplot(arrests_data, aes(x = Crime, y = State, fill = Rate)) +
      geom_tile()

    heat_map + scale_fill_gradientn(colors = cp$sequential2)
  })

  ## Scatter 1
  output$s3_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    scatter_plot <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
      geom_point(size = 4)

    scatter_plot + scale_color_gradientn(colors = cp$sequential3)
  })

  ## Scatter 2
  output$d1_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    scatter_diverging <- ggplot(mtcars, aes(x = wt, y = mpg, color = disp)) +
      geom_point(size = 4, alpha = 0.8)

    scatter_diverging + scale_color_gradientn(colors = cp$diverging1)
  })

  ## Scatter 2
  output$d2_plot <- renderPlot({
    req(palettes_from_llm_edited())
    cp <- palettes_from_llm_edited()

    scatter_diverging <- ggplot(mtcars, aes(x = wt, y = mpg, color = disp)) +
      geom_point(size = 4, alpha = 0.8)

    scatter_diverging + scale_color_gradientn(colors = cp$diverging2)
  })
}

shinyApp(ui, server)
