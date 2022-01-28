# ==============================================================================
#  LOAD INPUT
# ==============================================================================

    ## Load --------------------------------------------------------------------
        sol_fname = string(output_dir,"/solution.csv")
        res_fname = string(output_dir,"/results.csv")

        for f in [sol_fname,res_fname]
            if isfile(f) == false
                @printf("\"%s\" not found ",f)
            end
        end


    ## DataFrame ---------------------------------------------------------------
        sol_data = CSV.read(sol_fname, header=1, delim=",")

        fid = open(res_fname)
        max_length = 0
        while !eof(fid)
            line = readline(fid)
            elmt = split(line,",")
            if length(elmt) > max_length
                global max_length = length(elmt)
            end
        end
        max_length = max_length-1
        close(fid)

        var_name = ["pu","cost","boundary","score_minset","score_maxcov","coverage","wgt_coverage"]
        for k in 1:length(var_name)
            eval(Meta.parse("$(var_name[k]) = Array{String,1}(undef,max_length)"))
        end
        fid = open(res_fname)
        while !eof(fid)
            line = readline(fid)
            global elmt = split(line,",")
            for k in 1:length(var_name)
                if elmt[1] == var_name[k]
                    for i in 2:length(elmt)
                        eval(Meta.parse("$(var_name[k])[$(i-1)] = elmt[$(i)]"))
                    end
                    for i in length(elmt):max_length
                        eval(Meta.parse("$(var_name[k])[$(i)] = \"\""))
                    end
                end
            end
        end
        close(fid)
        res_data = DataFrame([pu cost boundary score_minset score_minset coverage wgt_coverage])
        rename!(res_data,["pu","cost","boundary","score_minset","score_maxcov","coverage","wgt_coverage"])


    ## Structure ---------------------------------------------------------------
        output_data = OutputData(sol_data.reserve, input_data, meta_data)
