/*Test for significant differences of diversity among origins*/
/*Using the Shannon-Weiner index. Weighted by the regression */
/*function of the Species Area Curve*/
/*Log transformed*/
Options Linesize=72;
Data ShannonWeiner;
Input RA Origin $ Gap $ Area H WeightH;
Cards;
3	Natural	A3	32.00	1.201381	0.726869
3	Natural	C4	16.00	1.797737	0.721228
3	Natural	CD4	8.00	1.196186	0.312556
3	Natural	E3	8.00	1.278759	0.334132
3	Natural	E4	8.00	1.921461	0.502066
3	Natural	J2	16.00	0.638813	0.256283
3	Natural	J4	24.00	0.580046	0.296704
4	Natural	A7	8.00	0.628174	0.164138
4	Natural	A8	8.00	1.011438	0.264282
4	Natural	C3B	8.00	1.145451	0.299299
4	Natural	C4	8.00	1.846440	0.482463
4	Natural	C5	8.00	1.281535	0.334857
4	Natural	D3	16.00	0.716267	0.287357
4	Natural	D4	8.00	1.053709	0.275328
8	Natural	B8	24.00	1.544056	0.789813
8	Natural	C1	24.00	1.073240	0.548982
8	Natural	C2	16.00	1.107656	0.444377
8	Natural	D3	24.00	2.325026	1.189294
8	Natural	D4	16.00	1.820837	0.730495
8	Natural	D5	32.00	1.680001	1.016448
8	Natural	E3	16.00	1.079751	0.433182
8	Natural	E6	16.00	1.788437	0.717497
8	Natural	H7	16.00	1.917860	0.769420
3	Non-gap	A2	16.00	1.064168	0.426930
3	Non-gap	D5	16.00	1.057171	0.424123
3	Non-gap	E2	16.00	0.913759	0.366588
3	Non-gap	F3	16.00	2.406594	0.965493
3	Non-gap	F4	16.00	0.869248	0.348731
3	Non-gap	G4	16.00	1.297231	0.520431
3	Non-gap	HI5	16.00	0.902550	0.362091
4	Non-gap	A2	16.00	0.804938	0.322930
4	Non-gap	A5	16.00	0.503739	0.202093
4	Non-gap	A6	16.00	0.975669	0.391425
4	Non-gap	B4	16.00	1.475367	0.591897
4	Non-gap	B6	16.00	0.779464	0.312710
4	Non-gap	B7	16.00	1.279919	0.513486
4	Non-gap	C3D	16.00	1.310559	0.525778
8	Non-gap	B2	16.00	1.931572	0.774920
8	Non-gap	C4	16.00	0.990590	0.397411
8	Non-gap	C7	16.00	0.891669	0.357725
8	Non-gap	D0	16.00	1.012963	0.406387
8	Non-gap	D6 	16.00	1.252534	0.502500
8	Non-gap	E5	16.00	1.216718	0.488131
8	Non-gap	F3	16.00	1.606416	0.644472
8	Non-gap	G5	16.00	1.550872	0.622189
8	Non-gap	G6	16.00	1.467073	0.588570
2	Harvest	C4	40.00	1.777165	1.221132
2	Harvest	D2	24.00	1.550327	0.793021
2	Harvest	F3	32.00	1.130912	0.684234
2	Harvest	F4	8.00	0.635060	0.165937
2	Harvest	G4	24.00	1.673824	0.856192
2	Harvest	K3	32.00	1.778093	1.075797
2	Harvest	K4	32.00	1.349450	0.816455
5	Harvest	B2	32.00	0.461600	0.279281
5	Harvest	B5	24.00	0.669218	0.342317
5	Harvest	C2	32.00	0.615111	0.372160
5	Harvest	D7	32.00	1.388150	0.839870
5	Harvest	E3	24.00	1.902739	0.973286
5	Harvest	E4	32.00	2.272490	1.374921
5	Harvest	E8	32.00	1.185856	0.717477
7	Harvest	B2	24.00	2.016840	1.031651
7	Harvest	B4	24.00	1.680404	0.859558
7	Harvest	B7	40.00	1.623068	1.115248
7	Harvest	C7	32.00	2.541594	1.537736
7	Harvest	D7	40.00	2.953007	2.029080
7	Harvest	F2	40.00	2.529925	1.738370
7	Harvest	F4	40.00	2.037904	1.400292
7	Harvest	F6	32.00	2.150673	1.301218
1	Harvest	E3	40.00	1.505162	1.034232
1	Harvest	G2	72.00	1.950689	1.846468
1	Harvest	G5	40.00	1.912732	1.314283
1	Harvest	H7	40.00	1.320777	0.907537
1	Harvest	I3	40.00	1.913530	1.314831
1	Harvest	J2	72.00	1.978993	1.873260
1	Harvest	J4	40.00	1.617699	1.111558
1	Harvest	J5	40.00	1.573576	1.081241
6	Harvest	A3	80.00	2.033916	2.033766
6	Harvest	B4	40.00	1.279581	0.879230
6	Harvest	B7	48.00	2.182646	1.660462
6	Harvest	C2	56.00	1.432911	1.186120
6	Harvest	C6	24.00	1.852162	0.947415
6	Harvest	D6	56.00	2.582800	2.137964
6	Harvest	E2	16.00	2.049046	0.822049
6	Harvest	E4	56.00	2.215666	1.834061
9	Harvest	A8	32.00	2.041062	1.234900
9	Harvest	B8	40.00	2.015166	1.384668
9	Harvest	C4	24.00	2.103940	1.076204
9	Harvest	C6	40.00	1.315760	0.904089
9	Harvest	E4	56.00	2.340283	1.937215
9	Harvest	Z5	32.00	1.805512	1.092386
9	Harvest	Z8	56.00	1.279830	1.059404
;
Proc Rank data=ShannonWeiner out=RankH;
Var WeightH;
Ranks R_WeightH;

/*Anova with planned group comparisons*/
/*For significant differences in diversity among origins*/
Proc GLM;
Class Origin;
Model R_WeightH=Origin;
Contrast 'Gap v. Closed canopy' Origin 1 1 -2;
Contrast 'Harvest gap v. Natural Gap' Origin 1 -1 0;
Title 'Anova for differences in diversity among gap origin';

Output out=A Predicted=pred Residual=resid;

Proc Univariate Plot normal; 
var resid;
Title 'Evaluation of residuals for normal distribution';

/*New data set with absolute value of residual*/
/*Levines test for equality of variance*/
Data B; Set A;
Absresid=abs(resid);
Proc Anova; Class origin;
Model absresid=origin;
Title 'Levines test for equality of variance';
run;

