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
    
    
# ===========================================================================
#  4 - Diving data
# ===========================================================================
    
    # Load --------------------------------------------------------------------
    diving.expl.fname = paste0(root.dir,"/1_data/diving/diving_exploitation.csv")
    diving.expl.data  = read.csv(diving.expl.fname,sep=",",header=TRUE)
    
    label.species.raw.fname = paste0(root.dir,"/1_data/acoustic/label_species.csv")
    label.species.raw.data  = read.table(label.species.raw.fname, header=TRUE, sep=",")  
    species.diving.interest = c("bottom.small.fish.school","small.pelagics.school","individual.demersal.fish","small.pelagics.and.predators","mixt.reef.fish" )
    label.species.data      = label.species.raw.data[(label.species.raw.data$Poly_depth<40) & (label.species.raw.data$Poly_LabelName %in% species.diving.interest),]
    
    
    
    # Processing --------------------------------------------------------------
    
    # diving exploitation rating
    diving.expl.raw = matrix(0,nrow = N, ncol = M)
    for(k in 1:length(diving.expl.data$n.dives.year)){
      i = min(which(diving.expl.data$Lat[k]<grid.lat.seq+grid.lat.resol/2))
      j = min(which(diving.expl.data$Long[k]<grid.lgn.seq+grid.lgn.resol/2))
      diving.expl.raw[i,j] = diving.expl.raw[i,j] + diving.expl.data$n.dives.year[k]
    }
    hist(diving.expl.raw,ylim=c(0,10))
    
    diving.expl = matrix(0,nrow = N, ncol = M)
    for(i in 1:N){
      for(j in 1:M){
        if(is.na(diving.expl.raw[i,j])){
          diving.expl[i,j] = 1
        }
        else{
          if(diving.expl.raw[i,j]>0 & diving.expl.raw[i,j]<=1000){
            diving.expl[i,j] = 2
          }
          if(diving.expl.raw[i,j]>1000 & diving.expl.raw[i,j]<=3000){
            diving.expl[i,j] = 3
          }
          if(diving.expl.raw[i,j]>3000 & diving.expl.raw[i,j]<=6000){
            diving.expl[i,j] = 4
          }
          if(diving.expl.raw[i,j]>6000){
            diving.expl[i,j] = 5
          }
        }
      }
    }
    
    
    # species of interest for diving rating
    diving.species.raw = matrix(0,nrow = N, ncol = M)
    for(k in 1:length(label.species.data$Poly_LabelName)){
      i = min(which(label.species.data$Poly_Latitude[k]<grid.lat.seq+grid.lat.resol/2))
      j = min(which(label.species.data$Poly_Longitude[k]<grid.lgn.seq+grid.lgn.resol/2))
      diving.species.raw[i,j] = diving.species.raw[i,j] + 1
    }
    hist(diving.species.raw,ylim=c(0,30))
    
    diving.species = matrix(0,nrow = N, ncol = M)
    for(i in 1:N){
      for(j in 1:M){
        if(diving.species.raw[i,j]>0 & diving.species.raw[i,j]<=5){
          diving.species[i,j] = 1
        }
        if(diving.species.raw[i,j]>5 & diving.species.raw[i,j]<=10){
          diving.species[i,j] = 2
        }
        if(diving.species.raw[i,j]>10 & diving.species.raw[i,j]<=20){
          diving.species[i,j] = 3
        }
        if(diving.species.raw[i,j]>20 & diving.species.raw[i,j]<=35){
          diving.species[i,j] = 4
        }
        if(diving.species.raw[i,j]>35){
          diving.species[i,j] = 5
        }
      }
    }

    
    diving.intensity = diving.species + diving.expl
  
    
    