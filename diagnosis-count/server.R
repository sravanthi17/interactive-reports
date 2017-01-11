library(shiny)
library(DBI)
library(ggplot2)
library(reshape2)
library(plotly)

shinyServer(function(input, output) {

  output$diagnosis_plot <-renderPlot({
    conn1 <- dbConnect(
    drv = RMySQL::MySQL(),
    dbname = "openmrs",
    host = "192.168.33.10",
    username = "openmrs-user",
    password = "password")
    on.exit(dbDisconnect(conn1), add = TRUE)

    dsamp1 <- dbGetQuery(conn1, paste0(
    "select cn.name as name,
    ifnull(sum(IF(p.gender = 'F', 1, 0)),0) AS female,
    ifnull(sum(IF(p.gender = 'M', 1, 0)),0) AS male,
    ifnull(sum(IF(p.gender = 'O', 1, 0)),0) AS other
    from obs
    inner join concept_name cn on cn.concept_id=obs.value_coded and cn.concept_name_type='FULLY_SPECIFIED' and cn.name in(",paste0("'",paste(input$diagnosis_selected, collapse="', '"),"'"),")
    inner join person p on p.person_id= obs.person_id
    where obs.obs_datetime between ", paste0("'", as.character(input$fromdate), "'"), " and ", paste0("'", as.character(input$todate), "'")," group by obs.value_coded order by count(obs.value_coded) desc", ";"))

    DF1 <- melt(dsamp1, id.var="name")
 
    ggplot(DF1, aes(x = name, y = value)) +
    geom_bar(aes(fill = variable), position = "dodge", stat="identity")  + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_text(aes(label=value))
    }
  )
})
