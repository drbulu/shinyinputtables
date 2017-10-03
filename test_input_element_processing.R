## 1. Text Input

text_input <- extractMatch(el = shiny::textInput("", ""), pattern = "<input(.)+/>")

## 2. Text Area

text_area <- extractMatch(el = shiny::textAreaInput("", ""), pattern = "<textarea(.)+area>")
text_area2 <- extractMatch(el = shiny::textAreaInput("foo", "bar"), pattern = "<textarea(.)+area>")
## 3. Numeric

numeric_input <- extractMatch(el = shiny::numericInput("", "", value=""), pattern = "<input(.)+/>")

## 4. Date Input

date_input <- extractMatch(el = shiny::dateInput("", ""), pattern = "<input(.)+/>")

## 5. Checkbox

check_box <- extractMatch(el = shiny::checkboxInput("", ""), pattern = "<input(.)+/>")

## 6. Select / Selectize?

# need to process select and selectize separately? Probably wise given unknown complexity!
# we need the inner div
# so we need to strip out the outer div and label + the last div close tag!
select_box <- extractMatch(el = shiny::checkboxInput("", ""), pattern = "<input(.)+/>")

## 7. Date range input --- not sure... will save till later!

date_range_input <- extractMatch(el = shiny::dateRangeInput("", ""), pattern = "<input(.)+/>")

## File input --- NO! Too complex to bother with! 
# I can probably replicate core function of type="file" in a simpler
# way if need be.


## Next step ... process quotes

double_quote <- '\\"'
single_quote <- "'"

# quote conversion: aimplicity!
gsub(double_quote, single_quote, text_input)

class_frm_ctrl <- "class=class='form-control'"
id_empty <- "id=''"
id_valid <- "id=(.)+\s"

# cell label
data_cell_label <- " data-cell_ref='' "

# possibly use 
# sigh... may have to paste this back on at the end!
#grepl "^<textarea" then replace start tag with data cell label
# or extract start tag, replace tag end, then paste with non start tag!
# 3 simple steps
# then paste0
textarea_tag_s_rhs <- ">" 
input_end_tag <- "/>"

