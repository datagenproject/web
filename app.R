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
            tabsetPanel(
                id = 'dataset',
                tabPanel("Taula", DT::dataTableOutput("table1")),
                tabPanel("Gràfics", 
                         plotOutput("g1"),
                         plotOutput("g2"),
                         plotOutput("g3"),
                         plotOutput("g4"),
                         plotOutput("g5"),
                         plotOutput("g6")
                )
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
    # output$contents <- renderTable({
    #     d1()
    #     
    # })
    output$table1 <- DT::renderDataTable({
        DT::datatable(d1(), options = list(lengthMenu = c(5, 10, 15, 20), pageLength = 15))
    })
    # output$graph <- DT::renderDataTable({
    #     DT::datatable(iris, options = list(lengthMenu = c(5, 10, 15, 20), pageLength = 15))
    # })
    
    output$g1 <- renderPlot({
        
        df1 <- data.frame()
        
        barplot(1,
                ylab="idk1",
                xlab="idk2")
    })
    output$g2 <- renderPlot({
        
        df1 <- data.frame()
        
        barplot(c(1,2),
                ylab="idk1",
                xlab="idk2")
    })
}

shinyApp(ui = ui, server = server)







