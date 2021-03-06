# show states expansion

# done once
# install.packages("USAboundariesData",
#                 repos = "https://ropensci.r-universe.dev",
#                 type = "source")

library(tidyverse)
library(purrr)
library(sf)
library(USAboundaries)
library(leaflet)
library(RColorBrewer)


citation("USAboundaries")

my.palette <- brewer.pal(n = 12, name = "Set3") %>% rep(5)

states <- USAboundaries::us_states("2000-12-31")



increments <- states$start_date %>% unique() %>% sort()



increment <- increments[length(increments)]
current_states <- USAboundaries::us_states()
increment = 10
states <- USAboundaries::us_states(increments[increment])

# recycle colors
color_map <-
  tibble(start_date = increments, color = my.palette[1:length(increments)]) %>%
  rownames_to_column(var = "increment_int")

states <- left_join(states,color_map)

labels <- paste0(states$start_date,"<br>",states$change) %>%
    map(strwrap,40) %>%
  map(paste0,collapse="<br>") %>%
  map(htmltools::HTML)

m <- leaflet(states) %>%
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

m

ggplot() +
  geom_sf(data=current_states) +
  geom_sf(data=states,aes(fill=start_date)) +
  geom_sf_text(aes(label = name),data=states,check_overlap = T) +
  coord_sf(xlim = c(-125,-65),ylim = c(25,50)) +
  theme_minimal()

