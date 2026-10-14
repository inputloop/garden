# Column C — Will & work (how one acts): sources

Companion to `col-C.tsv`. Every source once. Verification routes actually run (2026-09-06):

- **pubmed** = the PubMed plugin (`lookup_article_by_citation` batch match on journal/year/volume/page/author,
  spot-checked with `get_article_metadata` for PMID→DOI/title; `search_articles` for one title query).
- **crossref** = Crossref REST API queried by title+author via curl (publisher metadata for the DOI: title,
  container, year, volume, pages). Counts as the "DOI/publisher page" route.
- **openlibrary** = Open Library search API by title+author (books). Counts as the web route for books.
- **http** = direct fetch of the flair URL (HTTP 200 + page `<title>` read back).

VERIFIED-2 = pubmed + crossref. VERIFIED-1 = one route only (for social-psychology journals PubMed returned
NOT_FOUND; the DOI is from Crossref). UNVERIFIED = neither route succeeded — kept and labelled.
No DOI or PMID below was typed from memory; each was read back from a route's response.

Tally (unique sources, counted by script over this file) — formal: 38 VERIFIED-2 · 34 VERIFIED-1 · 0 UNVERIFIED.
Flair: 40 VERIFIED-1 · 1 UNVERIFIED. Per-row slots in the TSV (72 formal): 44 VERIFIED-2 · 28 VERIFIED-1;
(48 flair): 47 VERIFIED-1 · 1 UNVERIFIED.
WebSearch was unavailable this session (session budget exhausted before this column started); the web route
was run with curl against Crossref, Open Library and the flair pages instead.

## Formal — taxonomy-level (shared across rows)

- Costa PT & McCrae RR (1995). Domains and facets: hierarchical personality assessment using the Revised NEO Personality Inventory. *J Pers Assess* 64(1):21-50. DOI:10.1207/s15327752jpa6401_2 PMID:16367732 — **VERIFIED-2** (pubmed, crossref). Rows C1-1..C1-6; also cited C2-1 (N5), C3-3 (C1 Competence).
- Ashton MC & Lee K (2007). Empirical, theoretical, and practical advantages of the HEXACO model of personality structure. *Pers Soc Psychol Rev* 11(2):150-166. DOI:10.1177/1088868306294907 PMID:18453460 — **VERIFIED-2** (pubmed, crossref). Background for the HEXACO C facets; not cited in a row's formal_n.
- Lee K & Ashton MC (2004). Psychometric properties of the HEXACO Personality Inventory. *Multivariate Behav Res* 39(2):329-358. DOI:10.1207/s15327906mbr3902_8 — **VERIFIED-1** (crossref). Rows C1-4 (Prudence); notes C1-1, C1-2, C2-5.
- DeYoung CG, Quilty LC & Peterson JB (2007). Between facets and domains: 10 aspects of the Big Five. *J Pers Soc Psychol* 93(5):880-896. DOI:10.1037/0022-3514.93.5.880 PMID:17983306 — **VERIFIED-2** (pubmed, crossref). Rows C1-1, C1-2.
- Roberts BW, Chernyshenko OS, Stark S & Goldberg LR (2005). The structure of conscientiousness: an empirical investigation based on seven major personality questionnaires. *Personnel Psychol* 58(1):103-139. DOI:10.1111/j.1744-6570.2005.00301.x — **VERIFIED-1** (crossref). Rows C1-2, C1-5; notes C1-1, C1-6.
- Roberts BW, Lejuez C, Krueger RF, Richards JM & Hill PL (2014). What is conscientiousness and how can it be assessed? *Dev Psychol* 50(5):1315-1330. DOI:10.1037/a0031109 PMID:23276130 — **VERIFIED-2** (pubmed, crossref). Background review; not cited in a row's formal_n.
- Dudley NM, Orvis KA, Lebiecki JE & Cortina JM (2006). A meta-analytic investigation of conscientiousness in the prediction of job performance: examining the intercorrelations and the incremental validity of narrow traits. *J Appl Psychol* 91(1):40-57. DOI:10.1037/0021-9010.91.1.40 PMID:16435937 — **VERIFIED-2** (pubmed, crossref). Rows C1-1 (Order), C1-4 (Cautiousness), C1-5 (Achievement), C1-6 (Dependability) — the facet-level meta-analysis.
- Zuckerman M, Eysenck S & Eysenck HJ (1978). Sensation seeking in England and America: cross-cultural, age, and sex comparisons. *J Consult Clin Psychol* 46(1):139-149. DOI:10.1037/0022-006X.46.1.139 PMID:627648 — **VERIFIED-2** (pubmed, crossref). Rows C4-1, C4-4.
- Zuckerman M (1994). *Behavioral Expressions and Biosocial Bases of Sensation Seeking.* Cambridge University Press. https://openlibrary.org/works/OL1935674W — **VERIFIED-1** (openlibrary). Notes C4-1, C4-4.
- Cloninger CR, Svrakic DM & Przybeck TR (1993). A psychobiological model of temperament and character. *Arch Gen Psychiatry* 50(12):975-990. DOI:10.1001/archpsyc.1993.01820240059008 PMID:8250684 — **VERIFIED-2** (pubmed, crossref). Row C4-5.
- Weber EU, Blais AR & Betz NE (2002). A domain-specific risk-attitude scale: measuring risk perceptions and risk behaviors. *J Behav Decis Mak* 15(4):263-290. DOI:10.1002/bdm.414 — **VERIFIED-1** (crossref). Row C4-2.
- Blais AR & Weber EU (2006). A Domain-Specific Risk-Taking (DOSPERT) scale for adult populations. *Judgm Decis Mak* 1(1):33-47. DOI:10.1017/S1930297500000334 — **VERIFIED-1** (crossref). Row C4-2.
- Deci EL & Ryan RM (2000). The "what" and "why" of goal pursuits: human needs and the self-determination of behavior. *Psychol Inq* 11(4):227-268. DOI:10.1207/S15327965PLI1104_01 — **VERIFIED-1** (crossref). Row C3-5.
- Elliot AJ & McGregor HA (2001). A 2 x 2 achievement goal framework. *J Pers Soc Psychol* 80(3):501-519. DOI:10.1037/0022-3514.80.3.501 PMID:11300582 — **VERIFIED-2** (pubmed, crossref). Row C3-6.
- Whiteside SP & Lynam DR (2001). The Five Factor Model and impulsivity: using a structural model of personality to understand impulsivity. *Pers Individ Dif* 30(4):669-689. DOI:10.1016/S0191-8869(00)00064-7 — **VERIFIED-1** (crossref). Row C2-1.

## Formal — trait-specific

### C1 Conscientiousness core
- MacCann C, Duckworth AL & Roberts RD (2009). Empirical identification of the major facets of conscientiousness. *Learn Individ Differ* 19(4):451-458. DOI:10.1016/j.lindif.2009.03.007 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C1-2.
- Bogg T & Roberts BW (2004). Conscientiousness and health-related behaviors: a meta-analysis of the leading behavioral contributors to mortality. *Psychol Bull* 130(6):887-919. DOI:10.1037/0033-2909.130.6.887 PMID:15535742 — **VERIFIED-2** (pubmed, crossref). Note C1-2.
- Tangney JP, Baumeister RF & Boone AL (2004). High self-control predicts good adjustment, less pathology, better grades, and interpersonal success. *J Pers* 72(2):271-324. DOI:10.1111/j.0022-3506.2004.00263.x PMID:15016066 — **VERIFIED-2** (pubmed, crossref). Row C1-3.
- Duckworth AL & Seligman MEP (2005). Self-discipline outdoes IQ in predicting academic performance of adolescents. *Psychol Sci* 16(12):939-944. DOI:10.1111/j.1467-9280.2005.01641.x PMID:16313657 — **VERIFIED-2** (pubmed, crossref). Row C1-3.
- Patton JH, Stanford MS & Barratt ES (1995). Factor structure of the Barratt Impulsiveness Scale. *J Clin Psychol* 51(6):768-774. DOI:10.1002/1097-4679(199511)51:6<768::AID-JCLP2270510607>3.0.CO;2-1 PMID:8778124 — **VERIFIED-2** (pubmed, crossref). Row C2-1; note C1-4.
- Jackson JJ, Wood D, Bogg T, Walton KE, Harms PD & Roberts BW (2010). What do conscientious people do? Development and validation of the Behavioral Indicators of Conscientiousness (BIC). *J Res Pers* 44(4):501-511. DOI:10.1016/j.jrp.2010.06.005 PMID:21278818 — **VERIFIED-2** (pubmed, crossref). Row C1-6.

### C2 Self-regulation
- Sharma L, Markon KE & Clark LA (2014). Toward a theory of distinct types of "impulsive" behaviors: a meta-analysis of self-report and behavioral measures. *Psychol Bull* 140(2):374-408. DOI:10.1037/a0034418 PMID:24099400 — **VERIFIED-2** (pubmed, crossref). Rows C2-1, C4-4.
- Mischel W, Shoda Y & Rodriguez MI (1989). Delay of gratification in children. *Science* 244(4907):933-938. DOI:10.1126/science.2658056 PMID:2658056 — **VERIFIED-2** (pubmed, crossref). Row C2-2.
- Hoerger M, Quirk SW & Weed NC (2011). Development and validation of the Delaying Gratification Inventory. *Psychol Assess* 23(3):725-738. DOI:10.1037/a0023286 PMID:21480721 — **VERIFIED-2** (pubmed, crossref). Row C2-2.
- Duckworth AL, Tsukayama E & Kirby TA (2013). Is it really self-control? Examining the predictive power of the delay of gratification task. *Pers Soc Psychol Bull* 39(7):843-855. DOI:10.1177/0146167213482589 PMID:23813422 — **VERIFIED-2** (pubmed, crossref). Row C2-2.
- Duckworth AL, Peterson C, Matthews MD & Kelly DR (2007). Grit: perseverance and passion for long-term goals. *J Pers Soc Psychol* 92(6):1087-1101. DOI:10.1037/0022-3514.92.6.1087 PMID:17547490 — **VERIFIED-2** (pubmed, crossref). Row C2-3.
- Duckworth AL & Quinn PD (2009). Development and validation of the Short Grit Scale (Grit-S). *J Pers Assess* 91(2):166-174. DOI:10.1080/00223890802634290 PMID:19205937 — **VERIFIED-2** (pubmed, crossref). Row C2-3.
- Credé M, Tynan MC & Harms PD (2017). Much ado about grit: a meta-analytic synthesis of the grit literature. *J Pers Soc Psychol* 113(3):492-511. DOI:10.1037/pspp0000102 PMID:27845531 — **VERIFIED-2** (pubmed, crossref). Row C2-3.
- Steel P (2007). The nature of procrastination: a meta-analytic and theoretical review of quintessential self-regulatory failure. *Psychol Bull* 133(1):65-94. DOI:10.1037/0033-2909.133.1.65 PMID:17201571 — **VERIFIED-2** (pubmed, crossref). Row C2-4.
- Lay CH (1986). At last, my research article on procrastination. *J Res Pers* 20(4):474-495. DOI:10.1016/0092-6566(86)90127-3 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C2-4.
- Sirois F & Pychyl T (2013). Procrastination and the priority of short-term mood regulation: consequences for future self. *Soc Personal Psychol Compass* 7(2):115-127. DOI:10.1111/spc3.12011 — **VERIFIED-1** (crossref). Row C2-4.
- Frost RO, Marten P, Lahart C & Rosenblate R (1990). The dimensions of perfectionism. *Cognit Ther Res* 14(5):449-468. DOI:10.1007/BF01172967 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C2-5.
- Hewitt PL & Flett GL (1991). Perfectionism in the self and social contexts: conceptualization, assessment, and association with psychopathology. *J Pers Soc Psychol* 60(3):456-470. DOI:10.1037/0022-3514.60.3.456 PMID:2027080 — **VERIFIED-2** (pubmed, crossref). Row C2-5.
- Stoeber J & Otto K (2006). Positive conceptions of perfectionism: approaches, evidence, challenges. *Pers Soc Psychol Rev* 10(4):295-319. DOI:10.1207/s15327957pspr1004_2 PMID:17201590 — **VERIFIED-2** (pubmed, crossref). Row C2-5.
- Ludwig RM, Srivastava S & Berkman ET (2018). Planfulness: a process-focused construct of individual differences in goal achievement. *Collabra Psychol* 4(1):28. DOI:10.1525/collabra.136 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C2-6. (Crossref lists the 2017 PsyArXiv preprint DOI:10.31234/osf.io/yuqma as well; the journal DOI is cited.)
- Strathman A, Gleicher F, Boninger DS & Edwards CS (1994). The consideration of future consequences: weighing immediate and distant outcomes of behavior. *J Pers Soc Psychol* 66(4):742-752. DOI:10.1037/0022-3514.66.4.742 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C2-6.
- Zimbardo PG & Boyd JN (1999). Putting time in perspective: a valid, reliable individual-differences metric. *J Pers Soc Psychol* 77(6):1271-1288. DOI:10.1037/0022-3514.77.6.1271 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C2-6.

### C3 Agency & drive
- Judge TA & Kammeyer-Mueller JD (2012). On the value of aiming high: the causes and consequences of ambition. *J Appl Psychol* 97(4):758-775. DOI:10.1037/a0028084 PMID:22545622 — **VERIFIED-2** (pubmed incl. metadata read-back, crossref). Row C3-1.
- Jones AB, Sherman RA & Hogan RT (2017). Where is ambition in factor models of personality? *Pers Individ Dif* 106:26-31. DOI:10.1016/j.paid.2016.09.057 — **VERIFIED-1** (crossref). Row C3-1.
- Hirschi A & Spurk D (2021). Ambitious employees: why and when ambition relates to performance and organizational commitment. *J Vocat Behav* 127:103576. DOI:10.1016/j.jvb.2021.103576 — **VERIFIED-1** (crossref). Row C3-1.
- Smither RD & Houston JM (1992). The nature of competitiveness: the development and validation of the Competitiveness Index. *Educ Psychol Meas* 52(2):407-418. DOI:10.1177/0013164492052002016 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C3-2.
- Houston JM, Harris PB, McIntire S & Francis D (2002). Revising the Competitiveness Index using factor analysis. *Psychol Rep* 90(1):31-34. DOI:10.2466/pr0.2002.90.1.31 PMID:11899003 — **VERIFIED-2** (pubmed incl. metadata read-back, crossref). Row C3-2.
- Ryckman RM, Hammer M, Kaczor LM & Gold JA (1990). Construction of a Hypercompetitive Attitude Scale. *J Pers Assess* 55(3-4):630-639. DOI:10.1207/s15327752jpa5503&4_19 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C3-2.
- Bandura A (1977). Self-efficacy: toward a unifying theory of behavioral change. *Psychol Rev* 84(2):191-215. DOI:10.1037/0033-295X.84.2.191 PMID:847061 — **VERIFIED-2** (pubmed, crossref). Row C3-3.
- Chen G, Gully SM & Eden D (2001). Validation of a new general self-efficacy scale. *Organ Res Methods* 4(1):62-83. DOI:10.1177/109442810141004 — **VERIFIED-1** (crossref). Row C3-3.
- Stajkovic AD & Luthans F (1998). Self-efficacy and work-related performance: a meta-analysis. *Psychol Bull* 124(2):240-261. DOI:10.1037/0033-2909.124.2.240 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C3-3.
- Bateman TS & Crant JM (1993). The proactive component of organizational behavior: a measure and correlates. *J Organ Behav* 14(2):103-118. DOI:10.1002/job.4030140202 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C3-4.
- Seibert SE, Crant JM & Kraimer ML (1999). Proactive personality and career success. *J Appl Psychol* 84(3):416-427. DOI:10.1037/0021-9010.84.3.416 PMID:10380421 — **VERIFIED-2** (pubmed, crossref). Row C3-4.
- Fuller B Jr & Marler LE (2009). Change driven by nature: a meta-analytic review of the proactive personality literature. *J Vocat Behav* 75(3):329-345. DOI:10.1016/j.jvb.2009.05.008 — **VERIFIED-1** (crossref). Row C3-4.
- Tornau K & Frese M (2013). Construct clean-up in proactivity research: a meta-analysis on the nomological net of work-related proactivity concepts and their incremental validities. *Appl Psychol* 62(1):44-96. DOI:10.1111/j.1464-0597.2012.00514.x — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Note C3-4.
- Ryan RM & Deci EL (2006). Self-regulation and the problem of human autonomy: does psychology need choice, self-determination, and will? *J Pers* 74(6):1557-1585. DOI:10.1111/j.1467-6494.2006.00420.x PMID:17083658 — **VERIFIED-2** (pubmed, crossref). Row C3-5.
- Weinstein N, Przybylski AK & Ryan RM (2012). The index of autonomous functioning: development of a scale of human autonomy. *J Res Pers* 46(4):397-413. DOI:10.1016/j.jrp.2012.03.007 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C3-5.
- Koestner R & Losier GF (1996). Distinguishing reactive versus reflective autonomy. *J Pers* 64(2):465-494. DOI:10.1111/j.1467-6494.1996.tb00518.x — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Note C3-5.
- Dweck CS & Leggett EL (1988). A social-cognitive approach to motivation and personality. *Psychol Rev* 95(2):256-273. DOI:10.1037/0033-295X.95.2.256 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Row C3-6.
- Payne SC, Youngcourt SS & Beaubien JM (2007). A meta-analytic examination of the goal orientation nomological net. *J Appl Psychol* 92(1):128-150. DOI:10.1037/0021-9010.92.1.128 PMID:17227156 — **VERIFIED-2** (pubmed, crossref). Row C3-6.
- VandeWalle D (1997). Development and validation of a work domain goal orientation instrument. *Educ Psychol Meas* 57(6):995-1015. DOI:10.1177/0013164497057006009 — **VERIFIED-1** (crossref). Note C3-6.

### C4 Risk & sensation
- Arnett J (1994). Sensation seeking: a new conceptualization and a new scale. *Pers Individ Dif* 16(2):289-296. DOI:10.1016/0191-8869(94)90165-1 — **VERIFIED-1** (crossref). Row C4-1.
- Hoyle RH, Stephenson MT, Palmgreen P, Lorch EP & Donohew RL (2002). Reliability and validity of a brief measure of sensation seeking. *Pers Individ Dif* 32(3):401-414. DOI:10.1016/S0191-8869(01)00032-0 — **VERIFIED-1** (crossref). Row C4-1.
- Roberti JW (2004). A review of behavioral and biological correlates of sensation seeking. *J Res Pers* 38(3):256-279. DOI:10.1016/S0092-6566(03)00067-9 — **VERIFIED-1** (crossref; pubmed NOT_FOUND). Note C4-1.
- Stephenson MT, Velez LF, Chalela P, Ramirez A & Hoyle RH (2007). The reliability and validity of the Brief Sensation Seeking Scale (BSSS-8) with young adult Latino workers. *Addiction* 102(Suppl 2):79-91. DOI:10.1111/j.1360-0443.2007.01958.x PMID:17850617 — **VERIFIED-2** (pubmed incl. metadata read-back, crossref). Note C4-1.
- Frey R, Pedroni A, Mata R, Rieskamp J & Hertwig R (2017). Risk preference shares the psychometric structure of major psychological traits. *Sci Adv* 3(10):e1701381. DOI:10.1126/sciadv.1701381 PMID:28983511 — **VERIFIED-2** (pubmed, crossref). Row C4-2.
- Nicholson N, Soane E, Fenton-O'Creevy M & Willman P (2005). Personality and domain-specific risk taking. *J Risk Res* 8(2):157-176. DOI:10.1080/1366987032000123856 — **VERIFIED-1** (crossref). Note C4-2.
- Atkinson JW (1957). Motivational determinants of risk-taking behavior. *Psychol Rev* 64(6):359-372. DOI:10.1037/h0043445 PMID:13505972 — **VERIFIED-2** (pubmed metadata read-back, crossref). Row C4-3.
- Conroy DE, Willow JP & Metzler JN (2002). Multidimensional fear of failure measurement: the Performance Failure Appraisal Inventory. *J Appl Sport Psychol* 14(2):76-90. DOI:10.1080/10413200252907752 — **VERIFIED-1** (crossref). Row C4-3.
- Elliot AJ & Thrash TM (2004). The intergenerational transmission of fear of failure. *Pers Soc Psychol Bull* 30(8):957-971. DOI:10.1177/0146167203262024 PMID:15257781 — **VERIFIED-2** (pubmed, crossref). Row C4-3.
- Patrick CJ, Fowles DC & Krueger RF (2009). Triarchic conceptualization of psychopathy: developmental origins of disinhibition, boldness, and meanness. *Dev Psychopathol* 21(3):913-938. DOI:10.1017/S0954579409000492 PMID:19583890 — **VERIFIED-2** (pubmed incl. metadata read-back, crossref). Row C4-4 (construct definition only; clinical model).
- Cloninger CR, Przybeck TR & Svrakic DM (1991). The Tridimensional Personality Questionnaire: U.S. normative data. *Psychol Rep* 69(3):1047-1057. DOI:10.2466/pr0.1991.69.3.1047 PMID:1784653 — **VERIFIED-2** (pubmed incl. metadata read-back, crossref). Row C4-5.
- Miettunen J, Veijola J, Lauronen E, Kantojärvi L & Joukamaa M (2007). Sex differences in Cloninger's temperament dimensions — a meta-analysis. *Compr Psychiatry* 48(2):161-169. DOI:10.1016/j.comppsych.2006.10.007 PMID:17292707 — **VERIFIED-2** (pubmed, crossref). Row C4-5.
- Carver CS & White TL (1994). Behavioral inhibition, behavioral activation, and affective responses to impending reward and punishment: the BIS/BAS scales. *J Pers Soc Psychol* 67(2):319-333. DOI:10.1037/0022-3514.67.2.319 — **VERIFIED-1** (crossref; pubmed citation-match and title search both returned nothing). Note C4-5.
- Frost RO & Shows DL (1993). The nature and measurement of compulsive indecisiveness. *Behav Res Ther* 31(7):683-692. DOI:10.1016/0005-7967(93)90121-A PMID:8216169 — **VERIFIED-2** (pubmed incl. metadata read-back, crossref). Row C4-6.
- Germeijs V & De Boeck P (2002). A measurement scale for indecisiveness and its relationship to career indecision and other types of indecision. *Eur J Psychol Assess* 18(2):113-122. DOI:10.1027//1015-5759.18.2.113 — **VERIFIED-1** (crossref). Row C4-6.
- Webster DM & Kruglanski AW (1994). Individual differences in need for cognitive closure. *J Pers Soc Psychol* 67(6):1049-1062. DOI:10.1037/0022-3514.67.6.1049 PMID:7815301 — **VERIFIED-2** (pubmed, crossref). Row C4-6.

## Flair

Magazines / blogs (route: http fetch, HTTP 200 and page title read back)
- Psychology Today — Conscientiousness — https://www.psychologytoday.com/us/basics/conscientiousness — VERIFIED-1. C1-1, C1-6.
- Psychology Today — Productivity — https://www.psychologytoday.com/us/basics/productivity — VERIFIED-1. C1-2.
- Psychology Today — Self-Control — https://www.psychologytoday.com/us/basics/self-control — VERIFIED-1. C1-3, C2-1.
- Psychology Today — Motivation — https://www.psychologytoday.com/us/basics/motivation — VERIFIED-1. C1-5.
- Psychology Today — Grit — https://www.psychologytoday.com/us/basics/grit — VERIFIED-1. C2-3.
- Psychology Today — Procrastination — https://www.psychologytoday.com/us/basics/procrastination — VERIFIED-1. C2-4.
- Psychology Today — Perfectionism — https://www.psychologytoday.com/us/basics/perfectionism — VERIFIED-1. C2-5.
- Psychology Today — Time Management — https://www.psychologytoday.com/us/basics/time-management — VERIFIED-1. C2-6.
- Psychology Today — Career — https://www.psychologytoday.com/us/basics/career — VERIFIED-1. C3-1.
- Psychology Today — Confidence — https://www.psychologytoday.com/us/basics/confidence — VERIFIED-1. C3-3.
- Psychology Today — Leadership — https://www.psychologytoday.com/us/basics/leadership — VERIFIED-1. C3-4.
- Psychology Today — Sensation-Seeking — https://www.psychologytoday.com/us/basics/sensation-seeking — VERIFIED-1. C4-1, C4-4. (Col A marked this UNVERIFIED; it fetched 200 here.)
- Psychology Today — Fear — https://www.psychologytoday.com/us/basics/fear — VERIFIED-1. C4-3, C4-5.
- Psychology Today — Decision-Making — https://www.psychologytoday.com/us/basics/decision-making — VERIFIED-1. Note C4-6.
- Wait But Why (Tim Urban) — Why Procrastinators Procrastinate (2013) — https://waitbutwhy.com/2013/10/why-procrastinators-procrastinate.html — VERIFIED-1. C2-4.
- James Clear (blog) — The Marshmallow Experiment and the Power of Delayed Gratification — https://jamesclear.com/delayed-gratification — VERIFIED-1. C2-2.
- Scientific American — The Secret to Raising Smart Kids (Carol Dweck) — https://www.scientificamerican.com/article/the-secret-to-raising-smart-kids1/ — VERIFIED-1. C3-6.
- Psychology Today pages tried and NOT found (404, so not cited): impulsivity, ambition, competition, self-efficacy, delayed-gratification, risk-taking, self-determination-theory, fear-of-failure, goal-setting, workaholism, laziness, adventure, success.

Popular books (route: Open Library search API; work URL read back)
- Marie Kondo — The Life-Changing Magic of Tidying Up (2014) — https://openlibrary.org/works/OL17080845W — VERIFIED-1. C1-1.
- Cal Newport — Deep Work (2016) — https://openlibrary.org/works/OL17713267W — VERIFIED-1. C1-2.
- Kelly McGonigal — The Willpower Instinct (2011) — https://openlibrary.org/works/OL16184230W — VERIFIED-1. C1-3.
- Daniel Kahneman — Thinking, Fast and Slow (2011) — https://openlibrary.org/works/OL15992072W — VERIFIED-1. C1-4, C4-2, C4-5.
- Malcolm Gladwell — Blink (2005) — https://openlibrary.org/works/OL5749849W — VERIFIED-1. C1-4 (contrast).
- Angela Duckworth — Grit (2016) — https://openlibrary.org/works/OL17361140W — VERIFIED-1. C1-5, C2-3.
- David Brooks — The Road to Character (2015) — https://openlibrary.org/works/OL17364754W — VERIFIED-1. C1-6.
- Roy F. Baumeister & John Tierney — Willpower (2011) — https://openlibrary.org/works/OL20058191W — VERIFIED-1. C2-1.
- Walter Mischel — The Marshmallow Test (2014) — https://openlibrary.org/works/OL19670523W — VERIFIED-1. C2-2.
- Brené Brown — The Gifts of Imperfection (2010) — https://openlibrary.org/works/OL16010306W — VERIFIED-1. C2-5.
- Philip Zimbardo & John Boyd — The Time Paradox (2008) — https://openlibrary.org/works/OL23487W — VERIFIED-1 (Open Library's first-publish year reads 1998; publisher date is 2008). C2-6.
- Po Bronson & Ashley Merryman — Top Dog (2013) — https://openlibrary.org/works/OL19961737W — VERIFIED-1. C3-2.
- Alfie Kohn — No Contest: The Case Against Competition (1986) — https://openlibrary.org/works/OL1908440W — VERIFIED-1. C3-2.
- Carol Dweck — Mindset (2006) — https://openlibrary.org/works/OL2003465W — VERIFIED-1. C3-3, C3-6.
- Stephen R. Covey — The 7 Habits of Highly Effective People (1989) — https://openlibrary.org/works/OL2629977W — VERIFIED-1. C3-4.
- Daniel H. Pink — Drive (2009) — https://openlibrary.org/works/OL15016965W — VERIFIED-1. C3-5.
- Edward L. Deci with Richard Flaste — Why We Do What We Do (1995) — https://openlibrary.org/works/OL3740738W — VERIFIED-1. C3-5.
- Michael J. Apter — The Dangerous Edge: The Psychology of Excitement (1992) — https://openlibrary.org/works/OL10546917W — VERIFIED-1. C4-1.
- Nassim Nicholas Taleb — Antifragile (2012) — https://openlibrary.org/works/OL16726829W — VERIFIED-1. C4-2.
- Brené Brown — Daring Greatly (2012) — https://openlibrary.org/works/OL16664399W — VERIFIED-1. C4-3.
- Daniel Nettle — Personality: What Makes You the Way You Are (2007) — https://openlibrary.org/works/OL15325469W — VERIFIED-1. C4-4.
- Chip Heath & Dan Heath — Decisive (2013) — https://openlibrary.org/works/OL19624251W — VERIFIED-1. C4-6.
- Barry Schwartz — The Paradox of Choice (2004) — https://openlibrary.org/works/OL272375W — VERIFIED-1. C4-6.
- Ryan Holiday — Ego Is the Enemy (2016) — **UNVERIFIED** (Open Library request failed on connection twice; not an absence finding). C3-1.

## Replacements from the starting list (why)
- C2-6 **Prudence → Planfulness.** HEXACO Prudence = NEO Deliberation (C1-4); a duplicate. Planfulness (Ludwig 2018; CFC; ZTPI-Future) adds future orientation.
- C3-3 **Need for Achievement → Self-Efficacy.** nAch would be the fourth of {Achievement Striving, Industriousness, Ambition}; the agency *belief* had no row.
- C4-3 **Thrill & Adventure Seeking → Fear of Failure.** TAS is a subscale of C4-1 and its risk content is inside DOSPERT (C4-2); Atkinson's avoidance motive is the missing pole of "risk".

## Overlaps noticed (for the assembler)
- Col A Excitement Seeking (NEO E5) ↔ C4-1 Sensation Seeking (full SSS); col A Endurance ↔ C2-3 Grit; col A Anxiety / Stress Reactivity ↔ C4-5 Harm Avoidance and C4-3 Fear of Failure; col A Assertiveness ↔ C3-2 Competitiveness / C3-4 Proactivity.
- Likely other columns: C1-6 Dutifulness ↔ Honesty-Humility/morality; C3-3 Self-Efficacy ↔ self-esteem / locus of control / core self-evaluations; C3-6 Mastery Orientation ↔ Curiosity/Openness.
- Inside this column: {C1-2, C1-5, C3-1} are a cluster (effort / standard / status); {C1-3, C2-1, C2-2, C2-4} are the self-control cluster; {C1-4, C4-6} are a tension pair.
