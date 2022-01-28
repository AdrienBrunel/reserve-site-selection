# ===========================================================================
#  1 - Bathymetry data
# ===========================================================================
  
  # Load --------------------------------------------------------------------
    bathy.fname = paste0(root.dir,"/1_data/noronha/GEBCO_2014_2D_-35.0_-6.0_-30.0_-1.5.nc")
    bathy.raw.data = readGEBCO.bathy(bathy.fname, resolution=1)
  
  # Processing --------------------------------------------------------------
    bathy.xyz.data = as.xyz(bathy.raw.data)
    names(bathy.xyz.data) = c("lgn","lat","depth")
    bathy.data = bathy.xyz.data[bathy.xyz.data$lat >= grid.lat.bound[1] & bathy.xyz.data$lat <= grid.lat.bound[2] &
                                bathy.xyz.data$lgn >= grid.lgn.bound[1] & bathy.xyz.data$lgn <= grid.lgn.bound[2],]


# ===========================================================================
#  2 - Acoustic data
# ===========================================================================
    
    # Load --------------------------------------------------------------------
      acoustic.fname = paste0(root.dir,"/1_data/acoustic/kriged_acoustic_class.csv")
      acoustic.data  = read.table(acoustic.fname, header=TRUE, sep=",")

    # Processing --------------------------------------------------------------
      cpt = matrix(0,nrow = N, ncol = M)
      for(k in 1:length(acoustic.data$id)){
        i = min(which(acoustic.data$lat[k]<grid.lat.seq+grid.lat.resol/2))
        j = min(which(acoustic.data$lon[k]<grid.lgn.seq+grid.lgn.resol/2))
        cpt[i,j] = cpt[i,j] + 1
      }
      
      acoustic.class.serie = array(rep(0, N*M*max(cpt)), dim=c(N,M,max(cpt)))
      cpt = matrix(0,nrow = N, ncol = M)
      for(k in 1:length(acoustic.data$class)){
        i = min(which(acoustic.data$lat[k]<grid.lat.seq+grid.lat.resol/2))
        j = min(which(acoustic.data$lon[k]<grid.lgn.seq+grid.lgn.resol/2))
        cpt[i,j] = cpt[i,j] + 1
        acoustic.class.serie[i,j,cpt[i,j]] = acoustic.data$class[k]
      }
      
      acoustic.class.sum  = matrix(0,nrow = N, ncol = M)
      acoustic.class.mean = matrix(0,nrow = N, ncol = M)
      acoustic.class.med  = matrix(0,nrow = N, ncol = M)
      for(i in 1:N){
        for (j in 1:M){
          if (cpt[i,j]>0){
            acoustic.class.sum[i,j]  = sum(acoustic.class.serie[i,j,1:cpt[i,j]])
            acoustic.class.mean[i,j] = acoustic.class.sum[i,j]/cpt[i,j]
            acoustic.class.med[i,j]  = median(acoustic.class.serie[i,j,1:cpt[i,j]])
          }
        }
      }
      
      
# ===========================================================================
#  3 - Fishing data
# ===========================================================================
  
  # Load --------------------------------------------------------------------
    fishing.fname = paste0(root.dir,"/1_data/fishing/fishing.csv")
    fishing.raw.data = read.csv(fishing.fname,sep=",")
    
  # Processing --------------------------------------------------------------
    fisher.cheat = c("2017_04_08","2017_04_07","2016_09_01","2016_09_02","2016_09_11","2016_09_15","2016_09_17","2015_09_24")
    fishing.lgn = fishing.raw.data$lon[fishing.raw.data$stateww2==1 & !(fishing.raw.data$ID %in% fisher.cheat)]
    fishing.lat = fishing.raw.data$lat[fishing.raw.data$stateww2==1 & !(fishing.raw.data$ID %in% fisher.cheat)]
    
    fishing.intensity = matrix(0,nrow = N, ncol = M)
    for(k in 1:length(fishing.lgn)){
      i = min(which(fishing.lat[k]<grid.lat.seq+grid.lat.resol/2))
      j = min(which(fishing.lgn[k]<grid.lgn.seq+grid.lgn.resol/2))
      fishing.intensity[i,j] = fishing.intensity[i,j] + 1
    }
