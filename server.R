
shinyServer(function(input, output) {
  
  
  searchVar<- reactive({  
    n_nums=sapply(file,is.numeric)    
    enduses=names(file)[n_nums]
    enduses=try(as.character(data_dictionary$Variable[order(data_dictionary$Units)][data_dictionary$Variable[order(data_dictionary$Units)]%in% enduses]),silent=TRUE)
  })
  
  
  output$selectEnduses <- renderUI({ 
    try(checkboxGroupInput("enduses", label = h3("Select End Use"), searchVar(),selected=searchVar()[1] ),silent=TRUE)
  })
  
  
  output$plot_gui <- renderPlot({
    
    input$goButton
    
    start_ind=isolate(input$start_ind)
    enduses=isolate(input$enduses)
    obs=isolate(input$obs)
    
#     start_ind=input$start_ind
#     enduses=input$enduses
#     obs=input$obs
    plot_gui(start_ind,enduses,obs)    
    
  })
  
  
  
})


