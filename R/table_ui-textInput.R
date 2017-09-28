#' Create a text input table
#' 
#' @description 
#' Creates an HTML table entity containing a grid of editable input cells corresponding to the data frame object rendered by \code{renderTextTableInput} with the corresponding \code{tableId}.
#' 
#' @usage
#' 
#' \code{textTableInput(tableId)}
#' 
#' @param tableId The id of the UI element in which the generated HTML table will be embedded.
#' 
#' @return
#' An HTML table consisting of editable cells that can be added to a UI definition.
#' 
#' @details
#' 
#' @seealso 
#' \code{\link{renderTextTableInput}}
#' 
#' @export
textTableInput <- function(tableId){

  addResourcePath(
    prefix = 'www',
    directoryPath = system.file('www', package='shinyinputtables')
  )
    
  table_css_path <- file.path("www", "css", "element_styling_text_table.css")
  table_js_path <- file.path("www", "js", "input_binding_text_table.js")
  utils_js_path <- file.path("www", "js", "shinyinputtables_utils.js")
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src=utils_js_path),
        shiny::tags$script(src=table_js_path),
        shiny::tags$link(rel="stylesheet", type="text/css", href=table_css_path)
      )
    ),
    shiny::uiOutput(tableId)
  )
  
}