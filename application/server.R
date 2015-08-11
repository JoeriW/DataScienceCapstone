library(shiny)

source("functions.R")
shinyServer(
        function(input,output){
                x <- reactive(txt_prediction(txt_sizing(txt_cleaning(txt_profanitycheck(input$inputText)),3),3))
                output$top1Text <-renderText({
                        x()[1,3]
                })
                output$top2Text <-renderText({
                        x()[2,3]
                })
                output$top3Text <-renderText({                      
                        x()[3,3]
                })
                
        }
)