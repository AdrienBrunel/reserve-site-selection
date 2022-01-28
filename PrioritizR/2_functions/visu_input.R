# ===========================================================================
#  Plot input
# ===========================================================================

  # Cost map ----------------------------------------------------------------
    png(file=paste0(dir2,"/cost.png"), width=png.res.width, height=png.res.height)
    par(mar=c(4.4,4.6,3,1))
    layout(matrix(c(1), 1, 1, byrow = TRUE))
    plot(0,0, xlim=xloc.lim, ylim=yloc.lim, xlab=xloc.lab, ylab=yloc.lab, main="PU vs Cost",cex.main=3,cex.axis=2,cex.lab=2)
    lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="black",lwd=0.75,lty=2)
    plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
         drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
         bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
    z1 = min(pu.data$cost)
    z2 = max(pu.data$cost)
    dz = (z2-z1)/100
    Z = seq(z1,z2,dz)
    C = c("#FFFFFFFF",rev(heat.colors(length(Z)-1)))
    for(k in 1:length(pu.data$cost)){
      xc = pu.data$xloc[k]
      yc = pu.data$yloc[k]
      zi = pu.data$cost[k]
      if(z1!=z2){
        idx = min(c(which(Z-zi>0),length(Z)))
        t = (zi-Z[idx-1])/(Z[idx]-Z[idx-1])
        ci = t*col2rgb(C[idx])+(1-t)*col2rgb(C[idx-1])
      } else{
        idx = 1
        ci = col2rgb(C[idx])
      }               
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
           col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255), lwd=0.1, lty=2, border=NA)
      if(zi>1){
        text(xc, yc, labels=sprintf("%.1f",zi), cex=1.1)
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
    
    # Conservation feature map ------------------------------------------------
    for(sp in 1:spec.nb){
      png(file=paste0(dir2,sprintf("/puvsp%d.png",sp)), width=png.res.width, height=png.res.height)
      par(mar=c(4.4,4.6,3,1))
      layout(matrix(c(1), 1, 1, byrow = TRUE))
      plot(0,0, xlim=xloc.lim, ylim=yloc.lim, xlab=xloc.lab, ylab=yloc.lab,main=sprintf("PU vs CF%d",sp),cex.main=3,cex.axis=2,cex.lab=2)
      plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
           drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
           bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
      z1 = min(puvspr.data$amount[puvspr.data$species==sp])
      z2 = max(puvspr.data$amount[puvspr.data$species==sp])
      dz = (z2-z1)/100
      Z = seq(z1,z2,dz)   
      C = c("#FFFFFFFF",rev(heat.colors(length(Z)-1)))
      for(k in 1:length(puvspr.data$pu[puvspr.data$species==sp])){
        xc = pu.data$xloc[pu.data$id==puvspr.data$pu[puvspr.data$species==sp][k]]
        yc = pu.data$yloc[pu.data$id==puvspr.data$pu[puvspr.data$species==sp][k]]
        zi = puvspr.data$amount[puvspr.data$species==sp][k]
        idx = min(c(which(Z-zi>0),length(Z)))
        t = (zi-Z[idx-1])/(Z[idx]-Z[idx-1])
        ci = t*col2rgb(C[idx])+(1-t)*col2rgb(C[idx-1])
        if(zi>0){
          rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
               col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255),lwd=0.5, border=NA)
          text(xc, yc, labels=sprintf("%.1f",zi), cex=1.1)
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
      lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="black",lwd=0.75,lty=2)
      polygon(coast.FdN.data$lon,coast.FdN.data$lat,col="dark grey")
      dev.off()
    }
    