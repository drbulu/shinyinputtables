

textTableInput <- function(tableId){

  # addResourcePath(
  #   prefix = 'www/shinyinputtables',
  #   directoryPath = system.file('www', package='shinyinputtables')
  # )
  # 
  # table_css_path <- 'www/shinyinputtables/element_styling_text_table.css'
  # table_js_path <- 'www/shinyinputtables/input_binding_text_table.js'
  
  addResourcePath(
    prefix = 'shinyinputtables',
    directoryPath = "./inst/www"
  )
  
  table_css_path <- 'shinyinputtables/element_styling_text_table.css'
  table_js_path <- 'shinyinputtables/input_binding_text_table.js'
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src=table_js_path),
        shiny::tags$link(rel="stylesheet", type="text/css", href=table_css_path)
      )
    ),
    shiny::uiOutput(tableId)
  )
  
}