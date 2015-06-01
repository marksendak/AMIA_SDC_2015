#### This code creates the ED_Reliance_VS_Admitted_Percentage plot
#### Date: September 28, 2014
#### Author: Mark Dakkak

EDReliance_AdmProp_Plot <- function(Wide_Table){
        
        ## Load packages
        require(ggplot2)
        
        ## Make plot
        g <- ggplot(Wide_Table, aes(x = Adm_Prop, y = ED_Reliance))
        g + geom_point(aes(color=ED_Visit, size=Cost_Group), alpha=1/2) + labs(y = "Percent of Health Encounters that Take Place in ED (ED Reliance)", x = "Percent of ED Visits that Result in Admission", title = paste("100 Most Costly ", clinic, " Patients", sep = "")) + geom_text(aes_string(label=labels), size = 2, vjust=2)       
}