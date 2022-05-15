-- adapted from https://meta.stackexchange.com/a/293208
With PostTags as (SELECT
  Id,
  value TagName
FROM
  SQLquestions 
  CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(Tags,'><',','),'<',''),'>',''),',')
  )

  select top 500 count(Id) frequency, TagName, '1' as excludeTag from PostTags 
  where TagName not like '%sql%'
  group by TagName order by count(*) DESC