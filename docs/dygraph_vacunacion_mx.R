library(dplyr)
library(dygraphs)
library(xts)          # convert data-frame to xts format
library(tidyverse)
library(lubridate)

# 1. DATOS
# reference:
# Mathieu, E., Ritchie, H., Ortiz-Ospina, E. et al. A global database of COVID-19 vaccinations. Nat Hum Behav (2021)
# https://ourworldindata.org/covid-vaccinations?country=MEX

vacunas = read.csv("https://covid.ourworldindata.org/data/owid-covid-data.csv") # COSECHA DATOS DE OUR WORLD IN DATA
vacunas_mx = vacunas[vacunas$iso_code=="MEX",]

# 2. Generate a time series graph in D3! for the country
# vacunas_mx
date = vacunas_mx$date
death= vacunas_mx$new_deaths
cases = vacunas_mx$new_cases

names(death) = date
names(cases) = date

y = c(rep(NA, 7), death)
x = c(cases, rep(NA, 7))

d.7 = y/x

y = c(rep(NA, 14), death)
x = c(cases, rep(NA, 14))

d.14 = y/x

# 3. Generar base de datos con variables de la grafica

# PROPORCIONES
X.vac = data.frame(personas_1dosis =  vacunas_mx$people_vaccinated / vacunas_mx$population
                   , personas_2dosis = vacunas_mx$people_fully_vaccinated /vacunas_mx$population
                   , decesos_7d = d.7[date]
                   , decesos_14d = d.14[date])

# CASOS POR CADA 10 000 HABITANTES. SE CALCULA COMO: proporcion * 10 000
X.vac.10M = data.frame(personas_1dosis =  (vacunas_mx$people_vaccinated / vacunas_mx$population)*10000
                       , personas_2dosis = (vacunas_mx$people_fully_vaccinated /vacunas_mx$population)*10000
                       , decesos_7d = (d.7[date])*10000
                       , decesos_14d = (d.14[date])*10000)

q.10M = xts(x = X.vac.10M, order.by = as.Date(vacunas_mx$date))

# 4. Asignar nombres de la leyenda. Son los nombres de las comulmens en q.10M
names(q.10M)<-c( "personas vacunadas con 1 dosis cada 10 000 habitantes"
                 , "personas completamente vacunadas cada 10 000 habitantes"
                 , "decesos a los 7 días, cada 10 000 casos de Covid-19"
                 , "decesos a los 14 días, cada 10 000 casos de Covid-19")

# 5. Producir dygraph()
p.10M <- dygraph(q.10M, ylab="", main="Efecto de la vacunación en México"
                 , xlab ="<div align='left' style='margin-left:10%;'><ul><h3>Fuentes de datos:</h3>
                       <li>
                       <i>Mathieu, E., Ritchie, H., Ortiz-Ospina, E. et al. A global database of COVID-19 vaccinations. Nat Hum Behav (2021)
                       </li>
                       <li><a href= 'https://ourworldindata.org/covid-vaccinations' target='_blank'>Our World in Data</a>
                       </li>
                       </i><ul></div>"
                 , width="auto" , height="75vh"
                 )%>% dyOptions(labelsUTC = T, fillGraph=T, fillAlpha=0.3, drawGrid = T, colors=c("royalblue", "green", "red", "firebrick")) %>% 
          dyRangeSelector() %>%
          dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.3, hideOnMouseOut = FALSE) %>%
          dyRoller(rollPeriod = 7) %>% dyLegend(labelsSeparateLines = 1) %>% dyCSS(css="style_dygraph.css") 

p.10M

# 6. Guardar la gráfica p.10M en un documento *.html
library(plotly)
htmlwidgets::saveWidget(as_widget(p.10M), "vacunacion_letalidad_mx.html")
