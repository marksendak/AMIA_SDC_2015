#### This code runs monthly reports for the DOC
#### Date: September 25, 2014
#### Author: Mark Dakkak

################## Set month of Report and Clinic ##################
directory_month <- "September_2014"
clinic <- "DOC"
labels <- "Cost_Rank"
        ## Either "Cost_Rank" or "Patient.Identifier" or "Duke.MRN"

################## Load function ##################
source("/Users/sommpd10/Dropbox/R Code/DOC Projects/Monthly Reports/Report_Plots.R")

################## Return plots ##################
Plots <- Report_Plots(directory_month, clinic, labels)

################## Print plots ##################
Output <- paste("/Users/sommpd10/Desktop/DukeMed/Research/", clinic, "/Monthly Reports/", directory_month, "/Images", sep = "")
setwd(Output)

################## Print plots ##################
pdf(paste(directory_month, "_", labels, ".pdf", sep = ""), width = 8, height = 6)
Plots
dev.off()
