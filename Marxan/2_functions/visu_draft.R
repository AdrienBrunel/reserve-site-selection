# ===============================================
# 1 - Bathy + Marxan compatible
# ===============================================
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(0,0,xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim,main="Raw bathymetric data (GEBCO 2014)",asp=1,cex=2)
plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
     drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
     bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
for(sp in 2:3){ 
   plot(0,0, xlim=c(min(pu.data$xloc),max(pu.data$xloc)), ylim=c(min(pu.data$yloc),max(pu.data$yloc)), 
        main=sprintf("Marxan puvsp.dat (CF%d)",sp), xlab=xloc.lab, ylab=yloc.lab);axis(1, at=seq(1,spec.nb,1))     
   plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
        drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
        bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
   scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
   Z = seq(min(puvspr2.data$amount[puvspr2.data$species==sp]),max(puvspr2.data$amount[puvspr2.data$species==sp]),
           (max(puvspr2.data$amount[puvspr2.data$species==sp])-min(puvspr2.data$amount[puvspr2.data$species==sp]))/100);   
   C = rev(heat.colors(length(Z)+1));
   for(k in 1:length(puvspr2.data$pu[puvspr2.data$species==sp])){
      xc = pu.data$xloc[pu.data$id==puvspr2.data$pu[puvspr2.data$species==sp][k]]
      yc = pu.data$yloc[pu.data$id==puvspr2.data$pu[puvspr2.data$species==sp][k]]
      zi = puvspr2.data$amount[puvspr2.data$species==sp][k]
      t = (zi-min(Z))/(max(Z)-min(Z))
      idx = min(which(zi<=Z))
      # t=1 #if discrete gradient needed
      ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
           col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255),lwd=0.5, border=NA)
      text(xc, yc, labels=sprintf("%.1f",zi), cex=0.5)
   }
   lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
}



# ===============================================
# 2 - Fishing + Marxan compatible
# ===============================================
layout(matrix(c(1,2), 2, 1, byrow = TRUE))
fisher.cheat = c("2017_04_08","2017_04_07","2016_09_01","2016_09_02","2016_09_11","2016_09_15","2016_09_17","2015_09_24")
plot(0,0,main="Raw fishing activity",xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim)
points(fishing.raw.data$lon[!(fishing.raw.data$ID %in% fisher.cheat)],
       fishing.raw.data$lat[!(fishing.raw.data$ID %in% fisher.cheat)],
       col="black",pch=1,lwd=0.1,cex=0.1)
points(fishing.raw.data$lon[fishing.raw.data$stateww2==1 & !(fishing.raw.data$ID %in% fisher.cheat)],
       fishing.raw.data$lat[fishing.raw.data$stateww2==1 & !(fishing.raw.data$ID %in% fisher.cheat)],
       col="red",pch=1,lwd=0.1,cex=0.1)
lines(coast.FN.data$lon,coast.FN.data$lat,type="l",cex=2,lwd=0.1)
lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=2)
polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
plot(0,0, xlim=c(min(pu.data$xloc),max(pu.data$xloc)), ylim=c(min(pu.data$yloc),max(pu.data$yloc)), 
     main="Marxan pu.dat", xlab=xloc.lab, ylab=yloc.lab);
Z = seq(min(pu.data$cost),max(pu.data$cost),(max(pu.data$cost)-min(pu.data$cost))/100);   
C = c("white",rev(heat.colors(length(Z))));
for(k in 1:length(pu.data$cost)){
   xc = pu.data$xloc[k]
   yc = pu.data$yloc[k]
   zi = pu.data$cost[k]
   idx = min(which(zi<=Z))
   t = (zi-min(Z))/(max(Z)-min(Z))
   # t=1 #if discrete gradient needed
   ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
   rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
        col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255), lwd=0.1, lty=2, border=NA)
}
lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")


# ===============================================
# 3 - Acoustic + Marxan compatible
# ===============================================
layout(matrix(c(1,2), 2, 1, byrow = TRUE))
plot(0,0,xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim, main="Raw acoustic",asp=1,cex=2)
Z = seq(min(acoustic.data$Horizontal_logSa200),max(acoustic.data$Horizontal_logSa200),
        (max(acoustic.data$Horizontal_logSa200)-min(acoustic.data$Horizontal_logSa200))/100);   
C = c("white",rev(heat.colors(length(Z))));col_v=rep(0,length(acoustic.data$Horizontal_logSa200))
for(k in 1:length(acoustic.data$Horizontal_logSa200)){
   xc = acoustic.data$Longitude[k]
   yc = acoustic.data$Latitude[k]
   zi = acoustic.data$Horizontal_logSa200[k]
   idx = min(which(zi<=Z))
   t = (zi-min(Z))/(max(Z)-min(Z))
   # t=1 #if discrete gradient needed
   ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
   col_v[k]=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255)
   points(xc, yc, col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255),pch=21,bg=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255))
}
lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
for(sp in c(1)){
   plot(0,0, xlim=xloc.lim, ylim=yloc.lim, main=sprintf("Marxan puvsp.dat (CF%d)",sp), xlab=xloc.lab, ylab=yloc.lab);    
   Z = seq(min(puvspr2.data$amount[puvspr2.data$species==sp]),max(puvspr2.data$amount[puvspr2.data$species==sp]),
           (max(puvspr2.data$amount[puvspr2.data$species==sp])-min(puvspr2.data$amount[puvspr2.data$species==sp]))/100);   
   C = rev(heat.colors(length(Z)+1));
   for(k in 1:length(puvspr2.data$pu[puvspr2.data$species==sp])){
      xc = pu.data$xloc[pu.data$id==puvspr2.data$pu[puvspr2.data$species==sp][k]]
      yc = pu.data$yloc[pu.data$id==puvspr2.data$pu[puvspr2.data$species==sp][k]]
      zi = puvspr2.data$amount[puvspr2.data$species==sp][k]
      t = (zi-min(Z))/(max(Z)-min(Z))
      idx = min(which(zi<=Z))
      # t=1 #if discrete gradient needed
      ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
           col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255),lwd=0.5, border=NA)
      text(xc, yc, labels=sprintf("%.1f",zi), cex=0.5)
   }
   lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
}

# ===============================================
# s11_r1_sf
# ===============================================
   png(file=paste(main.dir,"/5_report/pictures/s14_r1_sf.png",sep=""), width=png.res.width, height=2*png.res.height)
   layout(matrix(c(2,1), 2, 1, byrow = TRUE))
   plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main="Selection Frequency", xlab=xloc.lab, ylab=yloc.lab)
   for(k in 1:length(ssoln.data$number)){
      xc = pu.data$xloc[k]
      yc = pu.data$yloc[k]
      t = (rev(ssoln.data$number)[k]-min(ssoln.data$number))/(max(ssoln.data$number)-min(ssoln.data$number))
      col_rgb = t*c(0,150,45)+(1-t)*c(0,100,180)
      col_rgb = rgb(red=col_rgb[1], green=col_rgb[2], blue=col_rgb[3], max=255)
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, col=col_rgb, border=NA)
      if(rev(ssoln.data$number)[k]>0){
         text(xc, yc, labels=rev(ssoln.data$number)[k], col="white",cex=0.8)
         if(pu.data$id[k] %in% locked.in.pu.id){
            text(xc, yc, labels=rev(ssoln.data$number)[k], col="black",cex=0.8)
         }
      }
   }
   lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
   
   title=sprintf("Reserve Solution (%d)\npu=%d | score=%.3e | cost=%.1f | mv=%d",
                 case,sum.data$Planning_Units[case],sum.data$Score[case],sum.data$Cost[case],sum.data$Missing_Values[case])
   plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main=title, xlab=xloc.lab, ylab=yloc.lab)
   plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
        drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
        bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
   scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
   for(k in 1:length(pu.data$id)){
      xc = pu.data$xloc[k]
      yc = pu.data$yloc[k]
      t = run.data$SOLUTION[k]
      col_rgb = t*c(0,150,45)+(1-t)*c(0,100,180)
      col_rgb = rgb(red=col_rgb[1], green=col_rgb[2], blue=col_rgb[3], max=255)         
      if(t==1){
         rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, col=col_rgb, border=NA)
      }
   }
   lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")

   dev.off()

# ===============================================
# s12_mv1_s13_mv1
# ===============================================
   # mv12 = mv.data
   MV = c("mv.data = mv12","mv.data = mv13")
   png(file=paste(main.dir,"/5_report/pictures/s12s13.png",sep=""), width=1600, height=800)
   layout(matrix(c(1,2), 1, 2, byrow = TRUE))
   for(cpt in 1:2){
      eval(parse(text=MV[cpt]))
      if(cpt==1){
      plot(-1,-1, xlim=c(0.5,1.5), ylim=c(0,max(mv.data$Target)), 
           main=sprintf("MV (%d) - Scenario 1.2",case), xlab="spec", ylab="target",col="dark red", panel.first=grid(lwd=0.5), xaxt="n")
      }
      if(cpt==2){
         plot(-1,-1, xlim=c(0.5,1.5), ylim=c(0,max(mv.data$Target)), 
              main=sprintf("MV (%d) - Scenario 1.3",case), xlab="spec", ylab="target",col="dark red", panel.first=grid(lwd=0.5), xaxt="n")
      }
      for(k in 1:length(mv.data$Conservation.Feature)){
         xc  = mv.data$Conservation.Feature[k] 
         yc1 = mv.data$Target[k] 
         yc2 = mv.data$Amount.Held[k] 
         col1 = rgb(red=0, green=100, blue=180, max=180)
         col2 = rgb(red=0, green=150, blue=45, max=255)
         col3 = rgb(red=150, green=0, blue=10, max=255)
         rect(xleft=xc-1/3, ybottom=0, xright=xc, ytop=yc1, col=col1, border=NA)
         if(yc2>=yc1){
            rect(xleft=xc, ybottom=0, xright=xc+1/3, ytop=yc2, col=col2, border=NA)
         }
         else{
            rect(xleft=xc, ybottom=0, xright=xc+1/3, ytop=yc2, col=col3, border=NA)
         }
      }
      axis(1, at=seq(0,1,1))
      if(cpt==1){
         legend("topright", inset=0.05, c("target","reached","unsatisfied"), col=c(col1,col2,col3), lty=1, cex=2)
      }
   }
   dev.off()
   

# ===============================================
# histo
# ===============================================
   png(file=paste(main.dir,"/5_report/pictures/hist.png",sep=""), width=1200, height=800)
   CMD = c("sum.data = sum14","sum.data = sum13")
   layout(matrix(c(2,1), 1, 2, byrow = TRUE))
   for(cpt in 1:2){
      eval(parse(text=CMD[cpt]))
      if(cpt==1){
         hist(sum.data$Planning_Units, main="Reserved PU histogram - Scenario 1.4", xlab="reserved pu", ylab="occ",
              col="dark red", panel.first=grid(lwd=0.5, col="black"),
              breaks=seq(20,45,2),xlim=c(20,45),ylim=c(0,0.35),freq=FALSE);#axis(2, at=seq(0,run.nb,floor(run.nb/10)))
         # axis(2, at=seq(0,50,10))
         
      }
      if(cpt==2){
         hist(sum.data$Planning_Units, main="Reserved PU histogram - Scenario 1.3", xlab="reserved pu", ylab="occ",
              col="dark red", panel.first=grid(lwd=0.5, col="black"),
              breaks=seq(20,45,2),xlim=c(20,45),ylim=c(0,0.35),freq=FALSE);#axis(2, at=seq(0,run.nb,floor(run.nb/10)))
         # axis(2, at=seq(0,50,10))
         # axis(1, at=seq(25,45,5))
      }
   }
   dev.off()

   
   png(file=paste(main.dir,"/5_report/pictures/hist.png",sep=""), width=1200, height=800)
   h1 = hist(sum13$Planning_Units,breaks=seq(20,46,2), plot=FALSE);
   m1 = mean(sum13$Planning_Units)
   h2 = hist(sum14$Planning_Units,breaks=seq(20,46,2), plot=FALSE);
   m2 = mean(sum14$Planning_Units)
   plot(main="Reserved PU", xlab="reserved pu", ylab="proba", panel.first=grid(lwd=0.5, col="black"),
        h1,freq=FALSE,col=adjustcolor("dark blue",alpha.f = 0.75),ylim=c(0,0.35))
   plot(h2,freq=FALSE,add=TRUE,col=adjustcolor("dark red",alpha.f = 0.75)) 
   abline(v=c(m1,m2),col=c("dark blue","dark red"),lty=2,lwd=5)
   legend("topright", inset=0.05, c("Scenario 1.3","Scenario 1.4"), col=c("dark blue","dark red"), lty=1, cex=2)
   dev.off()
  

# ===============================================
# s11_r1_sf
# ===============================================
   png(file=paste(main.dir,"/5_report/pictures/cost_s23_sf.png",sep=""), width=png.res.width, height=2*png.res.height)
   layout(matrix(c(2,1), 2, 1, byrow = TRUE))
   plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main="Selection Frequency", xlab=xloc.lab, ylab=yloc.lab)
   for(k in 1:length(ssoln.data$number)){
      xc = pu.data$xloc[k]
      yc = pu.data$yloc[k]
      t = (rev(ssoln.data$number)[k]-min(ssoln.data$number))/(max(ssoln.data$number)-min(ssoln.data$number))
      col_rgb = t*c(0,150,45)+(1-t)*c(0,100,180)
      col_rgb = rgb(red=col_rgb[1], green=col_rgb[2], blue=col_rgb[3], max=255)
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, col=col_rgb, border=NA)
      if(rev(ssoln.data$number)[k]>0){
         text(xc, yc, labels=rev(ssoln.data$number)[k], col="white",cex=0.8)
         if(pu.data$id[k] %in% locked.in.pu.id){
            text(xc, yc, labels=rev(ssoln.data$number)[k], col="black",cex=0.8)
         }
      }
   }
   lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
   
   plot(0,0, xlim=c(min(pu.data$xloc),max(pu.data$xloc)), ylim=c(min(pu.data$yloc),max(pu.data$yloc)), 
        main="PU Cost", xlab=xloc.lab, ylab=yloc.lab);
   Z = seq(min(pu.data$cost),max(pu.data$cost),(max(pu.data$cost)-min(pu.data$cost))/100);   
   C = c("white",rev(heat.colors(length(Z))));
   for(k in 1:length(pu.data$cost)){
      xc = pu.data$xloc[k]
      yc = pu.data$yloc[k]
      zi = pu.data$cost[k]
      idx = min(which(zi<=Z))
      t = (zi-min(Z))/(max(Z)-min(Z))
      # t=1 #if discrete gradient needed
      ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, 
           col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255), lwd=0.1, lty=2, border=NA)
   }
   lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
   dev.off()
   
   
   
   
   
# ===============================================
# s24_sf_s25_sf
# ===============================================
   png(file=paste(main.dir,"/5_report/pictures/s24_sf_s25_sf.png",sep=""), width=png.res.width, height=2*png.res.height)
   CMD = c("ssoln.data = sf1","ssoln.data = sf2")
   layout(matrix(c(1,2), 2, 1, byrow = TRUE))
   for(cpt in 1:2){
      eval(parse(text=CMD[cpt]))
      if(cpt==1){
         plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main="Selection Frequency - Scenario 2.4", xlab=xloc.lab, ylab=yloc.lab)
      }
      if(cpt==2){
         plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main="Selection Frequency - Scenario 2.5", xlab=xloc.lab, ylab=yloc.lab)
      }
      for(k in 1:length(ssoln.data$number)){
         xc = pu.data$xloc[k]
         yc = pu.data$yloc[k]
         t = (rev(ssoln.data$number)[k]-min(ssoln.data$number))/(max(ssoln.data$number)-min(ssoln.data$number))
         col_rgb = t*c(0,150,45)+(1-t)*c(0,100,180)
         col_rgb = rgb(red=col_rgb[1], green=col_rgb[2], blue=col_rgb[3], max=255)
         rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, col=col_rgb, border=NA)
         if(rev(ssoln.data$number)[k]>0){
            text(xc, yc, labels=rev(ssoln.data$number)[k], col="white",cex=0.8)
            if(pu.data$id[k] %in% locked.in.pu.id){
               text(xc, yc, labels=rev(ssoln.data$number)[k], col="black",cex=0.8)
            }
         }
      }
      lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
      lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
      polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
   }   
   dev.off()
    

   
# ===============================================
# 3 - Acoustic + kriged data
# ===============================================   
   
   x = rep(0,length(acoustic.data$Longitude))
   y = rep(0,length(acoustic.data$Longitude))
   Z = rep(0,length(acoustic.data$Longitude))
   for(k in 1:length(acoustic.data$Longitude)){
      x[k] = acoustic.data$Longitude[k]
      y[k] = acoustic.data$Latitude[k]
      Z[k] = acoustic.data$Horizontal_logSa200[k]
   }
   raw.vgm = data.frame(x=x,y=y,Z=Z)
   # class(raw.vgm) = c("gstatVariogram", "data.frame")
   
   emp.vgm = variogram(gstat(formula=Z~1, locations=~x+y, data=raw.vgm))     
   fit.vgm1 = fit.variogram(emp.vgm, vgm("Exp"), fit.kappa = TRUE)
   fit.vgm2 = fit.variogram(emp.vgm, vgm("Sph"), fit.kappa = TRUE)
   fit.vgm3 = fit.variogram(emp.vgm, vgm("Nug"), fit.kappa = TRUE)
   fit.vgm4 = fit.variogram(emp.vgm, vgm("Gau"), fit.kappa = TRUE)
   fit.vgm5 = fit.variogram(emp.vgm, vgm("Ste"), fit.kappa = TRUE)
   fit.vgm6 = fit.variogram(emp.vgm, vgm("Cir"), fit.kappa = TRUE)
   fit.vgm7 = fit.variogram(emp.vgm, vgm("Lin"), fit.kappa = TRUE)
   plot(emp.vgm,model=fit.vgm5,xlim=c(0,0.07),ylim=c(0,0.6),main="Variogram Exp")
   
   krg.x = rep(0,101*101)
   krg.y = rep(0,101*101)
   krg.Z = rep(0,101*101)
   ech.x = seq(grid.lgn.bound[1],grid.lgn.bound[2],(grid.lgn.bound[2]-grid.lgn.bound[1])/100)
   ech.y = seq(grid.lat.bound[1],grid.lat.bound[2],(grid.lat.bound[2]-grid.lat.bound[1])/100)
   cpt=0
   for(xnew in ech.x){
      for(ynew in ech.y){
         cpt=cpt+1
         new = data.frame(x=xnew,y=ynew)    
         krg = krige(formula=Z~1, locations=~x+y, data=raw.vgm, newdata=new , model=fit.vgm2)
         krg.x[cpt] = krg$x
         krg.y[cpt] = krg$y
         krg.Z[cpt] = krg$var1.pred
      }
   }
   krg = data.frame(x=krg.x,y=krg.y,Z=krg.Z)
   
   layout(matrix(c(1,1), 1, 1, byrow = TRUE))
   plot(0,0,xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim,main="Raw Acoustic",asp=1,cex=2)
   Z = seq(min(acoustic.data$Horizontal_logSa200),max(acoustic.data$Horizontal_logSa200),(max(acoustic.data$Horizontal_logSa200)-min(acoustic.data$Horizontal_logSa200))/100);   
   C = c("white",rev(heat.colors(length(Z))));col_v=rep(0,length(acoustic.data$Horizontal_logSa200))
   for(k in 1:length(acoustic.data$Horizontal_logSa200)){
      xc = acoustic.data$Longitude[k]
      yc = acoustic.data$Latitude[k]
      zi = acoustic.data$Horizontal_logSa200[k]
      idx = min(which(zi<=Z))
      t = (zi-min(Z))/(max(Z)-min(Z))
      # t=1 #if discrete gradient needed
      ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
      col_v[k]=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255)
      points(xc, yc, col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255),pch=21,bg=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255))
   }
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
      
   layout(matrix(c(1,1), 1, 1, byrow = TRUE))
   plot(0,0,xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim,main="Kriged Acoustic")
   for(k in 1:length(krg$x)){
      xc = krg$x[k]
      yc = krg$y[k]
      zi = krg$Z[k]      
      idx = min(which(zi<=Z))
      t = (zi-min(Z))/(max(Z)-min(Z))
      # t=1 #if discrete gradient needed
      ci = t*col2rgb(C[idx+1])+(1-t)*col2rgb(C[idx])
      col_v[k]=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255)
      points(xc, yc, col=rgb(red=ci[1],green=ci[2],blue=ci[3], max=255),pch=15,cex=2)
   }
   polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")

   
# pu id labels
layout(matrix(c(1), 1, 1, byrow = TRUE))
plot(0,0, xlim=c(min(pu.data$xloc),max(pu.data$xloc)), ylim=c(min(pu.data$yloc),max(pu.data$yloc)),
     main="PU id", xlab=xloc.lab, ylab=yloc.lab);axis(1, at=seq(1,max(spec.data$id),1))
for(k in 1:length(pu.data$id)){
   spec_amount_label = sprintf("%d",pu.data$id[k])
   xc = pu.data$xloc[k]
   yc = pu.data$yloc[k]
   # if(min(abs(pu.data$id[k]-parc.pu.id))==0){
   #    rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2,lwd=0.5,col="red")
   # }   
   if(min(abs(pu.data$id[k]-FdN.pu.id))==0){
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2,lwd=0.5,col="red")
   }
   else{
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2,lwd=0.5)
   }
   text(xc, yc, labels=spec_amount_label, cex=0.5)
}
lines(coast.FN.data$lon,coast.FN.data$lat,type="l",asp=1,cex=2,lwd=1,col="green")
lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="blue",lwd=2,lty=1)
# polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")




# fisher.list = unique(fishing.raw.data$ID)
# for(id.fisherman in fisher.cheat){
#    plot(0,0,main=sprintf("%s",id.fisherman),xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim)
#    points(fishing.raw.data$lon[fishing.raw.data$ID==id.fisherman],fishing.raw.data$lat[fishing.raw.data$ID==id.fisherman],pch=1,lwd=0.1,cex=0.1)
#    points(fishing.raw.data$lon[fishing.raw.data$stateww2==1 & fishing.raw.data$ID==id.fisherman],fishing.raw.data$lat[fishing.raw.data$stateww2==1 & fishing.raw.data$ID==id.fisherman],
#           col="red",pch=1,lwd=0.1,cex=0.1)
#    lines(coast.FN.data$lon,coast.FN.data$lat,type="l",cex=2,lwd=0.1)
#    lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=2)
#    polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
# }
# 
# fisher.cheat = c("2017_04_08","2017_04_07","2016_09_01","2016_09_02","2016_09_11","2016_09_15","2016_09_17","2015_09_24")
# plot(0,0,main="Cheating fishermen",xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim)
# for(id.fisherman in fisher.cheat){
#    points(fishing.raw.data$lon[fishing.raw.data$ID==id.fisherman],fishing.raw.data$lat[fishing.raw.data$ID==id.fisherman],pch=1,lwd=0.1,cex=0.1)
#    points(fishing.raw.data$lon[fishing.raw.data$stateww2==1 & fishing.raw.data$ID==id.fisherman],fishing.raw.data$lat[fishing.raw.data$stateww2==1 & fishing.raw.data$ID==id.fisherman],
#           col="red",pch=1,lwd=0.1,cex=0.1)
#    lines(coast.FN.data$lon,coast.FN.data$lat,type="l",cex=2,lwd=0.1)
#    lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=2)
#    polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
# }
# plot(0,0,main="Fishermen GPS tracks",xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim)
# for(id.fisherman in fisher.list){
#    if(sum(id.fisherman != fisher.cheat)==length(fisher.cheat)){
#       points(fishing.raw.data$lon[fishing.raw.data$ID==id.fisherman],fishing.raw.data$lat[fishing.raw.data$ID==id.fisherman],pch=1,lwd=0.1,cex=0.1)
#       points(fishing.raw.data$lon[fishing.raw.data$stateww2==1 & fishing.raw.data$ID==id.fisherman],fishing.raw.data$lat[fishing.raw.data$stateww2==1 & fishing.raw.data$ID==id.fisherman],
#              col="red",pch=1,lwd=0.1,cex=0.1)
#       lines(coast.FN.data$lon,coast.FN.data$lat,type="l",cex=2,lwd=0.1)
#       lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=2)
#       polygon(coast.FN.data$lon,coast.FN.data$lat,col="dark grey")
#    }
# }

#Creation des palettes de couleurs de la bathy
# blues1 <- c("lightsteelblue1", "lightsteelblue3","lightsteelblue2", "lightsteelblue1")
# blues2<-c("royalblue4","royalblue3","royalblue2","royalblue1") 
# 
# blues<-blues2
# col.land<-blues[4]


# plot(0,0,xlab=xloc.lab, ylab=yloc.lab, xlim=xloc.lim, ylim=yloc.lim,main="GEBCO 2014 - Fernando de Noronha",asp=1,cex=2)
# plot(coast.FN.data$lon,coast.FN.data$lat)
# plot(bathy.raw.data, image = TRUE, land = TRUE, lwd = 0.1, bpal = list(c(0, max(bathy.raw.data), col.land),c(min(bathy.raw.data),0,blues2)),add=T)
# scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
# polygon(parc.marin$Longitude,parc.marin$Latitude,col="light gray",border=NA)