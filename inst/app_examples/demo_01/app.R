ui <- shiny::fluidPage(shiny::tags$h3("Demo App: Basic Shiny table input"),
                shiny::tags$br(),
                shiny::tags$div(style = "margin-left:50px;",
                                shiny::textOutput("test_text")),
                shiny::tags$br(),
                shinyinputtables::textTableInput(tableId = "test_input_table")
)

server <- function(input, output, session) {
  
  # define output rendering ID of textTableInput entity
  # also serves as the base element ID for input handling
  output_table_id <- "test_input_table"
  
  # initial demo message
  output[["test_text"]] <- shiny::renderText(paste0("Modify table data to view changes here."))
  
  # Note: also works if tableId = output_table_id
  test_df <- head(iris)
  output[[output_table_id]] <- shinyinputtables::renderTextTableInput(
    df = test_df, 
    tableId = NA)
  
  # observe changes to input table
  shiny::observeEvent({
    input[[output_table_id]]
  }, {
    shiny::observe({
      # extract ID and value of the modified cell
      event_id <- input[[output_table_id]]
      event_val <- input[[event_id]]
      
      # report changes to UI
      output[["test_text"]] <- shiny::renderText(paste0("Cell ID: ", event_id, " value: ", event_val ))
    })
  })
  
}

shiny::shinyApp(ui = ui, server = server)