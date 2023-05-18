library(shiny)
library(stringr)
library(ggplot2)  # for the diamonds dataset


# See above for the definitions of ui and server
ui <- fluidPage(
    titlePanel("hola"),
    sidebarLayout(
        sidebarPanel(
            dat <- fileInput("file1", "Choose CSV File"),
            conditionalPanel(
                'input.dataset === "iris"',
                helpText("Display 5 records by default.")
            ),
           
            checkboxInput("iChEMBL.ID", label = "ChEMBL ID", value = TRUE),
            checkboxInput("iName", label = "Name"),
            checkboxInput("iSynonyms", label = "Synonyms"),
            checkboxInput("iType", label = "Type"),
            checkboxInput("iMolecular.Weight", label = "Molecular Weight"),
            checkboxInput("iTargets", label = "Targets"),
            checkboxInput("iBioactivities", label = "Bioactivities"),
            checkboxInput("iAlogP", label = "AlogP"),
            checkboxInput("iPolar.Surface.Area", label = "Polar Surface Area"),
            checkboxInput("iHBA", label = "HBA"),
            checkboxInput("iHBD", label = "HBD"),
            checkboxInput("iX.RO5.Violations", label = "X RO5 Violations"),
            checkboxInput("iX.Rotatable.Bonds", label = "X Rotatable Bonds"),
            checkboxInput("iCX.Acidic.pKa", label = "CX Acidic pKa"),
            checkboxInput("iCX.Basic.pKa", label = "CX Basic pKa"),
            checkboxInput("iCX.LogP", label = "CX LogP"),
            checkboxInput("iAromatic.Rings", label = "Aromatic Rings"),
            checkboxInput("iHeavy.Atoms", label = "Heavy Atoms"),
            checkboxInput("iHBA..Lipinski.", label = "HBA Lipinski."),
            checkboxInput("iHBD..Lipinski.", label = "HBD Lipinski."),
            checkboxInput("iX.RO5.Violations..Lipinski.", label = "X RO5 Violations Lipinski."),
            checkboxInput("iMolecular.Weight..Monoisotopic.", label = "Molecular.Weight Monoisotopic."),
            checkboxInput("iMolecular.Formula", label = "Molecular Formula"),
            checkboxInput("iSmiles", label = "Smiles"),
            checkboxInput("iInchi.Key", label = "Inchi Key")
        ),
        mainPanel(
            tabsetPanel(
                id = 'dataset',
                tabPanel("Table", DT::dataTableOutput("table1")),
                tabPanel("iris", DT::dataTableOutput("tableIris"))
            ),
            tableOutput("contents")
        )
    )
)

server <- function(input, output) {
    
    d1 <- reactive({
        req(input$file1)
        
        inFile <- input$file1 
        df <- read.csv(inFile$datapath, header = TRUE, sep = ";")
        
        cn <- colnames(df)
        print(cn)
        count <- 1
        for(v in cn) {
            cn[count] <- str_replace_all(v, " ", "_")
            count <- count + 1
        }
        colnames(df) <- cn
        
        include <- c("ChEMBL.ID")
        
     
        if(input$iName) include <- append(include, "Name")
        if(input$iSynonyms) include <- append(include, "Synonyms")
        if(input$iType) include <- append(include, "Type")
        if(input$iMolecular.Weight) include <- append(include, "Molecular.Weight")
        if(input$iTargets) include <- append(include, "Targets")
        if(input$iBioactivities) include <- append(include, "Bioactivities")
        if(input$iAlogP) include <- append(include, "AlogP")
        if(input$iPolar.Surface.Area) include <- append(include, "Polar.Surface.Area")
        if(input$iHBA) include <- append(include, "HBA")
        if(input$iHBD) include <- append(include, "HBD")
        if(input$iX.RO5.Violations) include <- append(include, "X.RO5.Violations")
        if(input$iX.Rotatable.Bonds) include <- append(include, "X.Rotatable.Bonds")
        if(input$iCX.Acidic.pKa) include <- append(include, "CX.Acidic.pKa")
        if(input$iCX.Basic.pKa) include <- append(include, "CX.Basic.pKa")
        if(input$iCX.LogP) include <- append(include, "CX.LogP")
        if(input$iAromatic.Rings) include <- append(include, "Aromatic.Rings")
        if(input$iHeavy.Atoms) include <- append(include, "Heavy.Atoms")
        if(input$iHBA..Lipinski.) include <- append(include, "HBA..Lipinski.")
        if(input$iHBD..Lipinski.) include <- append(include, "HBD..Lipinski.")
        if(input$iX.RO5.Violations..Lipinski.) include <- append(include, "X.RO5.Violations..Lipinski.")
        if(input$iMolecular.Weight..Monoisotopic.) include <- append(include, "Molecular.Weight..Monoisotopic.")
        if(input$iMolecular.Formula) include <- append(include, "Molecular.Formula")
        if(input$iSmiles) include <- append(include, "Smiles")
        if(input$iInchi.Key) include <- append(include, "Inchi.Key")
        
        return(df[include])
    })
    # output$contents <- renderTable({
    #     d1()
    #     
    # })
    output$table1 <- DT::renderDataTable({
        DT::datatable(d1(), options = list(lengthMenu = c(5, 10, 15, 20), pageLength = 15))
    })
    output$tableIris <- DT::renderDataTable({
        DT::datatable(iris, options = list(lengthMenu = c(5, 10, 15, 20), pageLength = 15))
    })
}

shinyApp(ui = ui, server = server)







