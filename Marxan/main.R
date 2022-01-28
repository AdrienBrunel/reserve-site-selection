rm(list=ls());if(length(dev.list())>0){dev.off(dev.list()["RStudioGD"])};cat("\f")
# ===========================================================================
# 1 - Parameters
# ===========================================================================
    root.dir = getwd()
    print("gen_param.R      ...");source(paste0(root.dir,"/2_functions/gen_param.R"),echo=FALSE)
    gen    = TRUE
    exe    = TRUE
    visu   = TRUE

# ===========================================================================
# 2 - Generation
# ===========================================================================
    rm(list=setdiff(ls(),c("gen","exe","visu","root.dir","dir1","dir2","command.exe","file.exe")))
    if(gen==TRUE){
      tic=Sys.time()
      print("load_param.R     ...");source(paste0(root.dir,"/2_functions/load_param.R"),echo=FALSE)
      print("gen_grid.R       ...");source(paste0(root.dir,"/2_functions/gen_grid.R"),echo=FALSE)
      print("load_raw.R       ...");source(paste0(root.dir,"/2_functions/load_raw.R"),echo=FALSE)
      print("gen_pu.R         ...");source(paste0(root.dir,"/2_functions/gen_pu.R"),echo=FALSE)
      print("gen_puvspr.R     ...");source(paste0(root.dir,"/2_functions/gen_puvspr.R"),echo=FALSE)
      print("gen_spec.R       ...");source(paste0(root.dir,"/2_functions/gen_spec.R"),echo=FALSE)
      print("gen_bound.R      ...");source(paste0(root.dir,"/2_functions/gen_bound.R"),echo=FALSE)
      print("gen_inputdat.R   ...");source(paste0(root.dir,"/2_functions/gen_inputdat.R"),echo=FALSE)
      toc=Sys.time()
      print(sprintf("Input files generated (%.2fs)",toc-tic))
    }
    
# ===========================================================================
# 3 - Execution
# ===========================================================================
    rm(list=setdiff(ls(),c("gen","exe","visu","root.dir","dir1","dir2","command.exe","file.exe")))
    if(exe==TRUE){
      tic=Sys.time()
      print("load_param.R  ...");source(paste0(root.dir,"/2_functions/load_param.R"),echo=FALSE)
      print("exe_marxan.R  ...");source(paste0(root.dir,"/2_functions/exe_marxan.R"),echo=FALSE)
      toc=Sys.time()
      print(sprintf("Marxan executed (%.2fs)",toc-tic))
    }
    
# ===========================================================================
# 4 - Visualisation
# ===========================================================================
    rm(list=setdiff(ls(),c("gen","exe","visu","root.dir","dir1","dir2")))
    if(visu==TRUE){
      tic=Sys.time()
      print("load_param.R  ...");source(paste0(root.dir,"/2_functions/load_param.R"),echo=FALSE)
      print("gen_grid.R    ...");source(paste0(root.dir,"/2_functions/gen_grid.R"),echo=FALSE)
      print("load_input.R  ...");source(paste0(root.dir,"/2_functions/load_input.R"),echo=FALSE)
      print("load_output.R ...");source(paste0(root.dir,"/2_functions/load_output.R"),echo=FALSE)
      print("visu_opt.R    ...");source(paste0(root.dir,"/2_functions/visu_opt.R"),echo=FALSE)
      print("visu_input.R  ...");source(paste0(root.dir,"/2_functions/visu_input.R"),echo=FALSE)
      print("visu_output.R ...");source(paste0(root.dir,"/2_functions/visu_output.R"),echo=FALSE)
      toc=Sys.time()
      print(sprintf("Visualisation over (%.2fs)",toc-tic))
    }

    
# ===========================================================================
    sp=1
    v1 = puvspr.data$pu[puvspr.data$species==sp]
    v2 = puvspr.data$amount[puvspr.data$species==sp]
    cpt=0
    for(k in 1:length(v1)){
      if(v1[k] %in% run.data$PUID[run.data$SOLUTION==1]){
        cpt = cpt + v2[k]
      }
    }
    cpt
    
    
    for(case in 1:100){    
      run=sprintf("r%05d",case);mv=sprintf("mv%05d",case);
      run.fname = paste(root.dir,"/3_results/",folder,"/output/",scenario,"_",run,".csv",sep="")
      run.data  = read.table(run.fname, header=TRUE, sep=",")
      mv.fname = paste(root.dir,"/3_results/",folder,"/output/",scenario,"_",mv,".csv",sep="")
      mv.data  = read.table(mv.fname, header=TRUE, sep=",")
      t1 = sum(puvspr.data$amount[puvspr.data$species==1 & puvspr.data$pu %in% run.data$PUID[run.data$SOLUTION==1]])
      t2 = sum(puvspr.data$amount[puvspr.data$species==2 & puvspr.data$pu %in% run.data$PUID[run.data$SOLUTION==1]])
      t3 = sum(puvspr.data$amount[puvspr.data$species==3 & puvspr.data$pu %in% run.data$PUID[run.data$SOLUTION==1]])
      t1b = mv.data$Amount.Held[3]
      t2b = mv.data$Amount.Held[2]
      t3b = mv.data$Amount.Held[1]
      
      print(sprintf("target 1 : %.2f,%.2f",t1,t1b))
      print(sprintf("target 2 : %.2f,%.2f",t2,t2b))
      print(sprintf("target 3 : %.2f,%.2f",t3,t3b))
      print("")
    }    
    
    
    
    