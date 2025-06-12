library(tidyverse)
library(ggplot2)
library(janitor)
library(stringr)
library(lubridate)
library(shiny)
ui <- fluidPage(
  fluidRow(
    column(4,tableOutput("cleaned_data")),
    column(8,plotOutput("year_wise_plot")),
    column(8,plotOutput("bengaluru_aqi_yearwise")),
    column(8,plotOutput("Co_aqi_yearwise")),
    column(8,plotOutput("BCMB_aqi_yearwise")),
    column(8,plotOutput("pm5_aqi_yearwise"))
 )
)
server <- function(input,output,session){
  data1 <- reactive({
    read_csv("INDIA-AQI-DATA-2015-2020.csv") %>% 
      clean_names()-> aqidf
    
    aqidf %>% 
      mutate(year = date %>% year(),
             month = date %>% month,
             day = date %>% day(),
             week = date %>% week(),
             weekday = date %>% wday(label=T)) -> aqidf1
    
    colnames(aqidf1)
    
    unique(aqidf1$city)
    
    aqidf1 %>% 
      pivot_longer(3:14, names_to = "pollutant", values_to = "Values")
    })
  
  output$cleaned_data<- renderTable({
    data1() %>% 
      group_by(year,pollutant) %>% 
      summarise(mean_value = mean(Values,na.rm = T))
  })
  
  output$year_wise_plot <- renderPlot({
  data1() %>%
      group_by(year,pollutant) %>% 
      summarise(mean_value = mean(Values,na.rm = T)) %>% 
      ggplot(aes(x = year, y = mean_value))+
      geom_line(color = "red")+
      facet_wrap(~pollutant,scales = "free_y")+ ## y axis should be free within its range,as its not for comparision between the pollutants free y axis will be helpfull to visualize each pollutant trend
      labs(title = "Air Pollutants Trend", subtitle = "From 2015=2020",
         x = NULL, y = "Pollutant mean value",caption = "Source: AIQ DATA")+
      theme_linedraw()
  })
  
  output$bengaluru_aqi_yearwise <- renderPlot({
    data1() %>%
    filter(city == "Bengaluru") %>%
    group_by(year, pollutant) %>%
    summarise(mean_value = mean(Values, na.rm = TRUE)) %>% 
    ggplot(aes(x = year, y = mean_value))+
    geom_line(color = "red")+
    facet_wrap(~pollutant,scales = "free_y")+ ## y axis should be free within its range,as its not for comparision between the pollutants free y axis will be helpfull to visualize each pollutant trend
    labs(title = "Bengaluru Air Pollutants Trend", subtitle = "From 2015=2020",
         x = NULL, y = "Pollutant mean value",caption = "Source: AIQ DATA"
    )+
    theme_linedraw()
  })


  output$Co_aqi_yearwise <- renderPlot({
    data1() %>% 
      filter(pollutant == "co") %>%
      group_by(year, pollutant, city) %>%
      summarise(mean_value = mean(Values, na.rm = TRUE), .groups = 'drop') %>% 
      ggplot(aes(x = year, y = mean_value, color = city)) +
      geom_line(size = 1) +
      facet_wrap(~city, scales = "free_y") +
      labs(
        title = "CO Air Pollutants Trend",
        subtitle = "From 2015–2020",
        x = NULL,
        y = "Pollutant Mean Value",
        caption = "Source: AQI DATA"
      ) +
      theme_linedraw()
  })
  
 
  
  output$BCMB_aqi_yearwise <- renderPlot({ 
    data1() %>% 
    filter(city %in% c("Bengaluru","Chennai","Mumbai","Hyderabad")) %>%
    group_by(year,city, pollutant) %>% 
    summarise(mean_value = mean(Values, na.rm = TRUE)) %>% 
    ggplot(aes(x = year, y = mean_value, color = city)) +
    geom_line() +
    facet_wrap(~pollutant, scales = "free_y") +
    labs(
      title = " Metro citiesAir Pollutants Trend",
      subtitle = "From 2015–2020",
      x = NULL,
      y = "Pollutant Mean Value",
      caption = "Source: AQI DATA"
    ) +
    theme_linedraw()
  })
  
   output$pm5_aqi_yearwise <- renderPlot({
    data1() %>%
    filter(pollutant == "pm2_5",city=="Bengaluru",year>=2015 & year <=2020) %>%
    group_by(year, pollutant, city) %>%
    summarise(mean_value = mean(Values, na.rm = TRUE), .groups = 'drop') %>% 
    ggplot(aes(x = year, y = mean_value, color = city)) +
    geom_line(size = 1) +
    facet_wrap(~city, scales = "free_y") +
    labs(title = "pm_5 Air Pollutants Trend",
        subtitle = "From 2015–2020",
        x = NULL,
        y = "Pollutant Mean Value",
        caption = "Source: AQI DATA"
      ) +
      theme_linedraw()
      
    
  })
  }

shinyApp(ui,server)

