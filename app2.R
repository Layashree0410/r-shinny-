library(shiny)
ui <- fluidPage(
  fluidRow(
    column(3, h1("Text 1")),
    column(3, h1("Text 2")),
    column(3, h1("Text 3")),
    column(3, h1("Text 4")),
           ),
  fluidRow(
    column(6, h1("R shinny app is user frindly to build web app")),
    column(6, h1("R shinny app is user frindly to build web app")),
           ),
  fluidRow(
    column(6, h1("R shinny app is user frindly to build web app")),
    column(2, h3("R shinny app is user frindly to build web app")),
    column(2, h3("R shinny app is user frindly to build web app")),
    column(2, h3("R shinny app is user frindly to build web app")),
           ),
  fluidRow(
    column(3, h3("R shinny app is user frindly to build web app")),
    column(3, h3("R shinny app is user frindly to build web app")),
    column(6, h1("R shinny app is user frindly to build web app")),
           ),
  fluidRow(
    column(2, h3("R shinny app is user frindly to build web app")),
           )
)

server <- function(input,output,session){
}

shinyApp(ui,server)


