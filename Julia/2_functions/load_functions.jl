# ==============================================================================
#  MY FUNCTIONS
# ==============================================================================

    ## Color to RGB vector -----------------------------------------------------
        function col2rgb(color)
            color_rgb = RGB(color)
            return [color_rgb.r,color_rgb.g,color_rgb.b]
        end

    ## RGB vector to color -----------------------------------------------------
        function rgb2col(color_rgb)
            return RGB(color_rgb[1],color_rgb[2],color_rgb[3])
        end

    ## Rectangle shape ---------------------------------------------------------
        rectangle(w, h, x, y) = Plots.Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

    ## Reserve cost ------------------------------------------------------------
        function ReserveCost(x,c)
            return (c' * x)[1]
        end

    ## Reserve boundary length -------------------------------------------------
        function ReserveBoundaryLength(x,B)
            return (x' * B * (1 .- x))[1]
        end

    ## Reserve score -----------------------------------------------------------
        function ReserveScore(x,c,B,BLM)
            return (c' * x .+ BLM * x' * B * (1 .- x))[1]
        end

    ## Print optim info --------------------------------------------------------
        function PrintOptim(input,meta,output)

            # check if binary
            if sum(output.reserve .== 1) + sum(output.reserve .== 0) != length(output.reserve)
                @printf(" Warning : decision variable is not binary\n")
            end

            # output info
            @printf("\ncoverage > targets (Achieved%%)\n")
            for i in 1:input.P
                @printf("%.2f   > %.2f (%.1f%%)\n",output.coverage[i],input.t[i],output.coverage[i]/input.t[i]*100)
            end
            @printf("pu           = %d\n", output.pu)
            @printf("cost         = %.1f\n", output.cost)
            @printf("boundary     = %.1f\n", output.boundary)
            println("minset_score = cost + BLM x boundary")
            @printf("             = %.1f + %.1f x %.1f\n",output.cost, meta.BLM, output.boundary)
            @printf("             = %.1f\n",output.score_minset)
            println("maxcov_score = weight*coverage + BLM x boundary")
            @printf("             = %.1f + %.1f x %.1f\n",output.wgt_coverage, meta.BLM, output.boundary)
            @printf("             = %.1f\n",output.score_maxcov)

            @printf("\ncost < budget (total%%)\n")
            @printf("%.2f < %.2f (%.1f%%)\n",output.cost,input.b,output.cost/sum(input.c)*100)

            return "============================"
        end
