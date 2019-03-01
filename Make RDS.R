library('lubridate')
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

###collapse over time 
dates <- unique(df$Date)
geoIDs <- unique(df$MergeID)

newmat <- as.data.frame(matrix(0, nrow= length(dates) * length(geoIDs), ncol = ncol(df)))
names(newmat) <- names(df)
newmat$MergeID <- rep(geoIDs, length(dates))
newmat$Date <- rep(dates, length(geoIDs))

for (i in 1:nrow(newmat)){
  newmat$MISCELLANEOUS.OR.UNKNOWN[i] <- sum(df$MISCELLANEOUS.OR.UNKNOWN[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  newmat$ANONYMOUS[i] <- sum(df$ANONYMOUS[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
  newmat$PERSON.PEOPLE.CAUSING.DISORDER.OR.ALTERCATION.OR.SUSPICION[i] <- 
    sum(df$PERSON.PEOPLE.CAUSING.DISORDER.OR.ALTERCATION.OR.SUSPICION[
      which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
  newmat$PERSONAL.HELP[i] <- sum(df$PERSONAL.HELP[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
  newmat$EMERGENCY[i] <- sum(df$EMERGENCY[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
  newmat$VICTIMIZATION..CALLER.[i] <- sum(df$VICTIMIZATION..CALLER.[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
  newmat$DISORDER.IN.PUBLIC.SPACE[i] <- sum(df$DISORDER.IN.PUBLIC.SPACE[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
  newmat$CRIME[i] <- sum(df$CRIME[
    which(df$Date == newmat$Date[i] & df$MergeID == newmat$MergeID[i])])
  
}
  

df <- newmat[,c('MergeID', 'Date','MISCELLANEOUS.OR.UNKNOWN', 'ANONYMOUS',
                'PERSON.PEOPLE.CAUSING.DISORDER.OR.ALTERCATION.OR.SUSPICION',
                'PERSONAL.HELP','EMERGENCY', 'VICTIMIZATION..CALLER.', 'DISORDER.IN.PUBLIC.SPACE', 'CRIME')]

df$Date <- ymd(df$Date)

saveRDS(df, "./911_data.rds")
