select RelatedPostId as [canonical Id], count(*) as [duplicate count],  min(canonical.Title) as title, min(canonical.viewcount) as [views]
  from PostLinks
  left join posts as duplicates on PostLinks.PostId = duplicates.Id
  left join posts as canonical on PostLinks.RelatedPostId = canonical.Id
  where PostLinks.LinkTypeId = 3 and duplicates.Tags like '%<sql>%' and canonical.Tags like '%<sql>%'
  group by PostLinks.RelatedPostId
  having count(*) >= 15
  order by count(*) DESC;
 

