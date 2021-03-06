.libPaths('FILEPATH')
# .libPaths('FILEPATH')
library(seegSDM)
covs <- brick('FILEPATH/covariates/schisto_covs1.grd')
covs <- dropLayer(covs, 6) # drop gecon
buffer <- raster('FILEPATH/haematobium100km.tif')
occ <- read.csv('FILEPATH/haematobium.csv')
bg <- bgSample(buffer, n = 2*nrow(occ), prob = TRUE, replace = TRUE, spatial = FALSE)
colnames(bg) <- c('longitude', 'latitude')
bg <- data.frame(bg)
bg$prevalence <- sum(occ$prevalence) / (2*nrow(occ))
dat <- rbind(cbind(PA = rep(1, nrow(occ)), occ[, c('longitude', 'latitude', 'prevalence')]),
             cbind(PA = rep(0, nrow(bg)), bg))
dat_covs <- extract(covs, dat[,2:3])
dat_all <- cbind(dat, dat_covs)
dat_all <- na.omit(dat_all)
write.csv(dat_all, file="FILEPATH/dat_all.csv", row.names=F)
