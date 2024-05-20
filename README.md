Florida Colleges and Major Cities Visualization
This project visualizes colleges in Florida and major cities using the leaflet library in R. The dataset includes college information and city population data, which are merged and displayed on an interactive map.

Table of Contents
Introduction
Datasets
Requirements
Installation
Usage
Code Explanation


Introduction
This project provides an interactive map showing the locations of colleges in Florida, differentiated by public and private institutions, as well as major cities with populations over 50,000. The map includes markers with varying sizes and colors based on college admission rates and city populations.

Datasets
uscities.csv: Contains information about cities in the USA, including their population.
college.csv: Contains information about colleges in the USA, including location, control (public/private), and admission rates.
Requirements
R (version 4.0.0 or higher)
The following R packages:
leaflet
dplyr
readr
Installation
Install R from CRAN.
Install the required packages by running the following commands in R:
R
Copy code
install.packages("leaflet")
install.packages("dplyr")
install.packages("readr")
Usage
Clone this repository to your local machine.
Place the uscities.csv and college.csv files in a suitable directory.
Update the file paths in the script to point to the correct location of your CSV files.
Run the script in R or RStudio.
R
Copy code
library(leaflet)
library(dplyr)
library(readr)

uscities <- read_csv("path/to/uscities.csv")
college <- read_csv("path/to/college.csv")

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
Code Explanation
Libraries and Data Loading: Load necessary libraries and datasets.
Data Filtering: Filter the college dataset for colleges in Florida.
Merging Datasets: Merge the filtered colleges dataset with the uscities dataset.
Filtering Major Cities: Filter cities in Florida with populations over 50,000.
Calculating Scale Factors: Calculate maximum values and scale factors for visualization.
Creating the Map: Use leaflet to create an interactive map with different markers for colleges and major cities.
Adding Legends: Add a legend to differentiate between private colleges, public colleges, and major cities.
