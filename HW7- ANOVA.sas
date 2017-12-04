%web_drop_table(breact);
FILENAME REFFILE 
	'/folders/myfolders/6611 Biostats Methods/Homework/bronchial reactivity.xlsx';

PROC IMPORT DATAFILE=REFFILE DBMS=XLSX OUT=breact;
	GETNAMES=YES;
RUN;

%web_open_table(breact);

PROC PRINT DATA=breact;
RUN;

PROC GLM DATA=breact ORDER=internal;
	CLASS FEV_FVC;
	MODEL Bron_React=FEV_FVC/solution;
	RUN;

PROC GLM DATA=breact ORDER=Internal;
	CLASS FEV_FVC;
	MODEL Bron_React=FEV_FVC/noint solution;
	MEANS FEV_FVC/tukey;
	RUN;

PROC GLM DATA=breact;
	CLASS FEV_FVC;
	MODEL Bron_React=FEV_FVC;
	MEANS FEV_FVC/WELCH;
	RUN;