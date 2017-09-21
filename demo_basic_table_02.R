library(shiny)

cat(getwd(), "\n")


tableModuleUI <- function(id){
  
  # obligatory UI namespacing function
  ns <- NS(id)
  
  # IDs matching Server module function entities
  table_id <- "input_table"
  text_id <- "text_output"
  
  fluidRow(width = 12,
           h3("Shiny Input Table: Module Test"),
           br(),
           textOutput(ns(text_id)),
           br(),
           textTableInput(tableId = ns(table_id)),
           br()
  )
  
}

tableModule <- function(input, output, session, df){
  
  # https://stackoverflow.com/a/38748422
  
  ns <- session$ns
  
  # IDs matching UI module component entities
  table_id <- "input_table"
  text_id <- "text_output"
  
  observe({
    output[[table_id]] <- renderTextTableInput(df = df(), tableId = NA)
    # output[[table_id]] <- renderTextTableInput(df = df(), tableId = table_id)
  })
  
  # input watching
  
  # observeEvent({
  #   input[[table_id]]
  # }, {
  #   
  #   observe({
  #     
  #     # extract the input element ID and cell value
  #     
  #     event_id <- input[[table_id]]
  #     event_val <- input[[event_id]]
  #     
  #     output[[text_id]] <- renderText(paste0("event id: ", event_id, 
  #                                            ". Event value: ", event_val, "."))
  #     
  #     cat("input event ID = ", event_id, "with event value:", event_val, "\n")
  #     
  #   })
  #   
  # })
  
}


ui <- fluidPage(h3("Basic Shiny table input... now with modules!"),
                br(),
                tableModuleUI(id = "module_test")
)

server <- function(input, output, session) {
  ui_id <- "module_test"
  
  # Cannot listen for events within server module function
  # must do so outside module within main server function.
  # https://github.com/ropensci/plotly/issues/659
  # answer: https://github.com/ropensci/plotly/issues/659#issuecomment-238693777
  callModule(tableModule, id = ui_id, df = reactive( head(DNase)))
  
  
  table_id <- paste0(ui_id, "-", "input_table")
  text_id <- paste0(ui_id, "-", "text_output")
  
  observeEvent({
    input[[table_id]]
  }, {
    
    observe({
      
      # extract the input element ID and cell value
      
      event_id <- input[[table_id]]
      event_val <- input[[event_id]]
      
      output[[text_id]] <- renderText(paste0("event id: ", event_id, 
                                             ". Event value: ", event_val, "."))
      
      cat("Outside module: input event ID =", event_id, "with event value:", event_val, "\n")
      
    })
    
  })
  
  
}

shinyApp(ui = ui, server = server)