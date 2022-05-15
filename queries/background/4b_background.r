sourceDir <- getSrcDirectory(function(dummy) {dummy})
setwd(sourceDir)
system('taskkill /f /im AcroRd32.exe')

library(tidyr)
library(data.table)
library(dplyr)


# read user, tag, posttype triples covering all background posts
post_background<-fread('user_background.csv', col.names = c("UserId", "tag", "postType"))

# count user involvement in each tag disregarding posttype
tag_frequency<- post_background %>% filter(UserId != 0) %>% select(-postType) %>% group_by(UserId, tag) %>% tally()

# count how many users have a background in a tag (having posted once) 
tag_occurences<-tag_frequency %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))
tag_occurences2<-tag_frequency %>% filter(n>1) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))
tag_occurences3<-tag_frequency %>% filter(n>2) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))
tag_occurences4<-tag_frequency %>% filter(n>3) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))
tag_occurences5<-tag_frequency %>% filter(n>4) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))
tag_occurences6<-tag_frequency %>% filter(n>5) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))
tag_occurences10<-tag_frequency %>% filter(n>9) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))

# The one we use:
tag_occurences20<-tag_frequency %>% filter(n>19) %>% group_by(tag) %>% tally() %>% filter(n > 100) %>% arrange(desc(n))



