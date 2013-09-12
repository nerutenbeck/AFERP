/*REgression for diversity indices by Canopy gap fraction*/
/*Each value represents a value per gap*/
options linesize=72;
Data HGcanopyopen;
Input HG $ HGdifn HGE HGH;
cards;
Harvest	2.98566032	0.494	1.505
Harvest	1.76469576	0.536	1.951
Harvest	0.99615116	0.522	1.913
Harvest	0.83386854	0.396	1.321
Harvest	0.654391	0.574	1.914
Harvest	4.99037	0.544	1.979
Harvest	1.095288	0.491	1.618
Harvest	1.018886	0.472	1.574
Harvest	1.013668	0.518	1.777
Harvest	1.021038	0.47	1.55
Harvest	1.5340704	0.378	1.131
Harvest	0.208544	0.326	0.635
Harvest	1.59682	0.542	1.674
Harvest	1.291532	0.584	1.778
Harvest	0.878108	0.458	1.349
Harvest	1.656182	0.254	0.669
Harvest	1.715238	0.267	0.615
Harvest	1.232936	0.449	1.388
Harvest	0.665934	0.599	1.903
Harvest	0.921546	0.697	2.272
Harvest	1.20074952	0.398	1.28
Harvest	1.1599049	0.609	2.183
Harvest	1.84580906	0.457	1.433
Harvest	1.1345492	0.668	1.852
Harvest	1.13112898	0.591	2.049
Harvest	1.06845572	0.662	2.017
Harvest	1.07175928	0.621	1.68
Harvest	1.897066	0.518	1.623
Harvest	1.985412	0.749	2.496
Harvest	1.957564	0.756	2.926
Harvest	1.956342	0.734	2.496
Harvest	1.89361	0.658	2.035
Harvest	2.001916	0.625	2.127
Harvest	1.947448	0.66	2.041
Harvest	0.627726	0.633	2.013
Harvest	0.634372	0.615	2.09
Harvest	0.520524	0.464	1.316
Harvest	0.596486	0.736	2.34
Harvest	0.622842	0.584	1.806
Harvest	0.652632	0.462	1.28
;
Proc reg; Model HGH=HGdifn;
Title 'Harvest gap regression on H by canopy openness';
output out=regHGH predicted=predHGH residual=residHGH;
Proc univariate plot normal;
var residHGH;
Title 'Normality test on harvest gap H by canopy openness';
Proc plot;
plot residHGH*predHGH;
Title 'residual graph on harvest gap H by canopy openness';

Proc reg; Model HGE=HGdifn;
Title 'regression on Harvest gap evenn by canopy openness';
output out=regHGE predicted=predHGE residual=residHGE;
Proc univariate plot normal;
var residHGE;
Title 'Normality test on Harvest gap evenn by canopy openness';
Proc plot;
Plot residHGE*predHGE;
Title 'Residual graph on harvest gap evenn by canopy openness';

Data NGcanopyopen;
Input NG $ NGdifn NGE NGH;
cards;
Natural	0.619488	0.501	1.201
Natural	0.670522	0.75	1.798
Natural	0.659792	0.481	1.196
Natural	6.69967708	0.555	1.279
Natural	15.198178	0.693	1.921
Natural	5.636886	0.226	0.58
Natural	7.035872	0.388	0.994
Natural	7.302734	0.46	1.011
Natural	15.28084	0.743	1.846
Natural	7.999886	0.486	1.282
Natural	4.851688	0.279	0.716
Natural	4.958442	0.439	1.054
Natural	3.769016	0.743	1.544
Natural	3.19569182	0.516	1.073
Natural	1.273432	0.504	1.108
Natural	3.12464552	0.737	2.312
Natural	6.32228404	0.584	1.806
Natural	5.9648298	0.592	1.677
Natural	4.02564	0.45	1.08
Natural	7.26607	0.645	1.788
Natural	6.026388	0.651	1.918
;
Proc reg; model NGH=NGdifn;
Title 'regression on natural gap H by canopy openness';
output out=regNGH predicted=predNGH residual=residNGH;
Proc univariate plot normal;
var residNGH;
Title 'Normality test on natural gap H by canopy openness';
Proc plot;
Plot residNGH*predNGH;
Title 'residual graph on natural gap H by canopy openness';
Proc reg;Model NGE=NGdifn;
Title 'regression on natural gap evenn by canopy openness';
output out=regNGE predicted=predNGE residual=residNGE;
Proc univariate plot normal;
var residNGE;
Title 'Normality test on natural gap evenn by canopy openness';
Proc plot;
Plot residNGE*predNGE;
Title 'residual graph of natural gap evenn by canopy openness';
run;

Data CCcanopyopen;
Input CC $ CCE CCH CCdifn; 
Cards;
Non-gap	0.428	1.064	5.35392
Non-gap	0.412	1.057	4.0379
Non-gap	0.47	0.914	4.623062
Non-gap	0.889	2.407	6.722208
Non-gap	0.321	0.869	8.117976
Non-gap	0.967	1.557	4.19544
Non-gap	0.376	0.903	2.232804
Non-gap	0.581	0.805	0.740416
Non-gap	0.203	0.504	2.014194
Non-gap	0.535	1.175	2.51375956
Non-gap	0.594	1.475	5.296418
Non-gap	0.401	0.779	4.789056
Non-gap	0.462	1.28	7.019858
Non-gap	0.673	1.311	4.634486
Non-gap	0.682	1.932	4.115162
Non-gap	0.553	0.991	4.61064
Non-gap	0.498	0.892	2.796884
Non-gap	0.487	1.013	5.011356
Non-gap	0.699	1.253	3.27162
Non-gap	0.756	1.217	5.129412
Non-gap	0.775	1.611	6.827654
Non-gap	0.588	1.551	3.436452
Non-gap	0.612	1.467	6.65828
;
Proc reg; Model CCH=CCdifn;
Title 'regression on closed canopy H by canop openness';
output out=regCCH predicted=predCCh residual=residCCH;
Proc univariate plot normal;
var residCCH;
Title 'Normality test on closed canopy H by canopy openness';
Proc plot;
Plot residCCH*predCCH;
Title'residual graph on closed cnaopy H by canopy openness';

Proc reg; model CCE=CCdifn;
Title'regression on closed canopy evenn by cnaopy openness';
output out=regCCE predicted=predCCE residual=residCCE;
Proc univariate plot normal;
var residCCE;
Title'Normality test on closed canopy Evenn by canopy openness';
Proc plot;
Plot residCCE*predCCE;
Title'residual graph on closed canopy Evenn by canopy openness';
run;