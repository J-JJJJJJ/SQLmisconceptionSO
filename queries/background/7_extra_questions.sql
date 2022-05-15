-- manual selection after pre-review
-- comment out line to select questions per background


/*

select * from SQLquestionsByNewSQLusers q1
where OwnerUserId in (193605, 3736649, 290082, 1226652, 420667, 12108254, 5098454, 146694, 715540, 3573539, 1149595, 184093, 7635909, 268236, 10156802, 3448806, 1745385) and  -- csharp users
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId);



select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (8535087, 5735244, 1501234, 276101, 2485799, 1216775, 428916, 1111130, 3288493, 168233, 2787184, 3667943, 21348, 1673861, 3530799,   -- java users
434089, 184730, 323221, 1394981, 1145674, 1906076, 1601336, 3725998, 10319470, 342518, 1650200, 228689, 
2895833, 896588, 750565, 2270076, 1489095, 10234240, 801919, 2274782, 3811108, 1501457) and  -- java users --485978 not queried because 40 reached
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId))
or (Id = 5466102 or Id = 5466901 or Id = 32049782);

select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (6554967, 2710606, 3511012, 2910721, 1166137, 484780, 5549354, 752288, 3929933, 4694781, 1154350, 2688204, 219609, 1318115, 1088313, 4682815, 815295, 1397051, 5523066, 6216235, 3650835, 2232273, 9119186, 1028039, 5383767, 7746263, 763600, 1143917, 1146022, 1298297, 3007294, 223863, 5095128) and  -- javascript users
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId))
or (Id = 8053535 or Id = 8083846 or Id = 5742361);



select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (863713, 7212929, 9885747, 6723642, 3594588, 2178164, 1397625, 7375754, 1807557, 3511819, 4502075, 730265, 50065, 6150310, 2817602, 11579387, 6108366, 173292, 7587176, 4301459, 486262, 10419791, 6619447, 2569042, 2988464, 3451339, 2886575, 3664123, 7908852, 2535611, 10938315, 2329714, 448496, 6753906, 4258834, 2788600, 4414359) and  -- python users 
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId))
or (Id = 40791452);



select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (1078678, 1709964, 1544001, 1766890, 5753091, 1174869, 1003363, 2781852, 1641552, 2186744, 1318162, 7803448, 3554485, 1760858, 3253896, 397991, 1185254, 661078, 2047987, 908425, 4660161, 874927, 2532674, 1468449, 1230884) and  -- android users
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId))
or (Id = 12327129);


select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (1143917, 3117628, 4288993, 1401620, 352150, 2872191, 978733, 3007294, 666487, 1298342, 1144916, 423316, 1738522, 5383767, 552669, 1088244, 4782067, 1499781, 672147, 4274475, 337522, 4703663) and  -- jquery users
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId))
or (Id = 13732983);


select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (1251684, 457348, 197606, 1215460, 3013861, 718990, 978733, 241654, 133418, 489046, 121626, 4782067, 2794221, 609630, 4682815, 984415, 562697, 752603, 233615, 19929, 255439, 987864, 1775598) and  -- php users
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId));

select * from SQLquestionsByNewSQLusers q1
where (OwnerUserId in (472245, 43756, 852063, 846550, 185235, 321866, 1553886, 350810, 3900951, 1798187, 99213, 613021, 1153165, 695652, 774236, 182959, 458742, 2331592, 8368, 2411320, 130442) and  -- c++ users
CreationDate = (select min(CreationDate) from SQLquestionsByNewSQLusers q2 where q1.OwnerUserId = q2.OwnerUserId));

*/



