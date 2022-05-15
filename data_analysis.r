sourceDir <- getSrcDirectory(function(dummy) {dummy})
setwd(sourceDir)
system('taskkill /f /im Acrobat.exe')


library(dplyr)
library(data.table)
library(stringr)
library(tidyr)
library(xtable)
library(tidyverse)
library(xlsx)
library(textclean)
library(ggcorrplot)
library(ggthemes)
# set xtable parameter
options(xtable.table.placement = "H", xtable.include.rownames=F)

theme_set(theme_tufte()+
            theme(
              axis.text=element_text(size=12, family = "sans"),
              axis.title =element_text(size=12, family = "sans"),
              legend.title = element_text(size=12, family = "sans"),
              legend.text = element_text(size=12, family = "sans")
              ))




process_error_i<-function(errors, i){
  frame <- errors %>% select("QuestionId", ends_with(i %>% as.character(i)))
  frame$iteration<-i # counter error index
  names(frame) <- gsub("[[:digit:]]", "", names(frame) )
  return(frame)
}

process_file<-function(path){
  
  review<-read.xlsx(path, 1) %>% filter(!is.na(QuestionId))
  review_base<-review[,1:10]
  review_errors<-review %>% select(starts_with(c("QuestionId", "error", "misconception")))
  
  review_final<-full_join(review_base, process_error_i(review_errors, 1), by = c("QuestionId" = "QuestionId")) 
  
  
  for(i in 2:5){
    review_final<- bind_rows( review_final,
      full_join(review_base, process_error_i(review_errors, i), by = c("QuestionId" = "QuestionId")))


  }
  
  review_final <- review_final %>%
    mutate(semicolon.misuse = as.integer(semicolon.misuse)) %>%
    filter( !is.na(error) | !is.na(misconception) | !is.na(error_explanation) | !is.na(misconception_elaboration) | iteration == 1   ) %>%
    distinct()
  
  
  return(review_final)
}

xtable_printer<-function(table, filename){
  
  current_table<-table %>% 
    xtable() 
  
  align(current_table)<-"rp{88mm}l"
  current_table %>%  print.xtable(
             digits = 0,
             type = "latex",
             paste0("results_temp/",  filename, ".tex"),
             tabular.environment = "longtable",
             floating = F,
             sanitize.text.function = identity, 
             sanitize.colnames.function = identity)
}







full_review<-process_file("full_review.xlsx") %>% mutate(data_selection_category = str_replace_all(data_selection_category, c("cpp", "csharp"), replacement = c("C++", "C#")))

misconceptions<- full_review$misconception %>% table() %>% sort(decreasing = T) %>% as.data.frame()
colnames(misconceptions)<-c("Label", "Frequency")
misconceptions %>% xtable_printer("misconceptions")



errors<- full_review$error %>% table()%>% sort(decreasing = T) %>% as.data.frame()
colnames(errors)<-c("Label", "Frequency")  
errors %>% xtable_printer("errors")


error_explanation<- full_review %>% select(QuestionId, error_explanation) %>% distinct() %>% select(error_explanation) %>% table()%>% sort(decreasing = T) %>% as.data.frame()
colnames(error_explanation)<-c("Description", "Count")  
error_explanation %>% xtable_printer("error explanation")

misconception_elaboration<- full_review %>% select(QuestionId, misconception_elaboration) %>% distinct() %>% select(misconception_elaboration) %>% table()%>% sort(decreasing = T) %>% as.data.frame()
colnames(misconception_elaboration)<-c("Description", "Count")  
misconception_elaboration %>% xtable_printer("misconception elaboration")


error_explanation_other<- full_review$error_explanation[str_detect(full_review$error, "other")] %>% table()%>% sort(decreasing = T) %>% as.data.frame()
colnames(error_explanation_other)<-c("Description", "Count")  
error_explanation_other %>% xtable_printer("error explanation other")

misconception_elaboration_other<- full_review$misconception_elaboration[str_detect(full_review$misconception, "other")] %>% table()%>% sort(decreasing = T) %>% as.data.frame()
colnames(misconception_elaboration_other)<-c("Description", "Count")  
misconception_elaboration_other %>% xtable_printer("misconception elaboration other")


#
#
#    bar chart frequency plots
#
#
#
ggplot_printer<-function(table, file_name, horizontallabel="frequency", verticallabel="labelll", custom_dims=F, cust_width = 5, cust_height=5){
  
  current_plot<-ggplot(table, aes( y=Frequency, x=Label)) +
    geom_bar(stat="identity", width=1, color="black", fill= "lightgrey") +
    coord_flip()+
    geom_text(aes(label=Frequency), size = 6, hjust= "inward")+
    xlab(verticallabel)+
    ylab(horizontallabel)
  
if(!custom_dims){ggsave(plot = current_plot, paste0("results_temp/", file_name, "_barplot.pdf"))}
  else{ggsave(plot = current_plot, paste0("results_temp/", file_name, "_barplot.pdf"), width = cust_width, height = cust_height)}
}

freq_table<-function(column){
  new_table<- column %>% table() %>% sort(decreasing = T) %>% as.data.frame()
  colnames(new_table)<-c("Label", "Frequency")
  
  
  
  return(new_table)
}





# group custom errors together
custom_error_categories<-c("non-standard SQL command", "performance optimization", "DBMS specific issue", "sloppiness", "missing subquery")
custom_error_count<-errors %>% 
  filter(Label %in% custom_error_categories) %>% 
  select(Frequency) %>% 
  sum()
new_errors<-errors %>% 
  filter(!Label %in% custom_error_categories) %>% 
  add_row(Label = "Custom reason", Frequency= custom_error_count) %>% 
  arrange(desc(Frequency))
new_errors$Label <- factor(new_errors$Label, levels = new_errors$Label)


custom_errors<-errors %>% 
  filter(Label %in% custom_error_categories) %>% 
  arrange(desc(Frequency))
custom_errors$Label <- factor(custom_errors$Label, levels = custom_errors$Label)


# group custom misconceptions together
mental_categories<- misconceptions$Label[grepl("mental", misconceptions$Label)]
mental_misc_count<-misconceptions %>% 
  filter(Label %in% mental_categories) %>% 
  select(Frequency) %>% 
  sum()

reduced_misconceptions<-misconceptions %>% 
  filter(!Label %in% mental_categories) %>% 
  add_row(Label = "Incorrect mental model", Frequency= mental_misc_count) %>% 
  arrange(desc(Frequency))
reduced_misconceptions$Label <- factor(reduced_misconceptions$Label, levels = reduced_misconceptions$Label)

mental_misconceptions<-misconceptions %>% 
  filter(Label %in% mental_categories) %>% 
  arrange(desc(Frequency))
mental_misconceptions$Label <- factor(mental_misconceptions$Label, levels = mental_misconceptions$Label)

# bar plot printer
ggplot_printer(reduced_misconceptions, "misconceptions", verticallabel = "misconception category")
ggplot_printer(mental_misconceptions, "mental_misconceptions", verticallabel = "incorrect mental model misconception subcategory")
ggplot_printer(new_errors, "errors", verticallabel = "error category")
ggplot_printer(custom_errors, "custom_errors", verticallabel = "non-standard error category")




#
#
#    error misconception relation
#
#
#
error_misconception_pairs<-full_review %>% select(error, misconception)
error_misconception_pairs$error[error_misconception_pairs$error %in% custom_error_categories]<-"custom error"
error_misconception_pairs$misconception[grepl("mental", error_misconception_pairs$misconception)]<-"incorrect mental model"

error_misconception_pairs$error %>% unique()
error_misconception_pairs$misconception %>% unique()
error_misconception_pairs %>% filter(is.na(misconception))



rel_error_misc_pairs<-table(error_misconception_pairs) %>% t()%>%   scale(center = F, scale = colSums(.)) %>% t() %>% as.data.frame()
rel_error_misc_pairs$Freq[is.na(rel_error_misc_pairs$Freq)]<-0

  
  


error_misc_heatmap<-ggplot(rel_error_misc_pairs, aes(y=error, x=misconception, fill= Freq)) + 
  geom_tile() +
  scale_fill_gradient(low = "lightgrey", high = "blue") +
  theme(axis.text.x=element_text(angle=90,hjust=1)) +
  guides(fill=guide_legend(title="relative frequency"))

 ggsave(plot= error_misc_heatmap, "results_temp/error_misconception_pairs.pdf")


#
#
#    general question info stats
#
#
#
 
 freqplot_printer<-function(table, column, file_name){
   
   current_plot<-ggplot(table, aes_string( x=column)) +
     geom_density(aes(y = ..count..))+
     xlab("number of missing semicolons in a single Stack Overflow question")+
     ylab("frequency")+
     xlim(0, NA)+
     scale_x_continuous(limits=c(0, 13), breaks=seq(0,13,1), expand = c(0,0))+
     scale_y_continuous(expand = c(0,0))+
     theme(axis.line.x = element_line(color="black", size = 0.3),
           axis.line.y = element_line(color="black", size = 0.3))
   
   
   ggsave(plot = current_plot, paste0("results_temp/", file_name, "_freqplot.pdf"))
 }
 
  
q_info<-full_review[!duplicated(full_review$QuestionId),]

freqplot_printer(q_info, "semicolon.misuse", "semicolon")



freq_table(q_info$question_type) %>% ggplot_printer("qtype", verticallabel = "question type", custom_dims=T, cust_width = 6, cust_height=2)
freq_table(q_info$premise) %>% ggplot_printer("premise", verticallabel = "question premise description")
freq_table(q_info$problem) %>% ggplot_printer("problem", verticallabel = "problem type", custom_dims=T, cust_width = 6, cust_height=3)
freq_table(q_info$query.attempt) %>% ggplot_printer("qattempt", verticallabel = "query attempt description", custom_dims=T, cust_width = 8, cust_height=3)
freq_table(q_info$SQL.education) %>% ggplot_printer("sqled", verticallabel = "SQL education mention", custom_dims=T, cust_width = 9, cust_height=4)


#
#
#
#   topics
#
#
topics<-q_info$topics %>% paste(collapse = ",") %>% strsplit(",") %>% table() %>% sort(decreasing = T) %>% as.data.frame()
colnames(topics)<-c("Topic", "Count")  



library(ggwordcloud)
topic_cloud<-ggplot(topics, aes(label = Topic, size=Count)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 17) +
  theme_minimal()
set.seed(12345)
ggsave(plot= topic_cloud, "results_temp/topic_cloud.pdf", width = 2400, height = 850, units = "px")


topics %>% top_n(30) %>% xtable_printer("top_topics")



#
#
#  unseen
#
#
errors %>% filter(Frequency <=20) %>% xtable_printer("unseen_errors")
reduced_misconceptions %>% filter(Frequency <=20) %>% xtable_printer("unseen_misconceptions")


#
#
## per category labels
#
#



for(error_cat in full_review$error %>% unique()){
  if(!error_cat %in% c("none", "unclear")){
  full_review$error_explanation[full_review$error == error_cat] %>%  unique() %>% sort() %>% as.list() %>% fwrite(paste0("results_temp/sub/error_", error_cat, ".txt"), sep = "\n")  
}}



full_review$misconception_elaboration[full_review$misconception == "other"] %>%  unique() %>% sort() %>% as.list() %>% fwrite("results_temp/sub/misc_other.txt", sep = "\n")

for(misc_cat in full_review$misconception %>% unique()){
  if(!misc_cat %in% c(NA, "unclear")){
    full_review$misconception_elaboration[full_review$misconception == misc_cat] %>%  unique() %>% sort() %>% as.list() %>% fwrite(paste0("results_temp/sub/misc_", misc_cat, ".txt"), sep = "\n")  
  }}



# all errors and misc
error_explanation_alphabetical<- full_review$error_explanation %>%  unique() %>% sort() %>% as.list() %>% fwrite("results_temp/error_alphabetical.txt", sep = "\n")
misc_explanation_alphabetical<- full_review$misconception_elaboration %>%  unique() %>% sort() %>% as.list() %>% fwrite("results_temp/misconception_alphabetical.txt", sep = "\n")



# frequent  labels
misconception_elaboration %>% filter(Count >=4)  %>% xtable_printer("common_misc_expl")
error_explanation %>% filter(Count >=4) %>% xtable_printer("common_error_expl")





# background selection stats
user_background_selection_errorcounts<-full_review %>% 
  filter(! data_selection_category %like% "keyword" & !data_selection_category %like% "canonical") %>% 
  group_by(QuestionId, data_selection_category) %>%
  mutate(error_count = case_when(any(error == "none") ~ 0, TRUE ~ max(iteration))) %>%
  ungroup() %>%
  count(QuestionId, data_selection_category, error_count) %>%
  group_by(data_selection_category) %>%
  summarise(average_error = sum(error_count) / n())


background_error_freq<-ggplot(data=user_background_selection_errorcounts, aes(x=average_error, y=data_selection_category)) +
geom_bar(stat="identity", width=1, color="black", fill= "lightgrey") +
  geom_text(aes(label=round(average_error,2)), size = 6, hjust= "inward")+
  ylab("user background")+
  xlab("average number of errors per question")+
  coord_fixed(0.2)


ggsave(plot = background_error_freq, paste0("results_temp/background_error_freq_barplot.pdf"), width = 5, height = 5)

#misc
user_background_selection_misccounts<-full_review %>% 
  filter(! data_selection_category %like% "keyword" & !data_selection_category %like% "canonical") %>% 
  group_by(QuestionId, data_selection_category) %>%
  mutate(misc_count = length(misconception[!is.na(misconception)  & misconception != "none" & misconception != "unclear"])) %>%
  ungroup() %>%
  count(QuestionId, data_selection_category, misc_count) %>%
  group_by(data_selection_category) %>%
  summarise(average_misc = sum(misc_count) / n())


background_misc_freq<-ggplot(data=user_background_selection_misccounts, aes(x=average_misc, y=data_selection_category)) +
geom_bar(stat="identity", width=1, color="black", fill= "lightgrey") +
  geom_text(aes(label=round(average_misc,2)), size = 6, hjust= "inward")+
  ylab("user background")+
  xlab("average number of misconceptions per question")+
  coord_fixed(0.2)


ggsave(plot = background_misc_freq, paste0("results_temp/background_misc_freq_barplot.pdf"), width = 5, height = 5)


# selection strategies
user_background_selection<-full_review %>% 
  filter(! data_selection_category %like% "keyword" & !data_selection_category %like% "canonical") %>%
  mutate(question_category = "background")


keyword_selection<-full_review %>% 
  filter(data_selection_category %like% "keyword") %>%
  mutate(question_category = "keyword")

canonical_selection<-full_review %>% 
  filter(data_selection_category %like% "canonical") %>%
  mutate(question_category = "canonical")

new_review<-bind_rows(user_background_selection, keyword_selection, canonical_selection)


strat_selection_errorcounts<-new_review %>% 
  group_by(QuestionId, question_category) %>%
  mutate(error_count = case_when(any(error == "none") ~ 0, TRUE ~ max(iteration))) %>%
  ungroup() %>%
  count(QuestionId, question_category, error_count) %>%
  group_by(question_category) %>%
  summarise(average_error = sum(error_count) / n())


strat_error_freq<-ggplot(data=strat_selection_errorcounts, aes(x=average_error, y=question_category)) +
  geom_bar(stat="identity", width=1, color="black", fill= "lightgrey") +
  geom_text(aes(label=round(average_error,2)), size = 6, hjust= "inward")+
  ylab("question category")+
  xlab("average number of errors per question")+
  coord_fixed(0.2)


ggsave(plot = strat_error_freq, paste0("results_temp/strat_error_freq_barplot.pdf"), width = 6, height = 2)



strat_selection_misccounts<-new_review %>% 
  group_by(QuestionId, question_category) %>%
  mutate(misc_count = length(misconception[!is.na(misconception)  & misconception != "none" & misconception != "unclear"])) %>%
  ungroup() %>%
  count(QuestionId, question_category, misc_count) %>%
  group_by(question_category) %>%
  summarise(average_misc = sum(misc_count) / n())


strat_misc_freq<-ggplot(data=strat_selection_misccounts, aes(x=average_misc, y=question_category)) +
  geom_bar(stat="identity", width=1, color="black", fill= "lightgrey") +
  geom_text(aes(label=round(average_misc,2)), size = 6, hjust= "inward")+
  ylab("question category")+
  xlab("average number of misconceptions per question")+
  coord_fixed(0.2)


ggsave(plot = strat_misc_freq, paste0("results_temp/strat_misc_freq_barplot.pdf"), width = 6, height = 2)

