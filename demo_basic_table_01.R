library(shiny)

cat(getwd(), "\n")

ui <- fluidPage(
  
  h3("basic Shiny table input"),
  br(),
  p("Input table renders here!"),
  br(),
  textTableInput(tableId = "test_input_table"),
  br(),
  textOutput("test_text"),
  br()
  
)


server <- function(input, output, session) {
  
  output_table_id <- "test_input_table"
  
  test_id <- paste0(output_table_id, "_1-1")
  
  test_df <- head(iris)
  
  
  output[[output_table_id]] <- renderTextTableInput(
    df = test_df, 
    tableId = NA)
  
  # output[[output_table_id]] <- renderTextTableInput(
  #   df = test_df, 
  #   tableId = output_table_id)
  
  observeEvent({
    
    input[[output_table_id]]
    
  }, {
    
    observe({
      
      event_id <- input[[output_table_id]]
      event_val <- input[[event_id]]
      
      output[["test_text"]] <- renderText(paste0("Cell ID: ", event_id, " value: ", event_val ))
      
      cat(paste0("Cell ID: ", event_id, " value: ", event_val ), "\n")
      
    })
    
  })
  
}

shinyApp(ui = ui, server = server)