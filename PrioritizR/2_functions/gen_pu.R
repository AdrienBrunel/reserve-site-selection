# ===========================================================================
#  PU data
# ===========================================================================

  # Computation -------------------------------------------------------------
    xloc=c();yloc=c();cost1=c();cost2=c();cost3=c();cost4=c();cost5=c();id=c();locked_out=c();locked_in=c();
    cpt=0
    for(i in 1:N){
      for(j in 1:M){
        cpt = cpt+1
        
        # PU id
        id[cpt] = cpt
        
        # PU location
        yloc[cpt] = grid.lat.seq[i]
        xloc[cpt] = grid.lgn.seq[j]      
        
        # PU status
        locked_in[cpt]=FALSE;locked_out[cpt]=FALSE
        if(cpt %in% locked.in){locked_in[cpt]=TRUE}
        if(cpt %in% locked.out){locked_out[cpt]=TRUE}
        
        # PU cost
        cost1[cpt] = 1
        cost2[cpt] = 1+fishing.intensity[i,j]
        cost3[cpt] = 1+log(1+fishing.intensity[i,j])
        cost5[cpt] = 1+diving.intensity[i,j]
        
        FC.bnb = 10
        FC.min = min(fishing.intensity)
        FC.max = max(fishing.intensity)
        FC.bwd = (FC.max-FC.min)/FC.bnb
        for(k in seq(1,FC.bnb,1)){
          if(fishing.intensity[i,j] == FC.max){
            cost4[cpt] = FC.bnb
          }
          else{
            if(fishing.intensity[i,j] >= (k-1)*FC.bwd & fishing.intensity[i,j]<k*FC.bwd){
              cost4[cpt] = k
            }
          }
        }
      }
    }
    eval(parse(text=sprintf("cost=%s",cost.type)))

  # Generation --------------------------------------------------------------
    pu.fname = paste0(root.dir,"/3_results/",folder,"/input/pu.csv")
    pu.data  = data.frame(id,cost,locked_in,locked_out,xloc,yloc)
    write.table(x=pu.data, file=pu.fname, append=FALSE, quote=FALSE, sep=",", col.names=TRUE, row.names=FALSE)
