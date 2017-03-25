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
      helpText( "Hold and brush over part of the chart to select a date range. Then choose plot type and characteristics (for scatter only)." ),
      plotOutput( "timeSeriesPlot",  brush = brushOpts(id = "brush2") )
    ),

    fluidRow(
       column( width=3, wellPanel(
                            radioButtons("plot_type", "Plot type",
                            c("Magnify", "Scatter"), selected="Scatter"
                            ),
                            sliderInput("alpha", "Choose point opacity:",
                                        min = 0, max = 1, value = .3
                            ),
                            sliderInput("size", "Choose point size:",
                                        min = 0, max = 10, value = 5
                            ),
                            checkboxInput("linefit", "Linear fit"
                            ),
                            checkboxInput("polyfit", "Quadratic fit"
                            )
       ) 
       ),
       column( width=9, plotOutput("newPlot") )
    )
  )

)
