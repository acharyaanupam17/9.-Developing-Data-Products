
library(shiny)
library(DT)
library(plotly)

 download.file("https://covid.ourworldindata.org/data/ecdc/total_cases.csv", "data.csv")
 data <- read.csv("./data.csv")
 data[is.na(data)] <- as.numeric("0")

data$date <- as.Date(data[[1]])

# Define server logic 
shinyServer(function(input, output) {

  countries_to_plot <- reactive({input$country})
  columns_to_plot <- reactive({c("date", countries_to_plot())})
  data_to_plot <- reactive({data[ ,columns_to_plot(), drop = FALSE]})
  
  
  output$mytable1 <- renderDataTable({
      
                                    data_to_plot()
    
                                    })
  
  output$casesplot <- renderPlotly({
    
    if (is.null(countries_to_plot()) == TRUE) {
      plot_ly()
    } else {
      p <- plot_ly(data = data_to_plot(), x = data_to_plot()[["date"]], 
             y =  data_to_plot()[,2], type = "scatter", mode = 'line+markers')
      
      add_col <- setdiff(colnames(data_to_plot()),"date")
      
      for(i in add_col){
        p <- p %>% add_trace(x = data_to_plot()[["date"]], y = data_to_plot()[[i]], name = i,
                            type = 'scatter', mode = 'line+markers', 
                            line = list(color = 'rgb(20, 20, 20)', width = 2)
                            )
      }
      p
    }                            
    
                                  })
})
