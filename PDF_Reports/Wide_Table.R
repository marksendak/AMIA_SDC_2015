#### This code builds the final wide table for monthly reports for DOC patients
#### Date: September 28, 2014
#### Author: Mark Dakkak

Wide_Table <- function(Inpatient_Clean, Outpatient_Clean){
        
        ## Load packages
        require(data.table)
        
        ################## Create big table ##################
        R_Fxns <- "/Users/sommpd10/Dropbox/R Code/DOC Projects/Monthly Reports"
        setwd(R_Fxns)
        source("Outpatient_Sum.R")
        source("Inpatient_Sum.R")
        
        ## Get summed inpatient and outpatient data
        Inpatient_Sum <- Inpatient_Sum(Inpatient_Clean)
        Outpatient_Sum <- Outpatient_Sum(Outpatient_Clean)
        
        ################## Create table for graphs ##################
        ## Merge all encounters
        Encounters <- merge(Outpatient_Sum, Inpatient_Sum, by = "Patient.Identifier", all = TRUE)
        
        ## Replace all NAs
        for (j in seq_len(ncol(Encounters))) set(Encounters,which(is.na(Encounters[[j]])),j,0)
        
        ## Create ED Reliance
        Encounters[, ED_Reliance := (ED_Visit + Hosp_Admission)/(ED_Visit + Hosp_Admission + Outpt_All)]
        
        ## Create Admitted Proportion
        Encounters[, Adm_Prop := (Hosp_Admission)/(ED_Visit + Hosp_Admission)]
        
        ## Replace all NAs
        for (j in seq_len(ncol(Encounters))) set(Encounters,which(is.na(Encounters[[j]])),j,0)
        
        ## Create Cost
        Encounters[, Cost := 55*(Outpt_All) + 479*(ED_Visit) + 2000*(Total.Hospital.LOS.in.days)]
        
        ## Subset 100 most expensive patients
        Encounters <- Encounters[order(-Cost)][1:100]
        
        ## Create factor variable for groups of 25 patients
        Encounters[, Cost_Rank := as.numeric(seq(from = 1, to = 100, by = 1))][Cost_Rank >= 1 & Cost_Rank <= 25, Cost_Group := "1-25"][Cost_Rank >= 26 & Cost_Rank <= 50, Cost_Group := "26-50"][Cost_Rank >= 51 & Cost_Rank <= 75, Cost_Group := "51-75"][Cost_Rank >= 76 & Cost_Rank <= 100, Cost_Group := "76-100"]
        
        ## Fix factor levels
        Encounters[, Cost_Group:= as.factor(Cost_Group)]
        Encounters$Cost_Group <- ordered(Encounters$Cost_Group, levels = c("76-100", "51-75", "26-50", "1-25"))
                
        ## Merge MRNs        
        Codebook <- paste("/Users/sommpd10/Desktop/DukeMed/Research/", clinic, "/Monthly Reports/", clinic, "FY15_Codebook.csv", sep = "")
        MRNs <- fread(Codebook, header = TRUE)
        
        ## Clean MRNs
        setnames(MRNs, colnames(MRNs), gsub(" ", ".", colnames(MRNs)))
        MRNs[, Patient.Identifier := as.character(Patient.Identifier)]
        
        ## Merge MRNs
        Encounters <- merge(Encounters, MRNs, by = "Patient.Identifier", all.x = TRUE)
        
        ## Return encounters table
        Encounters
}