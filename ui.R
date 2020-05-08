library(shiny)
library(shinythemes)
library(ggplot2)
library(plyr)
library(plotly)
library(shinyLP)
library(DT)
source("vars.R")
# source("cleaner.R")


#tags: https://shiny.rstudio.com/articles/tag-glossary.html

cat("Application started...\n")
#### UI ####
ui <- fluidPage(
  tags$head(
    tags$style("
              [type = 'number'] {
                  height: 25%;
                  width: 33%;
              }
               ")
  ),
  # Source: https://rstudio.github.io/shinythemes/ 
  theme = shinytheme("sandstone"),
  includeCSS("styles.css"),
  
  
  
  ############## HOME PAGE ####################
  navbarPage("2020 Ivy League Men's Basketball",
    tabPanel("Home",
      fluidRow(
        column(12, align="center",
               img(src="https://upload.wikimedia.org/wikipedia/en/thumb/b/b8/Ivy_League_logo.svg/1200px-Ivy_League_logo.svg.png", height=400)
        )
      ),
      h1("Visualizing the 2020 Ivy League Men's Basketball Regular Season", align="center"),
      # Source: https://loremipsum.io/
      p("TODO", align="center"),
      hr(),
      p("Image Source: Ivy League, Wikipedia Creative Commons,", tags$a(href="https://en.wikipedia.org/wiki/Ivy_League#/media/File:Ivy_League_logo.svg", "URL link."))
    ),
  
  ############## PAGE 1 ####################  
    tabPanel("Team Statistics",
             titlePanel("Team Statistics"),
             fluidRow(
               column(12, align="center",
                      DT::dataTableOutput("table_teams", width="100%")
               )
             ),
             # Footer Source: 
             # https://stackoverflow.com/questions/30205034/shiny-layout-how-to-add-footer-disclaimer
             hr(),
             p("Source: Sport-Reference,", tags$a(href= "https://www.sports-reference.com/cbb/conferences/ivy/2020.html", "Data Source"))
    ),
  
  ############## PAGE 2 ####################  
  tabPanel("Team Visualizer",
           titlePanel("Visualizing How Statistics Interact"),
           fluidRow(
             column(6,
                    h4("The following "),
             ),
             column(6,
                    tags$figure(
                      
                      img(src="https://www.onlinegambling.com/news/wp-content/uploads/2020/03/HarvardYaleHoops.jpg", 
                          align="right"),
                      tags$figcaption("Yale's Paul Atkinson Shoots over Mason Forbes' Luscious Locks (Image: Lukas Flippo/Yale Athletics)", align="center")
                      
                    )
             )
           ),
           tags$hr(),
           # Sidebar layout with input and output definitions ----
           sidebarLayout(
             
             
             # Sidebar panel for inputs ----
             sidebarPanel(
               # Source: https://shiny.rstudio.com/reference/shiny/latest/numericInput.html
               h4("Statistics:"),
               selectInput(inputId = "Staty_team",
                           label = "Statistic Y:", display_colnames_teams, selected = "W%", 
                           multiple = FALSE, selectize = TRUE, width = NULL, size = NULL),
               p("Note: This will be plotted on the y-axis"),
               selectInput(inputId = "Statx_team",
                           label = "Statistic X:", display_colnames_teams, selected = "NRtg", 
                           multiple = FALSE, selectize = TRUE, width = NULL, size = NULL),
               p("Note: This will be plotted on the x-axis")
             ),
             
             
             # Main panel for displaying outputs ----
             mainPanel(
               # TODO
               plotlyOutput("plot_team")
             )
           ),
           hr(),
           h4("TODO:"),
           p("TODO"),
           # Footer Source: 
           # https://stackoverflow.com/questions/30205034/shiny-layout-how-to-add-footer-disclaimer
           hr(),
           p("TODO")
           
  ),
  
  
    ############## PAGE 3 ####################
    tabPanel("Player Statistics",
             titlePanel("Full Dataset Player Statistics"),

             # Input: Numerics for the popsize, S and R ----
             # Source: https://shiny.rstudio.com/reference/shiny/latest/numericInput.html
             fluidRow(
               column(4, align="left",
                      numericInput(inputId = "mingames",
                          label = "Min Games Played (range 1 - 30):", 
                          value = 1, min = 1, max = 30, step = 1)
               ),
               column(8, align="left",
                  selectInput(inputId = "col_dt_v2",
                         label = "Display Type:", c("Per Game",
                                                    "Totals",
                                                    "Per 40 Minutes",
                                                    "Advanced",
                                                    "Demographics"), selected = "Per Game")
               ),
             ),

             fluidRow(
               column(12, align="center",
                      DT::dataTableOutput("table2", width="100%")
               )
             ),
          
             # Footer Source:
             # https://stackoverflow.com/questions/30205034/shiny-layout-how-to-add-footer-disclaimer
             hr(),
             p("Source: Sport-Reference,", tags$a(href= "https://www.sports-reference.com/cbb/conferences/ivy/2020.html", "Data Source"))
    ),

    ############## PAGE 4 ####################
    tabPanel("Player Visualizer",
             tabPanel("Player Visualizer",
                      titlePanel("TODO"),
                      tags$hr(),
                      # Sidebar layout with input and output definitions ----
                      sidebarLayout(
                        
                        
                        # Sidebar panel for inputs ----
                        sidebarPanel(
                          # Input: Numerics for the popsize, S and R ----
                          # Source: https://shiny.rstudio.com/reference/shiny/latest/numericInput.html
                          h4("Parameters:"),
                          numericInput(inputId = "mingames_players",
                                       label = "Min Games Played (range 1 - 30):", 
                                       value = 1, min = 1, max = 30, step = 1),
                          selectInput(inputId = "Staty_bb_type",
                                      label = "Statistic Y Type:", c("Per Game", 
                                                                     "Totals", 
                                                                     "Per 40 Minutes", 
                                                                     "Advanced"), selected = "Per Game"),
                          selectInput("Staty_bb",
                                      label = "Statistic Y:",c("PTS")),
                          p("Note: This will be plotted on the y-axis"),
                          selectInput(inputId = "Statx_bb_type",
                                      label = "Statistic X Type:", c("Per Game", 
                                                                     "Totals", 
                                                                     "Per 40 Minutes", 
                                                                     "Advanced"), selected = "Per Game"),
                          selectInput("Statx_bb",
                                      label = "Statistic X:", c("AST")),
                          p("Note: This will be plotted on the x-axis"),
                        ),
                        
                        
                        # Main panel for displaying outputs ----
                        mainPanel(
                          # TODO
                          plotlyOutput("plot2")
                        )
                      ),
                      hr(),
                      h4("TODO:"),
                      p("TODO"),
                      # Footer Source:
                      # https://stackoverflow.com/questions/30205034/shiny-layout-how-to-add-footer-disclaimer
                      hr(),
                      p("TODO")
                      
             )
    )
  ),
  position=c("fixed-top"),
  
  cat("UI Successfully Loaded...\n")
)
