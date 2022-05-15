-- step 2a in the filter process
-- select all SQL questions and their answers (regardless of strict tag-based filtering)
Create or alter view [SQLposts] as
select OwnerUserId, CreationDate from Posts where
(PostTypeId = 1 and Tags like '%<sql>%') or
(PostTypeId = 2 and ParentId in (select Id from Posts where PostTypeId = 1 and Tags like '%<sql>%'));
go 

-- step 2b in the filter process
-- compute cutoff post date for users
Create or alter view [SQLcutoffUsers] as 
	with SQLaskers as (
  select distinct OwnerUserId as UserId
  from SQLquestions)

select UserId, min(CreationDate) as firstSQLpostDate, dateadd(MONTH, 8, min(CreationDate)) as CutoffSQLdate
from SQLaskers 
left join SQLposts
on OwnerUserId = UserId
group by UserId;
go
