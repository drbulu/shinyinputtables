library(shiny)

cat(getwd(), "\n")

ui <- fluidPage(
  
  h3("basic Shiny table input"),
  br(),
  p("put table here"),
  textTableInput(tableId = "test_input_table"),
  br(),
  p("moreStuff 4.2.4")
  
)


server <- function(input, output) {
  
  output_table_id <- "test_input_table"
  
  test_id <- paste0(output_table_id, "_1-1")
  
  test_df <- head(iris)
  
  
  output[[output_table_id]] <- renderTextTableInput(
    df = test_df, 
    tableId = NA)
  
  # output[[output_table_id]] <- renderTextTableInput(
  #   df = test_df, 
  #   tableId = output_table_id)
  
  observe({
    
    observeEvent({
      # input[[test_id]]
      
      input[[output_table_id]]
      
    }, {
      
      cat("output_table_id = ", input[[test_id]], "\n")
      
    })
    
  })
  
}

shinyApp(ui = ui, server = server)