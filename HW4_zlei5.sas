libname hw4 "/home/zlei50/STAT 440";

title "Problem 1a";
proc sort data = hw4.orders;
	by Customer_ID;
run;

proc format;
	value $gender_fmt "F" = "Female"
					  "M" = "Male";
	value $order_fmt 1 = "Retail"
	                 2 = "Catalog"
	                 3 = "Internet";
run;

data discount_ret;
	set hw4.orders;
	label Customer_ID = "Customer*ID"
		  Customer_Name = "Name"
		  TotSales = "Total*Sales";
	format TotSales dollar10.2;
	by Customer_ID;
	if First.Customer_ID then TotSales = 0; 
	TotSales+Total_Retail_Price;
	if Last.Customer_ID;
	if TotSales <300 then delete;
	where Order_Type = 1;
	keep Customer_ID Customer_Name TotSales;
run;

data discount_cat; 
	set hw4.orders;
	label Customer_ID = "Customer*ID"
		  Customer_Name = "Name"
		  Customer_Gender = "Gender"
		  TotSales = "Total*Sales";
	format Customer_Gender gender_fmt.
		   TotSales dollar10.2;
	by Customer_ID;
	if First.Customer_ID then TotSales = 0; 
	TotSales+Total_Retail_Price;
	if Last.Customer_ID;
	if TotSales <100 then delete;
	where Order_Type = 2;
	keep Customer_ID Customer_Name Customer_Gender TotSales;
run;

data discount_int;
	set hw4.orders;
	label Customer_ID = "Customer*ID"
		  Customer_Name = "Name"
		  Customer_BirthDate = "BirthDate"
		  TotSales = "Total*Sales";
	format Customer_BirthDate MMDDYY.
	       TotSales dollar10.2;
	by Customer_ID;
	if First.Customer_ID then TotSales = 0; 
	TotSales+Total_Retail_Price;
	if Last.Customer_ID;
	if TotSales <300 then delete;
	where Order_Type = 3;
	keep Customer_ID Customer_Name Customer_BirthDate TotSales;
run;

data top_buyers_zlei5;
	set hw4.orders;
	label Customer_ID = "Customer*ID"
		  Customer_Name = "Name"
		  TotSales = "Total*Sales";
	format TotSales dollar10.2;
	by Customer_ID;
	if First.Customer_ID then TotSales = 0; 
	TotSales+Total_Retail_Price;
	if Last.Customer_ID;
	if TotSales <700 then delete;
	keep Customer_ID Customer_Name TotSales;
run;

title1 "Problem 1b: Retail Discount Dataset";
proc print data = discount_ret split="*";
run;

title1 "Problem 1b: Catalog Discount Dataset";
proc print data = discount_cat split="*";
run;

title1 "Problem 1b: Internet Discount Dataset";
proc print data = discount_int split="*";
run;

title1 "Problem 1b: Top Buyers Dataset";
proc print data = top_buyers_zlei5 split="*";
run;

title "Problem 2a";
data trade_zlei5;
	infile "/home/zlei50/STAT 440/importexport87-15.dat" dlm="	";
	input Date :mmddyy. Exports Imports @@;
	format Date mmddyy10.;
	Balance = Exports-Imports;
	label Exports = "Exports*from US*(Millions of Dollars)"
		  Imports = "Imports*to the US*(Millions of Dollars)"
		  Balance = "Balance*(Millions of Dollars)";
run;

title "Problem 2b";
proc print data = trade_zlei5 split="*";
	where year(Date)=2009;
run;

title "Problem 2c";
proc sql;
	create table yearlyimports_zlei5 as
	select YEAR(Date) as Year, SUM(Imports) as YearTotal,SUM(Imports)/12 as YearAvg
	from trade_zlei5
	group by Year;
quit;

title "Problem 2d";
proc contents data = yearlyimports_zlei5;
run;

title "Problem 2e";
proc print data = yearlyimports_zlei5;
	where Year between 1990 and 1999;
run;

title "Problem 2f";
data decades_zlei5;
	set yearlyimports_zlei5;
	if 1980<=Year<=1989 then decade='1980s';
	if 1990<=Year<=1999 then decade='1990s';
	if 2000<=Year<=2009 then decade='2000s';
	if 2010<=Year<=2019 then decade='2010s';	
run;

proc means data=decades_zlei5;
	class decade;
	var YearTotal;
run;

title "Problem 3a";
data mostmoney_zlei5 (drop=i);
	input Option $ Yearly_Deposit Annual_Interest_Rate Compound_Frequency $ Times_Per_Year Total_After_25_Years;
	do i=1 to 25;
		Total_After_25_Years+Yearly_Deposit;
		Total_After_25_Years=Total_After_25_Years*(1+(Annual_Interest_Rate/Times_Per_Year))**Times_Per_Year;
	end;
	datalines;
	A 1000 0.08 Yearly 1 0
	B 1700 0.04 Quarterly 4 0 
	C 1900 0.03 Quarterly 4 0
	D 2700 0.025 Monthly 12 0
	E 2500 0.0125 Monthly 12 0
	F 2100 0.01 Weekly 52 0
	;
run;

title "Problem 3b";
proc print data = mostmoney_zlei5;
run;

title "Problem 3c";
data save35k_zlei5;
	input Option $ Yearly_Deposit Annual_Interest_Rate Compound_Frequency $ Times_Per_Year Amount Years;
	do until (Amount>=35000);
		Years+1;
		Amount+Yearly_Deposit;
		Amount = Amount*(1+(Annual_Interest_Rate/Times_Per_Year))**Times_Per_Year;
		end;
	label Years = "Years Until $35k";
	datalines;
	A 1000 0.08 Yearly 1 0 0
	B 1700 0.04 Quarterly 4 0 0
	C 1900 0.03 Quarterly 4 0 0
	D 2700 0.025 Monthly 12 0 0
	E 2500 0.0125 Monthly 12 0 0
	F 2100 0.01 Weekly 52 0 0
	;
run;

title "Problem 3d";
proc print data = save35k_zlei5;
run;