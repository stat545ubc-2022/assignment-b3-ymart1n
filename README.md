# Cryptocurrency Market Data Plots - V2

![](www/crypto.jpg)

This [Shiny App](https://shiny.rstudio.com/) has 11 interactive cryptocurrency market data plots and tables that can be hovered over to show more information at a specific point or downloaded as a png picture, etc. By modifying the date range using the slider on the left panel, users can interact with the plot. The user can also select the data set to be visualised by utilising the select input, which is located at the left panel as well.

## Project Link

https://ymart1n.shinyapps.io/Cryptocurrency-Market-Data-Plots-V2/

## Assignment 4 Option

Option C - Option C – Shiny App

Version 2: https://ymart1n.shinyapps.io/Cryptocurrency-Market-Data-Plots-V2/

## Assignment 3 Option

Option B - your own Shiny app

Version 1: https://ymart1n.shinyapps.io/Cryptocurrency-Market-Data-Plots/

## Features

1. Add CSS to make the app look nicer
    - In the [CSS file](www/style.css), In the CSS file, I changed the background color of pickerInput to orange when it's focused so that it matches the other widgets' colors.
    - The color of sliderInput is also changed to match the colors.

2. Add an image to the UI
    - Adding an [image](www/crypto.jpg) of various cryptocurrency coins to increase the app's visual appeal and convey a clear understanding of its purpose to users.

3. Experiment with packages that add extra features to Shiny
    - Adding [`plotly` library](https://plotly.com/r/) to enable interactive charts with plot_ly, which can be hovered over to show more information at a specific point or downloaded as a png picture, etc.
    - Adding [`shinyWidgets` library](https://github.com/dreamRs/shinyWidgets) to use pickerInput, which is a selectInput substitute with a wide range of customization possibilities.
    
Version 2 Additional Features:

4. Allow the user to download the table in specified time range as a .csv file
    - Implemented using `downloadButton()` and `downloadHandler()` methods.

5. Use the DT package to turn a static table into an interactive table
    - Implemented using `DT::dataTableOutput()` and `DT::renderDataTable()` methods.
  
6. Use `tabsetPanel()` to create an interface with multiple tabs
    - Used `tabsetPanel()` to create two tabs `Interactive Plot` and `Interactive Table`.

## Dataset Acknowledgement

Two data sets published by Quandl on [Nasdaq Data Link](https://data.nasdaq.com/):

- [Bitfinex](https://data.nasdaq.com/data/BITFINEX-bitfinex)
    - Bitfinex is a trading platform for Bitcoin, Litecoin and Darkcoin with many advanced features including margin trading, exchange and peer to peer margin funding.
  
- [Blockchain](https://data.nasdaq.com/data/BCHAIN-blockchain)
    - Blockchain is a website that publishes data related to Bitcoin, updated daily.
  
- How to use Quandl with Nasdaq Data Link Data? Learn more [here](https://data.nasdaq.com/tools/r)
    - Notice: The R package is free. If you would like to make more than 50 calls a day, however, you will need to create a free Nasdaq Data Link account and set your API key: `Quandl.api_key("<YOUR_API_KEY_HERE>")`

