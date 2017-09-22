#' Table output containing editable data 
#' 
#' @description 
#' 
#' @usage 
#' 
#' \code{renderTextTableInput(df)}
#' 
#' \code{renderTextTableInput(df, tableId = NA, tableClasses = "table table-bordered")}
#' 
#' @param df data frame input to be rendered as an editable HTML table (text).
#' @param tableId single length character vector denoting the id of the corresponding 
#' HTML table element generated in the UI by \code{textTableInput}. 
#' @param tableClasses character vector specifying the HTML classes to apply to the 
#' table generated using \code{df}. table denoting the id of the corresponding HTML 
#' table element generated in the UI by \code{textTableInput}. 
#' 
#' @details
#' 
#' Note: Section documentation in progress. Also need to add example usage.
#' 
#' Shiny has a default Javascript dependency on the Bootstrap framework. Therefore the
#'  \code{tableClasses} vector should specify
#' 
#' To apply default Bootstrap CSS table styling, simply specify them here for inclusion into the genrated table. include them in this arg
#' 
#' can apply bootstrap themes to the page that can define the table output: https://shiny.rstudio.com/reference/shiny/latest/bootstrapPage.html
#' 
#' @references 
#' W3Schools \href{https://www.w3schools.com/bootstrap/bootstrap_tables.asp}{Bootstrap tables} resource.
#' 
#' @seealso 
#' \code{\link{textTableInput}}
#' 
#' @export
renderTextTableInput <- function(
  df, 
  tableId = NA, 
  tableClasses = "table"){
  
  # examples of extra classes to add
  # "table-condensed"
  # table-responsive
  # table-bordered
  
  textInputTable <- createTextInputTable(
    df = df, 
    idPrefix = tableId, 
    tableClasses = tableClasses, 
    baseClass = "shinyinputtables", 
    editableHeader = F)
  
  # render populated HTML table with initial values
  shiny::renderUI({shiny::HTML(textInputTable)})
  
}