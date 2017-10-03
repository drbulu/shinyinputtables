extractMatch <- function(el, pattern, invert = FALSE){
  el <- as.character(el)
  regmatches(x = el, 
             m = regexpr(pattern = pattern, text = el),
             invert = invert)
}

# ... ellipses args are arguments passed to cell_type function

# https://stackoverflow.com/questions/3057341/how-to-use-rs-ellipsis-feature-when-writing-your-own-function
# https://stackoverflow.com/a/7028630
# https://stackoverflow.com/questions/11885207/get-all-parameters-as-list
# https://stackoverflow.com/questions/7944809/assigning-null-to-a-list-element-in-r

# TODO: add selectize support, handle custom input classes!

createInputCell_dev <- function(row, col, cell_type, rm_frm_class = TRUE, ...){
  ## match args and check cell type
  type_opts <- c("text_input","text_area","num_input","date_input","check_box")
  cell_type <- match.arg(arg = cell_type, choices = type_opts)
  isTextArea <- ifelse(cell_type == "text_area", TRUE, FALSE)
  
  ## select shiny input function
  f <- switch(cell_type, 
              text_input = shiny::textInput, 
              text_area = shiny::textAreaInput, 
              num_input = shiny::numericInput, 
              date_input = shiny::dateInput,
              check_box = shiny::checkboxInput
  )
  
  ## process function args. strip "label" from list
  # extract function args
  in_args <- list(...)
  in_args["label"] <- list(NULL)
  # insert blank inputId if not supplied
  if(!("inputId" %in% names(in_args))) in_args["inputId"] <- ""
  # modify default args
  f_args <- as.list(args(f))
  f_args[names(in_args)] <- in_args
  
  ## remove unnamed args
  f_args <- f_args[!!nchar(names(f_args))]
  
  ## extract core input element: a) <textarea> or b) <input/>
  el_pattern <- ifelse(isTextArea, "<textarea(.)+area>", "<input(.)+/>")
  cell_el <- extractMatch(el = do.call(f, f_args), pattern = el_pattern)
  
  # process string quotes and rm invalid/empty element ID: valid: "id=(.)+\s"
  cell_el <- gsub('\\"', "'", cell_el)
  cell_el <- gsub("id=''", "", cell_el)
  
  ## strip form control CSS class if not required
  css_frm_ctrl <- "class=class='form-control'"
  if(rm_frm_class) cell_el <- gsub(css_frm_ctrl, "", cell_el)
  
  ## check cell_type and insert data cell label info
  label_prefix <- " data-cell_label"
  data_cell_label <- paste0(" ", label_prefix,"=", row, "-", col, " ")
  
  if(isTextArea){
    cell_end_REGEX <- ">(.)+>$"
    el_start <- extractMatch(cell_el, cell_end_REGEX, invert = TRUE)
    el_end <- extractMatch(cell_el, cell_end_REGEX)
    cell_el <- paste(el_start, data_cell_label, el_end)
  } else {
    cell_el <- gsub("/>", paste(data_cell_label, "/>"), cell_el)
  }
  
  return(cell_el)
  
}
