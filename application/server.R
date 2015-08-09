library(shiny)

source("functions.R")
shinyServer(
        function(input,output){
                output$cleanText <-renderText({
                        txt_sizing(txt_cleaning(input$inputText),3)
                })
                
        }
)