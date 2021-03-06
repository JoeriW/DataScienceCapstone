library(shiny)

shinyUI(fluidPage(
        titlePanel("John Hopkins University Data Science Capstone Project"),
        
        mainPanel(
                tabsetPanel(type = "tabs",
                            tabPanel("Prediction",
                                     br(),
                                     h4("Instruction:"),
                                     p("Enter your text in the box below. Profane/insulting words, numbers, punctuations and special characters will be filtered out."),
                                     tags$b("Note:"),
                                     p("only the last 3 valid words (i.e. excluding profane/insulting terms) of the input are relevant for the prediction algorithm."),
                                     br(),
                                     textInput('inputText',"Enter text here:",value="this is a"),
                                     submitButton("predict next word",icon=icon("magic",lib="font-awesome")),
                                     br(),
                                     h4("Top prediction:"),
                                     verbatimTextOutput('top1Text'),
                                     h4("2nd prediction:"),
                                     verbatimTextOutput('top2Text'),   
                                     h4("3rd prediction:"),
                                     verbatimTextOutput('top3Text')   
                            ),
                            
                            
                            tabPanel("Algorithm"),
                            tabPanel("About",
                                     br(),
                                     p(HTML('<p>Code is available on my github page: <a href="https://github.com/JoeriW/DataScienceCapstone">https://github.com/JoeriW/DataScienceCapstone.'))
                            )
                )
        )
))
