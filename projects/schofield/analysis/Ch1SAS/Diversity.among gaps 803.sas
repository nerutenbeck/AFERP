/* Shannon-Weiner Index differences among origins*/
options linesize=72;
Data ShannonWeiner;
Input origin $ gap $ gapsize Even H;
Cards;
Harvest	E3	1626	0.494	1.505
Harvest	G2	2169	0.536	1.951
Harvest	G5	940.6	0.522	1.913
Harvest	H7	1204	0.396	1.321
Harvest	I3	1621	0.574	1.914
Harvest	J2	1992	0.544	1.979
Harvest	J4	1459	0.491	1.618
Harvest	J5	1327	0.472	1.574
Harvest	C4	453.9	0.518	1.777
Harvest	D2	348.2	0.47	1.55
Harvest	F3	336.2	0.378	1.131
Harvest	F4	108.2	0.326	0.635
Harvest	G4	281.5	0.542	1.674
Harvest	K3	453.6	0.584	1.778
Harvest	K4	472.9	0.458	1.349
Harvest	B2	1000	0.186	0.462
Harvest	B5	925	0.254	0.669
Harvest	C2	707.3	0.267	0.615
Harvest	D7	916.4	0.449	1.388
Harvest	E3	556.7	0.599	1.903
Harvest	E4	676.7	0.697	2.272
Harvest	E8	449.7	0.384	1.186
Harvest	A3	2049	0.61	2.034
Harvest	B4	1258	0.398	1.28
Harvest	B7	1271	0.609	2.183
Harvest	C2	2106	0.457	1.433
Harvest	C6	1271	0.668	1.852
Harvest	D6	1393	0.683	2.583
Harvest	E2	1269	0.591	2.049
Harvest	E4	1170	0.593	2.216
Harvest	B2	824.5	0.662	2.017
Harvest	B4	897.8	0.621	1.68
Harvest	B7	1203	0.518	1.623
Harvest	C7	671.7	0.749	2.496
Harvest	D7	1293	0.756	2.926
Harvest	F2	655.1	0.734	2.496
Harvest	F4	626.9	0.658	2.035
Harvest	F6	469.4	0.625	2.127
Harvest	A8	319.3	0.66	2.041
Harvest	B8	1762	0.633	2.013
Harvest	C4	655	0.615	2.09
Harvest	C6	1444	0.464	1.316
Harvest	E4	1496	0.736	2.34
Harvest	Z5	580.2	0.584	1.806
Harvest	Z8	1161	0.462	1.28
Natural	A3	350.694815	0.501	1.201
Natural	C4	280.0651352	0.75	1.798
Natural	CD4	191.0591016	0.481	1.196
Natural	E3	152.6130756	0.555	1.279
Natural	E4	163.3188381	0.693	1.921
Natural	J2	246.9291862	0.23	0.639
Natural	J4	511.8832606	0.226	0.58
Natural	A7	128.5885308	0.388	0.994
Natural	A8	115.4299698	0.46	1.011
Natural	C3B	88.12167524	0.551	1.145
Natural	C4	157.8336172	0.743	1.846
Natural	C5	88.92278137	0.486	1.282
Natural	D3	227.6743646	0.279	0.716
Natural	D4	114.055523	0.439	1.054
Natural	B8	418.310922	0.743	1.544
Natural	C1	261.4747604	0.516	1.073
Natural	C2	139.0940168	0.504	1.108
Natural	D3	366.4353725	0.737	2.312
Natural	D4	185.6681286	0.584	1.806
Natural	D5	475.6135728	0.592	1.677
Natural	E3	184.4900313	0.45	1.08
Natural	E6	231.535382	0.645	1.788
Natural	H7	203.6223309	0.651	1.918
Non-Gap	A2	0	0.428	1.064
Non-Gap	D5	0	0.412	1.057
Non-Gap	E2	0	0.47	0.914
Non-Gap	F3	0	0.889	2.407
Non-Gap	F4	0	0.321	0.869
Non-Gap	G4	0	0.967	1.557
Non-Gap	HI5	0	0.376	0.903
Non-Gap	A2	0	0.581	0.805
Non-Gap	A5	0	0.203	0.504
Non-Gap	A6	0	0.535	1.175
Non-Gap	B4	0	0.594	1.475
Non-Gap	B6	0	0.401	0.779
Non-Gap	B7	0	0.462	1.28
Non-Gap	C3D	0	0.673	1.311
Non-Gap	B2	0	0.682	1.932
Non-Gap	C4	0	0.553	0.991
Non-Gap	C7	0	0.498	0.892
Non-Gap	D0	0	0.487	1.013
Non-Gap	D6 	0	0.699	1.253
Non-Gap	E5	0	0.756	1.217
Non-Gap	F3	0	0.775	1.611
Non-Gap	G5	0	0.588	1.551
Non-Gap	G6	0	0.612	1.467
;
Proc Glm; class origin;
Model H=origin;
Contrast 'Gap v. closed canopy' origin 1 1 -2;
Contrast 'Harvest gap v. natural gap' origin 1 -1 0;
Title 'ANOVA on Shannon-Weiner among origin';

output out=aovdataH predicted=pred residual=resid;
Proc Univariate plot normal;
var resid;
Title 'Normality test on H distribution';

Data NewH; set aovdataH;
absresid=abs(resid);
Proc Anova; class origin;
Model absresid=origin;
Title 'Levines test on equality of variance for H';
run;


Proc GLM; Class origin;
Model Even=origin;
Title 'ANOVA on differences in evenness';
output out=aovdataE predicted=predE residual=residE;
Proc univariate plot normal;
var residE;
Title 'Normality test on E ANOVA';

Data NewE; Set aovdataE;
absresidE= abs(residE);
Proc Anova; class origin;
model absresidE=origin;
Title 'Levines test on equality of variance for Evenness';
Run;



