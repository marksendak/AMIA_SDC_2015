library(shiny)
library(data.table)
library(ggplot2)

# ui.R

## For navbarpage example: http://shiny.rstudio.com/gallery/navbar-example.html

shinyUI(
    navbarPage("HomeBase App",
               tabPanel("Introduction",
                        headerPanel("The Duke Outpatient Clinic HomeBase App"),
                        mainPanel(
                            h5("Background"),
                            p("This app is built for Duke Outpatient Clinic providers involved in the HomeBase complex care management program. The app is intended to assist providers identify patients to enroll in HomeBase."),
                            h5("Data Source"),
                            p("This app uses data that is processed from flat files extracted from DEDUCE, an online tool providing Duke investigators access to clinical information collected as a by-product of patient care. DEDUCE is funded by the Duke Translational Medical Institute (DTMI)."),
                            h5("Author"),
                            p("All data extraction and cleaning as well as app development was performed by Mark Dakkak, an MD/MPP student at Duke University who is a data science enthusiast."),
                            p("Mark would like to thank RJ Andrews for his help designing data visualizations."))),
               tabPanel("Patient Selection",
                        h1("Duke Outpatient Clinic"),
                        sidebarLayout(
                            sidebarPanel(
                                h5("Patient Identification Tools"),
                                selectInput("CostGroup",
                                            "Choose a group of 25 patients to closely investigate. Cost rank:",
                                            choices = list("1-25",
                                                           "26-50",
                                                           "51-75",
                                                           "76-100"),
                                            selected = "1-25"),
                                helpText("Average cost for each type of visit (inpatient stay, emergency department, etc.) is calculated at the population level for the ~4100 Duke Outpatient Clinic patients."),
                                br(),
                                radioButtons("identifier",
                                            "Display patients by:",
                                            choices = list("Cost Rank" = "Cost.Rank",
                                                           "Patient MRN" = "Duke.MRN", 
                                                           "Patient Name" = "Patient.Full.Name"),
                                            selected = "Cost.Rank"),
                                br(),
                                checkboxGroupInput("CheckDiagnoses",
                                                   label = "Check Diagnoses to Show in Table:",
                                                   choices = list("Cardiac Dysrhythmia" = "Cardiac_Dysrthm", "Atrial Fibrillation" = "A_Fib", "Congestive Heart Failure" = "CHF", "Coronary Heart Disease" = "CHD", "Cerebrovascular Disease" = "CVD", "Peripheral Vascular Disease" = "PVD", "Dementia" = "Dementia", "Connective Tissue Disease" = "CTD", "Cancer" = "Cancer", "Metastatic Cancer" = "MetCancer", "Diabetes without Complications" = "DiabNoComp", "Diabetes with Complications" = "DiabWithComp", "Chronic Kidney Disease" = "CKD", "End Stage Renal Disease" = "ESRD", "Asthma" = "Asthma", "Chronic Obstructive Pulmonary Disease" = "COPD", "Memory Loss" = "MemoryLoss", "Developmental Disorder" = "DevDisorder", "Mental Illness" = "MentalIllness", "Substance Abuse" = "SubAbuse", "Alcohol Abuse" = "ETOHAbuse", "Peptic Ulcer Disease" = "PUD", "Mild Liver Disease" = "MildLiverDisease", "Moderate - Severe Liver Disease" = "ModSevereLiverDisease", "Osteoarthritis" = "Osteoarthritis", "Human Immunodeficiency Virus" = "HIV", "Paralysis" = "Paralysis"),
                                                   selected = "MentalIllness"),
                                helpText("Diagnoses are defined by ICD9 codes over the past 2 years. ", a("AHRQ's Clinical Classifications Software (CCS) groupers", href="https://www.hcup-us.ahrq.gov/toolssoftware/ccs/ccs.jsp", target="_blank"), " are used to identify diagnosis categories.")
                                #helpText(paste("Diagnoses are defined by ICD9 codes over the past 2 years. ", a("AHRQ's Clinical Classifications Software (CCS) groupers", href="https://www.hcup-us.ahrq.gov/toolssoftware/ccs/ccs.jsp"), " are used to identify diagnosis categories.", sep = ""))
                                ),
                            mainPanel(
                                plotOutput("utilizationtimeline"),
                                br(),
                                plotOutput("edtrends"),
                                br(),
                                tableOutput("diagnoses")
                            )
                        )
                    )
            )
)