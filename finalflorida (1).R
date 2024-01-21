
library(leaflet)
library(dplyr)
library(readr)

uscities <- read_csv("C:/Users/GOUTHAMI VENKATEH/Downloads/uscities.csv")
college <- read_csv("C:/Users/GOUTHAMI VENKATEH/Downloads/college.csv")

florida_colleges <- college %>%
  filter(state == "FL")

# Merge datasets
florida_colleges_with_population <- merge(florida_colleges, uscities, by = "city", all.x = TRUE)
View(florida_colleges_with_population)

major_cities_florida <- florida_colleges_with_population %>%
  filter(population > 50000)
View(major_cities_florida)

max_radius <- max(florida_colleges_with_population$admission_rate, na.rm = TRUE)
scale_factor_public <- 10  
scale_factor_private <- 10 
max_undergrad_population <- max(florida_colleges_with_population$undergrads, na.rm = TRUE)


florida_map <- leaflet(data = florida_colleges_with_population) %>%
  addTiles() %>%
  
  addCircleMarkers(
    lng = ~lng.x, 
    lat = ~lat.x, 
    radius = ~ifelse(control == "Private", undergrads / max_undergrad_population * scale_factor_private, 
                     undergrads / max_undergrad_population * scale_factor_public),
    fillOpacity = 0.7,
    opacity = 0.4,
    popup = ~paste("College:", name, "<br>Admission Rate:", admission_rate),
    label = ~name,
    color = ~ifelse(control == "Private", "red", "blue"),
    fill = ~ifelse(control == "Private", "red", "blue"),
    group = "Colleges"
  ) %>%
  
  addCircleMarkers(
    data = major_cities_florida,
    lng = ~lng.y,
    lat = ~lat.y,
    radius = ~sqrt(population) * 0.005,
    fillOpacity = 0.07,
    opacity = 0.4,
    popup = ~paste("City:", city, "<br>Population:", population),
    label = ~paste(city, " (Pop:", population, ")"),
    color = "green",
    fill = "green",
    group = "Major Cities"
  ) %>%
  
  addLegend(
    position = "topright",
    title = "Legend",
    colors = c("red", "blue","green"),
    labels = c("Private Colleges", "Public Colleges","MajorCities"),
    opacity = 0.7,
    group = "Colleges"
  
  )
print(florida_map)
      





