# ===========================================================================
# Load input
# ===========================================================================
  
  # spec.csv ----------------------------------------------------------------
    spec.fname = paste0(dir1,"/input/spec.dat")
    spec.data  = read.table(spec.fname, header=TRUE)
    
  # pu.csv ------------------------------------------------------------------
    pu.fname = paste0(dir1,"/input/pu.dat")
    pu.data  = read.table(pu.fname, header=TRUE)
    
  # puvspr.csv --------------------------------------------------------------
    puvspr.fname = paste0(dir1,"/input/puvspr.dat")
    puvspr.data  = read.table(puvspr.fname, header=TRUE)
    
  # bound.csv ---------------------------------------------------------------
    bound.fname = paste0(dir1,"/input/bound.dat")
    bound.data  = read.table(bound.fname, header=TRUE)
    