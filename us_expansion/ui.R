gridlayout::grid_page(
  layout = c(
    "header header",
    "sidebar mapPlot"
  ),
  row_sizes = c(
    "100px",
    "1fr"
  ),
  col_sizes = c(
    "250px",
    "1fr"
  ),
  gap_size = "15px",
  gridlayout::grid_panel_text(
    area = "header",
    content = "US_Expansion",
    h_align = "start",
    is_title = TRUE
  ),
  gridlayout::grid_panel_stack(
    area = "sidebar",
    item_alignment = "top",
    item_gap = "12px",
    title = "Settings",
    shiny::sliderInput(
      inputId = "increment_int",
      label = "Statehood Date",
      min = 1L,
      max = 43L,
      value = 1L,
      width = "100%",
      step = 1L
    ),
    shiny::textOutput(outputId = "increment_date")
  ),
  gridlayout::grid_panel_plot(area = "mapPlot")
)
