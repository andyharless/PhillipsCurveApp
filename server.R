#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

    u <- read.csv("UNRATE.csv")
    ue <- u$UNRATE
    cpi <- read.csv("CPIAUCNS.csv")
    c <- log(cpi$CPIAUCNS)
    infl <- 100*diff(c,12)
    unemployment=ts(u$UNRATE, c(1948,1), c(2017,2), 12)
    inflation=ts(infl,c(1948,1),c(2017,2),12)
    df <- data.frame( year=as.vector(time(unemployment)), 
                      unemployment=as.vector(unemployment), 
                      Percent=as.vector(inflation) )

    output$timeSeriesPlot <- renderPlot({
       ggplot(df, aes(year, Percent, color="inflation")) + geom_line() + 
              geom_line(aes(year,unemployment,color="unemployemnt"))
    })

    outs <- reactive({
      brushed_data2 <- brushedPoints(df, input$brush2,
                                    xvar = "year", yvar = "Percent")
      if(nrow(brushed_data2) < 2){  return(NULL)  }
      brushed_data2
    })
   output$brushed_data2 <- renderPrint({ 
     cat("Whatever\n")
     str(outs()) 
     })
   
   output$newPlot <- renderPlot({
     datas = outs()
     if (!is.null(datas)) {
         sampl <- df[df$year %in% datas$year,]
         if (input$plot_type == "Magnify") {
             Year <- datas$year
             Percent <- datas$Percent
             ggplot(sampl, aes(Year, Percent, color="inflation")) + 
             geom_line() +
             geom_line(aes(datas$year,datas$unemployment,color="unemployemnt"))
         }
         else if (input$plot_type == "Scatter") {
           Unemployment <- datas$unemployment
           Inflation <-  datas$Percent
           ggplot(sampl, aes(Unemployment, Inflation)) + geom_point()
         }
     }
   })
   
        
})   
  
