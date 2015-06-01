#### This function builds the plots for monthly reports for the DOC
#### Date: September 25, 2014
#### Author: Mark Dakkak

Report_Plots <- function(directory_month, clinic, labels){
        
        ################## Load functions
        R_Fxns <- "/Users/sommpd10/Dropbox/R Code/DOC Projects/Monthly Reports"
        
        setwd(R_Fxns)
        source("Outpatient_Visit_Clean.R")
        source("Inpatient_Visit_Clean.R")
        source("Wide_Table.R")
        source("Build_Visit_Stack.R")
        source("Fix_Visit_Stack.R")
        source("EDReliance_AdmProp_Plot.R")
        source("Utilization_Timelines.R")
        
        ###################### Get objects for graph 1
        Outpatient_Clean <- Outpatient_Visit_Clean(directory_month)
        Inpatient_Clean <- Inpatient_Visit_Clean(directory_month)
        
        Wide_Table <- Wide_Table(Inpatient_Clean, Outpatient_Clean)
        
        Plot1 <- EDReliance_AdmProp_Plot(Wide_Table)
        
        ###################### Get objects for graphs 2-5
        Visit_Stack <- Visit_Stack(Inpatient_Clean, Outpatient_Clean, Wide_Table)
        Fixed_Stack <- Visit_LOS_Fix(Visit_Stack, Wide_Table)

        ## Make Plots 2-4
        Plot2 <- Utilization_Timelines(Fixed_Stack,4)
        Plot3 <- Utilization_Timelines(Fixed_Stack,3)
        Plot4 <- Utilization_Timelines(Fixed_Stack,2)
        Plot5 <- Utilization_Timelines(Fixed_Stack,1)
        
        ################## Return Plots
        Plots <- list(Plot1, Plot2, Plot3, Plot4, Plot5)
        Plots
}
