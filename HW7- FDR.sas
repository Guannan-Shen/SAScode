DATA rawp;
	input SNP Raw_P;
	cards;
1 .04
2 .10 
3 .40
4 .55
5 .34
6 .62
7 .001
8 .01
9 .80
10 .005
;
run;

proc multtest pdata=rawp fdr;
run;

