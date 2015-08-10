library(shiny)

source("functions.R")
shinyServer(
        function(input,output){
                
                output$cleanText <-renderText({
                        txt_prediction(txt_sizing(txt_cleaning(txt_profanitycheck(input$inputText)),3))
                })
                
        }
)