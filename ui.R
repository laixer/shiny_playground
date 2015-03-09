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
      h3("Prediction"),
      uiOutput("prediction"),
      h3("Ridership graph by day of week"),
      plotOutput("ridershipPlot")
    )
  )
))

