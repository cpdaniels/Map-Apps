server <- function(input, output) {
  
  
  # total number of calls 
  df_subset <- reactive({
    
    #subset data over date range
    a <- subset(df, df$Date >= ymd(input$daterange[1]) & 
                  df$Date <= ymd(input$daterange[2]))
      
      #format mergeID 
      a$Tract <-formatC(a$MergeID, width=7, flag="0")
      a$Tract <- substring(a$Tract,1,6)
      
      #create vector of variable names
      col.n <- c('PROPERTY', 'ASSAULT','VIOLENT.OR.ROBBERY', 
                 'SHOOTING.OR.MURDER', 'SEXUAL.ASSAULT')
      
      #create empty matrix to store sums over date range for each tract
      allcalls <- as.data.frame(matrix(0, nrow = length(unique(a$Tract)), ncol = length(col.n)+1))
      
      #name the columns
      names(allcalls) <- c('Tract' , col.n)
      #pull Tract IDs from data
      allcalls$Tract <- unique(a$Tract)
      
      #Sum allcalls by Tract
      for (i in 1:nrow(allcalls)){
        for (j in col.n){
          allcalls[i,j] <- sum(a[,j][which(a[,'Tract'] == allcalls[i,'Tract'])])
        }
      }
      
      #create empty matrix to store sums over date range for each tract
      c <- as.data.frame(matrix(0, nrow = length(unique(a$Tract)), ncol = 3))
      
      #name the columns
      names(c) <- c('Tract' , 'Calls', input$variable)
      #pull Tract IDs from data
      c$Tract <- unique(a$Tract)
      
      for (i in 1:nrow(c)){
        c[i,'Calls'] <- rowSums(allcalls[i,c(col.n)])
        c[i,input$variable] <- allcalls[i,input$variable]
      }
      
      
      #initialize column to store rates
      c$Rate <- 0
      c$AllcallsRate <- c[,input$variable] / (c[,'Calls'])
      
      #join with geo and pop data
      balt_data <- full_join(balt_geo, c) 
    
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
    balt_wgs[,'AllcallsRate'][[1]] <- balt_wgs[,'AllcallsRate'][[1]] %>% replace_na(0)
    #IF user selects type raw
   if (input$ratetype == 'Raw'){ 
     pal <- colorNumeric("BuPu", balt_wgs[,input$variable][[1]])
     m <- leaflet(data = balt_wgs) %>%
      addTiles() %>%
      addPolygons(data=balt_wgs,
                  stroke = FALSE,
                  fillOpacity = .8, 
                  #fills tracts by raw count
                  fillColor = pal(balt_wgs[,input$variable][[1]]),
                  group = balt_wgs$input$variable) %>%
     addLegend(pal = pal, values = ~balt_wgs[,input$variable][[1]], group = "circles",
               position = "topright",title = "Raw #")
     #if user selects rate quintile
   } else{
     if (input$ratetype == 'Rate Quintile'){
       qpal <- colorBin("BuPu", balt_wgs[,'Rate'][[1]], 
                        bins=unique(quantile(balt_wgs[,'Rate'][[1]], probs = seq(0, 1, 0.2))))
     m <- leaflet(data = balt_wgs) %>%
       addTiles() %>%
       addPolygons(data=balt_wgs,
                   stroke = FALSE,
                   fillOpacity = .8, 
                   #fills tracts by rate binned by quintile (unique puts all 0's in one bin)
                   fillColor = qpal(balt_wgs[,'Rate'][[1]]),
                   group = balt_wgs$Rate) 
   #  addLegend(pal = qpal, values = ~balt_wgs[,'Rate'][[1]], group = "circles",
    #           position = "topright",title = "Rate Quintile", labFormat = labelFormat())
     }
     #if user selects raw quintile
     else
       if(input$ratetype == 'Raw as % of all calls'){
         pal <- colorNumeric("BuPu", balt_wgs[,'AllcallsRate'][[1]])
         m <- leaflet(data = balt_wgs) %>%
        addTiles() %>%
        addPolygons(data=balt_wgs,
                   stroke = FALSE,
                   fillOpacity = .8, 
                   #fills tracts by raw count binned by quintile (unique puts all 0's in one bin)
                   fillColor = pal(balt_wgs[,'AllcallsRate'][[1]]),
                    group = balt_wgs$AllcallsRate) %>%
          addLegend(pal = pal, values = ~balt_wgs[,'AllcallsRate'][[1]], group = "circles",
                    position = "topright",title = "Raw # as % of all calls")
       }
     else{
       
       qpal <- colorBin("BuPu", balt_wgs[,input$variable][[1]], 
                        bins=unique(quantile(balt_wgs[,input$variable][[1]], probs = seq(0, 1, 0.2))))
       m <- leaflet(data = balt_wgs) %>%
         addTiles() %>%
         addPolygons(data=balt_wgs,
                     stroke = FALSE,
                     fillOpacity = .8, 
                     #fills tracts by raw count binned by quintile (unique puts all 0's in one bin)
                     fillColor = qpal(balt_wgs[,input$variable][[1]]),
                     group = balt_wgs$Rate) %>%
         addLegend(pal = qpal, values = ~balt_wgs[,input$variable][[1]], group = "circles",
                   position = "topright",title = "Raw # Quintile")
         }
     }
       
     
    
    return(m)
  })
    
  
  ###Outputs map
  output$mymap <- renderLeaflet({
  
    map()
  })
 
}