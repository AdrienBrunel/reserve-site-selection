# ===========================================================================
# Plot optons
# ===========================================================================

  # Coast -------------------------------------------------------------------
    coast.FdN.fname = paste0(root.dir,"/1_data/noronha/coast_FdN.csv")
    coast.FdN.data = read.table(coast.FdN.fname,sep=",",header=TRUE,row.names=NULL)
    
  # MPA ---------------------------------------------------------------------
    parc.marin.fname = paste0(root.dir,"/1_data/noronha/mpa_FdN.csv")
    parc.marin.data = read.table(parc.marin.fname,sep=",",header=TRUE,row.names=NULL)
    names(parc.marin.data)=c("Longitude","Latitude")

  # Bathy -------------------------------------------------------------------
    bathy.fname = paste0(root.dir,"/1_data/noronha/GEBCO_2014_2D_-35.0_-6.0_-30.0_-1.5.nc")
    bathy.raw.data = readGEBCO.bathy(bathy.fname, resolution = 1)
    bathy.col.neg = colorRampPalette(c("royalblue4","royalblue1"))
    bathy.col.pos = colorRampPalette(c("royalblue1")) 
    
  # Plot --------------------------------------------------------------------
    png.res.width  = 1360
    png.res.height = 775
    xloc.lab = "Longitude [deg]"
    yloc.lab = "Latitude [deg]"
    xloc.lim = grid.lgn.bound
    yloc.lim = grid.lat.bound