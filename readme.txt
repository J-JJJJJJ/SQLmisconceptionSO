This repository consists of two main parts: the data selection part in the 'queries' folder and the data analysis part in the main folder. The 


## Queries
The file names in the queries folder start with a numerical code to indicate the order of execution. The description below attempts to provide some more guidance. 

The SQL queries use Brent Ozar's 'Large: current 401GB database as of 2021/02' SQL Server snapshot of the Stack Overflow dataset as their starting point. That dataset is available at https://www.brentozar.com/archive/2015/10/how-to-download-the-stack-overflow-database-via-bittorrent/. 

### Background

Step 0 of the user background based question selection focuses on tags. SQL file 0.1 extracts the top 500 tags used on questions with the SQL tag. By manually reviewing the exported results, we indicated which tags should disqualify a question. R file 0.2 reads these top 500 tags after reviewing for exclusion and sorts them by alphabetic order. That sorted file is given in ExcludeTags.csv. The R file also lists the tags which do and do not disqualify a question in excluded_tags.txt and included_tags.txt, respectively. Furthermore, the R file creates a SQL excerpt to filter questions by tag.

Back to the main folder for the user background-based question selection, SQL file 1 filters questions by tag. SQL files 2 and 3 create views for later use. SQL file 4 lists SQL question askers along with the tags of the questions they asked and answered before their first SQL question on the site. The result of SQL file 4 is given in 4a_output_user_background.csv. R file 4b tallies how many tags and how many users will be considered to have a background in these tags given that we require x posts to establish a background. Eventually, we settled on requiring x=20 posts to establish a user's background in that tag. That yielded 8 background tags.

SQL file 5 extracts the users who have sufficient background in these tags. SQL file 5 also provides an overview of all qualifying users and the number of posts in each of the backgrounds. That overview of qualifying users is given in 5a_output_bgposters.csv. R file 5b uses that overview to select the top users in each background and export them to to Tex files in which the pre-review was conducted. 

SQL file 6 extracts the first question asked by qualifying users. SQL file 7 retrieves the first SQL question asked by users who qualify next when previously selected users saw all their questions disqualified during the pre-review stage.  

 


### Canonical
The question selection based on duplicates of canonical question centers around two SQL files.

The first file lists the canonical question ordered by the number of associated duplicate questions. The duplicate questions are selected in the second file.  

The pre-review Excel sheets are provided in the subfolder 'pre-review sheets'.

### Keyword

The keyword selection starts with SQL files 1a and 1b which prepare temporary tables indicating for each SQL question how many comments the asker left on the answers to their question and on their own question, respectively. The second SQL file contains the queries which extract the questions for pre-review.

The pre-review Excel sheets are provided in the subfolder 'pre-review sheets'.

## Data Analysis

full_review.xlsx is the Microsoft Excel sheet in which the review data was recorded.
data_analysis.r uses that data sheet to create certain figures and tables which have been used in the report.