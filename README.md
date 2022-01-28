# reserve-site-selection
Code for the solving of the reserve site selection optimisation problem in different ways : Marxan, Prioritizr, Julia. 

Marxan executable file is called inside a code written in R language. Prioritizr is an R package and is called inside a code written in R language. The reserve site selection problem is expressed and solved in Julia language thanks to the JuMP optimisation library. 



# Steps (Marxan)
1. Marxan version for this code is 4.0.5
2. Fill in parameter values in gen_param.R file according to the scenario you want to simulate
3. In main.R, give a name to the scenario your want to simulate. Set "gen", "opti" and "visu" variables to true values if you want to generate input data, solve the reserve site selection optimisation problem and visualize the results. 
4. Run main.R
5. Results of the scenario simulation will be produced and stored in /3_results/your_scenario_name/ inside .csv files
6. Figures associated with the results will be produced and stored in /4_report/your_scenario_name/ 

# Steps (Prioritizr)
2. Fill in parameter values in gen_param.R file according to the scenario you want to simulate
3. In main.R, give a name to the scenario your want to simulate. Set "gen", "opti" and "visu" variables to true values if you want to generate input data, solve the reserve site selection optimisation problem and visualize the results. 
4. Run main.R
5. Results of the scenario simulation will be produced and stored in /3_results/your_scenario_name/ inside .csv files
6. Figures associated with the results will be produced and stored in /4_report/your_scenario_name/ 

# Steps (Julia)
1. Julia version for this code is 1.4.2
2. Fill in parameter values in gen_param.jl file according to the scenario you want to simulate
3. In main.jl, give a name to the scenario your want to simulate. Set "gen", "opti" and "visu" variables to true values if you want to generate input data, solve the reserve site selection optimisation problem and visualize the results. 
4. Run main.jl
5. Results of the scenario simulation will be produced and stored in /3_results/your_scenario_name/ inside .csv files
6. Figures associated with the results will be produced and stored in /4_report/your_scenario_name/ 
