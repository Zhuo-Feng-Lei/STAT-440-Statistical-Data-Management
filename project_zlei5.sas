/* formats/informats relevant to data cleaning */
proc format;
	invalue missing_fmt_num "\N" = .;
	invalue $missing_fmt_char "\N" = " ";
	value $dst_fmt "E" = "Europe"
				   "A" = "US/Canada"
				   "S" = "South America"
				   "O" = "Australia"
				   "Z" = "New Zealand"
				   "N" = "None"
				   "U" = "Unknown";
	value $type_fmt "airport" = "Air Terminals"
					"station" = "Train Stations"
					"port" = "Ferry Terminals"
					"unknown" = "Unknown";
	value $active_fmt "Y" = "Operational"
					  "N" = "Defunct"
					  "n" = "Defunct";
	value $codeshare_fmt "Y" = "Operated by other Carriers";
run;

/* reading in airports data */
data airports;
	length Name $50 City $20 Country $20 Tz_Database $30 Type $20 Source $20;
	infile "/home/zlei50/STAT 440/airports.dat.txt" dlm="," dsd;
	input Airport_ID Name $ City $ Country $ IATA $ ICAO $ Latitude Longitude Altitude Timezone DST $ Tz_Database $ Type $ Source $;
	informat Timezone missing_fmt_num.;
	informat  IATA ICAO DST Tz_Database Country $missing_fmt_char.;
	format DST $dst_fmt. Type $type_fmt.;
	label Altitude = "Altitude*(Feet)"
		  Timezone = "Timezone*Hours*Offset*From*UTC";
run;

proc contents data = airports;
run;

/* reading in airlines data */
data airlines;
	length Name $50 Country $20;
	infile "/home/zlei50/STAT 440/airlines.dat.txt" dlm="," dsd;
	input Airline_ID Name $ Alias $ IATA $ ICAO $ Callsign $ Country $ Active $;
	informat Alias Country $missing_fmt_char.;
	format Active $active_fmt.;
run;

proc contents data = airlines;
run;

/* reading in routes data */
data routes;
	length Airline $50 Equipment $20;
	infile "/home/zlei50/STAT 440/routes.dat.txt" dlm="," dsd;
	input Airline $ Airline_ID Start $ Start_ID End $ End_ID Codeshare $ Stops Equipment $;
	informat Airline_ID Start_ID End_ID missing_fmt_num.;
	format Codeshare $codeshare_fmt.;
	label Start_ID = "Source*Airport*ID"
		  End_ID = "Destination*Airport*ID"
		  Start = "Source*Airport*IATA/ICAO*Code"
		  End = "Source*Airport*IATA/ICAO*Code"
		  Stops = "Number*of*Stops*Till*Destination";
run;

proc contents data = routes;
run;

/* data validation */
proc freq data = airlines;
	table Active;
run;

proc freq data = airlines;
	table Country;
run;

/* combining routes data and airlines data set based on Airline_ID. */
proc sql;
	create table combined as
	select a.Airline_ID,a.Name,a.Alias,a.IATA,a.ICAO,a.Callsign,a.Country,a.Active,r.Start,r.Start_ID,r.End,r.End_ID,r.Codeshare,r.Stops,r.Equipment
	from airlines as a
	right join
	routes as r
	on a.Airline_ID = r.Airline_ID;
quit;

/* combining airport data and previously combined data to give more info on source airports */
proc sql;
	create table test as 
	select c.Airline_ID,c.Name,c.Alias,c.IATA,c.ICAO,c.Callsign,c.Country,c.Active,c.Start,c.Start_ID,ap.Name as Source_Airport,ap.City as Source_City,ap.Country as Source_Country,ap.Latitude as Source_Latitude, ap.Longitude as Source_Longitude,ap.Altitude as Source_Altitude, ap.Timezone as Source_Timezone,ap.DST as Source_DST, ap.Type as Source_Type,c.End, c.End_ID,c.Codeshare,c.Stops,c.Equipment
	from combined as c
	left join
	airports as ap
	on c.Start_ID = ap.Airport_ID
	;
quit;

/* combining airport data and previously combined data to give more info on destination airports */
proc sql;
	create table final as 
	select t.Airline_ID,t.Name,t.Alias,t.IATA,t.ICAO,t.Callsign,t.Country,t.Active,t.Start,t.Start_ID,t.Source_Airport,t.Source_City,t.Source_Country,t.Source_Latitude, t.Source_Longitude,t.Source_Altitude, t.Source_Timezone,t.Source_DST, t.Source_Type,t.End, t.End_ID,ap.Name as Destination_Airport,ap.City as Destination_City,ap.Country as Destination_Country,ap.Latitude as Destination_Latitude, ap.Longitude as Destination_Longitude,ap.Altitude as Destination_Altitude, ap.Timezone as Destination_Timezone,ap.DST as Destination_DST, ap.Type as Destination_Type,t.Codeshare,t.Stops,t.Equipment
	from test as t
	left join
	airports as ap
	on t.End_ID = ap.Airport_ID;
quit;

title "Question 1";
/* Most popular source */
proc sql outobs=5;
	select Source_Airport, count(Source_Airport) as Num_Source
	from final
	group by Source_Airport
	order by Num_Source desc;
quit;

/* Most popular destinations */
proc sql outobs=5;
	select Destination_Airport, count(Destination_Airport) as Num_Destination
	from final
	group by Destination_Airport
	order by Num_Destination desc;
quit;

title "Question 2";
/* Most used airline globally */
proc sql outobs=5;
	select Name, count(Airline_ID) as Num_Used
	from final
	group by Name
	order by Num_Used desc;
quit;

title "Question 3";
/* most used airline in Chicago airports of Midway and O'hare */
proc sql outobs=5;
	select Name as Airline,count(Name) as Most_Used_Airline
	from final
	where Source_Airport in ("Chicago O'Hare International Airport","Chicago Midway International Airport")
	group by Name
	order by Most_Used_Airline desc;
quit;

/* most frequent destination in Chicago airports of Midway and O'hare */
proc sql outobs=5;
	select Destination_City as Destination, count(Destination_City) as Most_Frequent_Destination
	from final
	where Source_Airport in ("Chicago O'Hare International Airport","Chicago Midway International Airport")
	group by Destination_City
	order by Most_Frequent_Destination desc;
quit;

title "Question 4";
/* Find countries with most airports (global)*/
proc sql outobs=5;
	select Country, count(Country) as Number_of_Airports
	from airports
	group by Country
	order by Number_of_Airports desc;
quit;

/* Find city with most airports (US REGION)*/
proc sql outobs=5;
	select City, count(Country) as Number_of_Airports
	from airports
	where Country = "United States"
	group by City
	order by Number_of_Airports desc;
quit;

title "Question 5";
/*  pairs of global and/or US regions have the most flights between them? */
proc sql outobs=5;
	select Source_Country, Destination_Country, count(*) as Num_Flights
	from final
	where Source_Country not equal Destination_Country
	group by Source_Country, Destination_Country
	order by Num_Flights desc;
quit;

proc sql outobs=10;
	select Source_City, Destination_City, count(*) as Num_Flights
	from final
	where Source_City not equal Destination_City and Source_Country = "United States" and Destination_Country = "United States"
	group by Source_City, Destination_City
	order by Num_Flights desc;
quit;

title "Question 6";
/* Parsing the data in the Equipment column to get an accurate count of each equipment */
data q6;
	set routes;
	gcount = countw(Equipment);
	do i=1 to (gcount);
	Each_Equipment = scan(Equipment, i, " ");
	end;
	drop i gcount;
run;

/* Most frequently used equipment */
proc sql outobs = 5;
	select Each_Equipment as Plane_Type, count(Equipment) as Freq_Plane_Type
	from q6
	group by Each_Equipment
	order by Freq_Plane_type desc;
quit;
