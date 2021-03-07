

library(shiny)
library(rclipboard)
source("utils.r")

ui <- fluidPage(
    rclipboardSetup(),
    h2("Recebe um QID, gera uma taxobox"),
    sidebarLayout(
        sidebarPanel(
        textInput(
            inputId = "qid",
            label = "Term QID",
            value = "",
            width = NULL,
            placeholder = NULL
        )
    ),
    mainPanel(
        # UI ouputs for the copy-to-clipboard buttons
        uiOutput("clip"),
        verbatimTextOutput("taxobox")
    )
    )
)

server <- function(input, output) {

    output$taxobox <- renderText({
        qid <- input$qid
        result <- get_taxobox(qid)
        
        if (qid == "") {
            return("Waiting for a term QID")
        } else {
            return(result)
        }
    })
    
    
    output$clip <- renderUI({
        qid <- input$qid
        result <- get_taxobox(qid)
        rclipButton("clipbtn", "Copy", result, icon("clipboard"))
    })
}

# Run the application
shinyApp(ui = ui, server = server)