library(shiny)

# ui required packages
# Feature 3: Experiment with packages that add extra features to Shiny.
# Adding `shinyWidgets` library to use pickerInput, which is a selectInput
# substitute with a wide range of customization possibilities.
library("shinyWidgets")

# server required packages
library(Quandl)
# Feature 3: Experiment with packages that add extra features to Shiny.
# Adding `plotly` library to enable interactive charts with plot_ly, which can
# be hovered to display detail info at specific point, be downloaded as png
# image, etc
library(plotly)

# constant variables
minStartDate <- "2009-01-03"
today <- Sys.Date()

# Selection input list
selections <- list(
  "ETH/BTC", "BTC/USD", "ETH/USD", "Bitcoin Average Block Size",
  "Bitcoin Difficulty", "Bitcoin Hash Rate", "Bitcoin Number of Transactions",
  "Bitcoin Number of Transaction per Block", "Bitcoin Miners Revenue",
  "Bitcoin Total Transaction Fees USD", "Bitcoin Market Capitalization"
)

# UI
ui <- fluidPage(
  # include css file for styles
  # Feature 1: Add CSS to make the app look nicer.
  # In the CSS file, I changed the background color of pickerInput to orange
  # when it's focused so that it matches the other widgets' colors.
  includeCSS("www/style.css"),
  titlePanel("Cryptocurrency Market Data Plots"),
  sidebarPanel(
    # Feature 2: Add an image to the UI.
    # Adding an image of various cryptocurrency coins to increase the app's
    # visual appeal and convey a clear understanding of its purpose to users.
    img(width = "100%", src = "crypto.jpg"),
    sliderInput("dates", "Dates",
      min = as.Date(minStartDate, "%Y-%m-%d"), today,
      value = c(today - 365, today),
      timeFormat = "%Y-%m-%d",
    ),
    pickerInput("data", "Data", selections),
    setSliderColor("orange", 1)
  ),
  mainPanel(
    h2("Plot:", textOutput("title")),
    plotlyOutput("plot"),
    h2("Details"),
    h4(textOutput("text"))
  )
)

# Constant variables needed in Server
# Output Selection lists
titles <- c(
  "ETH/BTC", "BTC/USD", "ETH/USD", "Bitcoin Average Block Size",
  "Bitcoin Difficulty", "Bitcoin Hash Rate", "Bitcoin Number of Transactions",
  "Bitcoin Number of Transaction per Block", "Bitcoin Miners Revenue",
  "Bitcoin Total Transaction Fees USD", "Bitcoin Market Capitalization"
)
# Output Data source code lists
dataSrcCode <- c(
  "BITFINEX/ETHBTC", "BCHAIN/MKPRU",
  "BITFINEX/ETHUSD", "BCHAIN/AVBLS",
  "BCHAIN/DIFF", "BCHAIN/HRATE",
  "BCHAIN/NTRAN", "BCHAIN/NTRBL",
  "BCHAIN/MIREV", "BCHAIN/TRFUS",
  "BCHAIN/MKTCP"
)

# Server
server <- function(input, output) {
  Quandl.api_key("aMsGCszXVf33j8xsCtr4")
  dataset_choices <- data.frame(
    Selection = titles,
    Code = dataSrcCode,
    Details = c(
      "Ether (Ethereum Coin) price in Bitcoin",
      "Bitcoin price in USD",
      "Ether (Ethereum Coin) price in USD",
      "The average block size in MB.",
      "A relative measure of how difficult it is to find a new block. The difficulty is adjusted periodically as a function of how much hashing power has been deployed by the network of miners.",
      "The estimated number of tera hashes per second (trillions of hashes per second) the Bitcoin network is performing.",
      "The number of daily confirmed Bitcoin transactions.",
      "The average number of transactions per block.",
      "Total value of coinbase block rewards and transaction fees paid to miners.",
      "The total value of all transaction fees paid to miners in USD (not including the coinbase value of block rewards).",
      "The total USD value of bitcoin supply in circulation, as calculated by the daily average market price across major exchanges."
    )
  )
  selection <- reactive(input$data)
  output$title <- renderText(selection())
  output$plot <- renderPlotly({
    # print(dataset_choices$Selection == selection())
    code <- as.character(dataset_choices$Code[dataset_choices$Selection == selection()][1])
    dataset <- Quandl(code, start_date = input$dates[1], end_date = input$dates[2])
    # change y axis based on the dataset we dealing with
    # if the dataset has no value, it must be dataset related to ETH
    ifelse(is.null(dataset$Value)[1], y <- dataset$High, y <- dataset$Value)
    # Feature 3: Experiment with packages that add extra features to Shiny.
    # Adding `plotly` library to enable interactive charts with plot_ly, which can
    # be hovered to display detail info at specific point, be downloaded as png
    # image, etc
    plot_ly(type = "scatter", mode = "lines", name = selection()) %>%
      add_trace(x = dataset$Date, y = y, showlegend = FALSE)
  })
  output$text <- renderText(as.character(
    dataset_choices$Details[dataset_choices$Selection == selection()][1]
  ))
}

# ShinyApp
shinyApp(ui = ui, server = server)
