library(data.table)
library(rgdal)

## zmente cestu
setwd('./data')

## nactete data
dta = readRDS('free_data.rds')

## nactete rozvodnice
pov = readOGR('povodi.shp')

d = '480500'
dta = dta[DBCN == d & !is.na(R)]
pov = pov[pov$DBCN == d, ]

require(leaflet)
wpov = spTransform(pov, CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs '))
leaflet(wpov) %>% addTiles()  %>% addPolygons()


mdta = dta[, .(DTM = DTM[1], P = sum(P), T = mean(T), R = sum(R)), by = .(year(DTM), month(DTM))]

library(bilan)
b = bil.new('m', data = mdta)
bil.pet(b)
res = bil.optimize(b)

