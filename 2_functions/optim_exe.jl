# ==============================================================================
#  OPTIMISATION EXECUTION
# ==============================================================================

    ## Computation -------------------------------------------------------------
        if meta_data.optim_type == "minset"

            MinSet = minset_full(input_data,meta_data);
            optimize!(MinSet);
            x = value.(MinSet[:x]).data
            println("MinSet ; w BLM ; wlinearization\n")

        elseif meta_data.optim_type == "maxcov"

            MaxCov = maxcov_full(input_data,meta_data);
            optimize!(MaxCov);
            x = value.(MaxCov[:x]).data
            println("MaxCov ; w BLM ; wlinearization\n")

        end

    ## Results --------------------------------------------------------------
        output_data = OutputData(x,input_data,meta_data)
        PrintOptim(input_data,meta_data,output_data)

    ## Generation --------------------------------------------------------------
        sol_fname = string(output_dir,"/solution.csv")
        sol_data  = DataFrame([grid_data.pu_id output_data.reserve grid_data.locked_in grid_data.locked_out grid_data.xloc grid_data.yloc])
        rename!(sol_data,["id","reserve","locked_out","locked_in","xloc","yloc"])
        sol_data.id         = convert(Array{Int64,1},sol_data.id)
        sol_data.locked_out = convert(Array{Int8,1},sol_data.locked_out)
        sol_data.locked_in  = convert(Array{Int8,1},sol_data.locked_in)
        sol_data.reserve    = convert(Array{Int8,1},sol_data.reserve)
        CSV.write(sol_fname, sol_data, writeheader=true)

        max_length      = max(1,length(output_data.coverage))
        res_data        = Array{String,2}(undef,max_length,7)
        res_data[1,1:5] = [string(output_data.pu),string(output_data.cost),string(output_data.boundary),
                           string(output_data.score_minset),string(output_data.score_maxcov)]
        res_data[1,7]   = string(output_data.wgt_coverage)
        var_name        = ["pu","cost","boundary","score_minset","score_maxcov","coverage","wgt_coverage"]
        cpt = 0
        for k in 1:length(var_name)
            global cpt = cpt+1
            eval(Meta.parse("var_length = length(output_data.$(var_name[k]))"))
            if (var_name[k] == "coverage")
                for i in 1:max_length
                    if (i <= var_length)
                        eval(Meta.parse("res_data[$(i),$(cpt)] = string(output_data.$(var_name[k])[$(i)])"))
                    end
                end
            else
                res_data[2:max_length,cpt] .= ""
            end
        end
        res_data = convert(DataFrame,res_data)
        rename!(res_data,["pu","cost","boundary","score_minset","score_maxcov","coverage","wgt_coverage"])
        #CSV.write(res_fname, res_data, writeheader=true)

        res_fname = string(output_dir,"/results.csv")
        fid       = open(res_fname,"w")
        str    = Array{String,1}(undef,7)
        str[1] = @sprintf("pu,%d",output_data.pu)
        str[2] = @sprintf("cost,%.2f",output_data.cost)
        str[3] = @sprintf("boundary,%.2f",output_data.boundary)
        str[4] = @sprintf("score_minset,%.2f",output_data.score_minset)
        str[5] = @sprintf("score_maxcov,%.2f",output_data.score_maxcov)
        str[6] = "coverage,"
        str[7] = @sprintf("wgt_coverage,%.2f",output_data.wgt_coverage)
        for i in 1:length(output_data.coverage)
            if i == length(output_data.coverage)
                global str[6] = string(str[6],@sprintf("%.2f",output_data.coverage[i]))
            else
                global str[6] = string(str[6],@sprintf("%.2f,",output_data.coverage[i]))
            end
        end
        writedlm(fid,str)
        close(fid)
