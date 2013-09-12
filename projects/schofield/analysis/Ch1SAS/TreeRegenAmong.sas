/*Tree regeneration among gaps by origin*/
/*Test for significant differences in all size classes*/
/*Seed1=<0.5m tall, Seed2= 0.5-1.0m tall, Sap= 1.0-2.0m tall*/
/*Tree=>2.0m tall.  Data is the average count of stems*/
/*in each size class for each gap*/
Options Linesize=72;
Data Treeregen;
Input Origin $ RA Gap $ seed1 seed2 sap tree;
Transeed1=seed1**2;
Transeed2=sqrt(seed2);
Transap=log(sap);
Transtree=log(tree);
/*Data did not meet assumptions of normality and/or equality*/
/*of variance, so transformed*/
/*Trees <0.5m tall (seed1, transeed1) still no equal variance*/
Cards;
Harvest	1	E3	3.205	0.477	0.977	0.159
Harvest	1	G2	3.084	0.705	0.484	0.253
Harvest	1	G5	3.700	0.100	0.033	0.017
Harvest	1	H7	4.091	0.023	0.000	0.000
Harvest	1	I3	6.225	0.525	0.200	0.075
Harvest	1	J2	5.766	0.585	0.394	0.106
Harvest	1	J4	5.513	0.103	0.000	0.000
Harvest	1	J5	2.222	0.311	0.489	0.356
Harvest	2	C4	4.943	0.377	0.113	0.000
Harvest	2	D2	2.731	0.000	0.000	0.000
Harvest	2	F3	2.853	0.294	0.118	0.059
Harvest	2	F4	1.286	0.714	0.714	0.571
Harvest	2	G4	3.333	0.152	0.273	0.030
Harvest	2	K3	5.030	0.394	0.242	0.000
Harvest	2	K4	4.115	1.423	0.923	0.231
Harvest	5	B2	5.000	0.148	0.185	0.222
Harvest	5	B5	5.533	0.533	0.333	0.133
Harvest	5	C2	11.926	0.037	0.000	0.000
Harvest	5	D7	4.675	0.225	0.050	0.025
Harvest	5	E3	9.472	0.028	0.000	0.000
Harvest	5	E4	8.441	0.029	0.000	0.000
Harvest	5	E8	2.886	1.486	2.171	0.343
Harvest	6	A3	6.364	0.390	0.208	0.143
Harvest	6	B4	2.796	0.429	0.469	0.490
Harvest	6	B7	7.396	0.509	0.170	0.132
Harvest	6	C2	2.962	0.846	0.808	0.481
Harvest	6	C6	3.609	0.565	0.565	0.043
Harvest	6	D6	3.086	0.346	0.309	0.247
Harvest	6	E2	5.833	0.125	0.250	0.208
Harvest	6	E4	4.814	0.314	0.233	0.186
Harvest	7	B2	4.679	1.250	0.893	0.464
Harvest	7	B4	5.103	0.345	0.379	0.345
Harvest	7	B7	7.262	0.929	0.048	0.048
Harvest	7	C7	4.419	0.774	0.613	0.258
Harvest	7	D7	4.860	1.023	0.233	0.047
Harvest	7	F2	5.056	0.417	0.278	0.278
Harvest	7	F4	4.380	0.560	0.180	0.120
Harvest	7	F6	5.061	0.879	0.273	0.273
Harvest	9	A8	5.932	0.614	0.250	0.205
Harvest	9	B8	3.000	0.694	0.653	0.673
Harvest	9	C4	4.710	0.548	0.516	0.226
Harvest	9	C6	3.581	0.387	0.903	1.484
Harvest	9	E4	3.115	0.821	0.718	0.103
Harvest	9	Z5	3.000	0.897	0.615	0.308
Harvest	9	Z8	3.225	0.225	0.525	0.650
Natural	3	A3	6.243	0.432	0.108	0.027
Natural	3	C4	7.000	0.200	0.200	0.050
Natural	3	D4	3.300	0.700	0.500	0.100
Natural	3	E3	8.923	0.000	0.000	0.000
Natural	3	E4	8.583	0.000	0.000	0.000
Natural	3	J2	4.882	0.000	0.059	0.059
Natural	3	J4	7.240	0.040	0.000	0.040
Natural	4	A7	4.444	0.000	0.222	0.333
Natural	4	A8	6.300	0.000	0.000	0.000
Natural	4	C3	12.125	0.000	0.000	0.000
Natural	4	C4	3.900	0.100	0.000	0.000
Natural	4	C5	7.143	0.000	0.000	0.000
Natural	4	D3	11.353	0.412	0.235	0.000
Natural	4	D4	4.222	0.222	0.111	0.000
Natural	8	B8	6.273	0.045	0.000	0.000
Natural	8	C1	3.571	0.238	0.238	0.238
Natural	8	C2	2.933	0.867	1.000	0.200
Natural	8	D3	1.077	0.000	0.077	0.231
Natural	8	D4	1.200	0.467	0.533	1.067
Natural	8	D5	2.200	0.600	0.320	0.280
Natural	8	E3	1.000	0.182	0.182	0.364
Natural	8	E6	2.211	0.263	0.263	0.158
Natural	8	H7	3.222	0.000	0.000	0.111
Non-gap	3	A2	2.176	0.000	0.000	0.059
Non-gap	3	D5	5.158	0.053	0.053	0.105
Non-gap	3	E2	3.500	0.083	0.083	0.000
Non-gap	3	F3	6.364	0.045	0.000	0.000
Non-gap	3	F4	4.217	0.000	0.000	0.000
Non-gap	3	G4	4.000	0.000	0.000	0.000
Non-gap	3	I5	2.857	0.214	0.143	0.000
Non-gap	4	A2	4.333	0.000	0.000	0.000
Non-gap	4	A5	2.222	1.111	0.444	0.111
Non-gap	4	A6	3.571	0.714	0.000	0.000
Non-gap	4	B4	4.000	0.000	0.000	0.000
Non-gap	4	B6	1.778	0.333	0.222	0.333
Non-gap	4	B7	1.455	0.182	0.545	0.364
Non-gap	4	C3	10.188	0.000	0.000	0.000
Non-gap	8	B2	3.235	0.059	0.059	0.294
Non-gap	8	C4	2.273	0.091	0.091	0.091
Non-gap	8	C7	3.000	0.091	0.000	0.091
Non-gap	8	D0	2.333	0.167	0.083	0.167
Non-gap	8	D6	1.091	0.000	0.000	0.364
Non-gap	8	E5	4.000	0.692	0.231	0.231
Non-gap	8	F3	1.083	0.250	0.167	0.167
Non-gap	8	G5	1.308	0.308	0.308	0.462
Non-gap	8	G6	1.000	0.000	0.333	0.500
;

/*Multiple dependent variable ANOVA*/
Proc GLM;Class Origin;
Model transeed1 transeed2 transap transtree=Origin;
Contrast 'Gap v. Closed canopy' Origin 1 1 -2;
Contrast 'Harvest v. Natural gap' Origin 1 -1 0;
Title1 'Test for signficant differences in tree regen-all size classes';
Title2 'ANOVA -Planned group Comparisons-multiple dependent variables';
Means Origin;

Output out=aovdata predicted=pred1-pred4 residual=resid1-resid4;
Proc univariate Plot normal;
var resid1-resid4;
Title 'Normality test on residuals for all dependent variables';
Proc plot; 
Plot resid1*pred1;
Plot resid2*pred2;
Plot resid3*pred3;
Plot resid4*pred4;

Data New; Set aovdata;
Absresid1=abs(resid1);
Absresid2=abs(resid2);
Absresid3=abs(resid3);
Absresid4=abs(resid4);
Proc Anova; Class Origin;
Model Absresid1-Absresid4=Origin;
Title 'Levines test for equality of variance for all tree regen';


run;
