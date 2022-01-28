# ===========================================================================
# Load output
# ===========================================================================

  # output.csv --------------------------------------------------------------
    output.fname = paste0(dir1,"/output/output.csv")
    output.data  = scan(output.fname,what="character",quiet=TRUE,sep=",")
    obj.value    = as.numeric(output.data[which(output.data=="Objective")+1])
  
  # solution.csv ------------------------------------------------------------
    sol.fname = paste0(dir1,"/output/solution.csv")
    optim.sol = read.table(sol.fname, header=TRUE, sep=",")
  
  # irrepl.csv --------------------------------------------------------------
    if(irrepl==TRUE){
      rc.fname = paste0(dir1,"/output/irrepl.csv")
      rc.sol   = read.table(rc.fname, header=TRUE, sep=",")
    }
