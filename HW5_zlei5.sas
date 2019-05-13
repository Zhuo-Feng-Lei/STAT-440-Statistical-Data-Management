libname hw5 "/home/zlei50/STAT 440";

title "Problem 1a";
proc sql;
	describe table hw5.employee_roster;
quit;

title "Problem 1b";
proc sql;
	create table top_earners_zlei5 as
	select *
	from hw5.employee_roster (rename=(Job_Title=Position Salary=Yearly_Salary))
	where Yearly_Salary >70000;
quit;

title "Problem 1c";
proc sql;
	select Employee_Name, Position, Yearly_Salary format=dollar16.2
	from top_earners_zlei5;
quit;

title "Problem 1d";
proc sql;
	select Employee_Name, Employee_Gender, Section, Salary format=dollar16.2
	from hw5.employee_roster
	where Employee_Gender = "M" and Section="Administration" and 25000<=Salary<=30000;
run;

title "Problem 1e";
proc sql;
	select Employee_Name, Employee_ID, Org_Group
	from hw5.employee_roster
	where Employee_Name like "C%" or Employee_Name like "D%" or Employee_Name like "E%"
	order by Employee_Name desc;
quit;

title "Problem 1f";
proc sql;
	select Employee_Gender,mean(Salary) format=dollar16.2 as Average_Salary, median(Salary) format=dollar16.2 as Median_Salary 
	from hw5.employee_roster
	group by Employee_Gender;
quit;

title "Problem 2a";
proc sql;
	describe table hw5.batting;
quit;

title "Problem 2b";
proc sql;
	select PlayerID, YearID, TeamID, H as Hits
	from hw5.batting
	where H>=245;
run;

title "Problem 2c";
proc sql;
	select LgID, min(YearID) as Minimum_Year, max(YearID) as Maximum_Year
	from hw5.batting
	group by LgID;
run;

title "Problem 2d";
proc sql;
	select PlayerID, YearID, max(HR) as HR
	from hw5.batting
	where HR>=50
	group by YearID
	order by YearID asc;
run;