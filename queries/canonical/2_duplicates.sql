create or alter procedure getDuplicates
@canonicalID1 int, @canonicalID2 int = NULL, @canonicalID3 int = NULL, @canonicalID4 int = NULL
as
select PostId, ViewCount, RelatedPostId, title
from PostLinks
left join Posts on PostLinks.PostId = Posts.Id
where 
LinkTypeId = 3 and 
RelatedPostId in (@canonicalID1, @canonicalID2, @canonicalID3, @canonicalID4) and
tags like '%<sql>%'
order by ViewCount DESC;
go



--declare @canonicalID1 int
--set @canonicalID1 = 11321491
--exec getDuplicates @canonicalID1
--go


-- revised
declare @canonicalID1 int, @canonicalID2 int, @canonicalID3 int, @canonicalID4 int
set @canonicalID1 = 451415 set @canonicalID2 = 194852 set @canonicalID3 = 4686543 set @canonicalID4 = 276927
exec getDuplicates @canonicalID1, @canonicalID2, @canonicalID3, @canonicalID4
go

-- revised
declare @canonicalID1 int, @canonicalID2 int, @canonicalID3 int
set @canonicalID1 = 7745609 set @canonicalID2 = 121387 set @canonicalID3 = 2000908
exec getDuplicates @canonicalID1, @canonicalID2, @canonicalID3
go

-- revised
declare @canonicalID1 int, @canonicalID2 int, @canonicalID3 int, @canonicalID4 int
set @canonicalID1 = 7674786 set @canonicalID2 = 10404348 set @canonicalID3 = 15745042 set @canonicalID4 = 12004603
exec getDuplicates @canonicalID1, @canonicalID2, @canonicalID3, @canonicalID4
go

--declare @canonicalID1 int, @canonicalID2 int
--set @canonicalID1 = 1313120 set @canonicalID2 = 3800551
--exec getDuplicates @canonicalID1, @canonicalID2
--go

--declare @canonicalID1 int
--set @canonicalID1 = 1520608
--exec getDuplicates @canonicalID1
--go

-- removed old dupe7
-- declare @canonicalID1 int
-- set @canonicalID1 = 194852
-- exec getDuplicates @canonicalID1
-- go

--declare @canonicalID1 int
--set @canonicalID1 = 337704
--exec getDuplicates @canonicalID1
--go

--declare @canonicalID1 int
--set @canonicalID1 = 2446764
--exec getDuplicates @canonicalID1
--go

--declare @canonicalID1 int
--set @canonicalID1 = 470542
--exec getDuplicates @canonicalID1
--go

-- new
declare @canonicalID1 int
set @canonicalID1 = 2129693
exec getDuplicates @canonicalID1
go