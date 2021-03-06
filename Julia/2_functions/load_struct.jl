# ==============================================================================
#  GRID
# ==============================================================================
    struct GridData
        lon_range::Array{Float64,1}
        lat_range::Array{Float64,1}
        lon_resol::Float64
        lat_resol::Float64
        lon_seq::Array{Float64,1}
        lat_seq::Array{Float64,1}
        Nx::Int64
        Ny::Int64
        pu_nb::Int64
        pu_id::Array{Int64,1}
        locked_out::Array{Int8,1}
        locked_in::Array{Int8,1}
        xloc::Array{Float64,1}
        yloc::Array{Float64,1}

        # grid data initialisation
        function GridData(param_data)

            # parse param
            lon_range = [parse.(Float64,param_data.lon_range[1]),parse.(Float64,param_data.lon_range[2])]
            lon_resol = parse.(Float64,param_data.lon_resol[1])
            lat_range = [parse.(Float64,param_data.lat_range[1]),parse.(Float64,param_data.lat_range[2])]
            lat_resol = parse.(Float64,param_data.lat_resol[1])

            # grid info
            lon_seq = lon_range[1]:lon_resol:lon_range[2]
            lat_seq = lat_range[1]:lat_resol:lat_range[2]
            Nx = length(lon_seq)
            Ny = length(lat_seq)
            pu_nb = Nx*Ny

            # planning units
            pu_id      = Array{Int64,1}(undef,pu_nb)
            xloc       = Array{Float64,1}(undef,pu_nb)
            yloc       = Array{Float64,1}(undef,pu_nb)
            locked_out = Array{Int8,1}(undef,pu_nb)
            locked_in  = Array{Int8,1}(undef,pu_nb)
            cpt = 0
            for i in 1:Ny
                for j in 1:Nx
                    cpt = cpt + 1

                    # pu id
                    pu_id[cpt] = cpt

                    # pu location
                    yloc[cpt] = lat_seq[i]
                    xloc[cpt] = lon_seq[j]

                    # pu status
                    locked_out[cpt]=0
                    if sum(string(cpt) .== param_data.locked_out) > 0
                      locked_out[cpt]=1
                    end
                    locked_in[cpt]=0
                    if sum(string(cpt) .== param_data.locked_in) > 0
                      locked_in[cpt]=1
                    end
                end
            end

            # constructor
            new(lon_range,lat_range,lon_resol,lat_resol,lon_seq,lat_seq,Nx,Ny,pu_nb,pu_id,locked_out,locked_in,xloc,yloc)

        end

    end

# ==============================================================================
#  INPUT
# ==============================================================================
struct InputData
    N::Int64
    P::Int64
    M::Int64
    F::Int64
    c::Array{Float64,2}
    t::Array{Float64,2}
    A::Array{Float64,2}
    B::Array{Float64,2}
    b::Float64
    w::Array{Float64,2}
    SB::Array{Float64,2}
    EF::Array{Float64,2}
    SEF::Array{Float64,2}


    # input data initialisation
    function InputData(pu_data, spec_data, puvspr_data, bound_data, frontier_data, budget_data, grid_data)

        # problem size
        N = length(pu_data.id)
        P = length(spec_data.id)
        M = 2*length(bound_data.boundary)

        # cost
        c = zeros(N,1)
        for j in 1:N
            c[j,1] = pu_data.cost[j]
        end

        # amount
        A = zeros(P,N)
        for i in 1:P
            A[i,1:N] = puvspr_data.amount[puvspr_data.species .== i,:]
        end

        # targets
        t = zeros(P,1)
        for i in 1:P
            t[i,1] = spec_data.amount[i] * sum(A[i,1:N] .* (1 .- grid_data.locked_out))
        end

        # bound
        B = zeros(N, N)
        for i1 in 1:N
            for i2 in 1:N
                id12 = ((bound_data.id1 .== i1) .& (bound_data.id2 .== i2))
                id21 = ((bound_data.id2 .== i1) .& (bound_data.id1 .== i2))
                if(length(bound_data.boundary[id12 .| id21,:])==1)
                    B[i1,i2] = bound_data.boundary[id12 .| id21,:][1]
                end
            end
        end

        # budget
        budget_max = 0
        for pu in unique(puvspr_data.pu[puvspr_data.amount .> 0])
            if grid_data.locked_out[pu] == 0
                budget_max = budget_max + sum(pu_data.cost[pu_data.id .== pu])
            end
        end
        b = budget_data.budget[1] * budget_max
        #b = budget_data.budget[1]

        # weight
        w = ones(P,1)
        for i in 1:P
            w[i,1] = spec_data.weight[i]/sum(A[i,1:N])
        end

        # sparse bound
        SB  = zeros(M,3)
        cpt = 0
        for i1 in 1:N
            for i2 in 1:N
                if B[i1,i2] != 0
                    cpt = cpt+1
                    SB[cpt,1] = B[i1,i2]
                    SB[cpt,2] = i1
                    SB[cpt,3] = i2
                end
            end
        end

        # External frontier
        EF = zeros(N,1)
        for i in 1:N
            EF[i,1] = frontier_data.frontier[i]
        end

        # Sparse frontier
        F = size(findall(x->x != 0,EF),1)
        cpt = 0
        SEF = zeros(F,2)
        for i in 1:N
            if EF[i,1] != 0
                cpt = cpt + 1
                SEF[cpt,1] = EF[i,1]
                SEF[cpt,2] = i
            end
        end

        # constructor
        new(N,P,M,F,c,t,A,B,b,w,SB,EF,SEF)

    end

end

# ==============================================================================
#  PARAMETERS
# ==============================================================================
struct MetaData
    spec_nb::Int64
    BLM::Float64
    cost_type::String
    optim_type::String
    locked_out::Array{Int64,1}
    locked_in::Array{Int64,1}

    # meta data initialisation
    function MetaData(param_data)

      # boundary length modifier
      spec_nb    = parse.(Int64,param_data.spec_nb[1])
      BLM        = parse.(Float64,param_data.BLM[1])
      cost_type  = param_data.cost_type[1]
      optim_type = param_data.optim_type[1]

      # locked out/locked_in PUs
      locked_out = Array{Int64,1}()
      for k in 1:sum(param_data.locked_out .!= "")
        push!(locked_out, parse.(Int,param_data.locked_out[k]))
      end
      locked_in = Array{Int64,1}()
      for k in 1:sum(param_data.locked_in .!= "")
        push!(locked_in, parse.(Int,param_data.locked_in[k]))
      end

      # constructor
      new(spec_nb,BLM,cost_type,optim_type,locked_out,locked_in)

    end

end

# ==============================================================================
#  OUTPUT
# ==============================================================================
    struct OutputData
        reserve::Array{Int8,1}
        pu::Int64
        cost::Float64
        boundary::Float64
        coverage::Array{Float64,1}
        wgt_coverage::Float64
        score_minset::Float64
        score_maxcov::Float64

        # output data initialisation
        function OutputData(x,input,meta)

            # conversion
            N = length(x)
            reserve = Array{Int8,1}(undef,N)
            for i in 1:N
                reserve[i] = convert(Int8,round(x[i,1],digits=0))
            end

            # optim results
            pu           = sum(reserve)
            cost         = round((input.c' * reserve)[1], digits=2)
            boundary     = round((reserve' * input.B * (1 .- reserve))[1], digits=2)
            coverage     = round.(input.A * reserve, digits=2)
            score_minset = round(cost + meta.BLM * boundary, digits=2)
            wgt_coverage = round((input.w' * coverage)[1], digits=2)
            score_maxcov = round(wgt_coverage + meta.BLM * boundary, digits=2)

            # constructor
            new(reserve,pu,cost,boundary,coverage,wgt_coverage,score_minset,score_maxcov)

        end

    end
