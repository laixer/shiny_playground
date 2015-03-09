library(ggplot2)
library(shiny)

turnstile_data <- read.csv("turnstile.csv.bz2")
turnstile_data <- mutate(turnstile_data,
                         hour = as.factor(hour),
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
hours <- as.numeric(levels(unique(turnstile_data$hour)))
hours <- hours[order(hours)]
days <- as.character(unique(turnstile_data$day_week))
days <- days[order(days)]
fit <- lm(entries ~ station + hour + day_week, turnstile_data)
shinyServer(function(input, output) {
  output$station_selector <- renderUI({
    selectInput("station", "Station", stations)
  })

  output$hour_selector <- renderUI({
    selectInput("hour", "Hour of day", hours)
  })

  output$prediction <- renderUI({
    model_input = data.frame(station=input$station,hour=input$hour,day_week=input$day)
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