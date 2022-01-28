# ===========================================================================
#  Spec data
# ===========================================================================
      
   # Computation -------------------------------------------------------------
      
      # id
      id = 1:spec.nb
      
      # type  
      type = rep(0,spec.nb)
      
      # spf
      spf  = c(10,10,10)
      
      # target
      target = c()
      target[1] = 0.5*sum(puvspr.data$amount[puvspr.data$species==1 & !(puvspr.data$pu %in% locked.out)])
      if(spec.nb==3){
         target[2] = 0.5*sum(puvspr.data$amount[puvspr.data$species==2 & !(puvspr.data$pu %in% locked.out)])
         target[3] = 0.5*sum(puvspr.data$amount[puvspr.data$species==3 & !(puvspr.data$pu %in% locked.out)])
      }
      
   # Generation --------------------------------------------------------------
      spec.fname = paste0(root.dir,"/3_results/",folder,"/input/spec.dat")
      spec.data  = data.frame(id,type,target,spf)
      write.table(x=spec.data, file=spec.fname, append=FALSE, quote=FALSE, sep="\t\t", col.names=TRUE, row.names=FALSE)