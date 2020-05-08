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
              ul {
                  text-align: left;
                }
                
              li {
                display: table;
                text-align: left;
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
      p("2020 Ivy League Men's Basketball statistics with interactive visualizations for easy comparison", align="center", style="font-size:18px;"),
      hr(),
      p("Source: Sport-Reference,", tags$a(href= "https://www.sports-reference.com/cbb/conferences/ivy/2020.html", "Data Source")),
      p("Image Source: Ivy League, Wikipedia Creative Commons,", tags$a(href="https://en.wikipedia.org/wiki/Ivy_League#/media/File:Ivy_League_logo.svg", "URL link."))
    ),
    
  
    ############## PAGE 1 ####################
    tabPanel("Player Statistics",
             titlePanel("Player Statistics"),

             # Input: Numerics for the popsize, S and R ----
             # Source: https://shiny.rstudio.com/reference/shiny/latest/numericInput.html
             fluidRow(
               column(4, align="left",
                      selectInput(inputId = "mingames",
                                  label = "Filter by Min Games Played:", 1:30, selected = 1)
                      # numericInput(inputId = "mingames",
                      #     label = "Filter by Min Games Played (1 - 30):", 
                      #     value = 1, min = 1, max = 30, step = 1)
               ),
               column(4, align="left",
                      selectInput(inputId = "school_filter",
                                  label = "Filter by School:", c("Full",schools), selected = "Full")
               ),
               column(4, align="left",
                      selectInput(inputId = "col_dt_v2",
                                  label = "Statistic Type (PG, Totals, per 40, etc.) :", c("Per Game",
                                                             "Totals",
                                                             "Per 40 Minutes",
                                                             "Advanced",
                                                             "Demographics"), selected = "Per Game")
               )
             ),
             tags$br(),
             p("Note: Click column headers to sort them or click-and-drag to reorder them. Click rows to highlight them and hold command to highlight multiple rows at once.", 
               "Use the search bar to search for specific players. Use the above boxes to filter rows or change the type of statistics displayed."),
             tags$br(),
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

    
    
    
    
    ############## PAGE 2 ####################
    tabPanel("Player Visualizer",
                titlePanel("Player Visualizer"),
                p("Note: Choose statistics to plot on the x- and y-axes. Use the box below to filter players by minimum games played. Hover over data points for more information.", 
               "Click on school names on the legend to filter by team. Use the buttons at the top of the graph to change the window size. Draw a box on the graph with you cursor to zoom in."),
                tags$br(),
                tags$hr(),
                # Sidebar layout with input and output definitions ----
                sidebarLayout(
                  
                  
                  # Sidebar panel for inputs ----
                  sidebarPanel(
                    # Input: Numerics for the popsize, S and R ----
                    # Source: https://shiny.rstudio.com/reference/shiny/latest/numericInput.html
                    h4("Parameters:"),
                    selectInput(inputId = "mingames_players",
                                label = "Min Games Played (1 - 30):", 1:30, selected = 1),
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
                    plotlyOutput("plot2")
                  )
                ),
                # Footer Source:
                # https://stackoverflow.com/questions/30205034/shiny-layout-how-to-add-footer-disclaimer
                hr(),
                p("Source: Sport-Reference,", tags$a(href= "https://www.sports-reference.com/cbb/conferences/ivy/2020.html", "Data Source"))
    ),
  
    ############## PAGE 3 ####################  
    tabPanel("Team Statistics",
             titlePanel("Team Statistics"),
             p("Note: Click column headers to sort them or click-and-drag to reorder them. Click rows to highlight them and hold command to highlight multiple rows at once.", 
               "Use the search bar to search for specific teams."),
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
    
    ############## PAGE 4 ####################  
    tabPanel("Team Visualizer",
             titlePanel("Team Visualizer"),
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
                 plotlyOutput("plot_team")
               )
             ),
             hr(),
             p("Source: Sport-Reference,", tags$a(href= "https://www.sports-reference.com/cbb/conferences/ivy/2020.html", "Data Source"))
    ),
    
    
    
    tabPanel("Glossary",
             titlePanel(h1("Glossary of Basketball Statistics", align="center")),
             fluidRow(
               column(4,
                      h4("Basic Individual Stats: "),
                      tags$li(p(tags$b("G: "), "Games")),
                      tags$li(p(tags$b("GS: "), "Games Started")),
                      tags$li(p(tags$b("MP: "), "Minutes Played")),
                      tags$li(p(tags$b("FG: "), "Field Goals")),
                      tags$li(p(tags$b("FGA: "), "Field Goal Attempts")),
                      tags$li(p(tags$b("FG%: "), "Field Goal Percentage")),
                      tags$li(p(tags$b("2P: "), "2 Point Field Goals Made")),
                      tags$li(p(tags$b("2PA: "), "2 Point Field Goal Attempts")),
                      tags$li(p(tags$b("2P%: "), "2 Point Field Percentage")),
                      tags$li(p(tags$b("3P: "), "3 Point Field Goals Made")),
                      tags$li(p(tags$b("3PA: "), "3 Point Field Goal Attempts")),
                      tags$li(p(tags$b("3P%: "), "3 Point Field Goal Percentage")),
                      tags$li(p(tags$b("FT: "), "Free Throws")),
                      tags$li(p(tags$b("FTA: "), "Free Throw Attempts")),
                      tags$li(p(tags$b("FT%: "), "Free Throws Percentage")),
                      tags$li(p(tags$b("ORB: "), "Offensive Rebounds")),
                      tags$li(p(tags$b("DRB: "), "Defensive Rebounds")),
                      tags$li(p(tags$b("TRB: "), "Total Rebounds")),
                      tags$li(p(tags$b("AST: "), "Assists")),
                      tags$li(p(tags$b("STL: "), "Steals")),
                      tags$li(p(tags$b("BLK: "), "Blocks")),
                      tags$li(p(tags$b("TOV: "), "Turnovers")),
                      tags$li(p(tags$b("PF: "), "Personal Fouls")),
                      tags$li(p(tags$b("PTS: "), "Points")),
                      tags$li(p(tags$b("SOS: "), "Strength of Schedule - A rating of strength of schedule. The rating is denominated in points above/below average, where zero is average. Non-Division I games are excluded from the ratings."))
                      
                      
               ),
               column(4,
                      h4("Advanced Individual Stats: "),
                      tags$li(p(tags$b("TS%: "), "True Shooting Percentage - A measure of shooting 
                                                    efficiency that takes into account 2-point field goals, 3-point field goals, and free throws.")),
                      tags$li(p(tags$b("eFG%: "), "Effective Field Goal Percentage - this statistic adjusts for the fact that a 3-point field goal is worth one more point than a 2-point field goal.")),
                      tags$li(p(tags$b("3PAr: "), "3-Point Attempt Rate - Percentage of FG Attempts from 3-Point Range")),
                      tags$li(p(tags$b("FTr: "), "Free Throw Attempt Rate - Number of FT Attempts Per FG Attempt")),
                      tags$li(p(tags$b("PProd: "), "Points Produced - an estimate of the player's offensive points produced.")),
                      tags$li(p(tags$b("ORB%: "), "Offensive Rebound Percentage - an estimate of the percentage of available offensive rebounds a player grabbed while he was on the floor.")),
                      tags$li(p(tags$b("DRB%: "), "Defensive Rebound Percentage; an estimate of the percentage of available defensive rebounds a player grabbed while he was on the floor.")),
                      tags$li(p(tags$b("TRB%: "), "Total Rebound Percentage - An estimate of the percentage of available rebounds a player grabbed while he was on the floor.")),
                      tags$li(p(tags$b("AST%: "), "Assist Percentage - An estimate of the percentage of teammate field goals a player assisted while he was on the floor.")),
                      tags$li(p(tags$b("STL%: "), "Steal Percentage - An estimate of the percentage of opponent possessions that end with a steal by the player while he was on the floor.")),
                      tags$li(p(tags$b("BLK%: "), "Block Percentage - An estimate of the percentage of opponent two-point field goal attempts blocked by the player while he was on the floor.")),
                      tags$li(p(tags$b("TOV%: "), "Turnover Percentage - an estimate of turnovers per 100 plays.")),
                      tags$li(p(tags$b("USG%: "), "Usage Percentage - an estimate of the percentage of team plays used by a player while he was on the floor.")),
                      tags$li(p(tags$b("OWS: "), "Offensive Win Shares - an estimate of the number of wins contributed by a player due to his offense.")),
                      tags$li(p(tags$b("DWS: "), "Defensive Win Shares - an estimate of the number of wins contributed by a player due to his defense.")),
                      tags$li(p(tags$b("WS: "), "Win Shares - an estimate of the number of wins contributed by a player due to his offense and defense.")),
                      tags$li(p(tags$b("WS/40: "), "Win Shares Per 40 Minutes - an estimate of the number of wins contributed by a player per 40 minutes (average is approximately .100).")),
                      tags$li(p(tags$b("OBPM: "), "Offensive Box Plus/Minus - A box score estimate of the offensive points per 100 possessions a player contributed above a league-average player, translated to an average team.")),
                      tags$li(p(tags$b("DBPM: "), "Defensive Box Plus/Minus - A box score estimate of the defensive points per 100 possessions a player contributed above a league-average player, translated to an average team.")),
                      tags$li(p(tags$b("BPM: "), "Box Plus/Minus - A box score estimate of the points per 100 possessions a player contributed above a league-average player, translated to an average team."))
               ),
               column(4, align="left",
                      h4("Team Stats:", align="left"),
                      tags$li(p(tags$b("Conf: "), "Conference Games")),
                      tags$li(p(tags$b("Home: "), "Home Games")),
                      tags$li(p(tags$b("Away: "), "Away Games")),
                      tags$li(p(tags$b("ORtg: "), "Offensive Rating - offensive rating is the number of points produced by a team per hundred total individual possessions.")),
                      tags$li(p(tags$b("DRtg: "), "Defensive Rating - offensive rating is the number of points allowed by a team per hundred total individual possessions.")),                      
                      tags$li(p(tags$b("NRtg: "), "Net Rating - an estimate of point differential per 100 possessions.")),
                      tags$li(p(tags$b("FG: "), "Field Goals")),
                      tags$li(p(tags$b("FGA: "), "Field Goal Attempts")),
                      tags$li(p(tags$b("FG%: "), "Field Goal Percentage")),
                      tags$li(p(tags$b("2P: "), "2 Point Field Goals Made")),
                      tags$li(p(tags$b("2PA: "), "2 Point Field Goal Attempts")),
                      tags$li(p(tags$b("2P%: "), "2 Point Field Percentage")),
                      tags$li(p(tags$b("3P: "), "3 Point Field Goals Made")),
                      tags$li(p(tags$b("3PA: "), "3 Point Field Goal Attempts")),
                      tags$li(p(tags$b("3P%: "), "3 Point Field Goal Percentage")),
                      tags$li(p(tags$b("FT: "), "Free Throws")),
                      tags$li(p(tags$b("FTA: "), "Free Throw Attempts")),
                      tags$li(p(tags$b("FT%: "), "Free Throws Percentage")),
                      tags$li(p(tags$b("ORB: "), "Offensive Rebounds")),
                      tags$li(p(tags$b("DRB: "), "Defensive Rebounds")),
                      tags$li(p(tags$b("TRB: "), "Total Rebounds")),
                      tags$li(p(tags$b("AST: "), "Assists")),
                      tags$li(p(tags$b("STL: "), "Steals")),
                      tags$li(p(tags$b("BLK: "), "Blocks")),
                      tags$li(p(tags$b("TOV: "), "Turnovers")),
                      tags$li(p(tags$b("PF: "), "Personal Fouls")),
                      tags$li(p(tags$b("PTS: "), "Points")),
                      tags$li(p(tags$b("OPPPts: "), "Opponent Points")),
                      tags$li(p(tags$b("SRS: "), "Simple Rating System - A rating that takes into account average point differential and strength of schedule. The rating is denominated in points above/below average, where zero is average. Non-Division I games are excluded from the ratings.")),
                      tags$li(p(tags$b("SOS: "), "Strength of Schedule - A rating of strength of schedule. The rating is denominated in points above/below average, where zero is average. Non-Division I games are excluded from the ratings.")),
                      tags$li(p(tags$b("Pace"), "Pace Factor - An estimate of school possessions per 40 minutes."))
               )
           ),
           hr(),
           p("Source: Sport-Reference,", tags$a(href= "https://www.sports-reference.com/cbb/conferences/ivy/2020.html", "Data Source"))
             
    )
  ),
  position=c("fixed-top"),
  
  cat("UI Successfully Loaded...\n")
)
