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
current_states <- USAboundaries::us_states("2000-12-31")
increments <- current_states$start_date %>% unique() %>% sort()
color_map <-
  tibble(start_date = increments, color = my.palette[1:length(increments)]) %>%
  rownames_to_column(var = "increment_int")

# debugging
# increment_int <- 1
# increment <- color_map$start_date[increment_int]

# Define server logic required to draw a histogram
function(input, output) {
  output$increment_date <- renderText({
    paste(increments[input$increment_int])
    })

  output$debug <- reactive({
    paste(input$increment_int,increments[input$increment_int])
  })

  output$mapPlot <- renderPlot({
    states <- USAboundaries::us_states(increments[input$increment_int])
    ggplot() +
      geom_sf(data=current_states) +
      geom_sf(data=states,aes(fill=start_date)) +
      geom_sf_text(aes(label = name),data=states,check_overlap = T) +
      coord_sf(xlim = c(-125,-65),ylim = c(25,50)) +
      theme_minimal()
  })

}

