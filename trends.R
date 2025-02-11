rm(list=ls(all=TRUE))

# Load libraries
if(!require(wqtrends)) { install.packages('wqtrends',
                                          repos = 'https://tbep-tech.r-universe.dev' )
}; library(wqtrends)
if(!require(dplyr)) { install.packages('dplyr') }; library(dplyr)
if(!require(lubridate)) { install.packages('lubridate') }; library(lubridate)
if(!require(mixmeta)) { install.packages('mixmeta') }; library(mixmeta)
if(!require(mgcv)) { install.packages('mgcv') }; library(mgcv)
if(!require(ggplot2)) { install.packages('ggplot2') }; library(ggplot2)


# Load CCHMN data and thresholds
load("input.dat.RData")
thresholds <- read.csv("thresholds.csv",check.names=FALSE)

# Select analyte and stratum
input.dat$param |> levels()
input.dat$station |> levels()
analyte <- "Nitrogen, TN"
stratum <- "Tidal Caloosahatchee River"

# Specify analytes to log-transform
logvars <- c( "Chlorophyll a",
              "Nitrogen, NHx-N", "Nitrogen, NOx-N", "Nitrogen, TKN", "Nitrogen, TN",
              "Phosphorus, PO4-P", "Phosphorus, TP" )
if( analyte %in% logvars ){
  trans <- "log10"
} else {
  trans <- "ident"
}

# Subset data
subdat <- input.dat[ which( input.dat$param == analyte &
                            input.dat$station == stratum ), ]

# Aggregate subdat to monthly resolution
subdat2 <- subdat
subdat2$date <- subdat2$date |> floor_date('month')  # floor all dates
subdat2$doy <- subdat2$date |> yday()  # recompute doy
subdat2$cont_year <- subdat2$date |> decimal_date()  # re-compute cont_year
subdat2 <- subdat2 |> group_by( date, station, param, unit,
                                doy, cont_year, yr, mo ) |>
                        dplyr::summarize( value = mean(value) ) |> as.data.frame()

# GAM for 2000-2021
mod <- anlz_gam( subdat2 )
show_prdseries( mod, ylab = unique(subdat2$unit) )

# Annual means and trend for 2017-2021
p2 <- show_metseason( mod, yrstr = 2017, yrend = 2021, doyend = 365,
                ylab = unique(subdat2$unit) )
if( analyte %in% c("Nitrogen, TN","Phosphorus, TP","Chlorophyll a") ){
  this.threshold <- thresholds[ which( thresholds$Stratum==stratum ),
                                which( colnames(thresholds)==analyte ) ]
  p2 +
    geom_hline( yintercept = this.threshold,
                linetype = "dashed", color = rgb(0,0,0,0.6) )
} else {
  p2
}

# Trend slopes over sliding 5-year window
show_trndseason( mod, justify = "right", win = 5, doyend = 365,
                 ylab = unique(subdat2$unit) )
