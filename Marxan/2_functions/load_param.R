# ===========================================================================
#  Load parameters data
# ===========================================================================
    input.fname = paste0(dir1,"/param.csv")
    input.data  = scan(input.fname,what="character", quiet=TRUE, sep=",")
    
    root.dir   = input.data[which(input.data=="root.dir")+1]
    folder     = input.data[which(input.data=="folder")+1]
    os         = input.data[which(input.data=="os")+1]
    scenario   = input.data[which(input.data=="scenario")+1]
    spec.nb    = as.numeric(input.data[which(input.data=="spec.nb")+1])
    BLM        = as.numeric(input.data[which(input.data=="BLM")+1])
    if(which(input.data=="locked.out")+1<=which(input.data=="locked.in")-1){
      locked.out = as.numeric(input.data[(which(input.data=="locked.out")+1):(which(input.data=="locked.in")-1)])
    } else{
      locked.out = c()
    }
    if(which(input.data=="locked.in")+1<=which(input.data=="cost.type")-1){
      locked.in = as.numeric(input.data[(which(input.data=="locked.in")+1):(which(input.data=="cost.type")-1)])
    } else{
      locked.in = c()
    }
    cost.type  = input.data[which(input.data=="cost.type")+1]
    optim.type = input.data[which(input.data=="optim.type")+1]
    nb.runs    = as.numeric(input.data[which(input.data=="nb.runs")+1])
