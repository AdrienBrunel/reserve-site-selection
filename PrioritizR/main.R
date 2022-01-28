rm(list=ls());if(length(dev.list())>0){dev.off(dev.list()["RStudioGD"])};cat("\f")
# ===========================================================================
# 1 - Parameters
# ===========================================================================
    root.dir = getwd()
    print("gen_param.R ...");source(paste0(root.dir,"/2_functions/gen_param.R"),echo=FALSE)
    gen    = TRUE
    exe    = TRUE
    visu   = TRUE
    irrepl = FALSE
    
# ===========================================================================
# 2 - Generation
# ===========================================================================
    rm(list=setdiff(ls(),c("gen","exe","irrepl","visu","root.dir","dir1","dir2")))
    if(gen==TRUE){
      tic=Sys.time()
      print("load_param.R ...");source(paste0(root.dir,"/2_functions/load_param.R"),echo=FALSE)
      print("gen_grid.R   ...");source(paste0(root.dir,"/2_functions/gen_grid.R"),echo=FALSE)
      print("load_raw.R   ...");source(paste0(root.dir,"/2_functions/load_raw.R"),echo=FALSE)
      print("gen_pu.R     ...");source(paste0(root.dir,"/2_functions/gen_pu.R"),echo=FALSE)
      print("gen_puvspr.R ...");source(paste0(root.dir,"/2_functions/gen_puvspr.R"),echo=FALSE)
      print("gen_spec.R   ...");source(paste0(root.dir,"/2_functions/gen_spec.R"),echo=FALSE)
      print("gen_bound.R  ...");source(paste0(root.dir,"/2_functions/gen_bound.R"),echo=FALSE)
      toc=Sys.time()
      print(sprintf("Input files generated (%.2fs)",toc-tic))
    }

# ===========================================================================
# 3 - Execution
# ===========================================================================
    rm(list=setdiff(ls(),c("gen","exe","irrepl","visu","root.dir","dir1","dir2")))
    if(exe==TRUE){
      tic=Sys.time()
      print("load_param.R ...");source(paste0(root.dir,"/2_functions/load_param.R"),echo=FALSE)
      print("gen_grid.R   ...");source(paste0(root.dir,"/2_functions/gen_grid.R"),echo=FALSE)
      print("load_input.R ...");source(paste0(root.dir,"/2_functions/load_input.R"),echo=FALSE)
      print("exe_optim.R  ...");source(paste0(root.dir,"/2_functions/exe_optim.R"),echo=FALSE)
      toc=Sys.time()
      print(sprintf("PrioritizR executed (%.2fs)",toc-tic))
    }
      
# ===========================================================================
# 4 - Visualisation
# ===========================================================================
    rm(list=setdiff(ls(),c("gen","exe","irrepl","visu","root.dir","dir1","dir2")))
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
    