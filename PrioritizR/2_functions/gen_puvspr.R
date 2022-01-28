# ===========================================================================
#  PU vs Spec data
# ===========================================================================

  # Computation -------------------------------------------------------------
    species=c();amount=c();pu=c();
    cpt1=0
    for(sp in 1:spec.nb){
      cpt2=0
      for(i in 1:N){
        for(j in 1:M){
          cpt2=cpt2+1
          bathy.data.pu = bathy.xyz.data[bathy.xyz.data$lat >= pu.data$yloc[cpt2]-grid.lat.resol/2 & 
                                           bathy.xyz.data$lat <= pu.data$yloc[cpt2]+grid.lat.resol/2 & 
                                           bathy.xyz.data$lgn >= pu.data$xloc[cpt2]-grid.lgn.resol/2 & 
                                           bathy.xyz.data$lgn <= pu.data$xloc[cpt2]+grid.lgn.resol/2,] 
          
          if(sp==1){             
            cpt1=cpt1+1
            species[cpt1] = sp
            pu[cpt1] = cpt2
            amount[cpt1] = acoustic.class.med[i,j]
          }
          
          if(sp==2){             
            cpt1=cpt1+1
            species[cpt1] = sp
            pu[cpt1] = cpt2
            
            continentalshelf = length(which(bathy.data.pu$depth < 0 & bathy.data.pu$depth >= -50))
            shelfbreak       = length(which(bathy.data.pu$depth < -50 & bathy.data.pu$depth >= -200))
            amount[cpt1] = 0
            if(continentalshelf>0){
              if(shelfbreak>0){
                if(continentalshelf >= shelfbreak){
                  amount[cpt1] = 1
                }
              } else{
                amount[cpt1] = 1
              }
            }
          }
          
          if(sp==3){             
            cpt1=cpt1+1
            species[cpt1] = sp
            pu[cpt1] = cpt2
            
            continentalshelf = length(which(bathy.data.pu$depth < 0 & bathy.data.pu$depth >= -50))
            shelfbreak       = length(which(bathy.data.pu$depth < -50 & bathy.data.pu$depth >= -200))
            amount[cpt1] = 0
            if(shelfbreak>0){
              if(continentalshelf>0){
                if(shelfbreak > continentalshelf){
                  amount[cpt1] = 1
                }
              } else{
                amount[cpt1] = 1
              }
            }
          }  
        }
      }
    }
    # amount[amount=="NaN"]=0

  # Generation --------------------------------------------------------------
    puvspr.fname = paste0(root.dir,"/3_results/",folder,"/input/puvspr.csv")
    puvspr.data  = data.frame(species,pu,amount)
    write.table(x=puvspr.data, file=puvspr.fname, append=FALSE, quote=FALSE, sep=",", col.names=TRUE, row.names=FALSE)
