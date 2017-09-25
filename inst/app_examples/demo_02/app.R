# Module UI function
tableModuleUI <- function(id){
  
  # obligatory UI namespacing function
  ns <- shiny::NS(id)
  
  # IDs matching Server module function entities
  table_id <- "input_table"
  text_id <- "text_output"
  
  shiny::fluidRow(width = 12,
           shiny::tags$h3("Demo App: Basic Shiny table input - Module Implementation"),
           shiny::tags$br(),
           shiny::tags$div(style = "margin-left:50px;",
                           shiny::textOutput(ns(text_id))
                           ),
           shiny::tags$br(),
           shinyinputtables::textTableInput(tableId = ns(table_id))
  )
  
}

# Module Server function
tableModule <- function(input, output, session, df){
  
  # https://stackoverflow.com/a/38748422
  
  # IDs matching UI module component entities
  table_id <- "input_table"
  text_id <- "text_output"
  
  # interestingly, both options work. Pregenerated ID doesn't seem to 
  # cause issues with shiny module framework.
  shiny::observe({
    output[[table_id]] <- shinyinputtables::renderTextTableInput(df = df(), tableId = NA)
  })
  
  # initial demo message
  output[[text_id]] <- shiny::renderText(paste0("Modify table data to view changes here."))
  
  # Note: also works if tableId = table_id
  test_df <- head(iris)
  output[[table_id]] <- shinyinputtables::renderTextTableInput(
    df = test_df, 
    tableId = NA)
  
  # observe changes to input table
  shiny::observeEvent({
    input[[table_id]]
  }, {
    # process event data JSON
    event_data <- input[[table_id]]
    
    # Parse to JSON THEN decode. Else unescaped char (") crashes fromJSON
    event_value <- jsonlite::fromJSON(event_data)
    event_value <- lapply(X = event_value, FUN = utils::URLdecode)
    
    # render result to UI
    output[[text_id]] <- shiny::renderText(paste0("Event detected: ", 
                                                  "cell ID = ", event_value$cell.id,
                                                  ". Cell value = ", event_value$cell.value,
                                                  "!"))
  })
  
}

# app UI funcdtion
ui <- shiny::fluidPage(
  tableModuleUI(id = "module_test")
)

# app server function
server <- function(input, output, session) {
  
  # module id as used in the UI
  ui_id <- "module_test"
  
  # initialise table UI module
  shiny::callModule(tableModule, 
                    id = ui_id, 
                    df = shiny::reactive( head(DNase))
  )
  
}

shiny::shinyApp(ui = ui, server = server)