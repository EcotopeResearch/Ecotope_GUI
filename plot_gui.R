



plot_gui=function(enduses,dates,smooth=1) {
  
  
  file=gui_munge(file,enduses,dates,smooth=1)
  
  ##
  data_dictionary=data_dictionary[data_dictionary$Variable %in% enduses,]
  
  
  
  melted=try(gather(file,"Variable","value",-time_ind,na.rm=TRUE),silent=TRUE)
  if (class(melted)=="try-error") return(NULL)
  melted=try(merge(x=melted,y=data_dictionary,by="Variable"),silent=TRUE)
  # melted=try(left_join(x=melted,y=data_dictionary),silent=TRUE)
  if (class(melted)=="try-error") return(NULL)
  
  if(length(levels(as.factor(as.character(data_dictionary$Units))))>1) {
    g=ggplot(data=melted,aes(x = DateTime, y = value,colour=Variable)) + theme_bw() +  geom_line() + 
      facet_grid(Units~.,scales="free") 
  } else {
    g=ggplot(melted) + theme_bw() + geom_line(aes(x = DateTime, y = value,colour=Variable), size = 1)
  } 
  
  g =g+ ylab("") + scale_color_discrete(name="Legend") + ggtitle("Ecotope Seattle Office")
  g
}

table_gui=function(enduses,dates,smooth=1) {
  file=gui_munge(file,enduses,dates,smooth=1)
  file=tbl_df(file)
  enduse_inds=which(names(file) %in% enduses)
  
  mean_col=summarise_each(file,funs(mean),enduse_inds)
  sd_col=summarise_each(file,funs(sd),enduse_inds)
  cool_table=t(as.data.frame(rbind(mean_col,sd_col)))
  colnames(cool_table)=c("Mean","SD")
  
  return(cool_table)
}


gui_munge=function(file,enduses,dates,smooth=1){
  #     rdas=list.files(pattern=".rda")
  #     for (file in rdas) {load(file)}
  smooth=as.numeric(smooth)
  #omiting irrelevant end uses
  
  end_inds=which(names(file) %in% enduses)
  time_ind=which(names(file)=="DateTime")
  file=file[,c(time_ind,end_inds)]
  
  
  #data selection
  dates=as.POSIXct(dates)
  
  start=try(min(which(file$DateTime>dates[1])),silent=TRUE)
  if ( class(start)=="try-error") {
    return(NULL)
  } else if (length(start)==0 ) {
    start=1
  } 
  
  if (smooth>2){
    start=start-smooth
    if (start<0) start=1
  }
  
  
  
  n_finish=max(which(file$DateTime<dates[2]))
  if (length(n_finish)==0) n_finish=nrow(file)
  
  
  file=file[start:n_finish,]
  
  #smoothing
  
  
  if (smooth>2){
    n_nums=sapply(file,is.numeric)
    if (sum(n_nums)>1){
      file[,n_nums]=apply(file[,n_nums],2,function(x){
        x= rollapply(x, smooth, mean, na.rm = TRUE,fill=NA)
      })
    } else {
      file[,n_nums]= rollapply(file[,n_nums], smooth, mean, na.rm = TRUE,fill=NA)
    }
  }
  
  return(file)
}
