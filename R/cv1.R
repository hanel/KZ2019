library(data.table)
library(rgdal)


## zmente cestu
setwd('./data')

## nactete data
dta = readRDS('free_data.rds')

## nactete rozvodnice
pov = readOGR('povodi.shp')

pov@data

dbcn = "345000"

mdta = dta[DBCN == dbcn, .(DTM = DTM[1], P= sum(P)*1.1, T = mean(T), R = sum(R)), by = .(year(DTM), month(DTM))]

mdta[, plot(P, type = 'l')]
mdta[, hist(P, type = 'l')]
mdta[, boxplot(P, type = 'l')]
mdta[, boxplot(T~month, type = 'l')]

### vykresleni shapefilu
plot(pov)
plot(pov[pov$DBCN == dbcn, ], col = 'red', add = TRUE)
mojePov = pov[pov$DBCN == dbcn, ]

require(leaflet)
wpov = spTransform(mojePov, CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs '))
leaflet(wpov) %>% addTiles()  %>% addPolygons()

## Bilan
library(bilan)
b = bil.new(type="m", data = mdta)
bil.pet(b)
bil.set.optim(b, method = 'DE')
res = bil.optimize(b)
res = data.table(res)
res[, plot(DTM, R, type = 'l')]
res[, lines(DTM, RM, col = 'red')]
res[!is.na(R), cor(R, RM)]

res[, mean(R, na.rm = TRUE), by = month(DTM)][, plot(month, V1, type ='l', ylim = c(0,100))]
res[, mean(RM, na.rm = TRUE), by = month(DTM)][, lines(month, V1, col = 'red')]

bil.get.params(b)

res[, plot(R, RM)]



###
library(dygraphs)
library(magrittr)

r = ts(res[, R], start = c(res[1, year(DTM)], res[1, month(DTM)]), frequency = 12 )
rm = ts(res[, RM], start = c(res[1, year(DTM)], res[1, month(DTM)]), frequency = 12 )
re = cbind(r, rm)

dygraph(re) %>% dyRangeSelector() %>% dyRoller(rollPeriod = 5)



### Ulozim praci:

setwd('../vysledky/')
saveRDS(mdta, 'obs.rds')

saveRDS(mojePov, 'mojePov.rds')
