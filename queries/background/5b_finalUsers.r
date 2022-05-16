sourceDir <- getSrcDirectory(function(dummy) {dummy})
setwd(sourceDir)
system('taskkill /f /im AcroRd32.exe')


library(dplyr)
library(data.table)
library(stringr)
library(tidyr)
library(xtable)
library(tidyverse)

# set xtable parameter
options(xtable.table.placement = "H", xtable.include.rownames=F)
  


# read table about background posters with the number of questions in each of the selected tags 
user_frame<-fread('5a_output_bgposters.csv', col.names = c("OwnerUserId", "backgroundPostCount", "csharpPosts", "javaPosts", 
                                                 "javascriptPosts", "pythonPosts", "androidPosts", "jqueryPosts", "phpPosts", "cppPosts"),
                  na.strings = "NULL")
# compute relevancy scores 
user_frame<- user_frame %>% mutate(csharpRelevancy = csharpPosts / backgroundPostCount,
                                   javaRelevancy = javaPosts / backgroundPostCount,
                                   javascriptRelevancy = javascriptPosts / backgroundPostCount,
                                   pythonRelevancy = pythonPosts / backgroundPostCount,
                                   androidRelevancy = androidPosts / backgroundPostCount,
                                   jqueryRelevancy = jqueryPosts / backgroundPostCount,
                                   phpRelevancy = phpPosts / backgroundPostCount,
                                   cppRelevancy = cppPosts / backgroundPostCount)
# replace nulls
user_frame[is.na(user_frame)]<-0

# function to determine the selected users for each background tag
selected_user_table<- function(tagName, uframe=user_frame, questions_needed=40){
  
  #relevancyColumn <- match(paste0(tagName, "Relevancy"), names(uframe))
  postColumn <- match(paste0(tagName, "Posts"), names(uframe))
  
  new_frame <- uframe %>% select(OwnerUserId, backgroundPostCount, postColumn, !!paste0(tagName, "Relevancy")) %>% 
    arrange(desc(!!sym(paste0(tagName, "Relevancy")))) %>%
    top_n(questions_needed)
  
  return(new_frame)
}

# minimum relevancy requirements per tag
cutoffs<-numeric(0)
  
# compute the selected user table for each background tag
tags<-c("csharp", "java", "javascript", "python", "android", "jquery", "php", "cpp")
for(tag in tags){
  tempTable<-selected_user_table(tag)
  assign(paste0(tag, "_users"), tempTable)
  relevancyColumn <- match(paste0(tag, "Relevancy"), names(tempTable))
  
  cutoffs<-c(cutoffs, min(tempTable %>% select(relevancyColumn)))
}


# user ids for selected users
question_owners<-c(csharp_users$OwnerUserId, java_users$OwnerUserId, javascript_users$OwnerUserId, python_users$OwnerUserId, 
                   android_users$OwnerUserId, jquery_users$OwnerUserId, php_users$OwnerUserId, cpp_users$OwnerUserId)







# create nice latex tables
to_percentage<- function(x) {
  if(is.numeric(x)){ 
     paste0(round(x*100L, 1), "%")
  } else x 
}

final_user_frame <- user_frame %>% filter(OwnerUserId %in% question_owners) %>% mutate_at(11:18, funs(to_percentage))

question_owners %>% unique() %>% list() %>% fwrite("users_selected.csv")


selected_questions<-fread('selectBGQ.csv', col.names = c("Id", "AcceptedAnswerId", "AnswerCount", "Body", "ClosedDate", "CommentCount", 
                                                         "CommunityOwnedDate", "CreationDate", "FavoriteCount", "LastActivityDate", 
                                                         "LastEditDate","LastEditorDisplayName", "LastEditorUserId", "OwnerUserId", 
                                                         "ParentId", "PostTypeId", "Score", "Tags", "Title", "ViewCount", "UserId", 
                                                         "firstSQLpostDate", "CutoffSQLdate"), na.strings = "NULL")



tags<-c("csharp", "java", "javascript", "python", "android", "jquery", "php", "cpp")
for(tag in tags){
  tempTable<-selected_user_table(tag)
  
   
  tempTable<- tempTable %>% 
    left_join(selected_questions, by = "OwnerUserId") %>%
    select(UserId,  QuestionId =Id, Title, Score, Tags, !!paste0(tag, "Relevancy")) %>%
    mutate(Tags = str_replace_all(Tags, "<sql>", "")) %>% 
    mutate(Tags = str_replace_all(Tags, "><", ", ")) %>% 
    mutate(Tags = str_replace_all(Tags, ">", "")) %>%
    mutate(`Other Tags` = str_replace_all(Tags, "<", "")) %>%
    mutate(Title = sanitize(Title, type= "latex")) %>%
   # arrange(QuestionId) %>%
    arrange(desc(!!sym(paste0(tag, "Relevancy")))) %>%
    mutate(QuestionId = paste0("\\href{https://stackoverflow.com/questions/", QuestionId, "}{", QuestionId, "}" )) %>%
    mutate(UserId = paste0("\\href{https://stackoverflow.com/users/", UserId, "}{", UserId, "}" )) %>%
    select(-Tags, -!!sym(paste0(tag, "Relevancy")))
    
  
  latex_table<-xtable(tempTable,
                      caption = paste0("SQL questions for manual review asked by users with a background in ", 
                                       tag,
                                       ". The UserId and QuestionId are hyperlinks to the corresponding page on Stack Overflow."))
  align(latex_table)<-"rrrp{9cm}rp{3.5cm}"
  assign(paste0(tag, "_users2"), tempTable)
  
   print(latex_table, 
         type = "latex", 
         paste0(tag,"BackgroundQuestions.tex"),
         tabular.environment = "longtable",
         sanitize.text.function = identity)
}

user_overview<-data.frame(UserId = integer(0), 
                          BackgroundPosts = integer(0),
                          BackgroundTags=character(0), 
                          Relevancy=character(0))

for(user in unique(question_owners)){
  bgTags<-character(0)
  relScore<-character(0)
  user_frames_list<-list(csharp_users, java_users, javascript_users, python_users, android_users, jquery_users, php_users, cpp_users)
  
  for(tag_id in 1:8){
    tag<-tags[tag_id]
    current_user_frame<-user_frames_list[[tag_id]]
    current_row<-current_user_frame %>% filter(OwnerUserId == user)
    
    if(nrow(current_row) > 0){
      bgTags<-bgTags %>% c(tag) 
      new_relScore<-as.numeric(current_row[1,4])
      new_relScore<- round(new_relScore*100L, 1) %>% paste0("%")
      relScore<- relScore %>% c(new_relScore)
      bgposts<-current_row[1,2]
    }
  }
  
  bgTags<-paste0(bgTags, collapse = ", ")
  relScore<-paste0(relScore, collapse = ", ")
  
  user_overview[nrow(user_overview) + 1,]<- c(user, bgposts, bgTags, relScore)
  
}


user_overview <- user_overview %>% 
  arrange(as.integer(UserId)) %>%
  mutate(UserId = paste0("\\href{https://stackoverflow.com/users/", UserId, "}{", UserId, "}" )) %>%
  mutate(Relevancy = sanitize(Relevancy, type = "latex")) %>%
  mutate(BackgroundTags=str_replace_all(BackgroundTags, "cpp", "c++")) %>%
  mutate(BackgroundTags=str_replace_all(BackgroundTags, "csharp", "c#")) %>%
  mutate(BackgroundTags = sanitize(BackgroundTags, type="latex"))
  
  
user_overview_tex<- user_overview %>% xtable()

align(user_overview_tex)<-"rrrrr"

print(user_overview_tex,
      type = "latex",
      "BackgroundUsersTEST.tex",
      tabular.environment = "supertabular",
      sanitize.text.function = identity)

############
############ questions selection after pre-review 
############ manually copy userIDs to SQL server and query corresponding questions from there


# need 11+4+2+1 more csharp questions
selected_user_table("csharp", uframe=user_frame, questions_needed=57) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print()

# need 19+9+3+3+2 more java questions
selected_user_table("java", uframe=user_frame, questions_needed=77) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print() # 485978 not queried because unneeded tie, reach 40 selected questions without it

# need 17+9+5+3 more javascript questions
selected_user_table("javascript", uframe=user_frame, questions_needed=73) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print()


# need 20 +8+7+ 2+1 more python questions
selected_user_table("python", uframe=user_frame, questions_needed=77) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print()


# need 18+ 6+1 more android questions
selected_user_table("android", uframe=user_frame, questions_needed=65) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print()


# need 14 + 4 + 4 + 1 more jquery questions
selected_user_table("jquery", uframe=user_frame, questions_needed=63) %>% tail(-41) %>% # -41 because tie in prior selection
  select(OwnerUserId) %>% paste0()%>% print()

# need 15 + 6 + 1 + 1 more php questions
selected_user_table("php", uframe=user_frame, questions_needed=63) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print()
  
# need 15 + 5 + 1 more cpp questions
selected_user_table("cpp", uframe=user_frame, questions_needed=61) %>% tail(-40) %>% 
  select(OwnerUserId) %>% paste0()%>% print()


