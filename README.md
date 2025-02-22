# CCHMN_trends_2021

This repo contains input data, code and supplemental visualizations for Medina et al. (2024): "Water quality trend analysis for the Greater Charlotte Harbor estuaries in southwest Florida, 2000–2021"

## input.dat.RData

Contains input data for the trend analysis. Columns:

* `date`:			sample date (YYYY-MM-DD)
* `station`:		CCHMN stratum name
* `param`:			water quality parameter
* `value`:			reported sample value
* `unit`:			measurement unit
* `depth`:			sampling depth
* `doy`:			day of year (integer)
* `cont_year`:		decimal year
* `yr`:				year (integer)
* `mo`:				month (integer)

## thresholds.csv

Contains selected thresholds for nitrogen, phosphorus, and chlorophyll. Columns:

* `Stratum`:			CCHMN stratum name
* `Phosphorus, TP`:		Phosphorus threshold values (mg/L)
* `Nitrogen, TN`:		Nitrogen threshold values (mg/L)
* `Chlorophyll a`:		Chlorophyll threshold values (ug/L)

## trends.R

Reproduces trend visualizations for a specified analyte (`input.dat$param`) and stratum (`input.dat$station`).

* The first plot displays the monthly-aggregated sample data and the GAM fit.
* The second plot displays the annual mean (with 95% CI) and the trend for 2017-2021 (with 95% CI). For TN, TP, and chlorophyll, the plot displays the corresponding threshold as a dotted line.
* The third plot displays the estimated trend slopes (with 95% CI) over a sliding 5-year window (right-handed).

## Supplement1.pdf

Visualizations of data with GAM fit, 10-year trends (2012-2021), and 5-year trends (2017-2021).

## Supplement2.pdf

Visualizations of estimated trend slopes over 5-year sliding windows.