# ===========================================================================
# Optimisation
# ===========================================================================

  # Minimum set -------------------------------------------------------------
    if(optim.type=="minset"){
      optim.pb = problem(x=pu.data,features=spec.data,rij=puvspr.data,cost_column="cost") %>%
                         add_min_set_objective() %>%
                         add_manual_targets(data.frame(feature=spec.data$name,type="absolute",target=spec.data$amount)) %>%
                         add_binary_decisions() %>%
                         add_boundary_penalties(penalty=BLM, edge_factor=1, data=bound.data) %>%
                         add_locked_out_constraints("locked_out")  %>%
                         add_rsymphony_solver(gap=0, time_limit=60, verbose=TRUE)
      print(optim.pb)
      optim.sol = solve(optim.pb)
    }

  # Maximum coverage --------------------------------------------------------
    if(optim.type=="maxcov"){
      optim.pb = problem(x=pu.data,features=spec.data,rij=puvspr.data,cost_column="cost") %>%
                         add_max_features_objective(budget=0.20*sum(pu.data$cost)) %>%
                         add_manual_targets(data.frame(feature=spec.data$name,type="absolute",target=sum(puvspr.data$amount))) %>%
                         add_binary_decisions() %>%
                         add_feature_weights(weights=rep(1,spec.nb)) %>%
                         add_locked_out_constraints("locked_out")  %>%
                         add_rsymphony_solver(gap=0, time_limit=60, verbose=TRUE)
      print(optim.pb)
      optim.sol = solve(optim.pb)
    }

  # Irreplaceability --------------------------------------------------------
    if(irrepl==TRUE){
      rc.pb = optim.pb
      rc.pb[["data"]][["cost"]] = as.data.frame(optim.pb[["data"]][["cost"]])
      rc.sol = replacement_cost(rc.pb,data.frame(optim.sol$solution_1))
      rc.df = data.frame(id=pu.data$id,irr=rc.sol$rc)
      rc.fname = paste0(dir1,"/output/irrepl.csv")
      #write.table(x=rc.df, file=rc.fname, append=FALSE, quote=FALSE, sep="\t\t", col.names=TRUE, row.names=FALSE)
      write.table(x=rc.df, file=rc.fname, append=FALSE, quote=FALSE, sep=",", col.names=TRUE, row.names=FALSE)
    }

  # Generation --------------------------------------------------------------
    sol.df = data.frame(id=pu.data$id,solution_1=optim.sol$solution_1,xloc=pu.data$xloc,yloc=pu.data$yloc)
    sol.fname = paste0(dir1,"/output/solution.csv")
    #write.table(x=sol.df, file=sol.fname, append=FALSE, quote=FALSE, sep="\t\t", col.names=TRUE, row.names=FALSE)
    write.table(x=sol.df, file=sol.fname, append=FALSE, quote=FALSE, sep=",", col.names=TRUE, row.names=FALSE)
    output.fname = paste0(dir1,"/output/output.csv")
    writeLines(sprintf("PlanningUnits,%d\nMinCost,%.1f\nMaxCost,%.1f\nNbFeatures,%d\nObjective,%.1f\nType,%s\nBLM,%.1f\nMinTarget,%.1f\nMaxTarget,%.1f\nLockedOut,%d\nLockedIn,%d\n",
                       N*M,min(pu.data$cost),max(pu.data$cost),spec.nb,attr(optim.sol,"objective"),optim.type,BLM,min(spec.data$amount),max(spec.data$amount),sum(pu.data$locked_out==1),sum(pu.data$locked_in==1)),output.fname)
