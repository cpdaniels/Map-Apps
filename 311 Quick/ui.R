# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("311 calls"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: date range ----
      dateRangeInput(inputId = "daterange",
                     label = "Date range:",
                     start  = "2017-09-01",
                     end    = "2017-11-23",
                     min    = "2017-09-01",
                     max    = "2017-11-23",
                     format = "mm/dd/yy",
                     separator = " - "),
      
      selectInput('variable', 'Call Type:', 
                  choices = c('MISCELLANEOUS.OR.UNKNOWN','ESTABLISHMENT.COMPLAINT',
                              'NEIGHBOR.COMPLAINT','PERSONAL.ASSISTANCE.OR.HELP', 
                              'DISORDER.IN.PUBLIC.SPACE')),
                                    
      selectInput('ratetype', 'Data Format:', 
                  choices = c('Rate Quintile', 'Raw','Raw Quintile', 'Raw as % of all calls')),
      
      
      
      hr()

    ),
    
    # Main panel for displaying outputs ----
      
      mainPanel(
        
        textOutput("startdate"), # display the start date
        textOutput("enddate"), # display the end date
       leafletOutput("mymap",height = 1000)
        
      )
      
    
  )
)