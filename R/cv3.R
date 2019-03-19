#source('./R/packages.R')

library(bilan)
library(data.table)
library(rgdal)
library(maptools)
library(raster)

scen = readRDS('./vysledky/scenar.rds')
b = bil.new(type = 'm', file = './vysledky/mujBilan.txt')

b_scen = bil.clone(b)
bil.set.values(b_scen, scen[, .(DTM, P = P_scen, T = T_scen)])
bil.pet(b_scen)

Sp = bil.get.params(b)$cur[1]
spas = Sp * ((-60:60)/100+1)
  
Actrl = list()  
Ascen = list()

s = spas[1]
  
for (s in spas){
  
  bil.set.params.curr(b, list(Spa = s))
  bil.set.params.curr(b_scen, list(Spa = s))
  Actrl[[ length(Actrl)+1 ]] = data.table(Spa = s, bil.run(b))[, .(Spa, DTM, P, R, RM, SW, ET)]
  Ascen[[ length(Ascen)+1 ]] = data.table(Spa = s, bil.run(b_scen))[, .(Spa, DTM, P, R, RM, SW, ET)]

}  

names(Actrl) = paste0('Spa', ifelse(-60:60>=0, '+', ''), -60:60, '%')
names(Ascen) = paste0('Spa', ifelse(-60:60>=0, '+', ''), -60:60, '%')

Actrl = rbindlist(Actrl, idcol = 'SPA')
Ascen = rbindlist(Ascen, idcol = 'SPA')

# prumerne hodnoty

sctrl = Actrl[, .(RM = mean(RM), SW = mean(SW), ET = mean(ET), Spa = Spa[1]), by = SPA]

sscen = Ascen[, .(RM = mean(RM), SW = mean(SW), ET = mean(ET), Spa = Spa[1]), by = SPA]

sscen[, plot(Spa, RM, type = 'l', ylim = c(30, 48))]
sctrl[, lines(Spa, RM, col = 'red')]

sscen[, plot(Spa, ET, type = 'l', ylim = c(38, 50))]
sctrl[, lines(Spa, ET, col = 'red')]

# extremni hodnoty

sctrl = Actrl[, .(RM = min(RM), SW = min(SW), ET = min(ET), Spa = Spa[1]), by = SPA]

sscen = Ascen[, .(RM = min(RM), SW = min(SW), ET = min(ET), Spa = Spa[1]), by = SPA]

sscen[, plot(Spa, RM, type = 'l', ylim = c(0, 0.1))]
sctrl[, lines(Spa, RM, col = 'red')]

sscen[, plot(Spa, ET, type = 'l', ylim = c(38, 50))]
sctrl[, lines(Spa, ET, col = 'red')]

# extremni hodnoty

sctrl = Actrl[, .(RM = quantile(RM,.9), SW = max(SW), ET = max(ET), Spa = Spa[1]), by = SPA]

sscen = Ascen[, .(RM = quantile(RM, .9), SW = max(SW), ET = max(ET), Spa = Spa[1]), by = SPA]

sscen[, plot(Spa, RM, type = 'l', ylim = c(50, 100))]
sctrl[, lines(Spa, RM, col = 'red')]

sscen[, plot(Spa, ET, type = 'l', ylim = c(38, 50))]
sctrl[, lines(Spa, ET, col = 'red')]