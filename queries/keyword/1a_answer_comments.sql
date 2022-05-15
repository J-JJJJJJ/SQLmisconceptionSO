-- answer comments
drop table dbo.AnswerAskerComments;
select questions.Id, count(*) as answerAskerCommentCount
into dbo.AnswerAskerComments
from Posts as questions
left join Posts as answers on answers.ParentId = questions.Id
left join Comments on Comments.PostId = answers.Id
where
questions.Tags like '%<sql>%' and
questions.PostTypeId = 1 and
answers.PostTypeId = 2 and
Comments.UserId = questions.OwnerUserId
group by questions.Id
;


