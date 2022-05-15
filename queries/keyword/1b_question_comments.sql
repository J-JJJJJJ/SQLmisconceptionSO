-- question comments
drop table dbo.QuestionAskerComments;
select questions.Id, count(*) as questionAskerCommentCount
into dbo.QuestionAskerComments
from Posts as questions
left join Comments on Comments.PostId = questions.Id
where
questions.Tags like '%<sql>%' and
questions.PostTypeId = 1 and
Comments.UserId = questions.OwnerUserId
group by questions.Id;


