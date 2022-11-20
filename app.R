library(shiny)

# ui required packages
library("shinyWidgets")

# server required packages
library(Quandl)
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

ui <- fluidPage(
  # include css file for styles
  includeCSS("www/style.css"),
  titlePanel("Cryptocurrency Market Data Plots"),
  sidebarPanel(
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
    h2("Description"),
    h4(textOutput("text"))
  )
)

# Output selection information lists
titles <- c(
  "ETH/BTC", "BTC/USD", "ETH/USD", "Bitcoin Average Block Size",
  "Bitcoin Difficulty", "Bitcoin Hash Rate", "Bitcoin Number of Transactions",
  "Bitcoin Number of Transaction per Block", "Bitcoin Miners Revenue",
  "Bitcoin Total Transaction Fees USD", "Bitcoin Market Capitalization"
)
dataSrcCode <- c(
  "BITFINEX/ETHBTC", "BCHAIN/MKPRU",
  "BITFINEX/ETHUSD", "BCHAIN/AVBLS",
  "BCHAIN/DIFF", "BCHAIN/HRATE",
  "BCHAIN/NTRAN", "BCHAIN/NTRBL",
  "BCHAIN/MIREV", "BCHAIN/TRFUS",
  "BCHAIN/MKTCP"
)

server <- function(input, output) {
  Quandl.api_key("aMsGCszXVf33j8xsCtr4")
  dataset_choices <- data.frame(
    Selection = titles,
    Code = dataSrcCode,
    Description = c(
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
    plot_ly(type = "scatter", mode = "lines", name = selection()) %>%
      add_trace(x = dataset$Date, y = y, showlegend = FALSE)
  })
  output$text <- renderText(as.character(
    dataset_choices$Description[dataset_choices$Selection == selection()][1]
  ))
}

shinyApp(ui = ui, server = server)
