

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Ecotope Seattle Office"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("goButton", "Plot"),
      htmlOutput("selectEnduses"),
#       htmlOutput("selectStart"),
      sliderInput("start_ind","Starting Slider:",min = 0,max = 1,value = 0,step=.005),
      numericInput("obs", label = h3("Days"), value = 60)
    ),
    mainPanel(
      plotOutput("plot_gui")
    )
  )
)
)





