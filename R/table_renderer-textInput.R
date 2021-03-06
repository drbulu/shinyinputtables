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
#' Shiny UI is based on the \href{https://cran.r-project.org/web/packages/shiny/README.html}{Bootstrap} 
#' framework. Therefore, To apply default Bootstrap CSS table styling, simply specify the corresponding
#' HTML class name(s) as elements in \code{tableClasses} for inclusion into the genrated table. Shiny's
#' Bootstrap CSS rules will then be applied to the table output identified by \code{tableId}. This can 
#' also be used to apply other class-based CSS styling schemes to the table output, such as the custom 
#' \href{https://shiny.rstudio.com/reference/shiny/latest/bootstrapPage.html}{bootstrap themes} that 
#' can be applied to shiny pages.
#' 
#' @references 
#' W3Schools \href{https://www.w3schools.com/bootstrap/bootstrap_tables.asp}{Bootstrap tables} resource.
#' 
#' @seealso 
#' \code{\link{textTableInput}}
#' 
#' @examples
#' renderTextTableInput(df = iris, tableId) 
#' renderTextTableInput(df = iris, tableId = "iris_table")
#' renderTextTableInput(df = mtcars, tableId = "iris_table", tableClasses = c("table", "table-bordered"))
#' renderTextTableInput(df = DNase, tableId = "iris_table", tableClasses = c("table table-bordered", "example"))
#' 
#' @export
renderTextTableInput <- function(
  df, 
  tableId = NA, 
  tableClasses = "table"){
  
  textInputTable <- createTextInputTable(
    df = df, 
    idPrefix = tableId, 
    tableClasses = tableClasses, 
    baseClass = "shinyinputtables", 
    editableHeader = F)
  
  # render populated HTML table with initial values
  shiny::renderUI({shiny::HTML(textInputTable)})
  
}