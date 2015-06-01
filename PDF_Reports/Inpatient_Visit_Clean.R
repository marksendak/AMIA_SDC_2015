#### This code builds ED visit sums for DOC patients
#### Date: September 25, 2014
#### Author: Mark Dakkak

## Use DEDUCE to pull "Patient Identifier", "Encounter Identifier", "ED Arrival Date", "ED Indicator", "Total Hospital LOS in Days"
        # Filter "ED Arrival Date" to last year

Inpatient_Visit_Clean <- function(directory_month){
        
        ## Load packages
        require(stringr)
        require(data.table)
        
        ## Load data
        directory <- paste("/Users/sommpd10/Desktop/DukeMed/Research/", clinic, "/Monthly Reports/", directory_month, "/Data", sep = "")
        setwd(directory)
        inpatientvisits <- fread("inpatientvisits.csv")
        
        ## Clean data
        setnames(inpatientvisits, colnames(inpatientvisits), gsub(" ", ".", colnames(inpatientvisits)))
        inpatientvisits$Patient.Identifier <- as.character(inpatientvisits$Patient.Identifier)
        inpatientvisits$Total.Hospital.LOS.in.days <- as.numeric(inpatientvisits$Total.Hospital.LOS.in.days)
        
        ## Fix visit dates
        if(clinic == "Pickens"){
                inpatientvisits[, ED.Arrival.Date := as.Date(word(as.character(ED.Arrival.Date), 1), format="%m/%d/%y")]
        }
        if(clinic == "DOC"){
                inpatientvisits[, ED.Arrival.Date := as.Date(word(as.character(ED.Arrival.Date), 1), format="%m/%d/%Y")]
        }
        
        ## Replace NAs in total LOS with 0
        inpatientvisits[is.na(Total.Hospital.LOS.in.days), Total.Hospital.LOS.in.days := 0]
        
        ## Create variables
        inpatientvisits[ED.Indicator == "Y" & Total.Hospital.LOS.in.days < 1, ED_Visit := 1]
        inpatientvisits[ED.Indicator == "Y" & Total.Hospital.LOS.in.days >= 1, Hosp_Admission := 1]
        
        ## Create subset to sum
        inpatientvisits <- inpatientvisits[, list(Patient.Identifier, ED.Arrival.Date, ED_Visit, Hosp_Admission, Total.Hospital.LOS.in.days)]
        
        ## Fix NAs
        for (j in seq_len(ncol(inpatientvisits))) set(inpatientvisits,which(is.na(inpatientvisits[[j]])),j,0)
        
        ## Return clean table
        inpatientvisits
}