#### Server ####
server <- shinyServer(function(input, output, session) {
  output$staty_bb_show <- renderUI({})
  output$statx_bb_show <- renderUI({})
  outputOptions(output, c("staty_bb_show","statx_bb_show"), suspendWhenHidden = FALSE)
  
  # Source: https://github.com/open-meta/uiStub
  cat("Session started.\n") # this prints when a session starts
  onSessionEnded(function() {cat("Session ended.\n\n")})  # this prints when a session ends

  ############# PAGE 1 ##################
  #Define Variables
  games_min=reactive({input$mingames})
  col_sel_v2=reactive({input$col_dt_v2})
  
  df_v2_raw <- reactive({
    if (col_sel_v2() == "Per Game") {
      basic[which(basic$G >= games_min()),]
    } else if (col_sel_v2() == "Totals") {
      totals[which(totals$G >= games_min()),]
    } else if (col_sel_v2() == "Per 40 Minutes") {
      per_40[which(per_40$G >= games_min()),]
    } else if (col_sel_v2() == "Advanced") {
      advanced[which(advanced$G >= games_min()), ]
    } else if (col_sel_v2() == "Demographics") {
      demo[which(demo$G >= games_min()), ]
    }
  })
  
  df_v2 <-  reactive({
    if (input$school_filter == "Full") { 
      df_v2_raw()
    } else { 
      df_v2_raw()[df_v2_raw()$School == input$school_filter,]
    }
  })
  

  col_names_format_v2 <-  reactive({c("Rk",colnames(df_v2()))}) # Add Rank Column to account for rownames
  display_colnames_v2 <-  reactive({get_display_colnames(df_v2(), replacements_bb)})

  # Reorders CounterColumn
  js_reorder <- c(
    "table.on('draw.dt', function(){",
    "  var PageInfo = table.page.info();",
    "  table.column(0, {page: 'current'}).nodes().each(function(cell,i){", 
    "    cell.innerHTML = i + 1 + PageInfo.start;",
    "  });",
    "})")
  
  output$table2 = DT::renderDataTable({
    datatable(df_v2(),
              colnames=display_colnames_v2(),
              extensions = c('FixedColumns','ColReorder', "Select"),
              # Options
              options = list(  scrollX = TRUE,
                               pageLength = 10,
                               initComplete = JS(
                                 "function(settings, json) {",
                                 "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                                 "}"), #https://rstudio.github.io/DT/options.html

                               fixedColumns = list(leftColumns = 2),
                               colReorder = TRUE,
                               select=TRUE
                               
              ), callback = JS(js_reorder)) %>% # Format Numbers: https://stackoverflow.com/questions/33171279/dt-in-shiny-and-r-custom-number-formatting
      formatRound(col_names_format_v2()%in%two_digit_bb_player, digits = 2) %>%
      formatPercentage(col_names_format_v2()%in%perc_bb_player, 1) %>%
      formatRound(if(col_sel_v2() == "Totals"){
                    NULL
                  } else if (col_sel_v2() %in% c("Advanced", "Per 40 Minutes")) { 
                    col_names_format_v2()%in%(one_digit_bb_player[one_digit_bb_player != "MP"])
                  }
                  else {
                    col_names_format_v2()%in%one_digit_bb_player
                  }, digits = 1) %>%
      formatRound(if(col_sel_v2() == "Advanced"){"WS.40"} else{NULL}, digits = 3)
  })
  
  ############# PAGE 2 ##################
  # Define Variables
  x_choices = reactive({label_generator(input$Statx_bb_type)})
  y_choices = reactive({label_generator(input$Staty_bb_type)})
  
  observe({
    # Can also set the label and select items
   updateSelectInput(session, "Staty_bb", 
                      choices = get_display_colnames_from_vec(y_choices(), replacements_bb),
                      selected = character(0))
   updateSelectInput(session, "Statx_bb",
                     choices = get_display_colnames_from_vec(x_choices(), replacements_bb),
                     selected = character(0))
  })
  
  df_x <- reactive({df_generator(input$Statx_bb_type,input$mingames_players)})
  df_y <- reactive({df_generator(input$Staty_bb_type,input$mingames_players)})
  
  x_var_p <- reactive({
    df_x()[,x_choices()[get_display_colnames_from_vec(x_choices(), replacements_bb) == input$Statx_bb]]
  })
  
  y_var_p <- reactive({
    df_y()[,y_choices()[get_display_colnames_from_vec(y_choices(), replacements_bb) == input$Staty_bb]]
  })
  
  x_str_p <- reactive({input$Statx_bb})
  y_str_p <- reactive({input$Staty_bb})
  
  x_lab_p <- reactive({
    list(
      title = x_str_p(),
      titlefont = f
    )
  })
  y_lab_p <- reactive({
    list(
      title = y_str_p(),
      titlefont = f
    )
  })
  
  df_full=reactive({rbind(df_x(),df_y())})
  # Plots
  output$plot2 <- renderPlotly(
    plot2<-plot_ly(x=x_var_p(), 
                   y=y_var_p(),
                   color=df_y()$School,
                   colors=ivy_colors,
                   text=df_y()$Player,
                   type="scatter",
                   legendgroup = df_y()$School,
                   hovertemplate = paste("Player: ", '%{text}<br>',
                                         x_str_p(),': : %{x}<br>', 
                                         y_str_p(), ': %{y}<br>', sep =""),
                   mode="markers") %>% layout(xaxis = x_lab_p(), yaxis = y_lab_p())
  )
  
  
  
  
  ############# PAGE 4 ##################
  #Define Variables
    output$table_teams = DT::renderDataTable(
      datatable(bball_ref, 
           colnames=team_display_names,
           # rownames = FALSE, 
           extensions = c('FixedColumns','ColReorder'),
           # Options
           options = list(  scrollX = TRUE,
                            pageLength = 10,
                            initComplete = JS(
                              "function(settings, json) {",
                              "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                              "}"), #https://rstudio.github.io/DT/options.html
                            
                            fixedColumns = list(leftColumns = 1),
                            colReorder = TRUE
           ),
           callback = JS(js_reorder)) %>%
     formatRound(c("ORtg","DRtg","NRtg","FG","FGA", "X3P", "X3PA", 
                   "FT", "FTA", "ORB","TRB", "AST","STL","BLK", 
                   "TOV", "PF", "PTS", "OPPPTS","Pace"), digits = 1) %>% # Format Numbers: https://stackoverflow.com/questions/33171279/dt-in-shiny-and-r-custom-number-formatting
     formatRound(c("SRS","SOS"), digits = 2) %>%
     formatPercentage(c("W.", "FG.", "X3P.", "eFG.", "FT."), 1)
    )
  
  ############# PAGE 5 ##################
  #Define Variables
  # Define Variables
  x_var_t <- reactive({
    bball_ref[,which(display_colnames_teams ==input$Statx_team) + 2]
  })
  
  y_var_t <- reactive({
    bball_ref[,which(display_colnames_teams ==input$Staty_team) + 2]
  })
  
  x_str_t <- reactive({input$Statx_team})
  y_str_t <- reactive({input$Staty_team})
  
  
  f <- list(
    family = "Roboto",
    size = 18,
    color = "black"
  )
  x_lab_t <- reactive({
    list(
      title = x_str_t(),
      titlefont = f
    )
  })
  y_lab_t<- reactive({
    list(
      title = y_str_t(),
      titlefont = f
    )
  })
  
  # Plots
  output$plot_team <- renderPlotly(
    plot_team<-plot_ly(bball_ref,
                       x=x_var_t(), 
                       y=y_var_t(),
                       color=bball_ref$School,
                       colors=ivy_colors,
                       name=bball_ref$School,
                       type="scatter",
                       hovertemplate = paste(x_str_t(),': %{x}<br>', 
                                             y_str_t(), ': %{y}<br>', sep =""),
                       mode="markers") %>% layout(xaxis = x_lab_t(), yaxis = y_lab_t())
  )
  
})



# DEPLOYMENT 
# library(rsconnect)
# rsconnect::setAccountInfo()
# deployApp("~/Desktop/ivy_bball", appName = "ivy_mbb2020")
