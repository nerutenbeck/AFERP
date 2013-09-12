/*Differences in abundance and diversity of harvest and */
/*natural gaps within the same size range 100-500 m2*/
/*REgression to determine the effect of gap size by eliminating*/
/*Large variation in gap size as a variable*/
options linesize=72;
Data SameSizeGap;
Input Origin $ RA Gap $ Gapsize Abund E H;
Transabund=log(Abund);
Cards;
Natural	3	J4	511.8832606	12.6	0.226	0.58
Natural	8	D5	475.6135728	17.1	0.592	1.677
Harvest	2	K4	472.9	17.3125	0.458	1.349
Harvest	7	F6	469.4	24.2625	0.625	2.127
Harvest	2	C4	453.9	35.62	0.518	1.777
Harvest	2	K3	453.6	16.3	0.584	1.778
Harvest	5	E8	449.7	32.825	0.384	1.186
Natural	8	B8	418.310922	15.2	0.743	1.544
Natural	8	D3	366.4353725	40.18333333	0.737	2.312
Natural	3	A3	350.694815	48.47777778	0.501	1.201
Harvest	2	D2	348.2	22.4	0.47	1.55
Harvest	2	F3	336.2	9.3875	0.378	1.131
Harvest	9	A8	319.3	52.4125	0.66	2.041
Harvest	2	G4	281.5	9.616666667	0.542	1.674
Natural	3	C4	280.0651352	31.35	0.75	1.798
Natural	8	C1	261.4747604	6.35	0.516	1.073
Natural	3	J2	246.9291862	4.375	0.23	0.639
Natural	8	E6	231.535382	17.4	0.645	1.788
Natural	4	D3	227.6743646	10.975	0.279	0.716
Natural	3	CD4	191.0591016	19.9	0.481	1.196
Natural	8	D4	185.6681286	34.075	0.584	1.806
Natural	8	E3	184.4900313	62.55	0.45	1.08
Natural	3	E4	163.3188381	8.95	0.693	1.921
Natural	4	C4	157.8336172	9.95	0.743	1.846
Natural	3	E3	152.6130756	33.05	0.555	1.279
Natural	8	C2	139.0940168	29.975	0.504	1.108
Natural	4	A7	128.5885308	53.55	0.388	0.994
Natural	4	A8	115.4299698	92	0.46	1.011
Natural	4	D4	114.055523	88.05	0.439	1.054
Harvest	2	F4	108.2	104.55	0.326	0.635
;
Proc Reg; Model TransAbund=gapsize;
Title 'regression on abundance v. gapsize for all gaps 100-500m2';
output out=abundreg predicted=preda residual=resida;
Proc univariate plot normal; 
var resida;
Title'Normality test on abundance v. gap size, all gaps 100-500m2';
Proc plot;
Plot resida*preda;
Title 'Residual graph on abundance v. gap size';

Proc reg; Model H=gapsize;
output out=regH predicted=predH residual=residH;
Title 'regression on H by gapsize for all gaps 100-500m2';
Proc univariate plot normal;
var resida;
Title 'Normality test on H by gap size for all gaps 100-500m2';
Proc plot;
Plot residH*predH;
Title 'Residual graph on H by gap size';

Proc reg; Model E=gapsize;
Title 'regression on E v. gapsize for all gaps 100-500m2';
output out=regE predicted=predE residual=residE;
Proc univariate plot normal;
var residE;
Title 'Normality test on E v. gapsize for all gaps 100-500m2';
Proc plot;
plot residE*predE;
Title 'residual graph on E v. gapsize';
run;
