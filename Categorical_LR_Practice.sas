libname hw6611 "/folders/myfolders/6611 Biostats Methods/Homework";

Data elemapi;
	* dataset to be created;
	set hw6611.elemapi2_2;
	* data being used in data step;
run;

proc datasets nolist;
  contents data= elemapi out=elemdesc noprint;
run;
proc print data=elemdesc noobs;
  var name label nobs;
  where name in ('api00', 'some_col', 'yr_rnd', 'mealcat');
run;