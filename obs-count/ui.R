library(shiny)
library(DBI)
library(ggplot2)


conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "openmrs",
  host = "10.0.1.103",
  username = "openmrs-user",
  password = "password")
on.exit(dbDisconnect(conn), add = TRUE)
dsamp <- dbGetQuery(conn, paste0("select cn.name as name, count(order_id) as count from orders inner join concept_name cn on cn.concept_id = orders.concept_id  group by orders.concept_id;"))
diagnosis_names <- dbGetQuery(conn, paste0("select name from concept_name where concept_id in (select value_coded from obs where concept_id in (select concept_id from concept_name where name = 'Coded Diagnosis' and concept_name_type='FULLY_SPECIFIED')) and concept_name_type='FULLY_SPECIFIED';"))

shinyUI(fluidPage(
  titlePanel("Patient Count with Diagnosis"),
  sidebarPanel(
    helpText("choose the diagnosis"),
    selectInput("diagnosis_selected", "Diagnoses:",
                choices=diagnosis_names$name, multiple = TRUE),
    hr(),
    dateInput('fromdate',
              label = 'Start Date input: yyyy-mm-dd',
              value = Sys.Date()
    ),
    dateInput('todate',
              label = 'End Date input: yyyy-mm-dd',
              value = Sys.Date()
    )
  ),
  mainPanel(
    plotOutput("diagnosis_plot",  click = "plot1_click")
  )
))
