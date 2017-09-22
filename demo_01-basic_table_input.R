library(shiny)

ui <- fluidPage(h3("basic Shiny table input"),
                br(),
                textOutput("test_text"),
                br(),
                textTableInput(tableId = "test_input_table")
)

server <- function(input, output, session) {
  
  # define output rendering ID of textTableInput entity
  # also serves as the base element ID for input handling
  output_table_id <- "test_input_table"
  
  # initial demo message
  output[["test_text"]] <- renderText(paste0("Modify table data to view changes here."))
  
  # Note: also works if tableId = output_table_id
  test_df <- head(iris)
  output[[output_table_id]] <- renderTextTableInput(
    df = test_df, 
    tableId = NA)
  
  # observe changes to input table
  observeEvent({
    input[[output_table_id]]
  }, {
    observe({
      # extract ID and value of the modified cell
      event_id <- input[[output_table_id]]
      event_val <- input[[event_id]]
      
      # report changes to UI
      output[["test_text"]] <- renderText(paste0("Cell ID: ", event_id, " value: ", event_val ))
    })
  })
  
}

shinyApp(ui = ui, server = server)