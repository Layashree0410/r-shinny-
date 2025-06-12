library(tidyverse)
library(ggplot2)
library(janitor)
library(stringr)

library(shiny)
ui <- fluidPage(
  fluidRow(textOutput("total_cases")),
  fluidRow(
    column(2,tableOutput("year_wise_table")),
    column(5,plotOutput("year_wise_plot1")),
    column(5,plotOutput("year_wise_plot2"))
  )
)
server <- function(input,output,session){
  data1<- reactive({
    "10_Property_stolen_and_recovered.csv" %>% 
      read_csv() %>% 
      clean_names()
  })
  
  data2 <- reactive({
    data1() %>% 
      rename("state_ut" = "area_name")
  })
  
  data3 <- reactive({
    data2() %>% 
      filter(group_name != "Total Property")
  })
  
  
  output$total_cases <- renderTable({
    data3() %>%
      pull(cases_property_stolen) %>% 
      sum(na.rm =T)->v
    paste0("Total no of the cases stolen: ",v)
    })
  
  year_wise_summary <- reactive({
    data3 %>% 
      group_by(year) %>% 
      summarise(total_cases = sum(cases_property_stolen, na.rm = T),
                total_value = sum(value_of_property_stolen, na.rm = T)) 
  )}
    output$year_wise_table<-renderTable({
    year_wise_summary %>% 
      mutate(total_cases = total_cases/100000)
    )}
      %>% 
      ggplot(aes(x = year, 
                 y = total_cases)) +
      geom_col(fill = "orange") +
      scale_x_continuous(breaks = c(2000:2011)) +
      labs(title = "Total No of theft cases",
           subtitle = "2001 to 2010",
           x = "Year",
           y = "Total No of cases (Lakh)") +
      theme_light()
    
  })
}

shinyApp(ui,server)

