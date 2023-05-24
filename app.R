library(shiny)
library(stringr)
library(ggplot2)  # for the diamonds dataset


# See above for the definitions of ui and server
ui <- fluidPage(
    titlePanel("SmallMol S.L."),
    tabsetPanel(
        tabPanel("Taula",
            sidebarPanel(
                fileInput("file1", "Choose CSV File"),
                     
                checkboxInput("iChEMBL.ID", label = "ChEMBL ID", value = TRUE),
                checkboxInput("iName", label = "Name"),
                checkboxInput("iMolecular.Weight", label = "Molecular Weight"),
                checkboxInput("iTargets", label = "Targets"),
                checkboxInput("iBioactivities", label = "Bioactivities"),
                checkboxInput("iAlogP", label = "AlogP"),
                checkboxInput("iPolar.Surface.Area", label = "Polar Surface Area"),
                checkboxInput("iHBA..Lipinski.", label = "HBA Lipinski"),
                checkboxInput("iHBD..Lipinski.", label = "HBD Lipinski"),
                checkboxInput("iX.RO5.Violations..Lipinski.", label = "X RO5 Violations Lipinski")
            ),
            mainPanel(
                DT::dataTableOutput("table1")
            )
        ),
        tabPanel("Gràfics", 
                 fluidRow(
                    column(6,
                        plotOutput("g1"),
                        plotOutput("g3"),
                        plotOutput("g5")
                    ),
                    column(6,
                        plotOutput("g2"),
                        plotOutput("g4"),
                        plotOutput("g6")
                        
                    )
                 )
        )
    )
)

server <- function(input, output) {
    
    d1 <- reactive({
        req(input$file1)
        
        inFile <- input$file1 
        df <- read.csv(inFile$datapath, header = TRUE, sep = ";")
        
        include <- c("ChEMBL.ID")
        
        if(input$iName) include <- append(include, "Name")
        if(input$iMolecular.Weight) include <- append(include, "Molecular.Weight")
        if(input$iTargets) include <- append(include, "Targets")
        if(input$iBioactivities) include <- append(include, "Bioactivities")
        if(input$iAlogP) include <- append(include, "AlogP")
        if(input$iPolar.Surface.Area) include <- append(include, "Polar.Surface.Area")
        if(input$iHBA..Lipinski.) include <- append(include, "HBA..Lipinski.")
        if(input$iHBD..Lipinski.) include <- append(include, "HBD..Lipinski.")
        if(input$iX.RO5.Violations..Lipinski.) include <- append(include, "X.RO5.Violations..Lipinski.")
        
        return(df[include])
    })
    output$table1 <- DT::renderDataTable({
        DT::datatable(d1(), options = list(lengthMenu = c(5, 10, 15, 20), pageLength = 15))
    })
    
    dfg1 <- reactive({
        
        req(input$file1)
        
        inFile <- input$file1 
        df <- read.csv(inFile$datapath, header = TRUE, sep = ";")
        
        df <- df[c("Molecular.Weight")]
        
        return(df)
    })
    
    output$g1 <- renderPlot({
        mw <- dfg1()[,"Molecular.Weight"]
 
        barplot(mw,
                ylab="Molecular Weight (Da)",
                xlab="")
    })
    
    
    
    
    dfg2 <- reactive({
        
        req(input$file1)
        
        inFile <- input$file1 
        df <- read.csv(inFile$datapath, header = TRUE, sep = ";")
        
        df <- df[c("Molecular.Weight")]
        
        return(df)
    })
    
    output$g2 <- renderPlot({
        rof <- dfg2()[,"Molecular.Weight"]
        
        barplot(rof,
                ylab="rof",
                xlab="")
    })
}

shinyApp(ui = ui, server = server)







