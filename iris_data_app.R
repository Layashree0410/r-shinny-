library(tidyverse)
library(ggplot2)

library(shiny)

ui <- fluidPage(
  selectInput("species", "Select Species",choices = c("setosa", "versicolor", "virginica")),
  plotOutput("speciesplot"),
  tableOutput("speciestable")
)

server <- function(input,output,session){
  
  speciesdata <- reactive({
    iris %>%
      filter(Species == input$species)
  })
  
  output$speciesplot <- renderPlot({
    speciesdata()%>% 
      ggplot(aes(x= Sepal.Length, y= Sepal.Width))+
      geom_point()+
      labs(tittle = input$species)
  })


output$speciestable <- renderTable({
  speciesdata()
})

}

shinyApp(ui,server)

