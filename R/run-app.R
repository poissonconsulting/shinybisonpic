#' Run shinybisonpic App
#'
#' This function will launch the app locally.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' run_bisonpic_app()
#' }
run_bisonpic_app <- function() {
  shiny::shinyAppDir(
    system.file("app", package = "shinybisonpic"),
    options = list("launch.browser" = TRUE)
  )
}
