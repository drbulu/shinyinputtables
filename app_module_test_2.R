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
  
  output[[text_id]] <- shiny::renderText(paste0("Modify table data to view changes here."))
  
  cat("namespaced table ID.. session$ns(table_id) is:", session$ns(table_id), "\n")
  cat("namespaced table ID.. class is:", class(session$ns(table_id)), "\n")
  
  # interestingly, both options work. Pregenerated ID doesn't seem to 
  # cause issues with shiny module framework.
  shiny::observe({
    output[[table_id]] <- shinyinputtables::renderTextTableInput(df = df(), tableId = session$ns(table_id))
  })
  
  shiny::observeEvent({
    # input[[ table_id  ]]
    
    input[[session$ns(table_id)]]
    
  }, {
    shiny::observe({
      # extract ID and value of the modified cell
      event_id <- input[[table_id]]
      event_val <- input[[event_id]]
      
      table_ns_id <- session$ns(table_id)
      table_cell_ns_id <- input[[ table_ns_id ]]
      # event_value <- input[[table_cell_ns_id]]
      
      cat("namespaced table ID (eventID):", session$ns(table_id), "\n" )
      cat("namespaced cell ID (srcID):", table_cell_ns_id, "\n" )
      cat("namespaced cell ID class():", class(table_cell_ns_id), "\n\n" )
      # cat("namespaced cell value (val):", event_value, "\n" )

      # report changes to UI
      output[[text_id]] <- shiny::renderText(paste0("Cell ID: ", event_id, " value: ", event_val, "."))
    })
  })
  
}

# app UI funcdtion
ui <- shiny::fluidPage(
  tableModuleUI(id = "module_test")
)

# app server function
server <- function(input, output, session) {
  
  # Cannot listen for events within server module function
  # must do so outside module within main server function.
  # https://github.com/ropensci/plotly/issues/659
  # answer: https://github.com/ropensci/plotly/issues/659#issuecomment-238693777
  # This seems to be the cleanest solution to the problem!
  #
  # https://shiny.rstudio.com/reference/shiny/latest/NS.html
  # much cleaner using shiny's native NS() function. Probably better
  # if the implementation changes in the future!
  
  ui_id <- "module_test"
  moduleNS <- shiny::NS(ui_id)
  table_id <- moduleNS("input_table")
  text_id <- moduleNS("text_output")
  
  # initialise table UI module
  shiny::callModule(tableModule, 
                    id = ui_id, 
                    df = shiny::reactive( head(DNase))
  )
  
  # initial demo message
  # output[[text_id]] <- shiny::renderText(paste0("Modify table data to view changes here."))
  
  shiny::observeEvent({
    input[[table_id]]
  }, {
    shiny::observe({
      # extract ID and value of the modified cell
      event_id <- input[[table_id]]
      event_val <- input[[event_id]]

      cat(paste0("server() watcher... Cell ID: ", event_id, " value: ", event_val, ".\n"))
      
      # report changes to UI
      # output[[text_id]] <- shiny::renderText(paste0("Cell ID: ", event_id, " value: ", event_val, "."))
    })
  })
  
}

shiny::shinyApp(ui = ui, server = server)