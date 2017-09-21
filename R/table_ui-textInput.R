#' textTableInput
#' 
#'  
#'    
#' @export
textTableInput <- function(tableId){

  addResourcePath(
    prefix = 'www',
    directoryPath = system.file('www', package='shinyinputtables')
  )
  
  table_css_path <- file.path("www", "css", "element_styling_text_table.css")
  table_js_path <- file.path("www", "js", "input_binding_text_table.js")
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src=table_js_path),
        shiny::tags$link(rel="stylesheet", type="text/css", href=table_css_path)
      )
    ),
    shiny::uiOutput(tableId)
  )
  
}