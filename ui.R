#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(

    titlePanel( "Inflation and Unemployment in the US, 1948-2016"),
    
    fluidRow( 
      helpText( "Hold and brush over part of the chart to select a date range. Then select plot type." ),
      plotOutput( "timeSeriesPlot",  brush = brushOpts(id = "brush2") )
    ),

    fluidRow(
       column( width=3, wellPanel(
                            radioButtons("plot_type", "Plot type",
                            c("Magnify", "Scatter")
                            )
                        ) 
       ),
       column( width=9, plotOutput("newPlot") )
    )
  )

)
