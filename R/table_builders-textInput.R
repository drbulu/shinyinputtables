
createTextInputTable <- function(df, idPrefix = NA, 
                                 tableClasses = "table-bordered", 
                                 baseClass = "shinyinputtables", editableHeader = F){

    tableMainClass <- paste0(baseClass, "-textInput")  
    tableClassSet <- edit_class <- paste(tableMainClass, paste(tableClasses, collapse = " "))
    
    table_tag_start <- paste0("<table class='", tableClassSet, "'>")
    
    tableHead <- createTextInputHead(df = df, idPrefix = idPrefix,
                                       isEditable = editableHeader,
                                       cellClasses = NA,
                                       baseClass = baseClass)
    tableBody <- createTextInputBody(df = df, idPrefix = idPrefix,
                                     cellClasses = NA,
                                     baseClass = baseClass)
    
    paste0(table_tag_start, tableHead, tableBody, "</table>")
  
}

createTextInputHead <- function(df, idPrefix, cellClasses, isEditable = F, baseClass){
  
  defaultCellClass <- paste0(baseClass, "-head")
  
  # basic input validation
  # input ID prefix
  idPrefix <- basicInputCheck(val = idPrefix, removeInfOrNA = T)
  hasIdPrefix <- !!nchar(idPrefix)
  # input cell classes
  cellClasses <- basicInputCheck(val = cellClasses, removeInfOrNA = T)
  cellClasses <- ifelse(!!nchar(cellClasses), paste0(" ", cellClasses), cellClasses)
  
  tableHead <- sapply(X = 1:ncol(df), FUN = function(colID){
    
    cellId <- ifelse(hasIdPrefix, paste0(idPrefix, "_", colID), NA)
    defaultCellClass <- ifelse(hasIdPrefix, 
                               defaultCellClass, 
                               paste0(defaultCellClass, "_", colID))
    
    cellClasses <- paste0(defaultCellClass, cellClasses)
    
    # can implement iseditable
    cellElement <- NA
    
    if(isEditable){
      cellElement <- createInputCell(eValue = names(df)[colID], 
                                    eId = cellId, 
                                    eClasses = cellClasses,
                                    type = "text")
    } else {
      cellElement <- createSpanCell(eValue = names(df)[colID], 
                     eId = cellId, 
                     eClasses = cellClasses)
    }
    
    paste0("<th>", cellElement, "</th>")

  })
  
  return(paste0("<thead>", "<tr>", 
                paste(tableHead, collapse=""), 
                "</tr></thead>"))
  
}

createTextInputBody <- function(df, idPrefix = NA, cellClasses = NA, baseClass){
  
  defaultCellClass <- paste0(baseClass, "-cell")
  
  # basic input validation
  # input ID prefix
  idPrefix <- basicInputCheck(val = idPrefix, removeInfOrNA = T)
  hasIdPrefix <- !!nchar(idPrefix)
  # input cell classes
  cellClasses <- basicInputCheck(val = cellClasses, removeInfOrNA = T)
  cellClasses <- ifelse(!!nchar(cellClasses), paste0(" ", cellClasses), cellClasses)
  
  tableRows <- lapply(X = 1:nrow(df), FUN = function(rowID){
    
    rowCells <- sapply(X = 1:ncol(df), FUN = function(colID){
      
      # essential table cell identifier
      cellRef <- paste0(rowID, "-", colID) 
      
      # modify ID or default class to ensure that cellRef accessible
      # 1. if ID provided paste with cellRef, else NA
      # 2. if ID provided leave unchanged, else paste with cellRef.
      cellId <- ifelse(hasIdPrefix, paste0(idPrefix, "_", cellRef), NA)
      defaultCellClass <- ifelse(hasIdPrefix, 
                                 defaultCellClass, 
                                 paste0(defaultCellClass, "_", cellRef))
      
      cellClasses <- paste0(defaultCellClass, cellClasses)
      
      paste0("<td>", 
             createInputCell(eValue = df[rowID, colID], 
                             eId = cellId, 
                             eClasses = cellClasses,
                             type = "text"),
             "</td>")
      
    })
    
    paste0("<tr>", paste(rowCells, collapse=""), "</tr>")
    
  })
  
  return(paste0("<tbody>", paste(tableRows, collapse=""), "</tbody>"))
  
}