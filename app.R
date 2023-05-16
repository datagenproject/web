library(shiny)
library(stringr)

# See above for the definitions of ui and server
ui <- fluidPage(
    titlePanel("hola"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose CSV File"),
            checkboxInput("iAlogP", label = "AlogP")
        ),
        mainPanel(
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
        
        include <- c("Name", "Molecular.Weight")
        
        if(input$iAlogP) include <- append(include, "Aromatic.Rings")
        
        return(df[include])
    })
    output$contents <- renderTable({
        d1()
    })
}

shinyApp(ui = ui, server = server)

