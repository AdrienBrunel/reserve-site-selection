# ===========================================================================
#  Boundary data
# ===========================================================================
  # Computation -------------------------------------------------------------
    id1=c();id2=c();boundary=c();
    cpt=0
    for(k in 1:(N*M)){
      if((k %% M)!=0){
        cpt=cpt+1
        id1[cpt] = k
        id2[cpt] = k+1
        boundary[cpt] = 1
      }
    }
    for(k in 1:((N-1)*M)){         
      cpt=cpt+1
      id1[cpt] = k
      id2[cpt] = k+M
      boundary[cpt] = 1
    }

  # Generation --------------------------------------------------------------
    bound.fname = paste0(root.dir,"/3_results/",folder,"/input/bound.csv")
    bound.data  = data.frame(id1,id2,boundary)
    write.table(x=bound.data, file=bound.fname, append=FALSE, quote=FALSE, sep=",", col.names=TRUE, row.names=FALSE)
