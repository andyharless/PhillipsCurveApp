# PhillipsCurveApp
Shiny App to Plot US Phillips Curves

The app is running on [this server](https://harless.shinyapps.io/PhillipsCurveApp/) at Shinyapps.io

Extensions to consider writing in the future:

1. Allow user to choose time offset for unemployment (a point-in-time reading) vs.
inflation (a 12-month change, so where should it overlap the unemployment rate?)

2. Allow a shifting baseline for inflation (e.g., subtract the last N-years average
inflation rate from inflation, where N is maybe a slider choice)

3. Allow user to choose different series to plot (most obviously, wage growth instead of
inflation, but more generally there could be other labor market tightness indicators
besides unemployment, and anyhow there's no reason to confine oneself to Phillips curves).

4. Allow user to choose different countries for which to plot Phillips curves.

5. Allow user to configure definition of inflation (e.g. 6 months instead of a year,
PCE deflator instead of CPI)
