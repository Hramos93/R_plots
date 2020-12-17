## Assignment week 3
### Plotly

<p> disclamer I need make this assignment this way because Rmarkdown not reder graph to plotly </p>

##3 Libraries

```{r setup, include=FALSE}
library(wbstats); library(WDI);
library(tidycensus)
library(tidyverse)
library(sf)
library(plotly)
library(tidyr)
library(plyr)
```


### Data Processing


```{r echo=TRUE}

indicators <- c( popTotal = "SP.POP.TOTL",
                 popGrow = "SP.POP.GROW",
                 popUrb = "SP.URB.GROW",
                 popRural = "SP.RUR.TOTL.ZG",
                 popMale = "SP.POP.TOTL.MA.IN",
                 popFemale = "SP.POP.TOTL.FE.IN")
popGrow <- wb_data(country = "VE", indicators, start_date = 1980, end_date = 2019)

```

### Plotly

```{r, warning=F}

fig <- plot_ly(x = popGrow$date, y = popGrow$popTotal, mode = 'lines', type  = "scatter", name = "total pop") 
 
fig <- fig %>% add_trace(y = popGrow$popFemale, name = 'Grow Female')
fig <- fig %>% add_trace(y = popGrow$popMale, name = 'Grow Male ')
fig
```
![PLotly](assignament.gif)
