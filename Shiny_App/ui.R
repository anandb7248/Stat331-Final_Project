library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)
library(reshape2)
library(sqldf)
library(rgdal)
library(cdlTools)
library(magrittr)
library(leaflet)
library(readxl)
library(maps)
library(plotrix)

univ_states <- read.csv('./Data/states.csv')
areas <- read.csv('./Data/areas.csv')
univ_states$X <- NULL
areas$X <- NULL
colnames(univ_states) <- 'state'
univ_states$state <- as.character(univ_states$state)
pie_states <- univ_states
metro_areas <- read.csv('./Data/MetroAreas.csv')


header <- dashboardHeader(
   title = "F.B.I. Crime Analytics and Visualizations",
   titleWidth = 450
)

sidebar <-   dashboardSidebar(
   sidebarMenu(
      menuItem("Line Chart", tabName = "LineChart", icon = icon("line-chart")),
      menuItem("Map", tabName = "Map", icon = icon("map")),
      menuItem("Pie Chart", tabName = "PieChart", icon = icon("pie-chart")),
      menuItem("University", tabName = "University", icon = icon("university"))
   )
)

body <- dashboardBody(
   tabItems(
      # First tab content
      tabItem(tabName = "LineChart", h2('Crime Rate Trends in U.S.', style=('text-align:center;')),
              fluidRow(
                 box(title = 'Range of Years',
                     sliderInput('range', "Range of Years:", min = 1995, max = 2015, value = c(1995,2015))
                 ),
                 
                 box(checkboxGroupInput('choice', label = h3("Select Violent Crime to Graph"), 
                                        selected = 'assault_rate', choices = c('Murder' = "murder_rate", 'Rape'="rape_rate", 'Aggravated Assult'="assault_rate", 
                                                                               'Robbery'="robbery_rate")))
                 
              ),
              
              fluidRow(
                 box(title='Rates of Violent Crime per 100,000 Inhabitants', width = 12, 
                     status='primary', plotOutput('LineChart', height = 350))
              )
      ),
      
      # Second tab content
      tabItem(
         tabName = "Map", 
         h2("Rate of Violent Crime in U.S. per 100,0000", style=('text-align: center;')),
         
         fluidRow(
            column(width = 12,
                   box(width = NULL, solidHeader = TRUE, leafletOutput("mymap", height = 500))
            )
         ),
         
         fluidRow(
            column(6,
                   box(width = NULL, status = "warning", 
                       selectInput("crime", "Select Crime",
                                   choices = c("Murder" = 'Murder',"Rape" = 'Rape',
                                               "Assault" = 'Assault',
                                               "Burglary" = 'Burglary'),
                                   selected = 5)
                   )
            ),
            column(6,
                   h4("Data from 2008", style=('text-align: center;')),
                   p(
                      class = "text-muted",
                      paste("Note: Click on any State to get detailed information")
                   )   
            )
         )
      ),
      
      #third tab item
      tabItem(
         tabName = 'PieChart',
         fluidRow(
            column(12,
               box(title = 'Proportion of Crime by Metropolitan Statistical Area', width = 12,
                   status= 'primary', plotOutput('PieChart', height = 450))
            )
         ),
            
         fluidRow(
            column(12,
               box(width = NULL, status = "warning", 
                  selectInput("area", "Select Metroplitan Statistical Area",
                     choices = areas, selected = metro_areas$Metro_Area[10])
                  )
            )
         )
      ),
      
      # Format for The 4th Item
      tabItem(
         tabName = 'University',
         h2('Crime at U.S. Universities in 2015', style=('text-align:center;')),
         
         fluidRow(
            box(title='State of user_chosen', width = 12, 
                status='primary', plotOutput('BarChart', height = 600))
         ),
         
         fluidRow(
            column(6,
                   box(width = NULL, status = "warning", 
                       selectInput("state", "Select State",
                                   choices = univ_states,
                                   selected = univ_states$state[5])
                   )
            )
         )
      )
   )
)

dashboardPage(
   skin = 'red',
   header,
   sidebar,
   body
)
