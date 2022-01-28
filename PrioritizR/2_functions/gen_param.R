# ===========================================================================
#  1 - Meta data
# ===========================================================================

  # Parameters --------------------------------------------------------------
    folder     = "example_tmp"
    spec.nb    = 3
    BLM        = 1
    locked.out = c(309,346:348,384:385,421:422,456:458,492:494,527:530)
    locked.in  = c()
    cost.type  = "cost5"
    optim.type = "minset" 

  # Directories management --------------------------------------------------
    dir1 = paste0(root.dir,"/3_results/",folder)
    dir2 = paste0(root.dir,"/4_report/pictures/",folder)
    dirs = c(dir1,dir2,paste0(dir1,"/input"),paste0(dir1,"/output"))
    for(i in 1:length(dirs)){
      if(dir.exists(dirs[i])==FALSE){
        dir.create(dirs[i])
      }
    }

  # Generation --------------------------------------------------------------
    writeLines(sprintf("root.dir,%s\nfolder,%s\nspec.nb,%d\nBLM,%s\nlocked.out,%s\nlocked.in,%s\ncost.type,%s\noptim.type,%s",
                       root.dir,folder,spec.nb,as.character(BLM),paste(as.character(locked.out),collapse=","),paste(as.character(locked.in),collapse=","),cost.type,optim.type),
                       paste0(dir1,"/param.csv"))