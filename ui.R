
library(shiny)
library(DT)
library(plotly)

# Collecting and Formatting data
download.file("https://covid.ourworldindata.org/data/ecdc/total_cases.csv", "data.csv")
data <- read.csv("./data.csv")
data[is.na(data)] <- as.numeric("0")
data$date <- as.Date(data$date, "%d-%m-%Y")


countries <- as.list(colnames(data)[-1])

# Define UI
shinyUI(fluidPage(

    # Application title
    titlePanel("Corona Cases in the World"),

    sidebarLayout(
      sidebarPanel(
          conditionalPanel(
            'input.tabs === Documentation',  
            helpText("Read the Documentation and then switch to the Corona tab")
                          ),
          
          conditionalPanel('input.tabs === Corona',
                        selectInput(inputId = "country",
                        label = "Country (you can choose multiple)",
                        choices = countries,
                        multiple = TRUE,
                        selected = "United.States"
                                  ),
        
                        ),
                      ),
    
      # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            id = 'Corona1',
            tabPanel("Documentation",
                     h1("How to use this App"),
                     h3("1. Click the Corona Tab."),
                     h3("2. Select Countries for from the dropdown list for which you want to see the number of 
                        Corona Cases and how it has grown over time."),
                     h3("3. See the plot below of the number of Corona Cases."),
                     h3("4. Choose multiple countries to compare"),
                     h3("5. Delete the data.csv file from your default folder, if necessary.")
                     ),
            tabPanel("Corona", 
                     dataTableOutput("mytable1"),
                     plotlyOutput("casesplot")
            )
          )
          
        )
    )
)
)