# Column E — Self & shadow — sources (2026-09-06)

Every source once. Verification state and the route(s) that produced it.
Routes: **pubmed** = the PubMed plugin (search_articles / get_article_metadata; PMID + DOI as returned);
**web** = WebSearch result page; **crossref** = `api.crossref.org/works/<DOI>` or a bibliographic query
resolved from the sandbox shell (a DOI-registry page — counts as the publisher/DOI route);
**http** = the URL answered HTTP 200 to a HEAD/GET from the sandbox (existence only, content not read).
VERIFIED-2 = pubmed + (web|crossref). VERIFIED-1 = one route. UNVERIFIED = neither — kept, said so.

Observed, not judged: a row below records that a source exists with the identifiers shown. What it
supports (a level word, a neighbour) is the TSV's judgement, not the source's.

Session note: the shared WebSearch budget ran out after 17 searches for this column (200/200 session-wide);
the remaining second-route checks were made against Crossref and by HTTP status from the sandbox.
`web_fetch` was rate-limited (HTTP 429) and returned empty bodies — not used as a route.

## Formal — taxonomy-level (shared across rows)

- Ashton MC & Lee K (2007). Empirical, theoretical, and practical advantages of the HEXACO model of personality structure. *Pers Soc Psychol Rev* 11(2):150-166. DOI:10.1177/1088868306294907 PMID:18453460 — **VERIFIED-2** (pubmed, crossref). Rows E3-1..E3-4.
- Lee K & Ashton MC (2004). Psychometric properties of the HEXACO Personality Inventory. *Multivariate Behav Res* 39(2):329-358. DOI:10.1207/s15327906mbr3902_8 — **VERIFIED-1** (crossref). E3-1.
- Ashton MC, Lee K & de Vries RE (2014). The HEXACO Honesty-Humility, Agreeableness, and Emotionality factors: a review of research and theory. *Pers Soc Psychol Rev* 18(2):139-152. DOI:10.1177/1088868314523838 PMID:24577101 — **VERIFIED-2** (PMID carried from the col-A record; crossref here). E3-1 note.
- Paulhus DL & Williams KM (2002). The Dark Triad of personality: narcissism, Machiavellianism, and psychopathy. *J Res Pers* 36(6):556-563. DOI:10.1016/S0092-6566(02)00505-6 — **VERIFIED-1** (web, crossref). E2-1, E2-2.
- Jones DN & Paulhus DL (2014). Introducing the Short Dark Triad (SD3): a brief measure of dark personality traits. *Assessment* 21(1):28-41. DOI:10.1177/1073191113514105 PMID:24322012 — **VERIFIED-2** (pubmed, crossref). E2-1, E2-2.
- Muris P, Merckelbach H, Otgaar H & Meijer E (2017). The malevolent side of human nature: a meta-analysis and critical review of the literature on the dark triad. *Perspect Psychol Sci* 12(2):183-204. DOI:10.1177/1745691616666070 PMID:28346115 — **VERIFIED-2** (pubmed, crossref). E2-1.
- Marcus DK & Zeigler-Hill V (2015). A big tent of dark personality traits. *Soc Personal Psychol Compass* 9(8):434-446. DOI:10.1111/spc3.12185 — **VERIFIED-1** (web, crossref). E2-6 note.
- Judge TA, Erez A, Bono JE & Thoresen CJ (2002). Are measures of self-esteem, neuroticism, locus of control, and generalized self-efficacy indicators of a common core construct? *J Pers Soc Psychol* 83(3):693-710. DOI:10.1037/0022-3514.83.3.693 PMID:12219863 — **VERIFIED-2** (pubmed, crossref). E1-1, E1-2, E4-1 notes.
- Tangney JP, Stuewig J & Mashek DJ (2007). Moral emotions and moral behavior. *Annu Rev Psychol* 58:345-372. DOI:10.1146/annurev.psych.56.091103.070145 PMID:16953797 — **VERIFIED-2** (pubmed, crossref). E4-6, E3-5 note.
- Tangney JP & Dearing RL (2002). *Shame and Guilt*. New York: Guilford. — **VERIFIED-1** (web: Guilford/Routledge pages). E4-6 note.
- Christie R & Geis FL (1970). *Studies in Machiavellianism*. New York: Academic Press. — **VERIFIED-1** (crossref chapter records under the book title). E2-1 note.
- Gross JJ (1998). The emerging field of emotion regulation: an integrative review. *Rev Gen Psychol* 2(3):271-299. DOI:10.1037/1089-2680.2.3.271 — **VERIFIED-1** (web, crossref). E4-3 note.
- Higgins ET (1997). Beyond pleasure and pain. *Am Psychol* 52(12):1280-1300. DOI:10.1037/0003-066X.52.12.1280 PMID:9414606 — **VERIFIED-2** (pubmed, crossref). E4-5.
- Bandura A (1977). Self-efficacy: toward a unifying theory of behavioral change. *Psychol Rev* 84(2):191-215. DOI:10.1037/0033-295X.84.2.191 PMID:847061 — **VERIFIED-2** (pubmed, crossref). E1-2.

## Formal — trait-specific

### E1 Identity
- Rosenberg M (1965). *Society and the Adolescent Self-Image*. Princeton NJ: Princeton University Press. — **UNVERIFIED** (the one web search that named it returned only the GSE; no second attempt possible). E1-1 note.
- Robins RW, Hendin HM & Trzesniewski KH (2001). Measuring global self-esteem: construct validation of a single-item measure and the Rosenberg Self-Esteem Scale. *Pers Soc Psychol Bull* 27(2):151-161. DOI:10.1177/0146167201272002 — **VERIFIED-1** (web, crossref; pubmed empty). E1-1.
- Sowislo JF & Orth U (2013). Does low self-esteem predict depression and anxiety? A meta-analysis of longitudinal studies. *Psychol Bull* 139(1):213-240. DOI:10.1037/a0028931 PMID:22730921 — **VERIFIED-2**. E1-1.
- Orth U, Robins RW & Widaman KF (2012). Life-span development of self-esteem and its effects on important life outcomes. *J Pers Soc Psychol* 102(6):1271-1288. DOI:10.1037/a0025558 PMID:21942279 — **VERIFIED-2**. E1-1.
- Luszczynska A, Scholz U & Schwarzer R (2005). The general self-efficacy scale: multicultural validation studies. *J Psychol* 139(5):439-457. DOI:10.3200/JRLP.139.5.439-457 PMID:16285214 — **VERIFIED-2**. E1-2.
- Schwarzer R & Jerusalem M (1995). Generalized Self-Efficacy scale. In Weinman J, Wright S & Johnston M (eds) *Measures in Health Psychology: A User's Portfolio*, 35-37. Windsor: NFER-NELSON. — **VERIFIED-1** (web). E1-2.
- Chen G, Gully SM & Eden D (2001). Validation of a new general self-efficacy scale. *Organ Res Methods* 4(1):62-83. DOI:10.1177/109442810141004 — **VERIFIED-1** (crossref). E1-2 note.
- Campbell JD, Trapnell PD, Heine SJ, Katz IM, Lavallee LF & Lehman DR (1996). Self-concept clarity: measurement, personality correlates, and cultural boundaries. *J Pers Soc Psychol* 70(1):141-156. DOI:10.1037/0022-3514.70.1.141 — **VERIFIED-1** (web, crossref; pubmed empty). E1-3.
- Lodi-Smith J & Roberts BW (2010). Getting to know me: social role experiences and age differences in self-concept clarity during adulthood. *J Pers* 78(5):1383-1410. DOI:10.1111/j.1467-6494.2010.00655.x PMID:20663028 — **VERIFIED-2**. E1-3.
- Na J, Chan MY, Lodi-Smith J & Park DC (2016). Social-class differences in self-concept clarity and their implications for well-being. *J Health Psychol* 23(7):951-960. DOI:10.1177/1359105316643597 PMID:27114215 — **VERIFIED-2**. E1-3.
- Neff KD (2003). The development and validation of a scale to measure self-compassion. *Self Identity* 2(3):223-250. DOI:10.1080/15298860309027 — **VERIFIED-1** (web, crossref). E1-4.
- Neff KD (2003). Self-compassion: an alternative conceptualization of a healthy attitude toward oneself. *Self Identity* 2(2):85-101. DOI:10.1080/15298860309032 — **VERIFIED-1** (crossref). E1-4 note.
- MacBeth A & Gumley A (2012). Exploring compassion: a meta-analysis of the association between self-compassion and psychopathology. *Clin Psychol Rev* 32(6):545-552. DOI:10.1016/j.cpr.2012.06.003 PMID:22796446 — **VERIFIED-2**. E1-4.
- Raes F, Pommier E, Neff KD & Van Gucht D (2011). Construction and factorial validation of a short form of the Self-Compassion Scale. *Clin Psychol Psychother* 18(3):250-255. DOI:10.1002/cpp.702 PMID:21584907 — **VERIFIED-2**. E1-4.
- Wood AM, Linley PA, Maltby J, Baliousis M & Joseph S (2008). The authentic personality: a theoretical and empirical conceptualization and the development of the Authenticity Scale. *J Couns Psychol* 55(3):385-399. DOI:10.1037/0022-0167.55.3.385 — **VERIFIED-1** (web, crossref; pubmed empty). E1-5.
- Kernis MH & Goldman BM (2006). A multicomponent conceptualization of authenticity: theory and research. *Adv Exp Soc Psychol* 38:283-357. DOI:10.1016/S0065-2601(06)38006-9 — **VERIFIED-1** (crossref). E1-5.
- Sutton A (2020). Living the good life: a meta-analysis of authenticity, well-being and engagement. *Pers Individ Dif* 153:109645. DOI:10.1016/j.paid.2019.109645 — **VERIFIED-1** (crossref). E1-5.
- Heppner WL, Kernis MH, Nezlek JB, Foster J, Lakey CE & Goldman BM (2008). Within-person relationships among daily self-esteem, need satisfaction, and authenticity. *Psychol Sci* 19(11):1140-1145. DOI:10.1111/j.1467-9280.2008.02215.x PMID:19076486 — **VERIFIED-2**. E1-5 note.
- Marcia JE (1966). Development and validation of ego-identity status. *J Pers Soc Psychol* 3(5):551-558. DOI:10.1037/h0023281 PMID:5939604 — **VERIFIED-2**. E1-6.
- Luyckx K, Schwartz SJ, Berzonsky MD, Soenens B, Vansteenkiste M, Smits I & Goossens L (2008). Capturing ruminative exploration: extending the four-dimensional model of identity formation in late adolescence. *J Res Pers* 42(1):58-82. DOI:10.1016/j.jrp.2007.04.004 — **VERIFIED-1** (web, crossref). E1-6.
- Kroger J, Martinussen M & Marcia JE (2010). Identity status change during adolescence and young adulthood: a meta-analysis. *J Adolesc* 33(5):683-698. DOI:10.1016/j.adolescence.2009.11.002 PMID:20004962 — **VERIFIED-2**. E1-6.
- McAdams DP & McLean KC (2013). Narrative identity. *Curr Dir Psychol Sci* 22(3):233-238. DOI:10.1177/0963721413475622 — **VERIFIED-1** (crossref). E1-6 note (the replaced alternative).

### E2 Dark traits
- Dahling JJ, Whitaker BG & Levy PE (2009). The development and validation of a new Machiavellianism scale. *J Manag* 35(2):219-257. DOI:10.1177/0149206308318618 — **VERIFIED-1** (crossref). E2-1.
- Rauthmann JF & Will T (2013). Investigating the MACH-IV with item response theory and proposing the trimmed MACH*. *J Pers Assess* 95(4):388-397. DOI:10.1080/00223891.2012.742905 — **VERIFIED-1** (crossref; issue/pages not shown by the record — from the DOI landing only if the assembler needs them). Not cited in the TSV; listed because it was checked.
- Raskin R & Terry H (1988). A principal-components analysis of the Narcissistic Personality Inventory and further evidence of its construct validity. *J Pers Soc Psychol* 54(5):890-902. DOI:10.1037/0022-3514.54.5.890 PMID:3379585 — **VERIFIED-2**. E2-2.
- Miller JD, Hoffman BJ, Gaughan ET, Gentile B, Maples J & Campbell WK (2011). Grandiose and vulnerable narcissism: a nomological network analysis. *J Pers* 79(5):1013-1042. DOI:10.1111/j.1467-6494.2010.00711.x PMID:21204843 — **VERIFIED-2**. E2-2, E2-3.
- Hendin HM & Cheek JM (1997). Assessing hypersensitive narcissism: a reexamination of Murray's Narcism Scale. *J Res Pers* 31(4):588-599. DOI:10.1006/jrpe.1997.2204 — **VERIFIED-1** (web, crossref; pubmed empty). E2-3.
- Pincus AL, Ansell EB, Pimentel CA, Cain NM, Wright AGC & Levy KN (2009). Initial construction and validation of the Pathological Narcissism Inventory. *Psychol Assess* 21(3):365-379. DOI:10.1037/a0016530 PMID:19719348 — **VERIFIED-2**. E2-3.
- Wright AGC, Lukowitsky MR, Pincus AL & Conroy DE (2010). The higher order factor structure and gender invariance of the Pathological Narcissism Inventory. *Assessment* 17(4):467-483. DOI:10.1177/1073191110373227 PMID:20634422 — **VERIFIED-2**. E2-3 note.
- Levenson MR, Kiehl KA & Fitzpatrick CM (1995). Assessing psychopathic attributes in a noninstitutionalized population. *J Pers Soc Psychol* 68(1):151-158. DOI:10.1037/0022-3514.68.1.151 PMID:7861311 — **VERIFIED-2**. E2-4.
- Lilienfeld SO & Andrews BP (1996). Development and preliminary validation of a self-report measure of psychopathic personality traits in noncriminal populations. *J Pers Assess* 66(3):488-524. DOI:10.1207/s15327752jpa6603_3 PMID:8667144 — **VERIFIED-2**. E2-4.
- Patrick CJ, Fowles DC & Krueger RF (2009). Triarchic conceptualization of psychopathy: developmental origins of disinhibition, boldness, and meanness. *Dev Psychopathol* 21(3):913-938. DOI:10.1017/S0954579409000492 PMID:19583890 — **VERIFIED-2**. E2-4.
- Buckels EE, Jones DN & Paulhus DL (2013). Behavioral confirmation of everyday sadism. *Psychol Sci* 24(11):2201-2209. DOI:10.1177/0956797613490749 PMID:24022650 — **VERIFIED-2**. E2-5.
- O'Meara A, Davies J & Hammond S (2011). The psychometric properties and utility of the Short Sadistic Impulse Scale (SSIS). *Psychol Assess* 23(2):523-531. DOI:10.1037/a0022400 PMID:21319907 — **VERIFIED-2**. E2-5.
- Plouffe RA, Saklofske DH & Smith MM (2017). The Assessment of Sadistic Personality: preliminary psychometric evidence for a new measure. *Pers Individ Dif* 104:166-171. DOI:10.1016/j.paid.2016.07.043 — **VERIFIED-1** (web, crossref). E2-5.
- Marcus DK, Zeigler-Hill V, Mercer SH & Norris AL (2014). The psychology of spite and the measurement of spitefulness. *Psychol Assess* 26(2):563-574. DOI:10.1037/a0036039 PMID:24548150 — **VERIFIED-2**. E2-6.
- Zeigler-Hill V, Noser AE, Roof C, Vonk J & Marcus DK (2015). Spitefulness and moral values. *Pers Individ Dif* 77:86-90. DOI:10.1016/j.paid.2014.12.050 — **VERIFIED-1** (web, crossref). E2-6.
- Lima-Costa AR, Bonfá-Araujo B, Pechorro P & Marcus DK (2022). Brazilian Portuguese adaptation of the Spitefulness Scale and associations with personality traits. *Psychol Assess* 34(7):e65-e71. DOI:10.1037/pas0001135 PMID:35467907 — **VERIFIED-2**. E2-6.
- Campbell WK, Bonacci AM, Shelton J, Exline JJ & Bushman BJ (2004). Psychological entitlement: interpersonal consequences and validation of a self-report measure. *J Pers Assess* 83(1):29-45. DOI:10.1207/s15327752jpa8301_04 PMID:15271594 — **VERIFIED-2**. E2-6 note (the Entitlement alternate).

### E3 Integrity & honesty
- de Vries RE, Zettler I & Hilbig BE (2014). Rethinking trait conceptions of social desirability scales: impression management as an expression of Honesty-Humility. *Assessment* 21(3):286-299. DOI:10.1177/1073191113504619 PMID:24072594 — **VERIFIED-2**. E3-1.
- Hilbig BE & Zettler I (2015). When the cat's away, some mice will play: a basic trait account of dishonest behavior. *J Res Pers* 57:72-88. DOI:10.1016/j.jrp.2015.04.003 — **VERIFIED-1** (web, crossref). E3-2.
- Schmitt M, Baumert A, Gollwitzer M & Maes J (2010). The Justice Sensitivity Inventory: factorial validity, location in the personality facet space, demographic pattern, and normative data. *Soc Justice Res* 23(2-3):211-238. DOI:10.1007/s11211-010-0115-2 — **VERIFIED-1** (web, crossref). E3-2.
- Thielmann I, Hilbig BE, Zettler I & Moshagen M (2016). On measuring the sixth basic personality dimension: a comparison between HEXACO Honesty-Humility and Big Six Honesty-Propriety. *Assessment* 24(8):1024-1036. DOI:10.1177/1073191116638411 PMID:26988405 — **VERIFIED-2**. E3-2 note.
- Seuntjens TG, Zeelenberg M, van de Ven N & Breugelmans SM (2015). Dispositional greed. *J Pers Soc Psychol* 108(6):917-933. DOI:10.1037/pspp0000031 PMID:25664899 — **VERIFIED-2**. E3-3.
- Krekels G & Pandelaere M (2015). Dispositional greed. *Pers Individ Dif* 74:225-230. DOI:10.1016/j.paid.2014.10.036 — **VERIFIED-1** (web, crossref). E3-3.
- Mussel P, Reiter AMF, Osinsky R & Hewig J (2015). State- and trait-greed, its impact on risky decision-making and underlying neural mechanisms. *Soc Neurosci* 10(2):126-134. DOI:10.1080/17470919.2014.965340 PMID:25300601 — **VERIFIED-2**. E3-3.
- Davis DE, Hook JN, Worthington EL, Van Tongeren DR, Gartner AL, Jennings DJ & Emmons RA (2011). Relational humility: conceptualizing and measuring humility as a personality judgment. *J Pers Assess* 93(3):225-234. DOI:10.1080/00223891.2011.558871 PMID:21516581 — **VERIFIED-2**. E3-4.
- Weidman AC, Cheng JT & Tracy JL (2018). The psychological structure of humility. *J Pers Soc Psychol* 114(1):153-178. DOI:10.1037/pspp0000112 PMID:27454926 — **VERIFIED-2**. E3-4.
- Van Tongeren DR, Davis DE, Hook JN & Witvliet CVO (2019). Humility. *Curr Dir Psychol Sci* 28(5):463-468. DOI:10.1177/0963721419850153 — **VERIFIED-1** (web, crossref). E3-4.
- Aquino K & Reed A (2002). The self-importance of moral identity. *J Pers Soc Psychol* 83(6):1423-1440. DOI:10.1037/0022-3514.83.6.1423 PMID:12500822 — **VERIFIED-2**. E3-5.
- Hertz SG & Krettenauer T (2016). Does moral identity effectively predict moral behavior? A meta-analysis. *Rev Gen Psychol* 20(2):129-140. DOI:10.1037/gpr0000062 — **VERIFIED-1** (web, crossref). E3-5.
- Blasi A (1983). Moral cognition and moral action: a theoretical perspective. *Dev Rev* 3(2):178-210. DOI:10.1016/0273-2297(83)90029-1 — **VERIFIED-1** (crossref). E3-5.
- Gerlach P, Teodorescu K & Hertwig R (2019). The truth about lies: a meta-analysis on dishonest behavior. *Psychol Bull* 145(1):1-44. DOI:10.1037/bul0000174 PMID:30596431 — **VERIFIED-2**. E3-6.
- Serota KB, Levine TR & Boster FJ (2010). The prevalence of lying in America: three studies of self-reported lies. *Hum Commun Res* 36(1):2-25. DOI:10.1111/j.1468-2958.2009.01366.x — **VERIFIED-1** (web, crossref). E3-6.
- Halevy R, Shalvi S & Verschuere B (2014). Being honest about dishonesty: correlating self-reports and actual lying. *Hum Commun Res* 40(1):54-72. DOI:10.1111/hcre.12019 — **VERIFIED-1** (crossref; the registry dates it 2013 online). E3-6.
- Heck DW, Thielmann I, Moshagen M & Hilbig BE (2018). Who lies? A large-scale reanalysis linking basic personality traits to unethical decision making. *Judgm Decis Mak* 13(4):356-371. DOI:10.1017/S1930297500009232 — **VERIFIED-1** (crossref). E3-6 note.
- Thielmann I, Hilbig BE, Klein SA, Seidl A & Heck DW (2023). Cheating to benefit others? On the relation between Honesty-Humility and prosocial lies. *J Pers* 92(3):870-882. DOI:10.1111/jopy.12835 PMID:36938760 — **VERIFIED-2**. E3-6 note.
- Daiku Y, Serota KB & Levine TR (2021). A few prolific liars in Japan: replication and the effects of Dark Triad personality traits. *PLoS One* 16(4):e0249815. DOI:10.1371/journal.pone.0249815 PMID:33857197 — **VERIFIED-2**. E3-6 note.

### E4 Regulation of self
- Rotter JB (1966). Generalized expectancies for internal versus external control of reinforcement. *Psychol Monogr* 80(1):1-28. DOI:10.1037/h0092976 PMID:5340840 — **VERIFIED-2** (pubmed gave the PMID without a DOI; crossref resolved the DOI to the same title/year). E4-1.
- Ng TWH, Sorensen KL & Eby LT (2006). Locus of control at work: a meta-analysis. *J Organ Behav* 27(8):1057-1087. DOI:10.1002/job.416 — **VERIFIED-1** (web, crossref). E4-1.
- Levenson H (1981). Differentiating among internality, powerful others, and chance. In Lefcourt HM (ed) *Research with the Locus of Control Construct*, vol 1, 15-63. New York: Academic Press. DOI:10.1016/B978-0-12-443201-7.50006-3 — **VERIFIED-1** (crossref). E4-1.
- Snyder M (1974). Self-monitoring of expressive behavior. *J Pers Soc Psychol* 30(4):526-537. DOI:10.1037/h0037039 — **VERIFIED-1** (web, crossref; pubmed empty). E4-2.
- Snyder M & Gangestad S (1986). On the nature of self-monitoring: matters of assessment, matters of validity. *J Pers Soc Psychol* 51(1):125-139. DOI:10.1037/0022-3514.51.1.125 — **VERIFIED-1** (crossref). E4-2 note.
- Gangestad SW & Snyder M (2000). Self-monitoring: appraisal and reappraisal. *Psychol Bull* 126(4):530-555. DOI:10.1037/0033-2909.126.4.530 PMID:10900995 — **VERIFIED-2**. E4-2.
- Day DV, Schleicher DJ, Unckless AL & Hiller NJ (2002). Self-monitoring personality at work: a meta-analytic investigation of construct validity. *J Appl Psychol* 87(2):390-401. DOI:10.1037/0021-9010.87.2.390 PMID:12002965 — **VERIFIED-2**. E4-2.
- Gross JJ & John OP (2003). Individual differences in two emotion regulation processes: implications for affect, relationships, and well-being. *J Pers Soc Psychol* 85(2):348-362. DOI:10.1037/0022-3514.85.2.348 PMID:12916575 — **VERIFIED-2**. E4-3.
- Aldao A, Nolen-Hoeksema S & Schweizer S (2010). Emotion-regulation strategies across psychopathology: a meta-analytic review. *Clin Psychol Rev* 30(2):217-237. DOI:10.1016/j.cpr.2009.11.004 PMID:20015584 — **VERIFIED-2**. E4-3.
- Webb TL, Miles E & Sheeran P (2012). Dealing with feeling: a meta-analysis of the effectiveness of strategies derived from the process model of emotion regulation. *Psychol Bull* 138(4):775-808. DOI:10.1037/a0027600 PMID:22582737 — **VERIFIED-2**. E4-3.
- Brown KW & Ryan RM (2003). The benefits of being present: mindfulness and its role in psychological well-being. *J Pers Soc Psychol* 84(4):822-848. DOI:10.1037/0022-3514.84.4.822 PMID:12703651 — **VERIFIED-2**. E4-4.
- Baer RA, Smith GT, Hopkins J, Krietemeyer J & Toney L (2006). Using self-report assessment methods to explore facets of mindfulness. *Assessment* 13(1):27-45. DOI:10.1177/1073191105283504 PMID:16443717 — **VERIFIED-2**. E4-4.
- Baer RA, Smith GT, Lykins E, Button D, Krietemeyer J, Sauer S, Walsh E, Duggan D & Williams JMG (2008). Construct validity of the Five Facet Mindfulness Questionnaire in meditating and nonmeditating samples. *Assessment* 15(3):329-342. DOI:10.1177/1073191107313003 — **VERIFIED-1** (crossref; authors/volume/pages read from the record). E4-4.
- Higgins ET, Friedman RS, Harlow RE, Idson LC, Ayduk ON & Taylor A (2001). Achievement orientations from subjective histories of success: promotion pride versus prevention pride. *Eur J Soc Psychol* 31(1):3-23. DOI:10.1002/ejsp.27 — **VERIFIED-1** (web, crossref). E4-5.
- Lanaj K, Chang CH & Johnson RE (2012). Regulatory focus and work-related outcomes: a review and meta-analysis. *Psychol Bull* 138(5):998-1034. DOI:10.1037/a0027723 PMID:22468880 — **VERIFIED-2**. E4-5.
- Lockwood P, Jordan CH & Kunda Z (2002). Motivation by positive or negative role models: regulatory focus determines who will best inspire us. *J Pers Soc Psychol* 83(4):854-864. DOI:10.1037/0022-3514.83.4.854 PMID:12374440 — **VERIFIED-2** (pubmed had no DOI; crossref resolved the DOI to the same title). E4-5 note.
- Tangney JP, Wagner P & Gramzow R (1992). Proneness to shame, proneness to guilt, and psychopathology. *J Abnorm Psychol* 101(3):469-478. DOI:10.1037/0021-843X.101.3.469 PMID:1500604 — **VERIFIED-2**. E4-6.
- Tangney JP, Wagner PE, Hill-Barlow D, Marschall DE & Gramzow R (1996). Relation of shame and guilt to constructive versus destructive responses to anger across the lifespan. *J Pers Soc Psychol* 70(4):797-809. DOI:10.1037/0022-3514.70.4.797 PMID:8636899 — **VERIFIED-2**. E4-6 note.
- Cohen TR, Wolf ST, Panter AT & Insko CA (2011). Introducing the GASP scale: a new measure of guilt and shame proneness. *J Pers Soc Psychol* 100(5):947-966. DOI:10.1037/a0022641 PMID:21517196 — **VERIFIED-2**. E4-6.

## Flair

- Psychology Today — Self-Esteem — https://www.psychologytoday.com/us/basics/self-esteem — **VERIFIED-1** (http 200). E1-1.
- Psychology Today — Identity — https://www.psychologytoday.com/us/basics/identity — **VERIFIED-1** (http 200). E1-3, E1-6.
- Psychology Today — Authenticity — https://www.psychologytoday.com/us/basics/authenticity — **VERIFIED-1** (http 200). E1-5.
- Psychology Today — Machiavellianism — https://www.psychologytoday.com/us/basics/machiavellianism — **VERIFIED-1** (http 200). E2-1.
- Psychology Today — Narcissism — https://www.psychologytoday.com/us/basics/narcissism — **VERIFIED-1** (http 200). E2-2, E2-3.
- Psychology Today — Psychopathy — https://www.psychologytoday.com/us/basics/psychopathy — **VERIFIED-1** (http 200). E2-4.
- Psychology Today — Sadism — https://www.psychologytoday.com/us/basics/sadism — **VERIFIED-1** (http 200). E2-5.
- Psychology Today — Deception — https://www.psychologytoday.com/us/basics/deception — **VERIFIED-1** (http 200). E3-1.
- Psychology Today — Ethics and Morality — https://www.psychologytoday.com/us/basics/ethics-and-morality — **VERIFIED-1** (http 200). E3-2, E3-5.
- Psychology Today — Self-Control — https://www.psychologytoday.com/us/basics/self-control — **VERIFIED-1** (http 200). E3-3 (nearest page; /basics/greed is 404).
- Psychology Today — Locus of Control — https://www.psychologytoday.com/us/basics/locus-of-control — **VERIFIED-1** (http 200). E4-1.
- Psychology Today — Emotion Regulation — https://www.psychologytoday.com/us/basics/emotion-regulation — **VERIFIED-1** (http 200; also in col-A). E4-3.
- Psychology Today — Mindfulness — https://www.psychologytoday.com/us/basics/mindfulness — **VERIFIED-1** (http 200). E4-4.
- Psychology Today — Motivation — https://www.psychologytoday.com/us/basics/motivation — **VERIFIED-1** (http 200). E4-5.
- Psychology Today — Shame — https://www.psychologytoday.com/us/basics/shame — **VERIFIED-1** (http 200). E4-6.
- Greater Good Magazine — Compassion: Definition — https://greatergood.berkeley.edu/topic/compassion/definition — **VERIFIED-1** (http 200). E1-4.
- Greater Good Magazine — Humility: Definition — https://greatergood.berkeley.edu/topic/humility/definition — **VERIFIED-1** (http 200). E3-4.
- Greater Good Magazine — Mindfulness: Definition — https://greatergood.berkeley.edu/topic/mindfulness/definition — **VERIFIED-1** (http 200). E4-4.
- Scientific American — What Is Narcissism? — https://www.scientificamerican.com/article/what-is-narcissism/ — **VERIFIED-1** (http 200; title from the URL slug, page not read). E2-2.
- APA Monitor on Psychology — The truth about lying (2019) — https://www.apa.org/monitor/2019/09/cover-lying — **VERIFIED-1** (http 200; title from the slug). E3-6.
- Kristin Neff — *Self-Compassion* (William Morrow, 2011); author site https://self-compassion.org/ — **VERIFIED-1** (http 200 on the site; the book itself not checked). E1-4.
- Carol S. Dweck — *Mindset: The New Psychology of Success* (Random House, 2006) — https://en.wikipedia.org/wiki/Mindset:_The_New_Psychology_of_Success — **VERIFIED-1** (http 200). E1-2.
- Robert Greene — *The 48 Laws of Power* (Viking, 1998) — https://en.wikipedia.org/wiki/The_48_Laws_of_Power — **VERIFIED-1** (http 200). E2-1.
- Simon McCarthy-Jones — *Spite: The Upside of Your Dark Side* (Basic Books, 2021) — https://www.basicbooks.com/titles/simon-mccarthy-jones/spite/9781541646889/ — **VERIFIED-1** (http 200). E2-6.
- Brené Brown — *Daring Greatly* (Gotham, 2012) — https://en.wikipedia.org/wiki/Daring_Greatly — **VERIFIED-1** (http 200). E4-6.
- Kevin Dutton — *The Wisdom of Psychopaths* (Farrar, Straus and Giroux, 2012) — **UNVERIFIED** (Wikipedia title guess 404; no search budget left). E2-4.
- Dan Ariely — *The (Honest) Truth About Dishonesty* (Harper, 2012) — **UNVERIFIED** (Wikipedia title guess 404). E3-6.
- Mark Snyder — *Public Appearances, Private Realities: The Psychology of Self-Monitoring* (W.H. Freeman, 1987) — **UNVERIFIED**. E4-2.
- Heidi Grant Halvorson & E. Tory Higgins — *Focus: Use Different Ways of Seeing the World for Success and Influence* (Hudson Street Press, 2013) — **UNVERIFIED**. E4-5.

## Attempted and not found (receipts)
- Psychology Today pages for self-compassion, honesty, humility, greed, fairness, revenge, entitlement — all HTTP 404 (US basics path); not cited.
- Scientific American troll/everyday-sadism piece and the shame-vs-guilt piece — URL guesses 404; not cited.
- Greater Good article-level pieces on spite, guilt vs shame, authenticity — URL guesses 404; topic definition pages used instead.
- PubMed plugin returned nothing for: Campbell 1996, Wood 2008, Neff 2003, Snyder 1974, Hendin & Cheek 1997, Christie & Geis, Schmitt 2010, Hart 2019 (LIES scale), Schlenker 2008, Halevy 2014, Sutton 2020, Ng 2006, Cheng 2013 (LOC cross-cultural meta-analysis) — social-psychology gaps as the brief predicts; Crossref used as the second route where a DOI exists.
