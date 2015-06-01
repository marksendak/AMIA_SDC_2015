#### This code fixes the visit stack for utilization timelines for monthly DOC reports
#### Date: September 28, 2014
#### Author: Mark Dakkak

###### Define function
Visit_LOS_Fix <- function(data_table, Wide_Table) {
        
        ## Load packages
        require(data.table)
        
        # Calculate the number of rows in the input
        # We will iterate over every row from 1 to n
        data_table <- as.data.frame(data_table)
        
        n <- nrow(data_table)
        
        # Change date to numeric
        #data_table[, Visit_date := as.numeric(Visit_date)]
        
        # Create a (huge) empty data table
        dt <- data.table(patientidentifier=rep(0,1000000), Visit_date=rep(0,1000000), Inpatient_LOS=rep(0,1000000), Visit_Type=rep(0,1000000))
        
        # Which line of the new dataset to print to
        out_line <- 1L
        
        for(i in 1:n) {                
                
                # The i index indicates which line of the input dataset to read from
                
                # Calculate the number of times to repeat rows
                Reps <- ifelse(data_table[i,3] < 1, 1L, as.integer(data_table[i,3]))              
                
                for(j in 1:Reps){
                        
                        # The j index writes (Rep) new rows, where the value in the date column of each incremental row increases by 1
                        
                        set(dt,out_line + (j - 1L),1L, data_table[i,1])
                        set(dt,out_line + (j - 1L),2L, (data_table[i,2] + (j - 1)))
                        set(dt,out_line + (j - 1L),3L, data_table[i,3])
                        set(dt,out_line + (j - 1L),4L, data_table[i,4])                    
                }
                
                # Bump up the line to print from by the number of Replicate rows written
                out_line <- out_line + Reps
                
                # Print the input line that the program is on
                print(i)
        }
        
        # Fix date formatting: R counts days from January 1, 1970
        dt[, Visit_date := as.Date(dt$Visit_date, origin = "1970-01-01")]
        
        # Fix column names
        setnames(dt, colnames(dt), c("Patient.Identifier", "Visit_date", "Inpatient_LOS", "Visit_Type"))
        
        ## Merge cost group and MRNs into fixed stack
        dt[, Patient.Identifier := as.character(Patient.Identifier)]
        
        dt <- merge(dt, Wide_Table[, list(Patient.Identifier, Cost_Rank, Cost_Group, Duke.MRN)], by = "Patient.Identifier", all.x = TRUE)
        
        # Only show the rows that have data
        dt[dt$Patient.Identifier != 0]
}