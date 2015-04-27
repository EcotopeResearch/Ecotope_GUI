
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
    enduses=isolate(input$enduses)
    dates=isolate(input$dates)
    smooth=isolate(input$smooth)
    plot_gui(enduses,dates,smooth)    
  })
  
  output$table_gui<- renderTable({
    input$goButton
    enduses=isolate(input$enduses)
    dates=isolate(input$dates)  
    smooth=isolate(input$smooth)
    cool_table=table_gui(enduses,dates,smooth)
    
  })
  
  output$compare_gui<- renderPlot({
    input$goButton
    enduses=isolate(input$enduses)
    dates=isolate(input$dates)
    smooth=isolate(input$smooth)
    compare_gui(enduses,dates,smooth)
  })
  
  output$dictionary_gui<- renderTable({
    
    enduses=input$enduses
    dictionary=dictionary_gui(enduses)
    
  })
  
})


