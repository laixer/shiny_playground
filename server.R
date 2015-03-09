library(dplyr)
library(ggplot2)
library(shiny)

cat("Loading data...")
turnstile_data <- read.csv("model_data.csv.bz2")
turnstile_data <- mutate(turnstile_data,
                         day_week = factor(day_week,
                                           levels=c(
                                             "Monday",
                                             "Tuesday",
                                             "Wednesday",
                                             "Thursday",
                                             "Friday",
                                             "Saturday",
                                             "Sunday"),
                                           ordered = TRUE))
stations <- as.character(unique(turnstile_data$station))
stations <- stations[order(stations)]
days <- as.character(unique(turnstile_data$day_week))
days <- days[order(days)]
# Load pre-computed coefficients as it takes time to compute.
load("fit.Rdata")

shinyServer(function(input, output) {
  output$station_selector <- renderUI({
    selectInput("station", "Station", stations)
  })

  output$hour_selector <- renderUI({
    selectInput("hour", "Hour of day", hours)
  })

  output$prediction <- renderUI({
    model_input = data.frame(station=input$station,time=input$hour * 60 * 60,day_week=input$day)
    HTML(paste("The predicted turnstile entry count for <b>",
          input$station,
          "</b> station on <b>",
          input$day,
          "</b> at <b>",
          input$hour,
          "</b> is <b>",
          round(max(predict(fit, model_input), 0)),
          "</b>."))
  })

  output$ridershipPlot <- renderPlot({
    turnstile_data_for_station <- turnstile_data %>%
      filter(station == input$station) %>%
      group_by(date, day_week) %>%
      summarize(entries = sum(entries)) %>%
      group_by(day_week) %>%
      summarize(entries = mean(entries))
    ggplot(turnstile_data_for_station, aes(day_week, entries, group = "day")) +
      geom_point() +
      geom_line() +
      ylim(0, NA) +
      xlab("day of week") +
      ggtitle(paste("turnstile entry counts for ", input$station))
  })
})