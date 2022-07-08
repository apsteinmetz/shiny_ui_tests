gridlayout::grid_page(
  layout = c(
    "Title increment_date",
    "sidebar map",
    "sidebar map"
  ),
  row_sizes = c(
    "100px",
    "1fr",
    "1fr"
  ),
  col_sizes = c(
    "250px",
    "1fr"
  ),
  gap_size = "15px",
  gridlayout::grid_panel_stack(
    area = "sidebar",
    item_alignment = "top",
    item_gap = "12px",
    shiny::textOutput(outputId = "start_date"),
    shiny::sliderInput(
      inputId = "increment_int",
      label = "Increment",
      min = 5L,
      max = 50L,
      value = 20L,
      width = "100%"
    )
  ),
  gridlayout::grid_panel_plot(area = "map"),
  gridlayout::grid_panel_text(
    area = "Title",
    content = "US Expansion",
    h_align = "start"
  ),
  gridlayout::grid_panel_stack(
    area = "start_date",
    item_alignment = "center",
    shiny::textOutput(outputId = "increment_date")
  )
)
