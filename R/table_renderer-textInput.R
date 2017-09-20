# examples of extra classes to add
# .table-condensed # "table-condensed" should also work. confused?
# .table-responsive
# .table-bordered

# https://www.w3schools.com/bootstrap/bootstrap_tables.asp

renderTextTableInput <- function(
  df, 
  tableId = NA, 
  tableClasses = "table table-bordered"){
  
  textInputTable <- createTextInputTable(
    df = df, 
    idPrefix = tableId, 
    tableClasses = tableClasses, 
    baseClass = "shinyinputtables", 
    editableHeader = F)
  
  # render populated html table with initial values
  shiny::renderUI({shiny::HTML(textInputTable)})
  
}