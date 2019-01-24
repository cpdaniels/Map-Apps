server <- function(input, output) {
  
  #Data & Data manipulation
  df_subset <- reactive({
    
    #subset data over date range
    a <- subset(df, df$Date >= ymd(input$daterange[1]) & 
                  df$Date <= ymd(input$daterange[2]))
    
    #format mergeID 
    a$Tract <-formatC(a$MergeID, width=7, flag="0")
    a$Tract <- substring(a$Tract,1,6)
    
    #create empty matrix to store sums over date range for each tract
    b <- as.data.frame(matrix(0, nrow = length(unique(a$Tract)), ncol = 2))
    
    #name the columns
    names(b) <- c('Tract' , input$variable)
    #pull Tract IDs from data
    b$Tract <- unique(a$Tract)
    
    #Sum by Tract
    for (i in 1:nrow(b)){
      b[i,input$variable] <- sum(a[,input$variable][which(a[,'Tract'] == b[i,'Tract'])])
    }
    
    #initialize column to store rates
    b$Rate <- 0
    
    #join with geo and pop data
    balt_data <- full_join(balt_geo, b) 
    
    #calculate rate
    balt_data[,'Rate'][[1]] <- balt_data[,input$variable][[1]] / (balt_data[,'estimate'][[1]] *1000)
    
    return(balt_data)
  })
  
  #returns start date selected by the user
  output$startdate <- renderText({
    as.character(input$daterange[1]) # start date selected by user
  })
  
  # returns the end date selected by the user
  output$enddate <- renderText({
    as.character(input$daterange[2]) # End date selected by the user
  })
  

 
###Mapping 
    
  map <- reactive({
    
    #mutates data to leaflet geo type
    balt_wgs <- df_subset() %>% st_set_crs(4326) 
    
    #replace NAs with 0s
    balt_wgs[,input$variable][[1]] <- balt_wgs[,input$variable][[1]] %>% replace_na(0)
    balt_wgs[,'Rate'][[1]] <- balt_wgs[,'Rate'][[1]] %>% replace_na(0)
  
    #IF user selects type raw
   if (input$ratetype == 'Raw'){ 
    
     m <- leaflet(data = balt_wgs) %>%
      addTiles() %>%
      addPolygons(data=balt_wgs,
                  stroke = FALSE,
                  fillOpacity = .8, 
                  #fills tracts by raw count
                  fillColor = ~colorNumeric("BuPu", balt_wgs[,input$variable][[1]])(balt_wgs[,input$variable][[1]]),
                  group = balt_wgs$input$variable)
     #if user selects rate quintile
   } else{
     if (input$ratetype == 'Rate Quintile'){
     m <- leaflet(data = balt_wgs) %>%
       addTiles() %>%
       addPolygons(data=balt_wgs,
                   stroke = FALSE,
                   fillOpacity = .8, 
                   #fills tracts by rate binned by quintile (unique puts all 0's in one bin)
                   fillColor = ~colorBin("BuPu", balt_wgs[,'Rate'][[1]], 
                                         bins=unique(quantile(balt_wgs[,'Rate'][[1]], 
                                                              probs = seq(0, 1, 0.2))))(balt_wgs[,'Rate'][[1]]),
                   group = balt_wgs$Rate) 
     }
     #if user selects raw quintile
     else{m <- leaflet(data = balt_wgs) %>%
       addTiles() %>%
       addPolygons(data=balt_wgs,
                   stroke = FALSE,
                   fillOpacity = .8, 
                   #fills tracts by raw count binned by quintile (unique puts all 0's in one bin)
                   fillColor = ~colorBin("BuPu", balt_wgs[,input$variable][[1]], 
                                         bins=unique(quantile(balt_wgs[,input$variable][[1]], probs = seq(0, 1, 0.2))))(balt_wgs[,input$variable][[1]]),
                   group = balt_wgs$Rate) }
       
     }
    
    return(m)
  })
    
  
  ###Outputs map
  output$mymap <- renderLeaflet({
  
    map()
  })
 
}