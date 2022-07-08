#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(purrr)
library(sf)
library(USAboundaries)
library(leaflet)
library(RColorBrewer)

my.palette <- brewer.pal(n = 12, name = "Set3") %>% rep(5)
states <- USAboundaries::us_states("2000-12-31")
increments <- states$start_date %>% unique() %>% sort()
color_map <-
  tibble(start_date = increments, color = my.palette[1:length(increments)]) %>%
  rownames_to_column(var = "increment_int")


# Define server logic required to draw a histogram
function(input, output) {

  # Reactive expression for the data subsetted to what the user selected
  states <- reactive({
    USAboundaries::us_states(increment) %>%
      left_join(states,color_map)
  })

  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  labels <- reactive({
    paste0(states$start_date, "<br>", states$change) %>%
      map(strwrap, 40) %>%
      map(paste0, collapse = "<br>") %>%
      map(htmltools::HTML)
  })

  output$distPlot <- renderLeaflet({
    leaflet(states) %>%
      setView(-96, 37.8, 4) %>%
      addPolygons(
        fillColor = states$color,
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      )
  })

  output$bluePlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'steelblue', border = 'white')
  })
}

