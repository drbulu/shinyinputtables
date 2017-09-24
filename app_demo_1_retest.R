ui <- shiny::fluidPage(shiny::tags$h3("Demo App: Basic Shiny table input"),
                       shiny::tags$br(),
                       shiny::tags$div(style = "margin-left:50px;",
                                       shiny::textOutput("text_output")),
                       shiny::tags$br(),
                       shinyinputtables::textTableInput(tableId = "input_table")
)

server <- function(input, output, session) {
  
  # define output rendering ID of textTableInput entity
  # also serves as the base element ID for input handling
  table_id <- "input_table"
  text_id <- "text_output"
  
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
    event_value <- jsonlite::fromJSON(event_data)
    
    # render result to UI
    output[[text_id]] <- shiny::renderText(paste0("Event detected: ", 
                                                  "cell ID = ", event_value$cell.id,
                                                  ". Cell value = ", event_value$cell.value,
                                                  "!"))
  })
  
}

shiny::shinyApp(ui = ui, server = server)