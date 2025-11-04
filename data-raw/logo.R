library(ggplot2)
library(hexSticker)

robot_plot <- ggplot() +

  # Head (rounded rectangle - using polygon approximation)
  geom_rect(aes(xmin = 0.38, xmax = 0.62, ymin = 0.65, ymax = 0.82),
            fill = "#FFC3A0", color = "#801F69", size = 1) +

  # Antenna base (small rectangle on top of head)
  geom_rect(aes(xmin = 0.48, xmax = 0.52, ymin = 0.82, ymax = 0.85),
            fill = "#801F69", color = "#801F69") +

  # Antenna bulb (circle)
  annotate("point", x = 0.5, y = 0.86, size = 10, color = "#801F69", shape = 19) +
  annotate("point", x = 0.5, y = 0.86, size = 8, color = "#BC3A4F", shape = 19) +

  # Eyes (circles with dark rings)
  annotate("point", x = 0.43, y = 0.76, size = 12, color = "#801F69", shape = 21, fill = "#FFE5E5") +
  annotate("point", x = 0.57, y = 0.76, size = 12, color = "#801F69", shape = 21, fill = "#FFE5E5") +
  annotate("point", x = 0.43, y = 0.76, size = 5, color = "#801F69", shape = 19) +
  annotate("point", x = 0.57, y = 0.76, size = 5, color = "#801F69", shape = 19) +

  # # Mouth panel (lighter rectangle)
  # geom_rect(aes(xmin = 0.40, xmax = 0.60, ymin = 0.655, ymax = 0.68),
  #           fill = "#DC543A", color = "#801F69", size = 0.5) +

  # Smiling mouth (curved line)
  geom_curve(aes(x = 0.43, y = 0.70, xend = 0.57, yend = 0.70),
             curvature = 0.3, color = "#801F69", size = 1.2, lineend = "round") +

  # Neck (small rectangle)
  geom_rect(aes(xmin = 0.45, xmax = 0.55, ymin = 0.60, ymax = 0.65),
            fill = "#FFC3A0", color = "#801F69", size = 0.8) +

  # Upper body (rectangle with "usethis" text area)
  geom_rect(aes(xmin = 0.35, xmax = 0.65, ymin = 0.48, ymax = 0.60),
            fill = "#DC543A", color = "#801F69", size = 1) +

  # Text panel for "usethis"
  geom_rect(aes(xmin = 0.37, xmax = 0.63, ymin = 0.50, ymax = 0.58),
            fill = "#FFE5E5", color = "#801F69", size = 0.5) +

  # Lower body (trapezoid - using polygon)
  annotate("polygon",
           x = c(0.35, 0.65, 0.62, 0.38),
           y = c(0.48, 0.48, 0.25, 0.25),
           fill = "#BC3A4F", color = "#801F69", size = 1) +

  # Ribbed lower body detail (vertical lines)
  geom_segment(aes(x = 0.40, y = 0.25, xend = 0.38, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.43, y = 0.25, xend = 0.42, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.46, y = 0.25, xend = 0.455, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.49, y = 0.25, xend = 0.49, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.51, y = 0.25, xend = 0.51, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.54, y = 0.25, xend = 0.545, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.57, y = 0.25, xend = 0.58, yend = 0.48), color = "#801F69", size = 0.5) +
  geom_segment(aes(x = 0.60, y = 0.25, xend = 0.62, yend = 0.48), color = "#801F69", size = 0.5) +

  # Control panel dots (yellow/orange circles)
  annotate("point", x = 0.43, y = 0.43, size = 5, color = "#DC543A", shape = 19) +
  annotate("point", x = 0.48, y = 0.43, size = 5, color = "#DC543A", shape = 19) +
  annotate("point", x = 0.52, y = 0.43, size = 5, color = "#DC543A", shape = 19) +
  annotate("point", x = 0.57, y = 0.43, size = 5, color = "#DC543A", shape = 19) +

  # Left arm (dark rectangle extending left)
  geom_rect(aes(xmin = 0.20, xmax = 0.35, ymin = 0.50, ymax = 0.56),
            fill = "#801F69", color = "#801F69", size = 1) +

  # Left shoulder joint (rectangle)
  geom_rect(aes(xmin = 0.18, xmax = 0.23, ymin = 0.49, ymax = 0.57),
            fill = "#801F69", color = "#801F69", size = 1) +

  # Left forearm (vertical rectangle)
  geom_rect(aes(xmin = 0.18, xmax = 0.23, ymin = 0.30, ymax = 0.49),
            fill = "#801F69", color = "#801F69", size = 1) +

  # Left hand (wrench shape - simplified as curved polygon)
  annotate("polygon",
           x = c(0.165, 0.185, 0.185, 0.215, 0.215, 0.235, 0.235, 0.215, 0.215, 0.185, 0.185, 0.165),
           y = c(0.26, 0.26, 0.30, 0.30, 0.26, 0.26, 0.23, 0.23, 0.19, 0.19, 0.23, 0.23),
           fill = "#FFC3A0", color = "#801F69", size = 1) +

  # Right arm (dark rectangle extending right)
  geom_rect(aes(xmin = 0.65, xmax = 0.80, ymin = 0.50, ymax = 0.56),
            fill = "#801F69", color = "#801F69", size = 1) +

  # Right shoulder joint (rectangle)
  geom_rect(aes(xmin = 0.77, xmax = 0.82, ymin = 0.49, ymax = 0.57),
            fill = "#801F69", color = "#801F69", size = 1) +

  # Right forearm (vertical rectangle)
  geom_rect(aes(xmin = 0.77, xmax = 0.82, ymin = 0.30, ymax = 0.49),
            fill = "#801F69", color = "#801F69", size = 1) +

  # Right hand (wrench shape)
  annotate("polygon",
           x = c(0.835, 0.815, 0.815, 0.785, 0.785, 0.765, 0.765, 0.785, 0.785, 0.815, 0.815, 0.835),
           y = c(0.26, 0.26, 0.30, 0.30, 0.26, 0.26, 0.23, 0.23, 0.19, 0.19, 0.23, 0.23),
           fill = "#FFC3A0", color = "#801F69", size = 1) +

  # Bottom base (rectangle)
  geom_rect(aes(xmin = 0.42, xmax = 0.58, ymin = 0.15, ymax = 0.25),
            fill = "#DC543A", color = "#801F69", size = 1) +

  # Add text "usethis"
  annotate("text", x = 0.5, y = 0.54, label = "brandthis",
           size = 15, family = "mono", fontface = "bold", color = "#801F69") +

  coord_fixed(ratio = 1) +
  xlim(0.1, 0.9) +
  ylim(0.1, 0.9) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.background = element_rect(fill = "transparent", color = NA)
  )

ggsave(
  "inst/figures/robot.png",
  robot_plot,
  width = 4,
  height = 4,
  units = "in",
  bg = "transparent"
)

sticker("inst/figures/robot.png",
        package = "",
        s_x = 1,
        s_y = 1,
        s_width = 0.8,
        s_height = 1.6,
        h_fill = "#FFE5E5",
        h_color = "#801F69",
        h_size = 1.5,
        filename = "inst/figures/logo.png")




