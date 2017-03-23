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
    begin_date <- c(1948,1)
    end_date <- c(2017,2)
#   This is 12-month lagging inflation: should unemployment be lagged by 12 months?
#      infl <- infl[13:length(infl)]
#      ue <- ue[1:(length(ue)-12)]
#      end_date <- end_date - 12
#    Or by 6 months?
    infl <- infl[7:length(infl)]
    ue <- ue[1:(length(ue)-6)]
    end_date <- end_date - 6
    unemployment=ts(ue, begin_date, end_date, 12)
    inflation=ts(infl, begin_date, end_date, 12)
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
  
