sourceDir <- getSrcDirectory(function(dummy) {dummy})
setwd(sourceDir)
system('taskkill /f /im AcroRd32.exe')


library(dplyr)
library(data.table)


tags<-fread('excludeTags.csv', header = F) %>% arrange(V2)
fwrite(tags, 'excludeTags.csv', col.names = F)

tags_exclude<-tags %>% dplyr::filter(V3==1) %>% arrange(V2)
tags_exclude<-tags_exclude$V2

tags_include<-tags %>% dplyr::filter(V3==0) %>% arrange(V2)
tags_include<-tags_include$V2

fileConn<-file("included_tags.txt")
writeLines(paste0(tags_include, collapse = ", "), fileConn)
close(fileConn)


fileConn<-file("excluded_tags.txt")
writeLines(paste0(tags_exclude, collapse = ", "), fileConn)
close(fileConn)


produce_sql<-T





if(produce_sql){
lines<-character(0)

for(tag in tags_exclude){
  
  lines<-lines %>% c(paste0("not Tags like '%<", tag, ">%' and"))
 
}


fileConn<-file("tag_remove_sql.txt")
writeLines(lines, fileConn)
close(fileConn)

}



