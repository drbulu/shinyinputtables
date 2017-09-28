## reference material for potential ideas:
# https://shiny.rstudio.com/gallery/custom-input-bindings.html
# https://www.w3schools.com/tags/att_input_readonly.asp
# https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#Attributes
# https://stackoverflow.com/questions/3676127/how-do-i-make-a-text-input-non-editable
# https://api.jquery.com/removeAttr/
# https://stackoverflow.com/questions/5995628/adding-attribute-in-jquery
# https://stackoverflow.com/questions/2496443/how-i-can-add-and-remove-the-attribute-readonly
# avoids memory leaks?: https://api.jquery.com/data/ (recommended in the prop vs attr discussion)

# simple helper function for dealing with NA, NaN, NULL and Inf values
# empty character vectors are ok as they are the desired return value
# to represent invalid inputs

basicInputCheck <- function(val, removeInfOrNA = T){
  if(is.null(val)) return("")
  if(removeInfOrNA) {
    if(grepl("^-?Inf$", as.character(val))) return("")
    else if(is.na(val)) return("")
  }
  return(val)
}


# I'm not sure that I want to set readonly status quite yet
# this might be something along the lines of a param called
# isLockable (or a better name)
createInputCell <- function(eValue, eRef = NAL, eClasses = NA, type = "text"){
  
  # input validation for params
  eValue <- basicInputCheck(val = eValue, removeInfOrNA = F)
  type <- basicInputCheck(val = type, removeInfOrNA = T)
  eRef <- basicInputCheck(val = eRef, removeInfOrNA = T)
  eClasses <- basicInputCheck(val = eClasses, removeInfOrNA = T)
  
  # param prep for element creation
  eClasses <- ifelse(!nchar(eClasses), eClasses, paste0("class ='", eClasses, "' "))
  type <- ifelse(!nchar(type), "text", type)
  
  return(paste0(
    "<input value = '", eValue, "' ",
    eRef, " ", eClasses,
    "type = '", type, "' >"
  ))
}

# Will possibly implement editable spans via contenteditable 
# attribute later if it makes sense
createSpanCell <- function(eValue, eRef = NA, eClasses = NA){
  
  # input validation for params
  eValue <- basicInputCheck(val = eValue, removeInfOrNA = F)
  eRef <- basicInputCheck(val = eRef, removeInfOrNA = T)
  eClasses <- basicInputCheck(val = eClasses, removeInfOrNA = T)
  
  # param prep for element creation
  eClasses <- ifelse(!nchar(eClasses), eClasses, paste0("class ='", eClasses, "' "))
  
  return(paste0(
    "<span ", eRef, " ", eClasses, ">", eValue, "</span>"
  ))
}
