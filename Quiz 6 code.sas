libname classdat "C:\Users\nicho\Dropbox\class_data"; *create folders for data;
libname ex "C:\Users\nicho\Documents\Epidemiology\Winter 2020\Large Databases\work folder\data";
data ex.encounter; *acquire modifiable encounter dataset;
set classdat.nencounter;
run;
data ex.dated; *includes only encounters from 2003;
set ex.encounter;
where datepart(encStartDtm) between '01Jan2003'd and '31Dec2003'd;
keep EncWid EncPatWid encstartdtm encvisittypecd;
run;
proc sort data=ex.dated; *sort data by patient id;
by encpatwid;
run;
data ex.inpat; *counts inpatient encounters;
set ex.dated;
by encpatwid;
if first.encpatwid then do;
inpatient=0;count=0;
end;
if encvisittypecd="INPT" then do;
inpatient=1;
count=count+1;
end;
if last.encpatwid then output;
retain inpatient count;
run;
proc freq data=ex.inpat; *generate table showing inpatient;
table inpatient count;
run;
/* 
Question a) There were 1074 patients who had at least one inpatient encounter during 2003
*/
data ex.emerg; *counts emergency room encounters;
set ex.dated;
by encpatwid;
if first.encpatwid then do;
emerg=0;count=0;
end;
if encvisittypecd="EMERG" then do;
emerg=1;
count=count+1;
end;
if last.encpatwid then output;
retain emerg count;
run;
proc freq data=ex.emerg; *generate table showing emergency room counts;
tables emerg count;
run;
/* 
Question b) There were 1978 patients who had at least one emergency room encounter during 2003
*/
data ex.combined; *counts borh emergency room and inpatient encounters;
set ex.dated;
by encpatwid;
if first.encpatwid then do;
combined=0;count=0;
end;
if encvisittypecd in ("INPT", "EMERG") then do;
combined=1;
count=count+1;
end;
if last.encpatwid then output;
retain combined count;
run;
proc freq data=ex.combined; *generate table showing combined count;
table combined count;
run;
/* 
Question c) There were 2891 patients who had at least one emergency room encounter or one inpatient encounter during 2003
*/
proc printto file="C:\Users\nicho\Documents\Epidemiology\Winter 2020\Large Databases\quiz5figure.txt" new;
proc freq data=ex.combined; *produces final frequency table;
table count;
options formchar="|----|+|---+=|-/\<>*";
run;
proc printto; run;
         The SAS System            14:42 Monday, March 30, 2020   2

                                          The FREQ Procedure

                                                        Cumulative    Cumulative
                      count    Frequency     Percent     Frequency      Percent
                      ----------------------------------------------------------
                          1        2556       88.41          2556        88.41  
                          2         270        9.34          2826        97.75  
                          3          45        1.56          2871        99.31  
                          4          14        0.48          2885        99.79  
                          5           3        0.10          2888        99.90  
                          6           1        0.03          2889        99.93  
                          7           1        0.03          2890        99.97  
                         12           1        0.03          2891       100.00  

