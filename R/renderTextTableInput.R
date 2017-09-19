
# examples of extra classes to add
# .table-condensed # "table-condensed" should also work. confused?
# .table-responsive
# .table-bordered

# https://www.w3schools.com/bootstrap/bootstrap_tables.asp

renderTextTableInput <- function(output, input_df, tableId, extra_classes = NA){
    
    # setting up additional table classes
    
    # render populated html table with initial values
    output[[tableId]] <- shiny::renderUI({
        shiny::HTML(
            df_to_html(df = input_df, id_prefix = tableId, extra_classes)
        )
    })
    
}

df_to_html <- function(df, id_prefix, extra_classes = NA,  
                       isThead = F, isTbody = F, editableHeader = F){
    
    if(!is.character(extra_classes)) extra_classes = "table-bordered"
    
    edit_main_css_class <- "editable_input_table"
    edit_class <- paste(edit_main_css_class, paste(extra_classes, collapse = " "))
    table_tag_start <- paste0("<table class='", edit_class, "'>")
    table_tag_end <- "</table>"
    
    table_head <- create_edit_table_head(df, id_prefix, isThead = isThead, isEditable = editableHeader)
    table_body <- create_edit_table_body(df, id_prefix, isTbody = isTbody)
    
    paste0(table_tag_start, table_head, table_body, table_tag_end)
    
}

# I'm not sure that I want to set readonly status quite yet
input_cell <- function(x, id, isEditable = T){
    if(isEditable){
        return(paste0(
            "<input value = '", x, "' ",
            "id = '", id, "' ",
            "class = 'input-cell'",
            " type = 'text' >"
        ))
    } else {
        return(paste0(
            "<span id = '", id, "' ",
            "class = 'display-cell' >",
            x,
            "</span>"
        ))
    }
}

create_edit_table_head <- function(df, id_prefix, isThead = F, isEditable = F){
    
    table_head <- sapply(X = 1:ncol(df), FUN = function(colID){
        cell_id <- paste0(id_prefix, "_head", "-", colID) 
        paste0("<th>", 
               input_cell(x = names(df)[colID], id = cell_id, isEditable = isEditable), 
               "</th>")
    })
    table_head <- paste0("<tr>", paste(table_head, collapse=""), "</tr>")
    if(isThead) return(paste0("<thead>", table_head, "</thead>"))
    else return(table_head)
}

create_edit_table_body <- function(df, id_prefix, isTbody = F){
    table_body <- lapply(X = 1:nrow(df), FUN = function(rowID){
        row_cells <- sapply(X = 1:ncol(df), FUN = function(colID){
            cell_id <- paste0(id_prefix, "_", rowID, "-", colID) 
            paste0("<td>", 
                   input_cell(x = df[rowID, colID], id = cell_id, isEditable = T), 
                   "</td>")
        })
        paste0("<tr>", paste(row_cells, collapse=""), "</tr>")
    })
    table_body <- paste(table_body, collapse="")
    if(isTbody) return(paste0("<tbody>", table_body, "</tbody>"))
    else return(table_body)
}
