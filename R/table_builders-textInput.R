createTextInputTable <- function(
  df, 
  idPrefix = NA, 
  tableClasses = "table-bordered", 
  baseClass = "shinyinputtables", 
  editableHeader = F){
  
  tableMainClass <- paste0(baseClass, "-textInput")  
  tableClassSet <- edit_class <- paste(tableMainClass, paste(tableClasses, collapse = " "))
  
  table_tag_start <- paste0("<table class='", tableClassSet, "'>")
  
  tableHead <- createTextInputHead(df = df, 
                                   isEditable = editableHeader)
  
  tableBody <- createTextInputBody(df = df)
  
  paste0(table_tag_start, tableHead, tableBody, "</table>")
  
}

createTextInputHead <- function(df, isEditable = F){
  
  baseCellClass <- "input_table_cell"
  cellRefPrefix <- "data-cell_label= "
  
  tableHead <- sapply(X = 1:ncol(df), FUN = function(colID){
    cell_data_ref <- paste0(cellRefPrefix, "'H-", colID, "'")
    cellElement <- NA
    if(isEditable){
      cellElement <- createInputCell(eValue = names(df)[colID], 
                                     eRef = cell_data_ref, 
                                     eClasses = baseCellClass,
                                     type = "text")
    } else {
      cellElement <- createSpanCell(eValue = names(df)[colID], 
                                    eRef = cell_data_ref, 
                                    eClasses = baseCellClass)
    }
    paste0("<th>", cellElement, "</th>")
  })
  
  return(paste0("<thead>", "<tr>", 
                paste(tableHead, collapse=""), 
                "</tr></thead>"))
  
}

createTextInputBody <- function(df){
  
  baseCellClass <- "input_table_cell"
  cellRefPrefix <- "data-cell_label = "
  
  tableRows <- lapply(X = 1:nrow(df), FUN = function(rowID){
    rowCells <- sapply(X = 1:ncol(df), FUN = function(colID){
      cell_data_ref <- paste0(cellRefPrefix, "'", rowID, "-", colID, "'")
      paste0("<td>", 
             createInputCell(eValue = df[rowID, colID], 
                             eRef = cell_data_ref, 
                             eClasses = baseCellClass,
                             type = "text"),
             "</td>")
    })
    paste0("<tr>", paste(rowCells, collapse=""), "</tr>")
  })
  
  return(paste0("<tbody>", paste(tableRows, collapse=""), "</tbody>"))
  
}