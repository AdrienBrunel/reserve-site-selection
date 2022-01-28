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
               # area.surface.pu = 6378^2*abs(grid.lat.resol*pi/180)*abs(sin((pu.data$yloc[cpt2]-grid.lat.resol/2)*pi/180)-sin((pu.data$yloc[cpt2]+grid.lat.resol/2)*pi/180))
               
               if(sp==1){             
                  cpt1=cpt1+1
                  species[cpt1] = sp
                  pu[cpt1] = cpt2
                  amount[cpt1] = round(acoustic.class.med[i,j],digits=2)
                  # amount[cpt1] = round(fish.200.sum[i,j],digits=3)
               }
               
               if(sp==2){             
                  cpt1=cpt1+1
                  species[cpt1] = sp
                  pu[cpt1] = cpt2
                  # amount[cpt1] = round(area.surface.pu*length(which(bathy.data.pu$depth < 0 & bathy.data.pu$depth >= -50))/length(bathy.data.pu$depth),digits=3)
                  
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
                  # amount[cpt1] = round(area.surface.pu*length(which(bathy.data.pu$depth < -50 & bathy.data.pu$depth >= -200))/length(bathy.data.pu$depth),digits=3)
                  
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
      pu = pu[amount>0]
      species = species[amount>0]
      amount = amount[amount>0]
      
      # amount[amount=="NaN"]=0

   # Generation --------------------------------------------------------------
      puvspr.fname = paste0(root.dir,"/3_results/",folder,"/input/puvspr.dat")
      puvspr.data  = data.frame(species,pu,amount)
      puvspr.data  = puvspr.data[order(puvspr.data$pu),]
      write.table(x=puvspr.data, file=puvspr.fname, append=FALSE, quote=FALSE, sep="\t\t", col.names=TRUE, row.names=FALSE)
