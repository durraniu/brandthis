_Just in case it isn't obvious, some of this text was written by an LLM._

# brandthis R Package

## Overview

`brandthis` is an R package that leverages Large Language Models (LLMs) to automatically generate brand configuration files (`_brand.yml`) and create color palettes for data visualization. It simplifies the process of establishing consistent branding across projects by intelligently extracting colors from images and generating appropriate font combinations.

## Key Features

### 1. **Brand Configuration Generation**
- **`create_brand()`**: Main function to generate `_brand.yml` files
- Supports both **personal** and **company** branding
- Can extract colors from images (URLs or local files)
- Uses LLMs to create semantic color schemes and typography
- Interactive file browsing support

### 2. **Color Palette Creation**
- **`create_color_palette()`**: Generates ggplot2-compatible color palettes from brand configurations
- Creates multiple palette types: discrete, sequential, and diverging
- Integrates with brand semantic colors

### 3. **Color Scale Suggestions**
- **`suggest_color_scales()`**: Recommends color scales from popular R packages
- Supports both **paletteer** and **ggsci** packages
- Uses RAG (Retrieval-Augmented Generation) for intelligent suggestions

## How It Works

### Core Architecture
- Built on the **ellmer** package for LLM interactions
- Supports multiple LLM providers (Google Gemini, GitHub Models, etc.)
- Modular chat object system with registered tools
- Cached knowledge stores for efficient color scale lookups

### Image Processing
- Extracts color palettes from images using `colorfindr` package
- Supports multiple extraction methods (median, mean, mode, hex_freq)
- Validates image formats and accessibility

### Brand Configuration
```yaml
# Example _brand.yml structure
meta:
  version: 1
  name: "Brand Name"
color:
  palette:
    primary: "#FF0000"
    secondary: "#00FF00"
  primary: "primary"
  secondary: "secondary"
```

## Usage Examples

### Personal Branding
```r
# Create personal brand with local image
personal_brand <- create_brand(
  "My name is Katniss Everdeen",
  browse = TRUE,
  type = "personal",
  chat_fn = ellmer::chat_github,
  model = "gpt-4.1"
)
```

### Company Branding
```r
# Create company brand with multiple guideline images
company_brand <- create_brand(
  "Company name is Walmart",
  img = c("walmart-font.png", "walmart-palette.jpeg"),
  type = "company"
)
```

### Color Palette Generation
```r
# Generate ggplot2 color palettes
color_palettes <- create_color_palette(personal_brand)

# Get suggested color scales
suggested_scales <- suggest_color_scales(personal_brand, pkg = "paletteer")
```

## Technical Implementation

### Registered Tools
- **`get_fonts_combination_tool`**: Provides Google Font pairings
- **`check_contrast_tool`**: Validates color accessibility (WCAG compliance)

### Knowledge Management
- Downloads and caches documentation databases from GitHub
- Supports offline operation after initial setup
- Automatic index building for efficient searching


## Dependencies
- **ellmer**: LLM interface and chat management
- **ragnar**: RAG implementation for knowledge retrieval
- **colorfindr**: Image color extraction
- **savonliquide**: Color contrast checking
- **brand.yml**: Brand configuration file handling

The package provides an end-to-end solution for automated brand development, making professional branding accessible through intelligent AI assistance and robust color science principles.

## Corporate Brand Guidelines

Effective corporate brand guidelines should accomplish several key objectives:

1. **Visual Consistency**: Establish a clear color palette using our theming system.
Primary colors should be defined using `class_="btn-primary"` and similar Bootstrap
classes.

2. *Typography Standards*: Maintain consistent font usage across all text elements.
Headers should use the built-in styling provided by the `ui.card_header()` component.

3. `Component Styling`: Apply consistent styling to UI elements such as buttons,
cards, and value boxes. Use the theme parameter in components like
`ui.value_box(theme="primary")`.

4. **Layout Principles**: Follow a grid-based layout system using
`ui.layout_column_wrap()` with appropriate width parameters to ensure consistent
spacing and alignment.

5. *Responsive Design*: Implement layouts that adapt gracefully to different screen
sizes using the `fillable` parameter in page components.

Remember that brand guidelines should serve as a framework for consistency while
remaining flexible enough to accommodate future updates and modifications to the
application interface.
