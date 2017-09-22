#' Run demo shiny apps to test out shinyinputtables functionality
#' 
#' @description Run a selected shiny app demo that showcases particulars aspects
#' of the functionality provided by the \code{shinyinputtables} package extension for Shiny.
#' 
#' @param demoName Single length character vector denoting the name of the desired demo app to run.
#' 
#' @details Currently the only supported demos are currently called "demo_01" and "demo_02".
#' Will describe each available demo in a separate section here
#' 
#' @export
runAppExample <- function(demoName) {
  # Useful reference: https://www.r-bloggers.com/supplementing-your-r-package-with-a-shiny-app-2/
  
  demoNames <- c("demo_01", "demo_02")
  
  demoName <- match.arg(arg = demoName, choices = demoNames)
  
  shiny::runApp(appDir = system.file("app_examples", demoName, package = "shinyinputtables"), 
                display.mode = "normal")
}