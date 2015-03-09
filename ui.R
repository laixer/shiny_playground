library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("NYC Subway Ridership Predictor"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("station_selector"),
      uiOutput("hour_selector"),
      selectInput("day", "Day of week",
                  choices = list("Monday",
                                 "Tuesday",
                                 "Wednesday",
                                 "Thursday",
                                 "Friday",
                                 "Saturday",
                                 "Sunday"),
                  selected = 1)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3("Description"),
      p("This application attempts (poorly) to predict the entry counts at a
           given NYC subway station at a given time and day of week. Select a
           subway station, time of day and day of week and the application
           will make a prediction for the number of entry counts."),
      p("For the selected station, the application will also plot the average
        entry counts by day of week."),
      h3("Prediction"),
      uiOutput("prediction"),
      h3("Ridership by day of week"),
      plotOutput("ridershipPlot")
    )
  )
))

