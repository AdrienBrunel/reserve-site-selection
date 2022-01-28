# ===========================================================================
# Load output
# ===========================================================================

  # Parameters --------------------------------------------------------------
    case=1
    set.seed(1);case.d=sample(1:nb.runs,4)

  # Summary -----------------------------------------------------------------
    sum.fname = paste0(root.dir,"/3_results/",folder,"/output/",scenario,"_sum.csv")
    sum.data  = read.table(sum.fname, header=TRUE, sep=",")
    run=sprintf("r%05d",case);mv=sprintf("mv%05d",case);if(case==0){run="best";mv="best";case=order(sum.data[,2])[1]}
    
  # Selection frequency -----------------------------------------------------
    ssoln.fname = paste0(root.dir,"/3_results/",folder,"/output/",scenario,"_ssoln.csv")
    ssoln.data  = read.table(ssoln.fname, header=TRUE, sep=",")

  # Runs --------------------------------------------------------------------
    run.fname = paste0(root.dir,"/3_results/",folder,"/output/",scenario,"_",run,".csv")
    run.data  = read.table(run.fname, header=TRUE, sep=",")
      
  # Missing values ----------------------------------------------------------
    mv.fname = paste0(root.dir,"/3_results/",folder,"/output/",scenario,"_",mv,".csv")
    mv.data  = read.table(mv.fname, header=TRUE, sep=",")
  
    
# ===========================================================================
# Results
# ===========================================================================
    pu=c();cost=c();boundary=c();score=c();
    for(case in 1:nb.runs){
      
      run.fname = sprintf("%s/3_results/%s/output/%s_r%05d.csv",root.dir,folder,scenario,case)
      run.data  = read.table(run.fname, header=TRUE, sep=",")
      
      boundary[case] = 0
      for(k in run.data$PUID[run.data$SOLUTION==1]){
        pu.neigbours = data.frame(id=c(bound.data$id2[bound.data$id1==pu.data$id[k]],bound.data$id1[bound.data$id2==pu.data$id[k]]),
                                  boundary=c(bound.data$bound[bound.data$id1==pu.data$id[k]],bound.data$bound[bound.data$id2==pu.data$id[k]]))
        for(i in 1:length(pu.neigbours$id)){
          if(!(pu.neigbours$id[i] %in% run.data$PUID[run.data$SOLUTION==1])){
            boundary[case] = boundary[case] + pu.neigbours$boundary[i]
          }
        }
      }
      pu[case]   = sum(run.data$SOLUTION)
      cost[case] = sum(pu.data$cost[run.data$SOLUTION==1])
      score[case] = cost[case] + BLM*boundary[case]
    }
    results = data.frame(pu,cost,score)

