#' Run demo shiny apps to test out shinyinputtables functionality
#' 
#' @description Run a selected shiny app demo that showcases particulars aspects
#' of the functionality provided by the \code{shinyinputtables} package extension for Shiny.
#' 
#' @param demoName Single length character vector specifying the name of the
#' desired demo app to run.
#' @param mode Single length character vector specifying the Shiny app display
#' mode. Value is used to set the \code{display.mode} arg in \code{Shiny::runApp}.
#' Legal values are either "showcase" (default) or "normal".
#' 
#' @details Currently the only supported demos are currently called "demo_01" 
#' and "demo_02". Will describe each available demo in a separate section here
#' 
#' @note These examples will run externally in the browser, but the may not run
#'  well in the RStudio
#' 
#' @export
runAppExample <- function(demoName, mode = "showcase") {
  
  mode <- match.arg(mode, choices = c("showcase", "normal"))
  # Useful reference: https://www.r-bloggers.com/supplementing-your-r-package-with-a-shiny-app-2/
  
demoNames <- c("demo_01", "demo_02")
  
  demoName <- match.arg(arg = demoName, choices = demoNames)
  
  shiny::runApp(appDir = system.file("app_examples", demoName, package = "shinyinputtables"), 
                display.mode = mode)
}