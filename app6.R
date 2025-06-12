library(shiny)
ui <- fluidPage(
  numericInput("num1","A", value=0),
  numericInput("num2","B", value=0),
  numericInput("num3","C", value=0),
  textOutput("multiplyabc")
)
server <- function(input,output,session){
  output$multiplyabc <- renderText({
    input$num1 * input$num2 * input$num3
  })
}

shinyApp(ui,server)

