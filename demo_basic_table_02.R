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
  
  # IDs matching UI module component entities
  table_id <- "input_table"
  text_id <- "text_output"
  
  # interestingly, both options work. Pregenerated ID doesn't seem to 
  # cause module issues.
  observe({
    output[[table_id]] <- renderTextTableInput(df = df(), tableId = NA)
    # output[[table_id]] <- renderTextTableInput(df = df(), tableId = table_id)
  })
  
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
  # This seems to be the cleanest solution to the problem!
  callModule(tableModule, id = ui_id, df = reactive( head(DNase)))
  
  # works with "-", which is the shiny namespace separator
  # https://shiny.rstudio.com/reference/shiny/latest/NS.html
  # table_id <- paste0(ui_id, shiny::ns.sep, "input_table")
  # text_id <- paste0(ui_id, shiny::ns.sep, "text_output")
  # much cleaner using shiny's native NS() function. Probably better
  # if the implementation changes in the future!
  moduleNS <- NS(ui_id)
  table_id <- moduleNS("input_table")
  text_id <- moduleNS("text_output")

  observeEvent({
    input[[table_id]]
  }, {

    observe({

      # extract the input element ID and cell value

      event_id <- input[[table_id]]
      event_val <- input[[event_id]]

      output[[text_id]] <- renderText(paste0("event id: ", event_id,
                                             ". Event value: ", event_val, "."))

      cat("Outside module!!!!: input event ID =", event_id, "with event value:", event_val, "\n")

    })

  })
  
  
}

shinyApp(ui = ui, server = server)