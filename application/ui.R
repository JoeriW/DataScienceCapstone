library(shiny)

shinyUI(fluidPage(
        titlePanel("Swift Key:John Hopkins Data science capstone project"),

        mainPanel(
                tabsetPanel(type = "tabs",
                            tabPanel("Prediction",
                                     br(),
                                     textInput('inputText',"Enter text here:",value=" "),
                                     submitButton("predict next word",icon=icon("magic",lib="font-awesome")),
                                     br(),
                                     textOutput('cleanText')
                                     ),
                            
                            
                            tabPanel("Algorithm"),
                            tabPanel("About",
                                     br(),
                                     p(HTML('<p>Code is available on my github page: <a href="https://github.com/JoeriW/DataScienceCapstone">https://github.com/JoeriW/DataScienceCapstone.'))
                                     )
                            )
                )
        ))

