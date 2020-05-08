







#### Players BB Reference ####
demo = read.csv("bball_ref/player_demographics.csv")
demo_pithy = demo[,c("Player","Class", "Pos")]
advanced = merge(demo_pithy, read.csv("bball_ref/player_advanced.csv"), by = c("Player"))
basic = merge(demo_pithy, read.csv("bball_ref/player_basic.csv"), by = c("Player"))
per_40 = merge(demo_pithy, read.csv("bball_ref/player_per_40.csv"), by = c("Player"))
totals = merge(demo_pithy, read.csv("bball_ref/player_totals.csv"), by = c("Player"))

