#######Gets census & geography data#############
balt_geo <- get_acs(geography = "tract", 
                    variables = "B01001_001", 
                   state = "MD",
                  county = 'Baltimore City',
                 geometry = TRUE)
  
balt_geo$Tract <- substring(balt_geo$GEOID, 6, 12)

