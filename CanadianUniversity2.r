library(plotly)
library(httr)
library(jsonlite)

country <- readline(prompt="Enter country:")
country_provided <- paste("http://universities.hipolabs.com/search?country=", toString(country), sep = "")
res <- GET(country_provided)
data = fromJSON(rawToChar(res$content))
lac = c()
lon = c()
name = c()
i = 0;
for (val in data$name)
{
  i = i+1
  res2 <- GET(paste("https://nominatim.openstreetmap.org/search/", toString(val), "?format=json"))
  data2 <-fromJSON(rawTOChar(res2$content))
  if (!is.null(data2$lat))
  {
    latitude = as.numeric(data2$lat)
    longitude = as.numeric(data2$lon)
    lat <-append(lat, latitude)
    lon <-append(lon, longitude)
    name <- append (name, data2$display_name)
    if (i == 5)  # put this here just so that the loop doesn't take too long and can show the result visually using plotly
      break
  }
}
df <- data.frame(lon, lat, name)
area <- map_data(map = "world", reigon = country)
p <- ggplot(area, aes(longitude, latitude)) + borders(regions=country) + geom_point(mapping = aes(text = name, x = lon, y = lat), data = df, colour = "Deep Pink", fill = "Pink", pch = 21, size = 1, alpha=I(0.7))
fig <- ggplotly(p)
fig
#in order to see the figures when running the code use souce("address to file", echo = TRUE) in the R terminal
