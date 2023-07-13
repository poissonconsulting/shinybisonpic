# deploy to poissonconsulting server
rsconnect::deployApp(
  account = "poissonconsulting",
  appName = "shinybisonpic-dev",
  forceUpdate = TRUE
)

if (FALSE) {
  rsconnect::deployApp(
    account = "poissonconsulting",
    appName = "shinybisonpic",
    forceUpdate = TRUE
  )
}
