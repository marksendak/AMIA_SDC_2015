#### This code creates utilization timelines for monthly reports for the DOC
#### Date: September 25, 2014
#### Author: Mark Dakkak

Utilization_Timelines <- function(Fixed_Stack, Group){
        
        ## Load packages
        require(ggplot2)
        require(scales)
        
        Group <- levels(Fixed_Stack$Cost_Group)[Group]
        
        ## Subset data
        Fixed_Stack <- Fixed_Stack[Cost_Group == Group]
        
        ## Fix variable classes
        Fixed_Stack[, Visit_Type := as.factor(Visit_Type)]
        Fixed_Stack[, Duke.MRN := as.factor(Duke.MRN)]
        
        ## Pull out cost rank
        MRN_List <- unique(Fixed_Stack[, list(Duke.MRN, Cost_Rank)])
        MRN_List <- MRN_List[order(Cost_Rank)]
        
        ## Identify y-axis labels
        if(labels == "Cost_Rank"){
                y_labels <- MRN_List$Cost_Rank
        }
        else if(labels == "Duke.MRN"){
                y_labels <- MRN_List$Duke.MRN
        }
        
        
        ## Make plot
        if(Group == "1-25"){
                g <- ggplot(Fixed_Stack, aes(x = Visit_date, y = Cost_Rank))
                g + geom_point(aes(color=Visit_Type), size = 1.2) + labs(x = "Duke University Health System Visits Over Past Year", y = "MRNs in Cost Rank (Costliest at Top)", title = paste("Healthcare Utilization Timeline, for Patients with Cost Rank ", Group, sep = "")) + scale_colour_manual(values = c("darkgreen", "red", "blue4", "lightgreen"), labels = c(paste(clinic, " Primary Care", sep = ""), "ED Visit", "Hospital Admission", "Subspecialty Visit")) + theme_bw() + scale_x_date(labels = date_format("%m/%y"), breaks = "1 month") + scale_y_reverse(breaks=seq(1, 25, 1), labels = y_labels)
        }
        else if(Group == "26-50"){
                g <- ggplot(Fixed_Stack, aes(x = Visit_date, y = Cost_Rank))
                g + geom_point(aes(color=Visit_Type), size = 1.2) + labs(x = "Duke University Health System Visits Over Past Year", y = "MRNs in Cost Rank (Costliest at Top)", title = paste("Healthcare Utilization Timeline, for Patients with Cost Rank ", Group, sep = "")) + scale_colour_manual(values = c("darkgreen", "red", "blue4", "lightgreen"), labels = c(paste(clinic, " Primary Care", sep = ""), "ED Visit", "Hospital Admission", "Subspecialty Visit")) + theme_bw() + scale_x_date(labels = date_format("%m/%y"), breaks = "1 month") + scale_y_reverse(breaks=seq(26, 50, 1), labels = y_labels)
        }
        else if(Group == "51-75"){
                g <- ggplot(Fixed_Stack, aes(x = Visit_date, y = Cost_Rank))
                g + geom_point(aes(color=Visit_Type), size = 1.2) + labs(x = "Duke University Health System Visits Over Past Year", y = "MRNs in Cost Rank (Costliest at Top)", title = paste("Healthcare Utilization Timeline, for Patients with Cost Rank ", Group, sep = "")) + scale_colour_manual(values = c("darkgreen", "red", "blue4", "lightgreen"), labels = c(paste(clinic, " Primary Care", sep = ""), "ED Visit", "Hospital Admission", "Subspecialty Visit")) + theme_bw() + scale_x_date(labels = date_format("%m/%y"), breaks = "1 month") + scale_y_reverse(breaks=seq(51, 75, 1), labels = y_labels)
        }
        else if(Group == "76-100"){
                g <- ggplot(Fixed_Stack, aes(x = Visit_date, y = Cost_Rank))
                        g + geom_point(aes(color=Visit_Type), size = 1.2) + labs(x = "Duke University Health System Visits Over Past Year", y = "MRNs in Cost Rank (Costliest at Top)", title = paste("Healthcare Utilization Timeline, for Patients with Cost Rank ", Group, sep = "")) + scale_colour_manual(values = c("darkgreen", "red", "blue4", "lightgreen"), labels = c(paste(clinic, " Primary Care", sep = ""), "ED Visit", "Hospital Admission", "Subspecialty Visit")) + theme_bw() + scale_x_date(labels = date_format("%m/%y"), breaks = "1 month") + scale_y_reverse(breaks=seq(76, 100, 1), labels = y_labels)
        }
}