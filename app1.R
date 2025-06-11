library(shiny)
ui <- fluidPage(
  h1("Hello World"),
  h2("Hello World"),
  h3("Hello World"),
  h4("Hello World"),
  p("This is a paragraph,
    Shinny is on R package that makes it easy to build in")
)
server <- function(input,output,session){
}

shinyApp(ui,server)

