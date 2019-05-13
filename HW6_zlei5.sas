libname hw6 "/home/zlei50/STAT 440";

title "Problem 1a";
proc sql;
	create table pricing_zlei5 as
	select p.Model,p.Quantity,i.Price,p.Quantity*i.Price as TotalCost format=dollar16.2
	from hw6.purchase as p
	left join
	hw6.inventory as i
	on p.Model = i.Model;
quit;

proc sql;
	select * 
	from pricing_zlei5;
quit;

title "Problem 1b";
proc sql;
	select i.Model,i.Price
	from hw6.purchase as p
	right join
	hw6.inventory as i
	on p.Model = i.Model
	where p.Model is null;
quit;

title "Problem 2a";
proc format;
	value $EDUCAfmt  '1'='No schooling completed, or less than 1 year'
                    '2'='Nursery, kindergarten, and elementary (grades 1-8)'
                    '3'='High school (grades 9-12, no degree)'
                    '4'='High school graduate � high school diploma or the equivalent (GED)'
                    '5'='Some college but no degree'
                    '6'="Associate's degree in college"
                    '7'="Bachelor's degree (BA, AB, BS, etc.)"
                    '8'="Master's professional, or doctorate degree (MA, MS, MBA, MD, JD, PhD, etc.)"
                    " "='Missing'
                    other='Miscoded';
	value $RACEfmt   '1'="White"
                    '2'="Black"
                    '3'="Native American"
                    '4'="Asian"
                    '5'="Pacific Islander"
                    '6'='Multi-race'
                    " "='Missing'
                    other='Miscoded';
   value $REGIONfmt '1'="Northeast"
                    '2'="Midwest"
                    '3'="South"
                    '4'="West"
                    " "='Missing'
                    other='Miscoded';
   value $SEXfmt    '1'="Male"
                    '2'="Female"
                    " "='Missing'
                    other='Miscoded';   
run;

title "Problem 2b";
proc sql;
	create table cesi143_zlei5 as
	select int(f.NEWID/10) as CU_ID format=z7.,mod(f.NEWID,10) as Interview_Num,m.AGE,m.CU_CODE,put(m.EDUCA,$EDUCAfmt.) as EDUCA,m.MARITAL,m.MEMBNO,m.SALARYX,put(m.SEX,$SEXfmt.) as SEX,put(m.MEMBRACE,$RACEfmt.) as MEMBRACE,f.FAM_SIZE,put(f.REGION,$REGIONfmt.) as REGION
	from hw6.memi143 as m
	right join
	hw6.fmli143 as f
	on m.NEWID=f.NEWID;
quit;

title "Problem 2c";
proc sql;
	describe table cesi143_zlei5;
quit;

proc sql;
	select * 
	from cesi143_zlei5
	where monotonic() between 1 and 10;
quit;

title "Problem 2d";
proc sql;
	select REGION, COUNT(distinct CU_ID) 
	from cesi143_zlei5
	group by REGION;
quit;

title "Problem 2e";
proc sql;
	select f.region, Total_CU, Total_Fam_Size, Avg_Fam_Size, Avg_CU
	from (select REGION, count(CU_ID) as Total_CU, (count(CU_ID)/count(distinct CU_ID)) as Avg_CU from cesi143_zlei5 group by REGION) c
	left join 
	(select put(REGION,$REGIONfmt.)as REGION, sum(Fam_Size) as Total_Fam_Size, avg(Fam_Size) as Avg_Fam_Size from hw6.fmli143 group by region) f
	on f.REGION = c.REGION;
quit;

title "Problem 2f";
proc sql;
	select c1.MEMBRACE, SUBTOTAL/TOTAL as Percentage format=percent12.4
	from (select distinct MEMBRACE, COUNT(MEMBRACE) as TOTAL from cesi143_zlei5) c
	left join
	(select MEMBRACE, count(MEMBRACE) as SUBTOTAL from cesi143_zlei5 group by MEMBRACE) c1
	on c.MEMBRACE=c1.MEMBRACE;
quit;

title "Problem 2g";
proc sql;
	select EDUCA, count(EDUCA) as Number_Members, avg(SALARYX) as avg_salary format=dollar16.2
	from cesi143_zlei5
	where EDUCA ne "Missing"
	group by EDUCA;
quit;