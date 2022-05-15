with sufficientBackgroundUsers as (
select distinct OwnerUserId from UserBackgroundTags
where 
(TagName like 'c#' or 
TagName like 'java' or 
TagName like 'javascript' or 
TagName like 'python' or 
TagName like 'android' or 
TagName like 'jquery' or 
TagName like 'php' or 
TagName like 'c++')
group by 
OwnerUserId, TagName
having count(*) >19
),
postCounter as (
select distinct OwnerUserId,  count(distinct Id) as backgroundPostCount from UserBackgroundTags
group by  OwnerUserId
),

cSharpBackgroundUsers as (
select OwnerUserId, count(*) as cSharpPosts from UserBackgroundTags
where TagName like 'c#'
group by OwnerUserId having count(*) >19),

javaBackgroundUsers as (
select OwnerUserId, count(*) as javaPosts from UserBackgroundTags
where TagName like 'java'
group by OwnerUserId having count(*) >19),

javascriptBackgroundUsers as (
select OwnerUserId, count(*) as javascriptPosts from UserBackgroundTags
where TagName like 'javascript'
group by OwnerUserId having count(*) >19),

pythonBackgroundUsers as (
select OwnerUserId, count(*) as pythonPosts from UserBackgroundTags
where TagName like 'python'
group by OwnerUserId having count(*) >19),

androidBackgroundUsers as (
select OwnerUserId, count(*) as androidPosts from UserBackgroundTags
where TagName like 'android'
group by OwnerUserId having count(*) >19),

jqueryBackgroundUsers as (
select OwnerUserId, count(*) as jqueryPosts from UserBackgroundTags
where TagName like 'jquery'
group by OwnerUserId having count(*) >19),

phpBackgroundUsers as (
select OwnerUserId, count(*) as phpPosts from UserBackgroundTags
where TagName like 'php'
group by OwnerUserId having count(*) >19),

cppBackgroundUsers as (
select OwnerUserId, count(*) as cppPosts from UserBackgroundTags
where TagName like 'c++'
group by OwnerUserId having count(*) >19)



select sufficientBackgroundUsers.OwnerUserId, backgroundPostCount, cSharpPosts, javaPosts, javascriptPosts, pythonPosts, androidPosts, jqueryPosts, phpPosts, cppPosts
from sufficientBackgroundUsers 
left join postCounter on postCounter.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join cSharpBackgroundUsers on cSharpBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join javaBackgroundUsers on javaBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join javascriptBackgroundUsers on javascriptBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join pythonBackgroundUsers on pythonBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join androidBackgroundUsers on androidBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join jqueryBackgroundUsers on jqueryBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join phpBackgroundUsers on phpBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId
left join cppBackgroundUsers on cppBackgroundUsers.OwnerUserId = sufficientBackgroundUsers.OwnerUserId