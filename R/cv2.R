source('./R/packages.R')

library(bilan)
library(data.table)
library(rgdal)
library(maptools)
library(raster)

setwd('./vysledky/')
mdta = readRDS('obs.rds')
mojePov = readRDS('mojePov.rds')
b = bil.new(type = 'm', file = 'mujBilan.txt')

setwd('../data/')

t_ctrl = brick("tas_mon_HadGEM2-ES_historical_r1i1p1-1950-2100.nc")
t_scen = brick("tas_mon_HadGEM2-ES_rcp85_r1i1p1-1950-2100.nc")
p_ctrl = brick("pr_mon_HadGEM2-ES_historical_r1i1p1-1950-2100.nc")
p_scen = brick("pr_mon_HadGEM2-ES_rcp85_r1i1p1-1950-2100.nc")

mojePov = spTransform(mojePov, proj4string(t_ctrl))

#plot(t_ctrl[[1]], xlim = c(16,22), ylim = c(49,51))
#plot(mojePov, add = TRUE)

# ctrl
pov_t_ctrl = extract(t_ctrl, mojePov, fun = mean, weights = TRUE)
pov_p_ctrl = extract(p_ctrl, mojePov, fun = mean, weights = TRUE)

ctrl = data.table(DTM = as.Date(dimnames(pov_t_ctrl)[[2]], format = 'X%Y.%m.%d'), T_ctrl = pov_t_ctrl[1, ], P_ctrl = pov_p_ctrl[1, ])

# scen
pov_t_scen = extract(t_scen, mojePov, fun = mean, weights = TRUE)
pov_p_scen = extract(p_scen, mojePov, fun = mean, weights = TRUE)

scen = data.table(DTM = as.Date(dimnames(pov_t_scen)[[2]], format = 'X%Y.%m.%d'), T_scen = pov_t_scen[1, ], P_scen = pov_p_scen[1, ])

# mesicni prumery
mctrl = ctrl[year(DTM) %in% c(1980:2010), .(T_ctrl = mean(T_ctrl), P_ctrl = mean(P_ctrl)), by = month(DTM)]
mscen = scen[year(DTM) %in% c(2070:2100), .(T_scen = mean(T_scen), P_scen = mean(P_scen)), by = month(DTM)]

# spocti delty
del = mctrl[mscen, on = 'month']
del[, del_T:= T_scen - T_ctrl]
del[, del_P:= P_scen / P_ctrl]

# propoj s pozorovanim
mdta = del[, .(month, del_P, del_T)][mdta, on = 'month']
mdta[, T_scen := T + del_T]
mdta[, P_scen := P * del_P]


b_scen = bil.clone(b)
bil.set.values(b_scen, mdta[, .(DTM, P = P_scen, T = T_scen)])
bil.pet(b_scen)
res_scen = data.table(bil.run(b_scen))

res = data.table(bil.run(b))



mres = res[, .(RM_ctrl = mean(RM)), by  = month(DTM)]
mres_scen = res_scen[, .(RM_scen = mean(RM)), by  = month(DTM)]

plot(mres$RM_ctrl, type = 'l', ylim = c(0, 100))
lines(mres_scen$RM_scen, col = 'red')

plot(mres_scen$RM_scen/mres$RM_ctrl, type = 'l')
abline(h= 1)

saveRDS(mdta, 'scenar.rds')
