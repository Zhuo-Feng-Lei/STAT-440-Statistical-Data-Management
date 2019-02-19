/* Zhuo Feng Lei (zlei5) */
/* HW01 Submission */

/* Exercise 1 */
title 'Exercise 1';

data shoes_data;
	set sashelp.shoes;
run;

/* Problem 1a */
title 'Exercise 1a';

proc contents data = shoes_data;
run;

/* Problem 1b */
title 'Exercise 1b';

data chicago_shoe_stores;
	set shoes_data;
	where Subsidiary = "Chicago";
run;

proc print data = chicago_shoe_stores;
run;

/* Problem 1c */
title 'Exercise 1c';

proc tabulate data = shoes_data;
	class Subsidiary;
	var Inventory;
	table Subsidiary,Inventory*(sum min max);
run;

/* Exercise 2 */
title 'Exercise 2';

data baseball_data;
	set sashelp.baseball;
run;

/* Problem 2a */
title 'Exercise 2a';
data baseball_salary;
	set baseball_data;
	where Salary > 1000;
	keep Name Team Position Salary;
run;

proc print data = baseball_salary;
run;

/* Problem 2b */
title 'Exercise 2b';

data baseball_league;
	set baseball_data;
	where League = "National" and YrMajor between 2 and 5;
	keep Name Team YrMajor nHome;
run;

proc print data = baseball_league;
run;

/* Problem 2c */
title 'Exercise 2c';
data baseball_not_outfield;
	set baseball_data;
	where Position ^= "OF" and Name like "N%" or Name like"O%" or Name like "P%" or Name like "Q%";
	keep Name Team Position nHits;
run;

proc print data = baseball_not_outfield;
run;
