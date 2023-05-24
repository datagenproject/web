library(shiny)
library(stringr)
library(ggplot2)


c("Enllaços Rotables", "AlogP", "Polar Surface Area", "HBA Lipinski", "HBR Lipinski", "Molecular Weight", "Aromatic Rings", "Heavy Atoms")
vars <- c("Molecular.Weight", "Polar.Surface.Area", "AlogP", "X.Rotatable.Bonds", "CX.Acidic.pKa", "CX.Basic.pKa", "CX.LogP", "Aromatic.Rings", "Heavy.Atoms", "HBA..Lipinski.", "HBD..Lipinski.")
ui <- fluidPage(
    titlePanel("SmallMol S.L."),
    tabsetPanel(
        tabPanel("Taula",
            sidebarPanel(
                fileInput("file1", "Choose CSV File"),
                
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
                 
                 tabsetPanel(
                      tabPanel("k-means clustering",
                               
                               pageWithSidebar(
                                 headerPanel('k-means clustering'),
                                 sidebarPanel(
                                   selectInput('xcol', 'X Variable', vars),
                                   selectInput('ycol', 'Y Variable', vars, selected = vars[[2]]),
                                   numericInput('clusters', 'Cluster count', 3, min = 1, max = 9)
                                 ),
                                 mainPanel(
                                   plotOutput('plot1')
                                 )
                               )
                      ),
                      tabPanel("rule of 5",
                               plotOutput("ro5"),
                      )
                 )
        )
    )
)

server <- function(input, output) {
    print(class(vars))
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
        DT::datatable(d1(), options = list(lengthMenu = c(5, 10, 15, 20, 25, 30), pageLength = 10))
    })
    
    # k-means
    d2 <- reactive({
      req(input$file1)
      
      inFile <- input$file1 
      df <- read.csv(inFile$datapath, header = TRUE, sep = ";")
      
      return(df[vars])
    })
    
    selectedData <- reactive({
      data <- d2();
      xcol <- input$xcol
      ycol <- input$ycol
      abc <- data[, c(xcol, ycol)]
      def <- abc[!is.na(abc[xcol]),]
      def <- abc[!is.na(abc[ycol]),]
      return(def)
    })
    
    clusters <- reactive({
      kmeans(selectedData(), input$clusters)
    })
    
    output$plot1 <- renderPlot({
      palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
                "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
      
      par(mar = c(5.1, 4.1, 0, 1))
      plot(selectedData(),
           col = clusters()$cluster,
           pch = 20, cex = 3)
      points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    })
    
    
    
    
    # rule of five
    ro5d <- reactive({
      req(input$file1)
      
      inFile <- input$file1 
      df <- read.csv(inFile$datapath, header = TRUE, sep = ";")
      r <- df$X.RO5.Violations..Lipinski.
      return(r)
    })
    output$ro5 <- renderPlot({
      rof <- ro5d()
      rof <- rof[nzchar(rof)]
      print(rof)
      barplot(c(30,23,45,32,22,10),
              ylab="Cantitat",
              xlab="Numero")
    })
}

shinyApp(ui = ui, server = server)


