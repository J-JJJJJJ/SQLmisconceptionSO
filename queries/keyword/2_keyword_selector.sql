create or alter procedure getKeywordQ
@Qkeyword1 varchar(100) = NULL, @Qkeyword2 varchar(100) = NULL, @Qkeyword3 varchar(100) = NULL, @Qkeyword4 varchar(100) = NULL, @Qkeyword5 varchar(100) = NULL
as
select top 300 questions.Id, questions.title, answerComments.answerAskerCommentCount + questionComments.questionAskerCommentCount as askerComments, questions.ViewCount
from Posts as questions
left join AnswerAskerComments as answerComments on answerComments.Id = questions.Id
left join QuestionAskerComments as questionComments on questionComments.Id = questions.Id
where 
(
questions.Body like '%' +@Qkeyword1 +'%' or
questions.Body like '%' +@Qkeyword2 +'%' or
questions.Body like '%' +@Qkeyword3 +'%' or
questions.Body like '%' +@Qkeyword4 +'%' or
questions.Body like '%' +@Qkeyword5 +'%'
) and
questions.tags like '%<sql>%' and
questions.PostTypeId = 1
order by askerComments DESC, questions.ViewCount DESC;
go

create or alter procedure getKeywordA
@Akeyword1 varchar(100) = NULL, @Akeyword2 varchar(100) = NULL, @Akeyword3 varchar(100) = NULL, @Akeyword4 varchar(100) = NULL, @Akeyword5 varchar(100) = NULL
as
select top 300 questions.Id, questions.title, answerComments.answerAskerCommentCount + questionComments.questionAskerCommentCount as askerComments, questions.ViewCount
from Posts as questions
left join AnswerAskerComments as answerComments on answerComments.Id = questions.Id
left join QuestionAskerComments as questionComments on questionComments.Id = questions.Id
left join Posts as answers on answers.ParentId = questions.Id
where 
(
answers.Body like '%' +@Akeyword1 +'%' or
answers.Body like '%' +@Akeyword2 +'%' or
answers.Body like '%' +@Akeyword3 +'%' or
answers.Body like '%' +@Akeyword4 +'%' or
answers.Body like '%' +@Akeyword5 +'%' 
) and
questions.tags like '%<sql>%' and
questions.PostTypeId = 1 and
answers.PostTypeId = 2
order by askerComments DESC, questions.ViewCount DESC;
go



--declare @Akeyword1 varchar(100);
--set @Akeyword1 = 'misconception';
--exec getKeywordA @Akeyword1;
--go

--declare @Akeyword1 varchar(100), @Akeyword2 varchar(100);
--set @Akeyword1 = 'legal' set @Akeyword2 = 'allowed';
--exec getKeywordA @Akeyword1, @Akeyword2;
--go


--declare @Akeyword1 varchar(100), @Akeyword2 varchar(100), @Akeyword3 varchar(100), @Akeyword4 varchar(100), @Akeyword5 varchar(100);
--set @Akeyword1 = 'unnecessary' set @Akeyword2 = 'not necessary' set @Akeyword3 = 'not needed' set @Akeyword4 = 'not required' set @Akeyword5 = 'redundant';
--exec getKeywordA @Akeyword1, @Akeyword2,  @Akeyword3, @Akeyword4,  @Akeyword5;
--go

--declare @Akeyword1 varchar(100), @Akeyword2 varchar(100), @Akeyword3 varchar(100), @Akeyword4 varchar(100)
--set @Akeyword1 = 'wrong pespective' set @Akeyword2 = 'incorrect perspective' set @Akeyword3 = 'incorrect approach' set @Akeyword4 = 'wrong approach';
--exec getKeywordA @Akeyword1, @Akeyword2,  @Akeyword3, @Akeyword4;
--go

--declare @Akeyword1 varchar(100);
--set @Akeyword1 = 'inconsisten';
--exec getKeywordA @Akeyword1;
--go

-- 6
--select top 300 questions.Id, questions.title, answerComments.answerAskerCommentCount + questionComments.questionAskerCommentCount as askerComments, questions.ViewCount
--from Posts as questions
--left join AnswerAskerComments as answerComments on answerComments.Id = questions.Id
--left join QuestionAskerComments as questionComments on questionComments.Id = questions.Id
--where 
--(
--questions.Body like N'%==%' or
--questions.Body like N'%≠%' or
--( questions.Body like '%is not%' and
--questions.Body not like '%is not null%'
--)) and
--questions.tags like '%<sql>%' and
--questions.PostTypeId = 1
--order by askerComments DESC, questions.ViewCount DESC;
--go



----7
--declare @Qkeyword1 varchar(100), @Qkeyword2 varchar(100), @Qkeyword3 varchar(100), @Qkeyword4 varchar(100), @Qkeyword5 varchar(100), @Qforbidden varchar(100);
--set @Qkeyword1 = 'sort by' set @Qkeyword2 = 'arrange by' set @Qkeyword3 = 'categorize by' set @Qkeyword4 = 'categorise by' set @Qkeyword5 = 'assort by' set @Qforbidden = 'order by';
--exec getKeywordQ @Qkeyword1, @Qkeyword2, @Qkeyword3, @Qkeyword4, @Qkeyword5, @Qforbidden;
--go

--select top 300 questions.Id, questions.title, answerComments.answerAskerCommentCount + questionComments.questionAskerCommentCount as askerComments, questions.ViewCount
--from Posts as questions
--left join AnswerAskerComments as answerComments on answerComments.Id = questions.Id
--left join QuestionAskerComments as questionComments on questionComments.Id = questions.Id
--where 
--(
--questions.Body like '%sort by%' or
--questions.Body like '%arrange by%' or
--questions.Body like '%categorize by%' or
--questions.Body like '%categorise by%' or
--questions.Body like '%assort by%'
--) and
--questions.Body not like '%order by%' and
--questions.tags like '%<sql>%' and
--questions.PostTypeId = 1
--order by askerComments DESC, questions.ViewCount DESC;
--go


----8
--select top 300 questions.Id, questions.title, answerComments.answerAskerCommentCount + questionComments.questionAskerCommentCount as askerComments, questions.ViewCount
--from Posts as questions
--left join AnswerAskerComments as answerComments on answerComments.Id = questions.Id
--left join QuestionAskerComments as questionComments on questionComments.Id = questions.Id
--where 

--questions.Body like '%group by [^ ]%' and
--questions.tags like '%<sql>%' and
--questions.PostTypeId = 1
--order by askerComments DESC, questions.ViewCount DESC;
--go


---- 9 
--select top 300 questions.Id, questions.title, answerComments.answerAskerCommentCount + questionComments.questionAskerCommentCount as askerComments, questions.ViewCount
--from Posts as questions
--left join AnswerAskerComments as answerComments on answerComments.Id = questions.Id
--left join QuestionAskerComments as questionComments on questionComments.Id = questions.Id
--left join Posts as answers on answers.ParentId = questions.Id
--where 
--answers.Body like '%null%' and
--questions.Body like '%not in%' and
--questions.Body not like '%null%' and
--questions.tags like '%<sql>%' and
--questions.PostTypeId = 1 and
--answers.PostTypeId = 2
--order by askerComments DESC, questions.ViewCount DESC;


----10
declare @Qkeyword1 varchar(100), @Qkeyword2 varchar(100), @Qkeyword3 varchar(100);
set @Qkeyword1 = 'AS "' set @Qkeyword2 = 'AS ''' set @Qkeyword3 = 'AS `';
exec getKeywordQ @Qkeyword1, @Qkeyword2, @Qkeyword3;
go