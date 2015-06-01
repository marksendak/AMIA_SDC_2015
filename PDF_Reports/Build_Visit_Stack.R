#### This code builds the visit stack for utilization timelines in monthly DOC reports
#### Date: September 28, 2014
#### Author: Mark Dakkak

Visit_Stack <- function(Inpatient_Clean, Outpatient_Clean, Wide_Table, clinic){
        
        ## Load packages
        require(data.table)
        
        ################## Prep outpatient visits ##################
        ## Create Visit_Type variable
        Outpatient_Clean[Clinic_Variable == 1, Visit_Type := 1][Subspecialty_Visit == 1, Visit_Type := 4]
        
        ## Create LOS variable
        Outpatient_Clean[, Inpatient.Stay.LOS.in.days := 0]
        
        ## Subset outpatient visits
        Outpatient_Clean <- Outpatient_Clean[Visit_Type == 1 | Visit_Type == 4, list(Patient.Identifier, Arrival.Date, Inpatient.Stay.LOS.in.days, Visit_Type)]
        
        ## Set names
        setnames(Outpatient_Clean, names(Outpatient_Clean), c("patientidentifier", "Visit_date", "Inpatient_LOS", "Visit_Type"))
        
        ################## Prep inpatient visits ##################
        ## Create Visit_Type variable
        Inpatient_Clean[ED_Visit == 1, Visit_Type := 2][Hosp_Admission == 1, Visit_Type := 3]
        
        ## Subset outpatient visits
        Inpatient_Clean <- Inpatient_Clean[, list(Patient.Identifier, ED.Arrival.Date, Total.Hospital.LOS.in.days, Visit_Type)]
        
        ## Set names
        setnames(Inpatient_Clean, names(Inpatient_Clean), c("patientidentifier", "Visit_date", "Inpatient_LOS", "Visit_Type"))
        
        ################## Append visits ##################
        Visit_Stack <- rbind(Inpatient_Clean, Outpatient_Clean)
        
        ################## Subset Visit Stack to 100 patients ##################
        PatientIDs <- Wide_Table[, Patient.Identifier]
        Visit_Stack <- Visit_Stack[patientidentifier %in% PatientIDs]
        
        ################## Return Visit Stack Subset ##################
        Visit_Stack
}