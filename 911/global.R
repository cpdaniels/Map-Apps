library(shiny)
library(lubridate)
library(tidycensus)
library(leaflet)
library(tidyverse)
library(sf)
library(dplyr)

#set your project directory
data_dir <- c('~/Dropbox/SCHOOL/Fall 2018/Crime Time & Space Proj/Map Apps/')

df = readRDS(paste(data_dir, "911/911_data.rds", sep =""))

