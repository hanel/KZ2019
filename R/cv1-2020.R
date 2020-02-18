library(rgdal)
library(data.table)

# meteo data

dta = readRDS('./data/free_data.rds')

dta$DBCN
dta[ , ,  ]
dta[month(DTM)==7 & DBCN=='017000']

pov = readOGR('data/povodi.shp')
plot(pov)

.dbcn = '018000'

mojePov = pov[pov$DBCN==.dbcn,]
plot(pov)
plot(mojePov, add = TRUE, col = 'orange2')

mojeDta = dta[DBCN==.dbcn]

saveRDS(mojeDta, './moje/dta.rds')
writeOGR(mojePov, './moje/pov.shp', driver = 'ESRI Shapefile', layer = 'pov')

###

mes = mojeDta[, .(DTM = mean(DTM), P = sum(P), T = mean(T), R = sum(R)), by = .(year(DTM), month(DTM))]
saveRDS(mes[!is.na(R), .(DTM, P, T, R)], './moje/mdta.rds')
write.table(mes[!is.na(R), .(DTM, P, T, R)], 'mdta.txt', row.names = FALSE)
