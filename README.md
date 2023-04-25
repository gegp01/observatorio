# observatorio
## Titulo 2
### titulo 3


<i>desarrollo del C3</i>

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

codigo 2

```{r d, echo = T, warning = F, message = F}

require(ape)
require(Hmisc)
# path = "~/sandbox/AMR/"
# setwd(path)
#d = read.csv("~/sandbox/AMR/Global_AMR_enriched_FINAL_corrected.csv", sep = ";")
d = read.csv("~/sandbox/AMR/Global_AMR_enriched_FINAL_ISO3_abnamescorrected.csv", sep = ",")
d.back = d

#names(d)[names(d)=="Betalactamics"]<-"Betalactans"
#names(d)[names(d)=="Sulfonamides"]<-"Sulphonamides"


#d = d[is.na(d$year)==F,] # Eliminate data without year

antibiotics = c("Aminoglycosides","Beta.lactams","Polymyxins"
  ,"Fosfomycin","Glycopeptides","Macrolides","Oxazolidinones","Phenicols"      
  ,"Quinolones","Rifampicin","Sulphonamides","Tetracyclines","Trimethoprim")

d$amr = rowSums(d[,antibiotics])
d = d[is.na(rowSums(d[, antibiotics]))==F,] # ELIMINATE NAs IN ANTIBIOTICS

```
