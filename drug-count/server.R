library(shiny)
library(DBI)
library(ggplot2)
library(reshape2)

shinyServer(function(input, output) {

  output$drugPlot <-renderPlot({ 
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
      from orders 
      inner join concept_name cn on cn.concept_id = orders.concept_id 
      inner join person p on p.person_id= orders.patient_id
      where cn.name in(",paste0("'",paste(input$drugselected, collapse="', '"),"'"),") and orders.date_activated between ", paste0("'", as.character(input$fromdate), "'"), " and ", paste0("'", as.character(input$todate), "'")," group by orders.concept_id order by count(order_id) desc", ";"))
    
    DF1 <- melt(dsamp1, id.var="name")
    ggplot(DF1, aes(x = name, y = value)) + 
      geom_bar(aes(fill = variable), position = "dodge", stat="identity") + geom_text(aes(label=value), position = position_dodge(width = 1), vjust=-1) + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + coord_flip()
  }
    )

})
