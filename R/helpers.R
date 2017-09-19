extract_cell_id <- function(x, pattern = "[0-9]+\\-[0-9]+$", split = "-"){
  cell_id_text <- regmatches(x, regexpr(pattern, x))
  as.numeric(unlist(strsplit(cell_id_text, split = split)))
}