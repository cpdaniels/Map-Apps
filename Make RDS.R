##########Read in data
#set working directory
working_dir <- c("~/Dropbox/SCHOOL/Fall 2018/Crime Time & Space Proj/Map Apps")
setwd(working_dir)

#set your data directory
data_dir <- c('~/Dropbox/SCHOOL/Fall 2018/Crime Time & Space Proj/Data/')

#read in data
df = read.csv(paste(data_dir, "Victim3mo.csv", sep = ""), stringsAsFactors = F)

df$Date <- ymd(df$Date)
df$Time <- hms(df$Time)

saveRDS(df, "./victim_data.rds")


#read in data
df = read.csv(paste(data_dir, "311_3mo.csv", sep = ""), stringsAsFactors = F)

df$Date <- ymd(df$Date)
df$Time <- hms(df$Time)

saveRDS(df, "./311_data.rds")


#read in data
df = read.csv(paste(data_dir, "911_3mo.csv", sep = ""), stringsAsFactors = F)

df$Date <- ymd(df$Date)
df$Time <- hms(df$Time)

saveRDS(df, "./911_data.rds")
