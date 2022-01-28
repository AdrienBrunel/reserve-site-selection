# ===========================================================================
# Marxan execution
# ===========================================================================
  
  setwd(paste(root.dir,"/3_results/",folder,sep=""))
  eval(parse(text=command.exe))
  setwd(root.dir)