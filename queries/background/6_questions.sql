select * from SQLquestionsByNewSQLusers as q1
where OwnerUserId in (select column1 from BackgroundUsersSelected) and
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers as q2 where q1.OwnerUserId = q2.OwnerUserId);