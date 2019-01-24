# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("911 calls"),
  
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
                  choices = c( 'ANONYMOUS', 'CRIME',
                               'PERSON.PEOPLE.CAUSING.DISORDER.OR.ALTERCATION.OR.SUSPICION',
                               'EMERGENCY', 'PERSONAL.HELP','MISCELLANEOUS.OR.UNKNOWN',
                               'DISORDER.IN.PUBLIC.SPACE', 'VICTIMIZATION..CALLER.')),
                                    
      selectInput('ratetype', 'Data Format:', 
                  choices = c('Rate Quintile', 'Raw','Raw Quintile')),
      
      
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