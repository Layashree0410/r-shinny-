library(shiny)
ui <- fluidPage(
  numericInput("num1","A", value=0),
  numericInput("num2","B", value=0),
  numericInput("num3","C", value=0),
  textOutput("sumabc")
)
server <- function(input,output,session){
  output$sumabc <- renderText({
    input$num1 + input$num2 + input$num3
  })
}

shinyApp(ui,server)
