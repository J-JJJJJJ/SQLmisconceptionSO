-- 3a create views
-- strict tag-based filtered SQL questions in 8 month new user period
-- the table 'SQLquestions' was created by filtering by tags in 1_add_sql_to_table.sql
Create or alter view [FilteredSQLquestionsUsersNewToSQL] as 
select * from SQLquestions 
left join SQLcutoffUsers on SQLquestions.OwnerUserId = SQLcutoffUsers.UserId
where SQLquestions.CreationDate < SQLcutoffUsers.CutoffSQLdate;
go

-- all questions by SQL askers before the cutoff date
Create or alter view [QuestionsBySQLaskers] as
select * from Posts 
inner join SQLcutoffUsers on Posts.OwnerUserId = SQLcutoffUsers.UserId
where
SQLcutoffUsers.firstSQLpostDate > Posts.CreationDate
 and PostTypeId = 1
 and Posts.OwnerUserId in (select distinct OwnerUserId from SQLquestionsByNewSQLusers);
go

-- all answers by SQL askers before the cutoff date
Create or alter view [AnswersBySQLaskers] as
select * from Posts 
inner join SQLcutoffUsers on Posts.OwnerUserId = SQLcutoffUsers.UserId
where
SQLcutoffUsers.firstSQLpostDate > Posts.CreationDate
and PostTypeId = 2
and Posts.OwnerUserId in (select distinct OwnerUserId from SQLquestionsByNewSQLusers);
go

-- 3 sql questions within 8 months
-- create table of SQL questions within 8 months
drop table SQLquestionsByNewSQLusers;
select * 
into dbo.SQLquestionsByNewSQLusers
from FilteredSQLquestionsUsersNewToSQL;
-- 3questions
-- create table of prior non-SQL questions by SQL users before cutoff date
drop table QuestionsBySQLusers;
select * 
into dbo.QuestionsBySQLusers
from QuestionsBySQLaskers
where QuestionsBySQLaskers.Tags not like '%<sql>%';

-- 3answers
-- create table of prior non-SQL answers by SQL users before cutoff date
drop table AnswersBySQLusers;
select AnswersBySQLaskers.*,  Posts.Tags as QuestionTags
into dbo.AnswersBySQLusers
from AnswersBySQLaskers
left join Posts on Posts.Id = AnswersBySQLaskers.ParentId
where Posts.Tags not like '%<sql>%';

-- 3 sql questions within 8 months
-- create table of SQL questions within 8 months
drop table SQLquestionsByNewSQLusers;
select * 
into dbo.SQLquestionsByNewSQLusers
from FilteredSQLquestionsUsersNewToSQL;


