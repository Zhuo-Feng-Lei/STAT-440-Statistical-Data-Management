libname hw2 "/home/zlei50/STAT 440";
/* Loading in data */
data fmli143;
	set hw2.fmli143;
run;

data memi143;
	set hw2.memi143;
run;

title "Excerise 1a fmli143 data";
/* Viewing descriptor portion of fmli143 dataset */
proc contents data=fmli143;
run;

title "Excerise 1a memi143 data";
/* Viewing descriptor portion of memi143 dataset */
proc contents data=memi143;
run;

title "Excerise 1b fmli143 data";
/* Format for fmli143 */
proc format;
	value $educationfmt "00" = "Never attended school"
	 					"10" = "First through eighth grade"
	 					"11" = "Ninth through twelfth grade (no H.S. diploma)"
	 					"12" = "High school graduate"
	 					"13" = "Some college, less than college graduate"
	 					"14" = "Associate’s degree (occupational/vocational or academic)"
	 					"15" = "Bachelor’s degree"
	 					"16" = "Master’s degree, (professional/Doctorate degree)*";
	value $inclassfmt "01" = "Less than $5,000"
					  "02" = "$5,000 to $9,999"
					  "03" = "$10,000 to $14,999"
					  "04" = "$15,000 to $19,999"
					  "05" = "$20,000 to $29,999"
					  "06" = "$30,000 to $39,999"
					  "07" = "$40,000 to $49,999"
					  "08" = "$50,000 to $69,999"
					  "09" = "$70,000 and over";
	value $inclass2fmt "1" = "Less than 0.1667"
					   "2" = "0.1667 – 0.3333"
					   "3" = "0.3334 – 0.4999"
					   "4" = "0.5000 – 0.6666"
					   "5" = "0.6667 – 0.8333"
					   "6" = "0.8334 – 1.0000";
	value $marital1fmt  "1" = "Married"
					   "2" = "Widowed"
					   "3" = "Divorced"
					   "4" = "Separated"
					   "5" = "Never married";
	value $racefmt "1" = "White"
				   "2" = "Black"
				   "3" = "Native American"
				   "4" = "Asian"
				   "5" = "Pacific Islander"
				   "6" = "Multi-race";
	value $regionfmt "1" = "Northeast"
					 "2" = "Midwest"
					 "3" = "South"
					 "4" = "West";
	value $sexfmt "1" = "Male"
 				  "2" = "Female";
 	value $statefmt "01" = "Alabama"
				 	"29" = "Missouri"
					"02" = "Alaska" 
					"30" = "Montana"
					"04" = "Arizona" 
					"31" = "Nebraska"
					"05" = "Arkansas"
					"32" = "Nevada"
					"06" = "California" 
					"33" = "New Hampshire"
					"08" = "Colorado"
					"34" = "New Jersey"
					"09" = "Connecticut"
					"36" = "New York"
					"10" = "Delaware" 
					"37" = "North Carolina"
					"11" = "District of Columbia" 
					"39" = "Ohio"
					"12" = "Florida"
					"40" = "Oklahoma"
					"13" = "Georgia 41 Oregon"
					"15" = "Hawaii"
					"42" = "Pennsylvania"
					"16" = "Idaho" 
					"44" = "Rhode Island"
					"17" = "Illinois" 
					"45" = "South Carolina"
					"18" = "Indiana"
					"46" = "South Dakota"
					"20" = "Kansas"
					"47" = "Tennessee"
					"21" = "Kentucky"
					"48" = "Texas"
					"22" = "Louisiana"
					"49" = "Utah"
					"23" = "Maine"
					"51" = "Virginia"
					"24" = "Maryland" 
					"53" = "Washington"
					"25" = "Massachuse";
	value $urbanfmt "1" = "Urban"
 					"2" = "Rural";
run;

/* New fmli143 dataset */
data fmli143_zlei5;
	set fmli143;
	label AGE_REF = "AGE*(REFERENCE PERSON)"
		  AGE2 = "AGE*(SPOUSE)"
		  BATHROOMQ = "NUM*BATHROOMS"
		  BEDROOMQ = "NUM*BEDROOMS"
		  EDUC_REF = "EDUCATION*(REFERENCE PERSON)"
		  EDUC2 = "EDUCATION*(SPOUSE)"
		  FINCATAX = "CU INCOME*AFTER TAX*(PAST 12 MONTHS)"
		  FINCBTAX = "CU INCOME*BEFORE TAX"
		  HH_CU_Q = "NUM OF CONSUMERS*IN HOUSEHOLD"
		  HLFBATHQ = "NUM*HALF BATHROOMS"
		  INCLASS = "INCOME*CLASS*BEFORE TAX"
		  INCLASS2 = "INCOME*CLASS*BASED ON*INCOME RANK"
		  INTERI = "INTERVIEW*NUM"
		  MARTIAL1 = "MARITAL STATUS*(REFERENCE PERSON)"
		  NO_EARNR = "NUM*EARNERS"
		  QINTRVMO = "Interview*Month"
		  QINTRVYR = "Interview*Year"
		  REF_RACE = "RACE*(REFERENCE PERSON)"
		  RACE2 = "RACE*(SPOUSE)"
		  SEX_REF = "SEX*(REFERENCE PERSON)"
		  SEX2 = "SEX*(SPOUSE)"
		  MARITAL1 = "MARITAL*STATUS";
	format EDUC_REF EDUCA2 $educationfmt.
		   INCLASS $inclassfmt.
		   INCLASS2 $inclass2fmt.
		   MARITAL1 $marital1fmt.
		   REF_RACE RACE2 $racefmt.
		   REGION $regionfmt.
		   SEX_REF SEX2 $sexfmt.
		   STATE $statefmt.
		   BLS_URBN $urbanfmt.;
run;

/* FORMAT FOR MEMI143 */
proc format;
	value $cucodefmt "1" = "Reference person"
					 "2" = "Spouse"
					 "3" = "Child or adopted child"
					 "4" = "Grandchild"
				     "5" = "In-law"
					 "6" = "Brother or sister"
					 "7" = "Mother or father"
					 "8" = "Other related person"
					 "9" = "Unrelated person"
				     "0" = "Unmarried Partner";
	value $memieducationfmt "1" = "No schooling completed, or less than 1 year"
						    "2" = "Nursery, kindergarten, and elementary (grades 1-8)"
						    "3" = "High school (grades 9-12, no degree)"
						    "4" = "High school graduate – high school diploma or the equivalent (GED)"
						    "5" = "Some college but no degree"
						    "6" = "Associate’s degree in college"
						    "7" = "Bachelor’s degree (BA, AB, BS, etc.)"
						    "8" = "Master’s professional, or doctorate degree (MA, MS, MBA, MD, JD, PhD, etc.)";
	value $maritalfmt "1" = "Married"
					  "2" = "Widowed"
					  "3" = "Divorced"
					  "4" = "Separated"
					  "5" = "Never married";
run;

title "Excerise 1b memi143 data";
/* New memi143 dataset */
data memi143_zlei5;
	set memi143;
	label CU_CODE = "RELATIONSHIP*TO*REFERENCE*PERSON"
	      EDUCA = "EDUCATION"
	      MEMBNO = "MEMBER*NUM"
	      MEMBRACE = "MEMBER'S*RACE"
	      SALARYX = "SALARY*BEFORE*DEDUCTIONS*(PAST 12 MONTHS)";
	format CU_CODE $cucodefmt.
		   EDUCA $memieducationfmt.
		   MARITAL $maritalfmt.
		   MEMBRACE $racefmt.
		   SEX $sexfmt.;
run;

/*Printing out descriptor portion for both new datasets */
proc contents data=fmli143_zlei5;
run;

proc contents data = memi143_zlei5;
run;

title "Excerise 1c fmli143_zlei5 data";
proc print data=fmli143_zlei5 (obs=10) split="*";
	var NEWID CUID AGE_REF BLS_URBN MARITAL1 FINCATAX;
run;

title "Excerise 1c memi143_zlei5 data";
proc print data=memi143_zlei5 (obs=10) split="*";
	var NEWID CU_CODE MARITAL SALARYX;
run;

title "Excerise 1d";
/*New format for SALARYX*/
proc format;
	value salaryfmt low-<12000 = "Impoverished"
					40000-<80000 = "Middle Class"
					80000-<140000 = "Upper Middle Class"
					140000<-high = "Upper Class"
					other = "Lower Class"
					. = "Missing";
run;

title "Excerise 1e";
/* Updating dataset with new format */
proc datasets library=WORK;
	modify 	MEMI143_ZLEI5;
		format SALARYX salaryfmt.;
run;

title "Excerise 1f";
/* Printing updated data */
proc print data=memi143_zlei5 (obs=10) split="*";
	var NEWID EDUCA SALARYX;
run;