### Variables
library(tidyverse)
### Helpers

# Getting display names
get_display_colnames = function(df, replacements){ 
  display_colnames = colnames(df)
  for (name in replacements) { 
    if (name[1] %in% display_colnames) { 
      display_colnames = replace(display_colnames, display_colnames==name[1], name[2])
    }
  }
  return(display_colnames)
}

get_display_colnames_from_vec = function(lst, replacements){ 
  for (name in replacements) { 
    if (name[1] %in% lst) { 
      lst = replace(lst, lst==name[1], name[2])
    }
  }
  return(lst)
}

# Clean Position 
position_cleaner = function(df, pos = "Pos") { 
  df[,pos] = as.factor(trimws(df[,pos]))
  df[,pos][which(df[,pos] == "C")] = "F"
  df[,pos] = droplevels(df[,pos],exclude="C")
  return(df)
}

label_generator= function(type_) { 
  if (type_ == "Per Game") {
    colnames(basic)[5:length(basic)]
  } else if (type_ == "Totals") {
    colnames(totals)[5:length(totals)]
  } else if (type_ == "Per 40 Minutes") {
    colnames(per_40)[5:length(per_40)]
  } else if (type_ == "Advanced") {
    colnames(advanced)[5:length(advanced)]
  }
}

df_generator = function(type_, games_min) { 
  if (type_ == "Per Game") {
    basic[which(basic$G >= games_min),]
  } else if (type_ == "Totals") {
    totals[which(totals$G >= games_min),]
  } else if (type_ == "Per 40 Minutes") {
    per_40[which(per_40$G >= games_min),]
  } else if (type_ == "Advanced") {
    advanced[which(advanced$G >= games_min),]
  } else if (type_ == "Demographics") {
    demo[which(demo$G >= games_min),]
  }
}



### Vars 



# Ivy Colors 
ivy_colors = c("#4E3629", "#003865", "#B31B1B", "#046A38", 
               "#A41034", "#990000", "#FF671F", "#00356B")


#### TEAMS BBALL REF ####
bball_ref = read.csv("team_data/teams_bball_ref.csv")
replacements_teams = list(c("W.", "W%"), 
                          c("Conf_W", "Conf W"),
                          c("Conf_L","Conf L"),
                          c("Home_W","Home W"),
                          c("Home_L","Home L"),
                          c("Away_W","Away W"),
                          c("Away_L","Away L"),
                          c("FG.", "FG%"),
                          c("X3P", "3P"),
                          c("X3PA", "3PA"),
                          c("X3PM", "3PM"),
                          c("X3P.", "3P%"),
                          c("eFG.", "eFG%"),
                          c("FT.", "FT%"))



team_display_names = get_display_colnames(bball_ref, replacements_teams)
for_selection_teams = colnames(bball_ref)[3:length(colnames(bball_ref))]
display_colnames_teams = team_display_names[3:length(team_display_names)]







#### Players BB Reference ####
replacements_bb = list(c("W.", "W%"), 
                      c("Conf_W", "Conf W"),
                      c("Conf_L","Conf L"),
                      c("Home_W","Home W"),
                      c("Home_L","Home L"),
                      c("Away_W","Away W"),
                      c("Away_L","Away L"),
                      c("FG.", "FG%"),
                      c("X3P", "3P"),
                      c("X3PA", "3PA"),
                      c("X3PM", "3PM"),
                      c("X3P.", "3P%"),
                      c("eFG.", "eFG%"),
                      c("FT.", "FT%"),
                      c("High.School", "High School"), # Demographics
                      c("X3PAr", "3PAr"), # Basic
                      c("ORB.", "ORB%"),
                      c("DRB.", "DRB%"),
                      c("TS.", "TS%"),
                      c("TRB.", "TRB%"),
                      c("AST.", "AST%"),
                      c("STL.", "STL%"),
                      c("BLK.", "BLK%"),
                      c("TOV.", "TOV%"),
                      c("USG.", "USG%"),
                      c("WS.40", "WS/40"),
                      c("ORB.", "ORB%"),
                      c("X2P", "2P"),
                      c("X2PA", "2PA"),
                      c("X2P.", "2P%"))


demo_raw = read.csv("bball_ref/player_demographics.csv")
demo_pithy = demo_raw[,c("Player","School","Class", "Pos")]
advanced = position_cleaner(merge(demo_pithy, read.csv("bball_ref/player_advanced.csv"), by = c("Player")))
basic = position_cleaner(merge(demo_pithy, read.csv("bball_ref/player_basic.csv"), by = c("Player")))
per_40 = position_cleaner(merge(demo_pithy, read.csv("bball_ref/player_per_40.csv"), by = c("Player")))
totals = position_cleaner(merge(demo_pithy, read.csv("bball_ref/player_totals.csv"), by = c("Player")))

# Create demo for display
demo_col_order <- c("Player", "School","Class", "Pos", "G", "Height", "Weight", "Hometown", "High.School")
demo <- merge(demo_raw, read.csv("bball_ref/player_basic.csv"), by = c("Player"))[,demo_col_order]


# Fix rounding for columns 
# Column Display 
perc_bb_player = c("X3P.", "X2P.", "ORB.","DRB.","TRB.","AST.","STL.","BLK.","TOV.",
         "USG.", "eFG.", "FG.", "FT.", "TS.", "FTr", "X3PAr", "ORB.")
one_digit_bb_player = c('MP',"FG", "FGA", "X2P", "X2PA",'X3P','X3PA',"FT", "FTA","ORB", "DRB","TRB",
              "AST", "STL", "BLK", "TOV", "PF","PTS", "DWS", "OWS", "WS", "PER", "BPM")
two_digit_bb_player = c("STPG", "TOPG", "PFPG", "BLKPG", "RP40", "AP40M", "STP40M", "BLKP40M", 
              "AST.TO", "ST.TO", "ST.PF", "BLK.PF")

colnames(advanced)




