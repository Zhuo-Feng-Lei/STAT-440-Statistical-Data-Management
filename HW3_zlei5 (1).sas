libname hw3 "/home/zlei50/STAT 440";

title "Problem 1a";
/* User defined format for AUaids dataset */
proc format;
	value $statefmt "NSW" = "New South Wales"
					"VIC" = "Victoria"
					"QLD" = "Queensland"
					other = "Other";
	value $sexfmt "M" = "Male"
			   "F" = "Female";
	value $statusfmt "D" = "Dead"
				  "A" = "Alive";
run;
	
title "Problem 1b";
/*Reading in data with user-defined formats and labels */
data AUaids_zlei5;
	infile "/home/zlei50/STAT 440/AUaids.dat" dlm=" ";
	input  ID State $ Sex $ Date_D Date_E Status $ Transmission $ Age_D;
	label ID = "Observation*Number"
		  State = "State*of*Origin"
		  Date_D = "Date*of*Diagnois"
		  Date_E = "Date*of*Death/End"
		  Age_D = "Age*of*Diagnosis";
	format State $statefmt.
		   Sex $sexfmt.
		   Status $statusfmt.
		   Date_D Date_E mmddyy8.;
run;

title "Problem 1c";
proc print data = AUaids_zlei5 (obs=10) noobs;
	var State Sex Date_D Date_E Status Transmission Age_D;
	where State = "VIC";
run;

title "Problem 1d";
data hw3.under25_zlei5;
	infile "/home/zlei50/STAT 440/AUaids.dat" dlm=" ";
	input  ID State $ Sex $ Date_D Date_E Status $ Transmission $ Age_D;
	if Sex = "F" or Age_D>24 or Transmission ^= "hsid" then	
		delete;
	label ID = "Observation*Number"
		  State = "State*of*Origin"
		  Date_D = "Date*of*Diagnois"
		  Date_E = "Date*of*Death/End"
		  Age_D = "Age*of*Diagnosis";
	format State $statefmt.
		   Sex $sexfmt.
		   Status $statusfmt.
		   Date_D Date_E mmddyy8.;
run;

title "Problem 1e";
proc print data = hw3.under25_zlei5 noobs split="*";
	var State Sex Date_D Date_E Status Transmission Age_D;
run;

title "Problem 2a";
data rushing_zlei5;
	infile "/home/zlei50/STAT 440/nflrush.dat";
	input +117 Season 6.
		  @13 Player $25.
		  @43 Team $3.
		  @70 Yds comma6.
		  @79 Avg 5.
		  @97 Lg 3.
		  @105 TD 2.
		  @113 FD 2.;
	label Yds = "Number*of*Rushing*Yards"
		  Avg = "Avg*Rushing*Yards*Per*Game"
		  Lg = "Longest*Rushing*Attempt"
		  TD = "Number*of*Touchdowns"
		  FD = "Rushing*First-Downs";
run;

title "Problem 2b";
proc contents data = rushing_zlei5;
run;

title "Problem 2c";
proc sort data = rushing_zlei5 out=results;
	by descending TD;
	where Season between 2013 and 2015;
run;

proc print data = results (obs=10) noobs split="*";
	var Player TD Season;
run;

title "Problem 2d";
data localnfl_zlei5;
	infile "/home/zlei50/STAT 440/nflrush_quotes.dat" dsd;
	input @39 Team $3. @;
	if Team in ("Stl","Chi","Ind","GB") then
		input @1 Season 4.
			  @12 Player $25.
			  @66 Yds comma6.
			  @75 Avg 5.
			  @93 Lg 3.
			  @102 TD 2.
			  @109 FD 2.;
	else delete;
	label Yds = "Num*of*Rushing*Yards"
		  Avg = "Avg*Rushing*Yards*Per*Game"
		  Lg = "Longest*Rushing*Attempt"
		  TD = "Num*Touchdowns"
		  FD = "Rushing*First-Downs";
run;

title "Problem 2e";
proc contents data = localnfl_zlei5;

title "Problem 2f";
proc sort data = localnfl_zlei5 out=results2;
	by descending Yds;
run;

proc print data = results2 (obs=10) noobs split="*";
	var Player Team Yds Season;
run;

title "Problem 3a";
data hw3.low_earners4_zlei5;
	length ID 6 Name $ 25 Country $ 2 Company $ 25 Department $ 25 Section $ 25 Org $ 25 Job $ 25;
	infile "/home/zlei50/STAT 440/employee_roster4.dat" delimiter= "**" missover;
	input ID Name $ Country $ / Company $ Department $ Section $ Org $ Job $ Gender $ / Salary : dollar12. Birth Hire Termination;
	format Salary dollar12.2 Birth mmddyy10. Hire mmddyy10. Termination mmddyy10.;
	if Company =: "Orion" and Department =: "Sales" and Salary < 24000;
	label Org = "Organization*Group"
		  Job = "Job*Title"
		  Birth = "Birth*Date"
		  Hire = "Date*Hired"
		  Termination = "Date*Terminated";
run;

title "Problem 3b";
proc contents data = hw3.low_earners4_zlei5;
run;

title "Problem 3c";
proc print data = hw3.low_earners4_zlei5 noobs split="*";
	var Name Gender Department Job Salary;
run;