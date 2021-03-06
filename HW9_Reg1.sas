/** SAS university studio **/
libname hw6611 "/folders/myfolders/6611 Biostats Methods/Homework";

Data lead2;
	* dataset to be created;
	set hw6611.lead2;
	* data being used in data step;

	IF first2y=1 THEN
		notfirst2y=0;

	IF first2y=0 THEN
		notfirst2y=1;
	milesfirst2y=miles*first2y;
	milesNf2y=miles*notfirst2y;
	LABEL notfirst2y='Not exposed first 2years' 
		milesfirst2y="Distance x Exposed first 2yrs" milesNf2y='miles*notfirst2y';
	* the column used for interaction effect;
	* between distance and exposed status in first;
run;

*crude model of iq = expose;

PROC REG DATA=lead2 plots=none;
	MODEL iq=expose/CLB;
	RUN;
	*adjust model of iq= expose race;
	*also test the addition of race, partial F;

PROC REG DATA=lead2 plots=none;
	MODEL iq=expose race/CLB;
	race: TEST race;
	RUN;
	*covariate model, for two categorical variables;
	*from proc ttest to proc freq to conduct chi-square;

proc freq data=lead2;
	tables expose*race / chisq;
run;

*crude model of iq=miles;

PROC REG DATA=lead2 plots=none;
	MODEL iq=miles/CLB;
	RUN;
	*adjust model additon of first2y;
	*also the same as notfirst2y;
	*test the addition of notfirst2y;

PROC REG DATA=lead2 PLOTS=NONE;
	MODEL iq=miles notfirst2y/CLB;
	notfirst2yrs: test notfirst2y;
	run;
	*covariate model of miles and first2y;

PROC TTEST plots=none;
	CLASS notfirst2y;
	var miles;
RUN;

*linear model includes interaction;
*diff in the beta of miles between first2y or notfirst2y;
*partial F test of first2y and interaction;

PROC REG DATA=lead2 plots=none;
	MODEL iq=miles first2y milesfirst2y/CLB;
	all_first2y: TEST first2y, milesfirst2y;
	RUN;

PROC REG DATA=lead2 plots=none;
	MODEL iq=miles notfirst2y milesNf2y/CLB;
	all_notfirst2y: TEST notfirst2y, milesNf2y;
	RUN;
	*reg lines graph grouped by first2y;
	*format 0,1 to no,yes;

PROC GLM ;
	MODEL iq=miles notfirst2y milesNf2y /CLPARM;
	ESTIMATE 'Distance Effect: first2yrs exposed' miles 1;

	/* Estimate 1βmiles */
	ESTIMATE 'Distance Effect: first2yrs not exposed' miles 1 milesNf2y 1;

	/* Estimate 1βmiles + 1βmilesNf2y */
	RUN;

PROC FORMAT ;
	VALUE yesno 0='No' 1='Yes';
RUN;

PROC SGPLOT DATA=hw6611.lead2;
	*Use two-level name for permanent SAS dataset;
	REG Y=iq X=miles / GROUP=first2y;
	FORMAT first2y yesno.;
RUN;
