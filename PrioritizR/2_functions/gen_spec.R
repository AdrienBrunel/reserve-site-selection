# ===========================================================================
#  Spec data
# ===========================================================================

  # Computation -------------------------------------------------------------

    # id
    id = 1:spec.nb
    
    # name
    name = sprintf("cf%d",id)
    
    # amount
    amount = c()
    amount[1] = 0.5*sum(puvspr.data$amount[puvspr.data$species==1 & !(puvspr.data$pu %in% locked.out)])
    if(spec.nb==3){
      amount[2] = 0.5*sum(puvspr.data$amount[puvspr.data$species==2 & !(puvspr.data$pu %in% locked.out)])
      amount[3] = 0.5*sum(puvspr.data$amount[puvspr.data$species==3 & !(puvspr.data$pu %in% locked.out)])
    }

  # Generation --------------------------------------------------------------
    spec.fname = paste0(root.dir,"/3_results/",folder,"/input/spec.csv")
    spec.data  = data.frame(id,name,amount)
    write.table(x=spec.data, file=spec.fname, append=FALSE, quote=FALSE, sep=",", col.names=TRUE, row.names=FALSE)