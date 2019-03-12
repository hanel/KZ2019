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

