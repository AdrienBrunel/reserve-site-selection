# ==============================================================================
#  MINSET ; W BLM ; W LINEARIZATION
# ==============================================================================
	function minset_full(data,meta)

		# model declaration
		m = Model(Gurobi.Optimizer)
		#set_optimizer_attribute(model, "TimeLimit", 100)

	    #m = Model(Cbc.Optimizer)
		#set_optimizer_attribute(m, "logLevel", 1)
		#set_optimizer_attribute(m, "maxnodes", 100000)
		#set_optimizer_attribute(m, "seconds", 1000)
		#set_optimizer_attribute(m, "ratiogap", 0.001)

		# ranges
		PU = 1:data.N
		CF = 1:data.P
		LZ = 1:data.M
		FI = 1:data.F

		# decision variable
	    @variable(m, x[PU,1], Bin)
	    @variable(m, z[LZ,1], Bin)

	    # minset objective
	    @objective(m, Min, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI))

		# target constraints
	    @constraint(m, targets[i in CF],  sum(data.A[i,j]*x[j,1] for j in PU) >= data.t[i,1])

		# locked out/in constraints
	    @constraint(m, locked_out[j in meta.locked_out],  x[j,1] == 0)
	    @constraint(m, locked_in[j in meta.locked_in],  x[j,1] == 1)

		# linearization constraints
	    @constraint(m, linzi[l in LZ],  z[l,1] - x[data.SB[l,2],1] <= 0)
	    @constraint(m, linzk[l in LZ],  z[l,1] - x[data.SB[l,3],1] <= 0)

		return m
	end
