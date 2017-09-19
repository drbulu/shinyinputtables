

textTableInput <- function(tableId){
  
  addResourcePath(
    prefix = 'www/shinyinputtables', 
    directoryPath = system.file('www', package='shinyinputtables')
  )
  
  table_css_path <- 'www/shinyinputtables/input_binding_text_table.js'
  table_js_path <- 'www/shinyinputtables/element_styling_text_table.css'
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src=table_js_path),
        shiny::tags$link(rel="stylesheet", type="text/css", href=table_css_path)
      ),
      shiny::uiOutput(tableId)
    )
    
}