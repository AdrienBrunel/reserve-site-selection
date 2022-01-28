# ===============================================
# 1 - Summary
# ===============================================
   png(file=paste(root.dir,"/4_report/pictures/",folder,"/summary_scatter.png",sep=""), width=1200, height=800)
   layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
   plot(sum.data$Run_Number,sum.data$Score, main="Summary - Score", xlab="run number", ylab="score", 
        col="dark red", pch=3, cex=0.8, lwd=2, panel.first=grid(lwd=0.5, col="black"));axis(1, at=seq(0,nb.runs,floor(nb.runs/10)))
   plot(sum.data$Run_Number,sum.data$Cost, main="Summary - Reserve cost", xlab="run number", ylab="reserve cost",
        col="dark red", pch=3, cex=0.8, lwd=2, panel.first=grid(lwd=0.5, col="black"));axis(1, at=seq(0,nb.runs,floor(nb.runs/10)))
   plot(sum.data$Run_Number,sum.data$Planning_Units, main="Summary - Reserved PU", xlab="run number", ylab="reserved pu",
        col="dark red", pch=3, cex=0.8, lwd=2, panel.first=grid(lwd=0.5, col="black"));axis(1, at=seq(0,nb.runs,floor(nb.runs/10)))
   plot(sum.data$Run_Number,sum.data$Missing_Values, main="Summary - Missing values", xlab="run number", ylab="missing values",
        col="dark red", pch=3, cex=0.8, lwd=2, panel.first=grid(lwd=0.5, col="black"));axis(1, at=seq(0,nb.runs,floor(nb.runs/10)))
   dev.off()
   
   png(file=paste(root.dir,"/4_report/pictures/",folder,"/summary_hist.png",sep=""), width=1200, height=800)
   layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
   hist(results$score, main="Summary - Score", xlab="score", ylab="occ",
        col="dark red",panel.first=grid(lwd=0.5, col="black"));axis(2, at=seq(0,nb.runs,floor(nb.runs/10)))
   hist(results$cost, main="Summary - Reserve cost", xlab="reserve cost", ylab="occ",
        col="dark red", panel.first=grid(lwd=0.5, col="black"));axis(2, at=seq(0,nb.runs,floor(nb.runs/10)))
   hist(results$pu, main="Summary - Reserved PU", xlab="reserved pu", ylab="occ",
        col="dark red", panel.first=grid(lwd=0.5, col="black"));axis(2, at=seq(0,nb.runs,floor(nb.runs/10)))
   hist(sum.data$Missing_Values, main="Summary - Missing values", xlab="missing value", ylab="occ",
        col="dark red", panel.first=grid(lwd=0.5, col="black"));axis(2, at=seq(0,nb.runs,floor(nb.runs/10)))
   dev.off()
   
# ===============================================
# 2 - Run
# ===============================================
   png(file=paste(root.dir,"/4_report/pictures/",folder,sprintf("/run_%d.png",case),sep=""), width=png.res.width, height=png.res.height)
   layout(matrix(c(1), 1, 1, byrow = TRUE))
   title=sprintf("Reserve Solution (%d)\npu=%d | cost=%.1f | score=%.1f | mv=%d",
                 case,results$pu[case],results$cost[case],results$score[case],sum.data$Missing_Values[case])
   plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main=title, xlab=xloc.lab, ylab=yloc.lab)
   plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
        drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
        bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
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
   lines(coast.FdN.data$lon,coast.FdN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
   lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
   polygon(coast.FdN.data$lon,coast.FdN.data$lat,col="dark grey")
   plot(bathy.raw.data, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
        drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
        bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
   scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
   dev.off()
   
   png(file=paste(root.dir,"/4_report/pictures/",folder,sprintf("/run_%d_%d_%d_%d.png",case.d[1],case.d[2],case.d[3],case.d[4]),sep=""), width=1200, height=800)
   layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
   for(case.i in case.d){
      title=sprintf("Reserve Solution (%d)\npu=%d | score=%.3e | cost=%.1f | mv=%d",
                    case.i,sum.data$Planning_Units[case.i],sum.data$Score[case.i],sum.data$Cost[case.i],sum.data$Missing_Values[case.i]) 
      run.fname = paste(root.dir,"/3_results/",folder,"/output/",scenario,"_",sprintf("r%05d",case.i),".csv",sep="")
      run.data  = read.table(run.fname, header=TRUE, sep=",")
      plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main=title, xlab=xloc.lab, ylab=yloc.lab)
      plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
           drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
           bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
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
      plot(bathy.raw.data, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
           drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
           bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
      scaleBathy(bathy.raw.data, deg = .1, x = "bottomright", inset = 5)
      lines(coast.FdN.data$lon,coast.FdN.data$lat,type="l",asp=1,cex=2,lwd=0.1)
      lines(parc.marin.data$Longitude,parc.marin.data$Latitude,col="dark grey",lwd=0.5,lty=1)
      polygon(coast.FdN.data$lon,coast.FdN.data$lat,col="dark grey")
   }
   dev.off()
   
# ===============================================
# 3 - MV
# ===============================================
   png(file=paste(root.dir,"/4_report/pictures/",folder,sprintf("/mv_%d.png",case),sep=""), width=800, height=800)
   layout(matrix(c(1), 1, 1, byrow = TRUE))
   plot(-1,-1, xlim=c(0.5,spec.nb+0.5), ylim=c(0,max(mv.data$Target)), 
        main=sprintf("MV (%d)",case), xlab="spec", ylab="target",col="dark red", panel.first=grid(lwd=0.5), xaxt="n")
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
   legend("topleft", inset=0.05, c("target","reached","unsatisfied"), col=c(col1,col2,col3), lty=1, cex=1)
   axis(1, at=seq(1,spec.nb,1))
   dev.off()
   
   png(file=paste(root.dir,"/4_report/pictures/",folder,sprintf("/mv_%d_%d_%d_%d.png",case.d[1],case.d[2],case.d[3],case.d[4]),sep=""), width=1200, height=800)
   layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
   for(case.i in case.d){
      mv.fname = paste(root.dir,"/3_results/",folder,"/output/",scenario,"_",sprintf("mv%05d",case.i),".csv",sep="")
      mv.data  = read.table(mv.fname, header=TRUE, sep=",")
      plot(-1,-1, xlim=c(0.5,spec.nb+0.5), ylim=c(0,max(mv.data$Target,mv.data$Amount.Held)), 
           main=sprintf("MV (%d)",case.i), xlab="spec", ylab="target",col="dark red", panel.first=grid(lwd=0.5), xaxt="n")
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
      axis(1, at=seq(1,spec.nb,1))
   }
   legend("topleft", inset=0.05, c("target","reached","unsatisfied"), col=c(col1,col2,col3), lty=1, cex=1)
   dev.off()
   
# ===============================================
# 4 - Selection Frequency
# ===============================================
   png(file=paste(root.dir,"/4_report/pictures/",folder,"/selection_frequency.png",sep=""), width=png.res.width, height=png.res.height)
   layout(matrix(c(1), 1, 1, byrow = TRUE))
   plot(-1,-1, xlim=xloc.lim, ylim=yloc.lim, main="Selection Frequency", xlab=xloc.lab, ylab=yloc.lab)
   plot(bathy.raw.data, image=TRUE, land=TRUE, deep=c(-5000,-1000,-200), shallow=c(-1000,-200,-50), step=c(1000,800,150),
        drawlabels=c(TRUE,TRUE,TRUE),lty=c(1,1,1),lwd=c(0.3,0.3,0.3),col=c("black","black","black"),
        bpal=list(c(0, max(bathy.raw.data), bathy.col.pos(1)),c(min(bathy.raw.data),0,bathy.col.neg(10))),add=TRUE)
   for(k in 1:length(ssoln.data$number)){
      xc = pu.data$xloc[k]
      yc = pu.data$yloc[k]
      t = (rev(ssoln.data$number)[k]-min(ssoln.data$number))/(max(ssoln.data$number)-min(ssoln.data$number))
      col_rgb = t*c(0,150,45)+(1-t)*c(0,100,180)
      col_rgb = rgb(red=col_rgb[1], green=col_rgb[2], blue=col_rgb[3], max=255)
      rect(xleft=xc-grid.lgn.resol/2, ybottom=yc-grid.lat.resol/2, xright=xc+grid.lgn.resol/2, ytop=yc+grid.lat.resol/2, col=col_rgb, border=NA)
      if(rev(ssoln.data$number)[k]>0){
         text(xc, yc, labels=rev(ssoln.data$number)[k], col="white",cex=0.8)
         if(pu.data$id[k] %in% locked.in){
            text(xc, yc, labels=rev(ssoln.data$number)[k], col="black",cex=0.8)
         }
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
   
   
   
   
   
   
   