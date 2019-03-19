source('./R/packages.R')

library(bilan)
library(data.table)
library(rgdal)
library(maptools)
library(raster)

scen = readRDS('./vysledky/scenar.rds')
b = bil.new(type = 'm', file = './vysledky/mujBilan.txt')

b_scen = bil.clone(b)
bil.set.values(b_scen, mdta[, .(DTM, P = P_scen, T = T_scen)])