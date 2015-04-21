



plot_gui=function(start_ind,enduses,obs) {
  
#     rdas=list.files(pattern=".rda")
#     for (file in rdas) {load(file)}
  
  start=round(start_ind*nrow(file))
  if (start==0) start=1
  
  time_ind=which(sapply(file,is.POSIXct)==TRUE)[1]
  time_diff=as.numeric(round(median(diff(file[,time_ind]))),units="secs")/60
  obs=obs*1440/time_diff
  
  n_finish=start+obs
  #set obs to max out at max obs
  if (n_finish>nrow(file)) n_finish=nrow(file)
  end_inds=which(names(file) %in% enduses)
  file=file[start:n_finish,c(time_ind,end_inds)]
  
  
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

