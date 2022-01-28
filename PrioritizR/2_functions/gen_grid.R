# ===========================================================================
# 1 - Grid selection
# ===========================================================================

  # Resolution --------------------------------------------------------------
    grid.lgn.resol = 0.01 #0.005
    grid.lat.resol = 0.01 #0.005
  
  # Boundaries --------------------------------------------------------------
    grid.lgn.bound = c(-32.65,-32.30)
    grid.lat.bound = c(-3.95,-3.75)

  # Grid vector -------------------------------------------------------------
    grid.lgn.seq = seq(grid.lgn.bound[1],grid.lgn.bound[2],grid.lgn.resol)
    grid.lat.seq = seq(grid.lat.bound[1],grid.lat.bound[2],grid.lat.resol)
    
  # PU number ---------------------------------------------------------------
    N = length(grid.lat.seq)
    M = length(grid.lgn.seq)
    pu.nb = N*M