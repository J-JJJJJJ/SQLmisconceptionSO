sourceDir <- getSrcDirectory(function(dummy) {dummy})
setwd(sourceDir)
system('taskkill /f /im AcroRd32.exe')


library(dplyr)
library(data.table)


# read results of 0.1_sql_top_related_tags.sql after manually classifying which tags should be excluded 
tags<-fread('excludeTags.csv', header = F) %>% arrange(V2)
fwrite(tags, 'excludeTags.csv', col.names = F)


# split tags based on the assigned classification
tags_exclude<-tags %>% dplyr::filter(V3==1) %>% arrange(V2)
tags_exclude<-tags_exclude$V2

tags_include<-tags %>% dplyr::filter(V3==0) %>% arrange(V2)
tags_include<-tags_include$V2


# export included and excluded tags to files
fileConn<-file("included_tags.txt")
writeLines(paste0(tags_include, collapse = ", "), fileConn)
close(fileConn)


fileConn<-file("excluded_tags.txt")
writeLines(paste0(tags_exclude, collapse = ", "), fileConn)
close(fileConn)



# create SQL code for excluding questions based on tags for use in 1_add_sql_to_table.sql
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



