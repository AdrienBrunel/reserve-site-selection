# ===========================================================================
# Plot output
# ===========================================================================


  # Reading raw diving data -------------------------------------------------
    diving.expl.fname = paste0(root.dir,"/1_data/diving/diving_exploitation.csv")
    diving.expl.data  = read.csv(diving.expl.fname,sep=",",header=TRUE)
    
    # covering=c(0,0,0)
    # for(j in 1:length(optim.sol$id)){
    #   for(i in 1:length(spec.data$amount)){
    #     covering[i] = covering[i] + puvspr.data$amount[puvspr.data$species==i][j]*optim.sol$solution_1[j]
    #   }
    # }
    # sprintf("Targets  : %.2f %d %d",spec.data$amount[1],spec.data$amount[2],spec.data$amount[3])
    # sprintf("Covering : %.2f %d %d",covering[1],covering[2],covering[3])
    
  # Reserve solution --------------------------------------------------------
    png(file=paste0(dir2,"/solution.png"), width=png.res.width, height=png.res.height)
    par(mar=c(4.4,4.6,6.5,1))
    layout(matrix(c(1), 1, 1, byrow = TRUE))
    title = sprintf("Reserve solution (%s)\n pu=%.1f | cost=%.1f | obj=%.1f",optim.type,
                    sum(optim.sol$solution_1),sum(pu.data$cost[optim.sol$solution_1==1]),obj.value)
    plot(0,0, xlim=xloc.lim, ylim=yloc.lim, xlab=xloc.lab, ylab=yloc.lab, main=title,cex.main=3,cex.axis=2,cex.lab=2)
    plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
         drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
         bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
    for(k in 1:length(optim.sol$id)){
      xc = optim.sol$xloc[k]
      yc = optim.sol$yloc[k]
      if(optim.sol$solution_1[k]==1){      
        rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2,
             col=rgb(red=0, green=150, blue=45, max=255),border=NA)
        if(k %in% locked.out){
          rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2,
               col=rgb(red=200, green=200, blue=200, max=255, alpha=150), lwd=0.5, border=NA)
        }
      }
    }
    plot(bathy.raw.data, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
         drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
         bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
    scaleBathy(bathy.raw.data, deg=.1, x = "bottomright", inset = 5)
    lines(coast.FdN.data$lon,coast.FdN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
    polygon(coast.FdN.data$lon,coast.FdN.data$lat,col="dark grey")
    symbols(diving.expl.data$Lon,diving.expl.data$Lat,circles=diving.expl.data$n.dives,inches=0.2,lwd=3,add=TRUE,fg="white")
    dev.off()

    
  # Irreplaceability --------------------------------------------------------
    if(irrepl==TRUE){
      png(file=paste0(dir2,"/irrepl.png"), width=png.res.width, height=png.res.height)
      par(mar=c(4.4,4.6,3,1))
      layout(matrix(c(1), 1, 1, byrow = TRUE))
      plot(0,0, xlim=xloc.lim, ylim=yloc.lim, xlab=xloc.lab, ylab=yloc.lab, main="Irreplaceability",cex.main=3,cex.axis=2,cex.lab=2)
      plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
           drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
           bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
      for(k in 1:length(rc.sol$irr)){
        xc = optim.sol$xloc[k]
        yc = optim.sol$yloc[k]
        t  = rc.sol$irr[k]
        ci = t*c(150,0,0)+(1-t)*c(255,255,255)
        if(t>0){      
          rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
               col=rgb(red=ci[1], green=ci[2], blue=ci[3], max=255), border=NA)
          text(xc,yc,format(rc.sol$irr[k],digits=2))
        }
        if(k %in% locked.out){
          rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2,
               col=rgb(red=200, green=200, blue=200, max=255, alpha=150), lwd=0.5, border=NA)
        }
      }
      plot(bathy.raw.data, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
           drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
           bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
      scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
      lines(coast.FdN.data$lon,coast.FdN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
      lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
      polygon(coast.FdN.data$lon,coast.FdN.data$lat,col="dark grey")
      dev.off()
    }