# ===========================================================================
# Load input
# ===========================================================================

  # spec.csv ----------------------------------------------------------------
    spec.fname = paste0(dir1,"/input/spec.csv")
    spec.data  = read.table(spec.fname, header=TRUE, sep=",")
  
  # pu.csv ------------------------------------------------------------------
    pu.fname = paste0(dir1,"/input/pu.csv")
    pu.data  = read.table(pu.fname, header=TRUE, sep=",")
  
  # puvspr.csv --------------------------------------------------------------
    puvspr.fname = paste0(dir1,"/input/puvspr.csv")
    puvspr.data  = read.table(puvspr.fname, header=TRUE, sep=",")
    
  # bound.csv ---------------------------------------------------------------
    bound.fname = paste0(dir1,"/input/bound.csv")
    bound.data  = read.table(bound.fname, header=TRUE, sep=",")
    
