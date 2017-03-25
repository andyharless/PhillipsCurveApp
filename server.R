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
#      end_date <- end_date - c(1,0)
#    Or by 6 months?
    infl <- infl[7:length(infl)]
    ue <- ue[1:(length(ue)-6)]

    # Kludge to adjust end_date to reflect inflation lag
    nsubtract = 6  # number of months to subtract from end_date, must be <= 12
    end_date[1] <- end_date[1] - ifelse( end_date[2]>nsubtract, 0, 1)
    end_date[2] <- end_date[2] - nsubtract + ifelse( end_date[2]>nsubtract, 0, 12)

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
           g <- ggplot(sampl, aes(Unemployment, Inflation)) +
                geom_point(size=input$size, alpha=input$alpha)
           if (input$linefit) { g <- g + geom_smooth(method = "lm") }
           if (input$polyfit) { 
               g <- g + 
                 geom_smooth( method="lm", formula = y ~ poly(x,2) ) 
           }
           g
         }
     }
   })
   
        
})   
  
