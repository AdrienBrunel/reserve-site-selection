# ==============================================================================
#  LOAD PACKAGES
# ==============================================================================
    ENV["GUROBI_HOME"]="/opt/gurobi901/linux64"
    ENV["GRB_LICENSE_FILE"]="/opt/gurobi901/linux64/gurobi.lic"

    import Pkg
    Pkg.add("Printf");using Printf;
    Pkg.add("DataFrames");using DataFrames;
    Pkg.add("DelimitedFiles");using DelimitedFiles;
    Pkg.add("CSV");using CSV;
    Pkg.add("JuMP");using JuMP;
    Pkg.add("Cbc");using Cbc;
    Pkg.add("Gurobi");Pkg.build("Gurobi");using Gurobi
    Pkg.add("Plots");using Plots;
    Pkg.add("GR");using GR;
    Pkg.add("NetCDF");using NetCDF;
    Pkg.add("LinearAlgebra");using LinearAlgebra;
    Pkg.add("Distributions");using Distributions

    #Pkg.add("Clp");using Clp;
    #Pkg.add("Ipopt");using Ipopt;
    #Pkg.add("GLPK");using GLPK;
    #Pkg.add("GR");using GR;
    #Pkg.add("Plotly");using Plotly;
    #Pkg.add("StatsPlots");using StatsPlots;
    #Pkg.add("SparseArrays");using SparseArrays;
    #Pkg.add("BenchmarkTools");using BenchmarkTools;
