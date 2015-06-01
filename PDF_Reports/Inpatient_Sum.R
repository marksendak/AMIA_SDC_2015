#### This code sums inpatient visits for DOC patients
#### Date: September 28, 2014
#### Author: Mark Dakkak

Inpatient_Sum <- function(Inpatient_Clean_Table){
        
        ## Load packages
        require(data.table)
        
        ## Pull subset
        Inpatient_Clean_Table <- Inpatient_Clean_Table[, list(Patient.Identifier, ED_Visit, Hosp_Admission, Total.Hospital.LOS.in.days)]

        ## Create frequency table
        inpatientvisits_freq <- Inpatient_Clean_Table[, lapply(.SD,sum), by = Patient.Identifier]
        
        ## Convert class of patient identifier
        inpatientvisits_freq$Patient.Identifier <- as.character(inpatientvisits_freq$Patient.Identifier)
        
        ## Return table
        inpatientvisits_freq
}