set processors 12
dis c(processors)

*-------------------------------------------------------------------------------
* Baseline regressions with financial constraints (US measure)
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Tang_US: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Invent_US: areg dlnprice_tr dlnRER x_Invent_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_FPC_US imp_ExtFin_US imp_Tang_US imp_Invent_US, labels(group_id "Firm-product-country FE")
esttab imp_FPC_US imp_ExtFin_US imp_Tang_US imp_Invent_US using "D:\Project C\tables\revision\table_imp_fin_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("FPC" "External Finance" "Tangibility" "Inventory") order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* ERPT with alternative samples
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_nopeg: areg dlnprice_tr dlnRER dlnrgdp i.year if peg_USD==0, a(group_id) vce(cluster FRDM)
eststo imp_top50: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_imp<=50, a(group_id) vce(cluster FRDM)
eststo imp_top20: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_imp<=20, a(group_id) vce(cluster FRDM)

estfe imp_baseline imp_top50 imp_top20, labels(group_id "Firm-product-country FE")
esttab imp_baseline imp_top50 imp_top20 using "D:\Project C\tables\revision\table_imp_baseline.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "Top 50" "Top 20")

*-------------------------------------------------------------------------------

* Regressions with financial constraints (CN measure)
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_FPC_cic2: areg dlnprice_tr dlnRER c.FPC_cic2#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_ExtFin_cic2: areg dlnprice_tr dlnRER c.ExtFin_cic2#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Tang_cic2: areg dlnprice_tr dlnRER c.Tang_cic2#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Invent_cic2: areg dlnprice_tr dlnRER c.Invent_cic2#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_RDint_cic2: areg dlnprice_tr dlnRER c.ExtFin_cic2#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_FPC_cic2 imp_ExtFin_cic2 imp_Tang_cic2 imp_Invent_cic2 imp_RDint_cic2, labels(group_id "Firm-product-country FE")
esttab imp_FPC_cic2 imp_ExtFin_cic2 imp_Tang_cic2 imp_Invent_cic2 imp_RDint_cic2 using "D:\Project C\tables\revision\table_imp_fin_CN.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "FPC" "External Finance" "Tangibility" "Inventory") order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------

* Regressions with financial constraints (firm-level)
cd "D:\Project C\sample_matched"
use sample_matched_imp_new,clear

gen x_Cash=Cash*dlnRER
gen x_Cash_cic2=Cash_cic2*dlnRER

gen x_Tang=Tang*dlnRER
gen x_Tang_cic2=Tang_cic2*dlnRER

gen x_Invent=Invent*dlnRER
gen x_Invent_cic2=Invent_cic2*dlnRER

eststo imp_Tang: ivreghdfe dlnprice_tr dlnRER (x_Tang=x_Tang_cic2) dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Invent: ivreghdfe dlnprice_tr dlnRER (x_Invent=x_Invent_cic2) dlnrgdp i.year, a(group_id) vce(cluster FRDM)

*-------------------------------------------------------------------------------
* Import Sources
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

egen group_id_fp=group(FRDM HS6)

eststo imp_source: areg dlnprice_tr dlnRER c.source#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_FPC_US_source: areg dlnprice_tr dlnRER c.source#c.dlnRER c.FPC_US#c.dlnRER_source c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_ExtFin_US_source: areg dlnprice_tr dlnRER c.source#c.dlnRER c.ExtFin_US#c.dlnRER_source c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_Tang_US_source: areg dlnprice_tr dlnRER c.source#c.dlnRER c.Tang_US#c.dlnRER_source c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)

estfe imp_source imp_FPC_US_source imp_ExtFin_US_source imp_Tang_US_source, labels(group_id "Firm-product-country FE")
esttab imp_source imp_FPC_US_source imp_ExtFin_US_source imp_Tang_US_source using "D:\Project C\tables\revision\table_imp_source.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*)

eststo imp_source_init: areg dlnprice_tr dlnRER c.source_initial#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_FPC_US_source_init: areg dlnprice_tr dlnRER c.source_initial#c.dlnRER c.FPC_US#c.dlnRER_source_initial c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_ExtFin_US_source_init: areg dlnprice_tr dlnRER c.source_initial#c.dlnRER c.ExtFin_US#c.dlnRER_source_initial c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_Tang_US_source_init: areg dlnprice_tr dlnRER c.source_initial#c.dlnRER c.Tang_US#c.dlnRER_source_initial c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)

estfe imp_source_init imp_FPC_US_source_init imp_ExtFin_US_source_init imp_Tang_US_source_init, labels(group_id "Firm-product-country FE")
esttab imp_source_init imp_FPC_US_source_init imp_ExtFin_US_source_init imp_Tang_US_source_init using "D:\Project C\tables\revision\table_imp_source_initial.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*)

eststo imp_source_lag: areg dlnprice_tr dlnRER c.source_lag#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_FPC_US_source_lag: areg dlnprice_tr dlnRER c.source_lag#c.dlnRER c.FPC_US#c.dlnRER_source_lag c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_ExtFin_US_source_lag: areg dlnprice_tr dlnRER c.source_lag#c.dlnRER c.ExtFin_US#c.dlnRER_source_lag c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)
eststo imp_Tang_US_source_lag: areg dlnprice_tr dlnRER c.source_lag#c.dlnRER c.Tang_US#c.dlnRER_source_lag c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster group_id_fp)

estfe imp_source_lag imp_FPC_US_source_lag imp_ExtFin_US_source_lag imp_Tang_US_source_lag, labels(group_id "Firm-product-country FE")
esttab imp_source_lag imp_FPC_US_source_lag imp_ExtFin_US_source_lag imp_Tang_US_source_lag using "D:\Project C\tables\revision\table_imp_source_lag.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* Distance
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_dist: areg dlnprice_tr dlnRER x_dist dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_FPC_US_dist: areg dlnprice_tr dlnRER x_dist c.FPC_US#c.dlnRER_dist c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_ExtFin_US_dist: areg dlnprice_tr dlnRER x_dist c.ExtFin_US#c.dlnRER_dist c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Tang_US_dist: areg dlnprice_tr dlnRER x_dist c.Tang_US#c.dlnRER_dist c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_dist imp_FPC_US_dist imp_ExtFin_US_dist imp_Tang_US_dist, labels(group_id "Firm-product-country FE")
esttab imp_dist imp_FPC_US_dist imp_ExtFin_US_dist imp_Tang_US_dist using "D:\Project C\tables\revision\table_imp_dist.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*)

eststo imp_distw: areg dlnprice_tr dlnRER x_distw dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_FPC_US_distw: areg dlnprice_tr dlnRER x_distw c.FPC_US#c.dlnRER_distw c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_ExtFin_US_distw: areg dlnprice_tr dlnRER x_distw c.ExtFin_US#c.dlnRER_distw c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Tang_US_distw: areg dlnprice_tr dlnRER x_distw c.Tang_US#c.dlnRER_distw c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_distw imp_FPC_US_distw imp_ExtFin_US_distw imp_Tang_US_distw, labels(group_id "Firm-product-country FE")
esttab imp_distw imp_FPC_US_distw imp_ExtFin_US_distw imp_Tang_US_distw using "D:\Project C\tables\revision\table_imp_distw.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* Regressions with market share
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_MS: areg dlnprice_tr dlnRER c.l.MS#c.dlnRER dlnrgdp MS_lag i.year, a(group_id) vce(cluster FRDM)
eststo imp_MS_FPC_US: areg dlnprice_tr dlnRER c.l.MS#c.dlnRER c.FPC_US#c.dlnRER dlnrgdp MS_lag i.year, a(group_id) vce(cluster FRDM)
eststo imp_MS_ExtFin_US: areg dlnprice_tr dlnRER c.l.MS#c.dlnRER c.ExtFin_US#c.dlnRER dlnrgdp MS_lag i.year, a(group_id) vce(cluster FRDM)
eststo imp_MS_Tang_US: areg dlnprice_tr dlnRER c.l.MS#c.dlnRER c.Tang_US#c.dlnRER dlnrgdp MS_lag i.year, a(group_id) vce(cluster FRDM)

estfe imp_MS imp_MS_FPC_US imp_MS_ExtFin_US imp_MS_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_MS imp_MS_FPC_US imp_MS_ExtFin_US imp_MS_Tang_US using "D:\Project C\tables\revision\table_imp_MS.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("MS_lag" "FPC" "ExtFin" "Tangibility") order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* Regressions controlling firms' markup and TFP
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_markup: areg dlnprice_tr dlnRER c.Markup_DLWTLD#c.dlnRER dlnrgdp Markup_DLWTLD i.year, a(group_id) vce(cluster FRDM)
eststo imp_FPC_US_markup: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER c.l.Markup_DLWTLD#c.dlnRER dlnrgdp Markup_DLWTLD i.year, a(group_id) vce(cluster FRDM)
eststo imp_ExtFin_US_markup: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER c.l.Markup_DLWTLD#c.dlnRER dlnrgdp Markup_DLWTLD i.year, a(group_id) vce(cluster FRDM)
eststo imp_Tang_US_markup: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER c.l.Markup_DLWTLD#c.dlnRER dlnrgdp Markup_DLWTLD i.year, a(group_id) vce(cluster FRDM)

estfe imp_markup imp_FPC_US_markup imp_ExtFin_US_markup imp_Tang_US_markup, labels(group_id "Firm-product-country FE")
esttab imp_markup imp_FPC_US_markup imp_ExtFin_US_markup imp_Tang_US_markup using "D:\Project C\tables\revision\table_imp_markup_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*)

gen x_tfp=dlnRER*tfp_tld
gen x_tfp_lag=dlnRER*tfp_lag

eststo imp_tfp: areg dlnprice_tr dlnRER x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id) vce(cluster FRDM)
eststo imp_FPC_US_tfp: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id) vce(cluster FRDM)
eststo imp_ExtFin_US_tfp: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id) vce(cluster FRDM)
eststo imp_Tang_US_tfp: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id) vce(cluster FRDM)

estfe imp_tfp imp_FPC_US_tfp imp_ExtFin_US_tfp imp_Tang_US_tfp, labels(group_id "Firm-product-country FE")
esttab imp_tfp imp_FPC_US_tfp imp_ExtFin_US_tfp imp_Tang_US_tfp using "D:\Project C\tables\revision\table_imp_tfp_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.*_lag c.*_US)

*-------------------------------------------------------------------------------
* Alternative FEs
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

egen group_id_fy=group(FRDM year)
egen group_id_pc=group(HS6 coun_aim)

eststo imp_baseline_fe1: reghdfe dlnprice_tr dlnRER dlnrgdp, a(group_id_fy coun_aim HS6) vce(cluster FRDM)
eststo imp_FPC_US_fe1: reghdfe dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp, a(group_id_fy coun_aim HS6) vce(cluster FRDM)
eststo imp_ExtFin_US_fe1: reghdfe dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp, a(group_id_fy coun_aim HS6) vce(cluster FRDM)
eststo imp_Tang_US_fe1: reghdfe dlnprice_tr dlnRER c.Tang_US#c.dlnRER dlnrgdp, a(group_id_fy coun_aim HS6) vce(cluster FRDM)
eststo imp_Invent_US_fe1: reghdfe dlnprice_tr dlnRER x_Invent_US dlnrgdp, a(group_id_fy coun_aim HS6) vce(cluster FRDM)
 
eststo imp_baseline_fe2: reghdfe dlnprice_tr dlnRER dlnrgdp, a(group_id_fy group_id_pc) vce(cluster FRDM)
eststo imp_FPC_US_fe2: reghdfe dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp, a(group_id_fy group_id_pc) vce(cluster FRDM)
eststo imp_ExtFin_US_fe2: reghdfe dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp, a(group_id_fy group_id_pc) vce(cluster FRDM)
eststo imp_Tang_US_fe2: reghdfe dlnprice_tr dlnRER c.Tang_US#c.dlnRER dlnrgdp, a(group_id_fy group_id_pc) vce(cluster FRDM)
eststo imp_Invent_US_fe2: reghdfe dlnprice_tr dlnRER x_Invent_US dlnrgdp, a(group_id_fy group_id_pc) vce(cluster FRDM)

estfe imp_baseline_fe1 imp_FPC_US_fe1 imp_ExtFin_US_fe1 imp_Tang_US_fe1 imp_baseline_fe2 imp_FPC_US_fe2 imp_ExtFin_US_fe2 imp_Tang_US_fe2, labels(group_id "Firm-product-country FE" group_id_fy "Firm-year FE" group_id_pc "Product-country FE" coun_aim "Country FE" HS6 "Product FE")
esttab imp_baseline_fe1 imp_FPC_US_fe1 imp_ExtFin_US_fe1 imp_Tang_US_fe1 imp_baseline_fe2 imp_FPC_US_fe2 imp_ExtFin_US_fe2 imp_Tang_US_fe2 using "D:\Project C\tables\revision\table_imp_fe.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate(`r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* Ownership Types
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

gen SOE=1 if ownership=="SOE"
replace SOE=0 if SOE==.
gen MNE=1 if ownership=="MNE"
replace MNE=0 if MNE==.
gen JV=1 if ownership=="JV"
replace JV=0 if JV==.
gen lnrSI=ln(rSI)

egen group_id_pc=group(HS6 coun_aim)
eststo imp_ownership_baseline: areg dlnprice_tr dlnRER dlnrgdp SOE MNE JV lnrSI i.year, a(group_id_pc) vce(cluster FRDM)
eststo imp_ownership_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp SOE MNE JV lnrSI i.year, a(group_id_pc) vce(cluster FRDM)
eststo imp_ownership_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp SOE MNE JV lnrSI i.year, a(group_id_pc) vce(cluster FRDM)
eststo imp_ownership_Tang_US: areg dlnprice_tr dlnRER dlnrgdp c.Tang_US#c.dlnRER SOE MNE JV lnrSI i.year, a(group_id_pc) vce(cluster FRDM)

estfe imp_ownership_baseline imp_ownership_FPC_US imp_ownership_ExtFin_US imp_ownership_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_ownership_baseline imp_ownership_FPC_US imp_ownership_ExtFin_US imp_ownership_Tang_US using "D:\Project C\tables\revision\table_imp_ownership.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* Affiliation
use sample_matched_imp,clear

egen group_id_pc=group(HS6 coun_aim)
gen lnrSI=ln(rSI)

eststo imp_affiliate_baseline: areg dlnprice_tr dlnRER dlnrgdp affiliate lnrSI i.year, a(group_id_pc) vce(cluster FRDM)
eststo imp_affiliate_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp affiliate lnrSI i.year, a(group_id_pc) vce(cluster FRDM)
eststo imp_affiliate_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp affiliate lnrSI i.year, a(group_id_pc) vce(cluster FRDM)
eststo imp_affiliate_Tang_US: areg dlnprice_tr dlnRER dlnrgdp c.Tang_US#c.dlnRER affiliate lnrSI i.year, a(group_id_pc) vce(cluster FRDM)

estfe imp_affiliate_baseline imp_affiliate_FPC_US imp_affiliate_ExtFin_US imp_affiliate_Tang_US, labels(group_id "Product-country FE")
esttab imp_affiliate_baseline imp_affiliate_FPC_US imp_affiliate_ExtFin_US imp_affiliate_Tang_US using "D:\Project C\tables\revision\table_imp_affiliate.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" "Affiliate control =*affiliate" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp c.*)

*-------------------------------------------------------------------------------
* Two-way traders
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_twoway_baseline: areg dlnprice_tr dlnRER dlnrgdp i.twoway_trade i.year, a(group_id) vce(cluster FRDM)
eststo imp_twoway_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp i.twoway_trade i.year, a(group_id) vce(cluster FRDM)
eststo imp_twoway_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp i.twoway_trade i.year, a(group_id) vce(cluster FRDM)
eststo imp_twoway_Tang_US: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER dlnrgdp i.twoway_trade i.year, a(group_id) vce(cluster FRDM)

estfe imp_twoway_baseline imp_twoway_FPC_US imp_twoway_ExtFin_US imp_twoway_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_twoway_baseline imp_twoway_FPC_US imp_twoway_ExtFin_US imp_twoway_Tang_US using "D:\Project C\tables\revision\table_imp_twoway.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" "Two-way FE =*.twoway_trade" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp c.*_US)

*-------------------------------------------------------------------------------
* Ordinary vs Processing
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_process_ctrl_baseline: areg dlnprice_tr dlnRER process assembly dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_process_ctrl_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER process assembly dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_process_ctrl_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER process assembly dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_process_ctrl_Tang_US: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER process assembly dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_process_ctrl_baseline imp_process_ctrl_FPC_US imp_process_ctrl_ExtFin_US imp_process_ctrl_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_process_ctrl_baseline imp_process_ctrl_FPC_US imp_process_ctrl_ExtFin_US imp_process_ctrl_Tang_US using "D:\Project C\tables\revision\table_imp_processing_control.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp)

gen x_process=dlnRER*process
gen x_assembly=dlnRER*assembly

eststo imp_process_baseline: areg dlnprice_tr dlnRER x_process dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_process_FPC_US: areg dlnprice_tr dlnRER x_process c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_process_ExtFin_US: areg dlnprice_tr dlnRER x_process c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_process_Tang_US: areg dlnprice_tr dlnRER x_process c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)

eststo imp_assembly_baseline: areg dlnprice_tr dlnRER x_assembly dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_assembly_FPC_US: areg dlnprice_tr dlnRER x_assembly c.FPC_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_assembly_ExtFin_US: areg dlnprice_tr dlnRER x_assembly c.ExtFin_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_assembly_Tang_US: areg dlnprice_tr dlnRER x_assembly c.Tang_US#c.dlnRER dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_process_baseline imp_process_FPC_US imp_process_ExtFin_US imp_process_Tang_US imp_assembly_baseline imp_assembly_FPC_US imp_assembly_ExtFin_US imp_assembly_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_process_baseline imp_process_FPC_US imp_process_ExtFin_US imp_process_Tang_US imp_assembly_baseline imp_assembly_FPC_US imp_assembly_ExtFin_US imp_assembly_Tang_US using "D:\Project C\tables\revision\table_imp_processing.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_process x_assembly)

*-------------------------------------------------------------------------------
* One-year sample (2007)
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

keep if year==2007
drop year
egen group_id_fp=group(FRDM HS6)

eststo imp_oneyear_baseline: areg dlnprice_tr dlnRER dlnrgdp, a(group_id_fp)
eststo imp_oneyear_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp, a(group_id_fp)
eststo imp_oneyear_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp, a(group_id_fp)
eststo imp_oneyear_Tang_US: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER dlnrgdp, a(group_id_fp)

estfe imp_oneyear_baseline imp_oneyear_FPC_US imp_oneyear_ExtFin_US imp_oneyear_Tang_US, labels(group_id "Product FE")
esttab imp_oneyear_baseline imp_oneyear_FPC_US imp_oneyear_ExtFin_US imp_oneyear_Tang_US using "D:\Project C\tables\revision\table_imp_oneyear.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate( `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp c.*_US)

*-------------------------------------------------------------------------------
* Between Estimator
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

collapse (mean) dlnprice_tr dlnRER c.*_US dlnrgdp, by (FRDM HS6 coun_aim)
egen group_id_fp=group(FRDM HS6)

eststo imp_between_baseline: areg dlnprice_tr dlnRER dlnrgdp, a(group_id_fp)
eststo imp_between_FPC_US: areg dlnprice_tr dlnRER c.FPC_US#c.dlnRER dlnrgdp, a(group_id_fp)
eststo imp_between_ExtFin_US: areg dlnprice_tr dlnRER c.ExtFin_US#c.dlnRER dlnrgdp, a(group_id_fp)
eststo imp_between_Tang_US: areg dlnprice_tr dlnRER c.Tang_US#c.dlnRER dlnrgdp, a(group_id_fp)

estfe imp_between_baseline imp_between_FPC_US imp_between_ExtFin_US imp_between_Tang_US, labels(group_id "Product FE")
esttab imp_between_baseline imp_between_FPC_US imp_between_ExtFin_US imp_between_Tang_US using "D:\Project C\tables\revision\table_imp_between.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate( `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp c.*_US)