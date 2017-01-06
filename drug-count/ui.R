library(shiny)
library(DBI)
library(ggplot2)


conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "openmrs",
  host = "192.168.33.10",
  username = "openmrs-user",
  password = "password")
on.exit(dbDisconnect(conn), add = TRUE)
dsamp <- dbGetQuery(conn, paste0("select cn.name as name, count(order_id) as count from orders inner join concept_name cn on cn.concept_id = orders.concept_id  group by orders.concept_id;"))
drugnames <- dbGetQuery(conn, paste0("select cn.name as drugs, count(order_id) as count from orders inner join concept_name cn on cn.concept_id = orders.concept_id where cn.concept_name_type='FULLY_SPECIFIED' group by orders.concept_id having count(order_id) > 0;"))

shinyUI(fluidPage(
  titlePanel("Patient Count with drugs prescibed"),
  sidebarPanel(
    helpText("choose the drugs"),
    selectInput("drugselected", "Drug Names:", 
                choices=drugnames$drugs, multiple = TRUE),
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
    plotOutput("drugPlot",  click = "plot1_click") 
  )
))
