# ===========================================================================
#  1 - Meta data
# ===========================================================================

  # Parameters --------------------------------------------------------------
    folder     = "tmp_wcorrection"
    os         = "Linux"  
    scenario   = "sc"
    spec.nb    = 3
    BLM        = 1
    #locked.out = c(309,346:348,384:385)
    locked.out = c(309,346:348,384:385,421:422,456:458,492:494,527:530)
    locked.in  = c()
    cost.type  = "cost3"
    optim.type = "minset" 
    nb.runs    = 100
    

  # OS ----------------------------------------------------------------------
    if(os=="Windows"){
      file.exe    = "Marxan_x64.exe"
      command.exe ="system2(paste(root.dir,\"/3_results/\",folder,\"/\",file.exe,sep=\"\"))"
    }
    if(os=="Linux"){
      # file.exe    = "Marxan_v4.0.5"
      file.exe    = "MarOpt_v243_Linux64"
      command.exe = "system(paste(\"./\",file.exe,sep=\"\"),timeout=150)"
    }

  # Directories management --------------------------------------------------
    Sys.setenv(TZ="Europe/Berlin")
    dir1 = paste0(root.dir,"/3_results/",folder)
    dir2 = paste0(root.dir,"/4_report/pictures/",folder)
    dirs = c(dir1,dir2,paste0(dir1,"/input"),paste0(dir1,"/output"))
    for(i in 1:length(dirs)){
      if(dir.exists(dirs[i])==FALSE){
        dir.create(dirs[i])
        
      }
    }
    if(!file.exists(paste0(dir1,"/",file.exe))){
      file.copy(paste0(root.dir,"/3_results/",file.exe),dir1)
    }
    
  # Generation --------------------------------------------------------------
    writeLines(sprintf("root.dir,%s\nos,%s\nscenario,%s\nfolder,%s\nspec.nb,%d\nBLM,%s\nlocked.out,%s\nlocked.in,%s\ncost.type,%s\noptim.type,%s\nnb.runs,%s",
               root.dir,os,scenario,folder,spec.nb,as.character(BLM),paste(as.character(locked.out),collapse=","),paste(as.character(locked.in),collapse=","),
               cost.type,optim.type,nb.runs),paste0(dir1,"/param.csv"))
    
    
    
    