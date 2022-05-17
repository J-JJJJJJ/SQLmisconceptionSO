-- 0.1 get top 500 tags on SQL-tagged Stack Overflow questions 
-- adapted from https://meta.stackexchange.com/a/293208
With SQLtaggedQuestions as
(select * from Posts where Tags like '%<sql>%'),
PostTags as (SELECT
  Id,
  value TagName
FROM
  SQLtaggedQuestions 
  CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(Tags,'><',','),'<',''),'>',''),',')
  )

  select top 500 count(Id) frequency, TagName, '1' as excludeTag from PostTags 
  group by TagName order by count(*) DESC