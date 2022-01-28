# ===========================================================================
#  Boundary data
# ===========================================================================
   # Computation -------------------------------------------------------------
      id1=c();id2=c();bound=c();
      cpt=0
      for(k in 1:(N*M)){
         if((k %% M)!=0){
            cpt=cpt+1
            id1[cpt] = k
            id2[cpt] = k+1
            bound[cpt] = 1
         }
      }
      for(k in 1:((N-1)*M)){         
         cpt=cpt+1
         id1[cpt] = k
         id2[cpt] = k+M
         bound[cpt] = 1
      }
      
   # Generation --------------------------------------------------------------
      bound.fname = paste0(root.dir,"/3_results/",folder,"/input/bound.dat")
      bound.data  = data.frame(id1,id2,bound)
      write.table(x=bound.data, file=bound.fname, append=FALSE, quote=FALSE, sep="\t\t", col.names=TRUE, row.names=FALSE)
