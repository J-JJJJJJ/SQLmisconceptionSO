
-- report statistics
-- number of SQL questions with the right tag
select count(*) from SQLquestions;
-- number of SQL questions with the right tag and asked within 8 months of the asker's first [sql] post
select count(*) from SQLquestionsByNewSQLusers;

drop table UserBackgroundTags;
With AnswerBackgroundTags as
(SELECT
  OwnerUserId,
  value TagName,
  'A' as postType,
  Id
FROM
  AnswersBySQLusers 
  CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(QuestionTags,'><',','),'<',''),'>',''),',')
  where OwnerUserId <> 0
  ),
  QuestionBackgroundTags as
(SELECT
  OwnerUserId,
  value TagName,
  'Q' as postType,
  Id
FROM
  QuestionsBySQLusers 
  CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(Tags,'><',','),'<',''),'>',''),',')
  where OwnerUserId <> 0
  )

  
  select * into UserBackgroundTags from (
  select * from AnswerBackgroundTags union all select * from QuestionBackgroundTags
  )
  as tmp;


  -- We export the UserBackgroundTags as CSV (user_background.csv) for processing in R
  select  OwnerUserId, TagName, postType from UserBackgroundTags;

  -- report statistics
-- number of background posts to consider
select count(*) from UserBackgroundTags;