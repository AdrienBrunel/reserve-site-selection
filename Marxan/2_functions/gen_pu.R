# ===========================================================================
#  PU data
# ===========================================================================
     
  # Computation -------------------------------------------------------------
     xloc=c();yloc=c();cost1=c();cost2=c();cost3=c();cost4=c();cost5=c();id=c();status=c();
     cpt=0
     for(i in 1:N){
        for(j in 1:M){
           cpt = cpt+1
           
           # PU id
           id[cpt] = cpt
           
           # PU location
           yloc[cpt] = grid.lat.seq[i]
           xloc[cpt] = grid.lgn.seq[j]      
           
           # status
           status[cpt] =0
           if(cpt %in% locked.in){
              status[cpt]=2
           }
           
           status[cpt] =0
           if(cpt %in% locked.out){
              status[cpt]=3
           }

           # PU cost
           cost1[cpt] = 1
           cost2[cpt] = 1+fishing.intensity[i,j]
           cost3[cpt] = 1+log(1+fishing.intensity[i,j])
           
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
     eval(parse(text=sprintf("cost=round(%s,digits=2)",cost.type)))

     
  # Generation --------------------------------------------------------------
     pu.fname = paste0(root.dir,"/3_results/",folder,"/input/pu.dat")
     pu.data  = data.frame(id,cost,status,xloc,yloc)
     write.table(x=pu.data, file=pu.fname, append=FALSE, quote=FALSE, sep="\t\t", col.names=TRUE, row.names=FALSE)
 