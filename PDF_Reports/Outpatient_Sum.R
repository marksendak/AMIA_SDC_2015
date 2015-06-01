#### This code sums outpatient visits for DOC patients
#### Date: September 28, 2014
#### Author: Mark Dakkak

Outpatient_Sum <- function(Outpatient_Clean_Table){
        
        ## Load packages
        require(data.table)
        
        ## Pull subset
        Outpatient_Clean_Table <- Outpatient_Clean_Table[, list(Patient.Identifier, Clinic_Variable, PCP_Visit, Subspecialty_Visit, Urgent_Care)]
        
        ## Create frequency table
        outpatientvisits_freq <- Outpatient_Clean_Table[, lapply(.SD,sum), by = Patient.Identifier]
        
        ## Create total outpatient visit variable
        outpatientvisits_freq[, Outpt_All := (PCP_Visit + Subspecialty_Visit + Urgent_Care)]
        
        ## Convert class of patient identifier
        outpatientvisits_freq$Patient.Identifier <- as.character(outpatientvisits_freq$Patient.Identifier)
        
        ## Return table
        outpatientvisits_freq
}