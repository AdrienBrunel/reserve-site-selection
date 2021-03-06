# ==============================================================================
#  PUVSPR DATA
# ==============================================================================

  ## Data declaration ----------------------------------------------------------
    species = Array{Int64,1}(undef,spec_nb*pu_nb)
    amount  = Array{Float64,1}(undef,spec_nb*pu_nb)
    pu      = Array{Int64,1}(undef,spec_nb*pu_nb)

  ## Computation ---------------------------------------------------------------
    matrix_amount = fish_200_sum
    cpt1 = 0
    for sp in 1:spec_nb
      cpt2 = 0
      for i in 1:Ny
        for j in 1:Nx
          cpt2 = cpt2 + 1
          bathy_data_pu = bathy_data[(bathy_data.lat .>= pu_data.yloc[cpt2] - lat_resol/2) .&
                                     (bathy_data.lat .<= pu_data.yloc[cpt2] + lat_resol/2) .&
                                     (bathy_data.lon .>= pu_data.xloc[cpt2] - lon_resol/2) .&
                                     (bathy_data.lon .<= pu_data.xloc[cpt2] + lon_resol/2),:]

          area_surface_pu = 6378^2*abs(lat_resol*pi/180)*abs(sin((pu_data.yloc[cpt2]-lat_resol/2)*pi/180)-sin((pu_data.yloc[cpt2]+lat_resol/2)*pi/180))
          if sp==1
            global cpt1 = cpt1 + 1
            species[cpt1] = sp
            pu[cpt1] = cpt2
            amount[cpt1] = round(matrix_amount[i,j],digits=2)
          end

          if sp==2
            global cpt1 = cpt1 + 1
            species[cpt1] = sp
            pu[cpt1] = cpt2
            amount[cpt1] = round(area_surface_pu*length(findall((bathy_data_pu.elv .< 0) .& (bathy_data_pu.elv .>= -50)))/length(bathy_data_pu.elv),digits=2)
          end

          if sp==3
            global cpt1 = cpt1 + 1
            species[cpt1] = sp
            pu[cpt1] = cpt2
            amount[cpt1] = round(area_surface_pu*length(findall((bathy_data_pu.elv .< -50) .& (bathy_data_pu.elv .>= -200)))/length(bathy_data_pu.elv),digits=2)
          end
        end
      end
    end

  ## Generation ----------------------------------------------------------------
    puvspr_fname = string(input_dir,"/puvspr.csv")
    puvspr_data  = DataFrame([species pu amount])
    rename!(puvspr_data,["species","pu","amount"])
    puvspr_data.species = convert(Array{Int64,1},puvspr_data.species)
    puvspr_data.pu = convert(Array{Int64,1},puvspr_data.pu)
    CSV.write(puvspr_fname, puvspr_data, writeheader=true)
