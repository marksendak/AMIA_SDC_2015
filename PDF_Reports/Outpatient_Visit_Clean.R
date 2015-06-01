#### This code cleans outpatient visits for DOC patients
#### Date: September 25, 2014
#### Author: Mark Dakkak

## Use DEDUCE to pull "Patient Identifier", "Encounter Identifier", "Arrival Date", "Clinic Department Name", "Clinic Service or Subspecialty", "Encounter Type"
        # Filter "Arrival Date" to last year

Outpatient_Visit_Clean <- function(directory_month){
        
        ## Load packages
        require(stringr)
        require(data.table)
        
        ## Load data
        directory <- paste("/Users/sommpd10/Desktop/DukeMed/Research/", clinic, "/Monthly Reports/", directory_month, "/Data", sep = "")
        setwd(directory)
        outpatientvisits <- fread("outpatientvisits.csv")
        
        ## Clean data
        setnames(outpatientvisits, colnames(outpatientvisits), gsub(" ", ".", colnames(outpatientvisits)))
        
        ## Create Pickens visit variable
        if(clinic == "Pickens"){
                outpatientvisits[, Arrival.Date := as.Date(word(as.character(Arrival.Date), 1), format="%m/%d/%y")]
                
                outpatientvisits[(Clinic.Service.or.Specialty %in% c("Primary Care")) & (Clinic.Department.Name %in% c("DUKE FAMILY MEDICINE")) & (Encounter.Type %in% c("Clinic Visit", "Office Visit", "Procedure visit", "Initial consult", "Initial Prenatal", "Routine Prenatal")), Clinic_Variable := 1]       
        }
        
        ## Create DOC visit variable
        if(clinic == "DOC"){
                outpatientvisits[, Arrival.Date := as.Date(word(as.character(Arrival.Date), 1), format="%m/%d/%Y")]
                
                outpatientvisits[(Clinic.Service.or.Specialty %in% c("General Internal Medicine", "GENERAL MEDICINE", "CHART RESPONSIBLE MD")) & (Clinic.Department.Name %in% c("DUKE OUTPATIENT CLINIC", "DUKE OUTPATIENT CLINIC-MPDC")) & (Encounter.Type %in% c("Clinic Visit", "Office Visit", "Procedure visit", "Initial consult")), Clinic_Variable := 1]       
        }
        
        ## Create PCP visit variable
        outpatientvisits[(Clinic.Service.or.Specialty %in% c("General Internal Medicine", "GENERAL MEDICINE", "COMMUNITY AND FAMILY MEDICINE", "Family Medicine", "Primary Care", "CHART RESPONSIBLE MD", "Internal Medicine")) & (Encounter.Type %in% c("Clinic Visit", "Office Visit", "Procedure visit", "Initial consult")) & (Clinic.Department.Name %in% c("DUKE OUTPATIENT CLINIC-MPDC", "DUKE OUTPATIENT CLINIC", "DUKE HEALTH CTR-N. DUKE STREET", "PDC DUKEWELL", "DUKE PRIMARY CARE CROASDAILE", "GEN.INT.MED. ROXBORO RD.-MPDC", "DUAP-SUTTON STATION INT.MED.", "DUKE PRIMARY CARE DURHAM MEDICAL CENTER", "PRIMARY CARE FAYETTEVILLE RD.", "DUAP-DURHAM MED.CTR.-ROX. RD.", "DUAP-HILLANDALE FAMILY MED.", "DUKE FAMILY MEDICINE", "TRIANGLE FAMILY PRACTICE", "DUKE URGENT CARE BRIER CREEK", "DUKE PRIMARY BUTNER CREEDMOOR", "DUKE PRIMARY CARE BUTNER-CREEDMOOR", "DUAP-DUKE PRIMARY CARE PICKETT RD.", "HILLSBOROUGH PRIMARY CARE", "DUKE FAMILY MEDICINE-MPDC", "DUKE PRIMARY CARE MEBANE", "DUKE PRIMARY CARE BRIER CREEK", "SUTTON STATION INTERNAL MEDICINE", "MEBANE PRIMARY CARE", "PICKETT ROAD PRIMARY CARE", "BRIER CREEK PRIMARY CARE", "DUKE MEDICINE MORRISVILLE", "DUKE PRIMARY CARE HILLSBOROUGH", "CREEDMOOR ROAD PRIMARY CARE", "DUAP-HILLSB. FAMILY PRACTICE", "HENDERSON PRIMARY CARE", "DUAP-METROPOLITAN DURHAM MED.GRP.", "DUKE PRIMARY CARE WAVERLY PLACE", "PICKETT RD. CLINIC-MPDC", "TIMBERLYNE PRIMARY CARE", "DUKE PRIMARY CARE KNIGHTDALE", "WAKE FOREST PRIMARY CARE", "DUKE MEDICINE KNIGHTDALE", "BURLINGTON MEDICAL PRACTICE", "DPC WAVERLY PLACE", "PEAK FAMILY MEDICINE", "DUKE PRIMARY CARE TIMBERLYNE", "EXECUTIVE HLTH-SIGNATURE CARE", "DUAP-WAKE FOREST FAMILY PHYS.", "DUAP-PRIMARY CARE CREEDMOOR RD.", "DUKE PRIMARY CARE MEADOWMONT", "LINCOLN COMM HEALTH CENTER", "PICKETT RD. GEN. PEDS.-MPDC")), PCP_Visit := 1]
                
        ## Create subspecialty visit variable
        outpatientvisits[(Clinic.Service.or.Specialty %in% c("Allergy", "Audiology", "Bariatrics", "BONE MARROW TRANSPLANT", "Cardiac Rehabilitation", "Cardiology", "Cardiovascular Medicine", "Colon and Rectal Surgery", "Dermatology", "EAR NOSE THROAT", "Endocrinology", "Gastroenterology", "General Surgery", "Geriatrics", "GYN ENDOCRINE", "Gynecologic Oncology", "Gynecology", "Hematology", "Hematology and Oncology", "Infectious Diseases", "MEDICAL NEURO-ONCOLOGY", "Nephrology", "Neurology", "Neurosurgery", "Obstetrics", "Obstetrics and Gynecology", "Oncology", "Ophthalmology", "OPHTHALMOLOGY (CEDS)", "Oral Surgery", "ORTHOPAEDIC TRAUMA SERVICE", "Orthopaedics", "Otolaryngology", "Pain and Palliative Care", "Pain Medicine", "Perinatology", "Physical Medicine and Rehabilitation", "Plastic Surgery", "Psychiatry", "Pulmonary", "Pulmonary and Allergy", "Pulmonology", "Radiation Oncology", "Reproductive Endocrinology and Infertility", "Rheumatology", "Sleep Medicine", "Sports Medicine", "SURGICAL PAIN MANAGEMENT", "Thoracic Surgery", "Transplant", "Trauma Surgery", "Travel Medicine", "Urogynecology", "Urology", "Vascular Surgery", "Women's Health", "Wound Care")) & (Encounter.Type %in% c("Clinic Visit", "Office Visit", "Procedure visit", "Initial consult")), Subspecialty_Visit := 1]
                
        ## Create urgent care visit variable
        outpatientvisits[(Clinic.Department.Name %in% c("DUAP-DUKE URGENT CARE MORRISVILLE", "DUAP-DUKE URGENT CARE-HILLANDALE", "DUAP-DUKE URGENT CARE-SOUTH", "DUAP-DUKE URGENT CARE-SOUTH EXTEND", "DUKE URGENT CARE BRIER CREEK", "DUKE URGENT CARE CROASDAILE", "DUKE URGENT CARE KNIGHTDALE", "DUKE URGENT CARE MORRISVILLE", "DUKE URGENT CARE SOUTH")) & (Encounter.Type %in% c("Clinic Visit", "Office Visit", "Procedure visit", "Initial consult")), Urgent_Care := 1]
                
        ## Create subset
        outpatientvisits <- outpatientvisits[, list(Patient.Identifier, Arrival.Date, Clinic_Variable, PCP_Visit, Subspecialty_Visit, Urgent_Care)]
              
        ## Fix NAs
        for (j in seq_len(ncol(outpatientvisits))) set(outpatientvisits,which(is.na(outpatientvisits[[j]])),j,0)
        
        ## Return clean table
        outpatientvisits
}