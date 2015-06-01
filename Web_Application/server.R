library(shiny)
library(data.table)
library(ggplot2)
library(scales)

## Load and fix data
encounters <- fread("data/Top100_Stack.csv")
encounters[, Visit_date := as.Date(Visit_date, format = "%Y-%m-%d")][, Visit_Type := as.factor(Visit_Type)]

diagnoses <- fread("data/Diagnoses.csv")

ED_2yr <- fread("data/ED_2yr_Table.csv")
ED_2yr[, variable := as.factor(variable)]
levels(ED_2yr$variable) <- c("ED_Visit_18_24mo", "ED_Visit_12_18mo", "ED_Visit_6_12mo", "ED_Visit_0_6mo")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
        range <- reactive({
            switch(
                input$CostGroup,
                "1-25" = c(1,25),
                "26-50" = c(26,50),
                "51-75" = c(51,75),
                "76-100" = c(76,100)
                )
        })
        
        output$utilizationtimeline <- renderPlot({
          
            labels_data <- subset(diagnoses, Cost.Rank >= range()[1] & Cost.Rank <= range()[2], select = c("Patient.Identifier", "Cost.Rank", "Duke.MRN", "Patient.Full.Name"))
            
            ggplot(subset(encounters, Cost.Rank >= range()[1] & Cost.Rank <= range()[2]), aes(x = Visit_date, y = Cost.Rank)) + geom_point(aes(color=Visit_Type), size = 1.2) + labs(x = "Duke University Health System Visits Over Past Year", y = "", title = paste("Healthcare Utilization Timeline, for Patients with Cost Rank ", input$CostGroup, "\n (with costliest at top)", sep = "")) + scale_colour_manual(values = c("darkgreen", "red", "blue4", "lightgreen"), labels = c("DOC Visit", "ED Visit", "Hospital Admission", "Subspecialty Visit")) + theme_bw() + scale_x_date(labels = date_format("%m/%y"), breaks = "1 month") + scale_y_reverse(breaks=seq(as.numeric(range()[1]), as.numeric(range()[2]), 1), labels = labels_data[[input$identifier]])
        })

        output$edtrends <- renderPlot({
            ggplot(subset(ED_2yr, Cost.Rank >= range()[1] & Cost.Rank <= range()[2]), aes_string(x = "variable", y = "value", group = input$identifier)) + geom_line(color = "red") + facet_wrap(as.formula(paste("~", input$identifier)), ncol=5) + theme_bw() + theme(axis.text.x = element_text(angle = 90, size = 10), legend.position="none") + scale_x_discrete(breaks=c("ED_Visit_18_24mo", "ED_Visit_12_18mo", "ED_Visit_6_12mo", "ED_Visit_0_6mo"), labels=c("Past 18-24mo", "Past 12-18mo", "Past 6-12mo", "Past 0-6mo")) + labs(title = "ED Visits during past 2 years", x = "", y = "Number of ED Visits in 6 Month Timeframe")
        })
        
        output$diagnoses <- renderTable({
            subset(diagnoses, Cost.Rank >= range()[1] & Cost.Rank <= range()[2], select = c(input$identifier, input$CheckDiagnoses))
        }, include.rownames=FALSE)
})