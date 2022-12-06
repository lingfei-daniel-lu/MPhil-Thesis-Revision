set processors 16
dis c(processors)

*-------------------------------------------------------------------------------
* Baseline regressions for import whole customs data
cd "D:\Project C\sample_all"
use sample_all_imp,clear
eststo reg_all_imp: areg dlnprice_tr dlnRER dlnrgdp i.year, a(group_id)
eststo reg_top50_imp: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_imp<=50, a(group_id)
eststo reg_top20_imp: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_imp<=20, a(group_id)

estfe reg_all_imp reg_top50_imp reg_top20_imp, labels(group_id "Firm-product-country FE")
esttab reg_all_imp reg_top50_imp reg_top20_imp using "D:\Project C\tables\all\table_all_imp.csv", replace b(3) se(3) starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Whole" "Top 50" "Top 20")

forv i=2003/2009{
	eststo reg_all_imp_ma5_`i': areg dlnprice_tr dlnRER dlnrgdp i.year if year>=`i'-2 & year<=`i'+2, a(group_id)
}
estfe reg_all_imp_ma5_*, labels(group_id "Firm-product-country FE")
esttab reg_all_imp_ma5_* using "D:\Project C\tables\all\table_all_imp_ma5.csv", replace b(3) se(3) starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "03" "04" "05" "06" "07" "08" "09")

forv i=2002/2010{
	eststo reg_all_imp_ma3_`i': areg dlnprice_tr dlnRER dlnrgdp i.year if year>=`i'-1 & year<=`i'+1, a(group_id)
}
estfe reg_all_imp_ma3_*, labels(group_id "Firm-product-country FE")
esttab reg_all_imp_ma3_* using "D:\Project C\tables\all\table_all_imp_ma3.csv", replace b(3) se(3) starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "02" "03" "04" "05" "06" "07" "08" "09" "10")

*-------------------------------------------------------------------------------
* Baseline regressions for import matched sample
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year, a(group_id)
eststo imp_top50: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_imp<=50, a(group_id)
eststo imp_top20: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_imp<=20, a(group_id)

estfe imp_baseline imp_top50 imp_top20, labels(group_id "Firm-product-country FE")
esttab imp_baseline imp_top50 imp_top20 using "D:\Project C\tables\matched\table_imp_baseline.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "Top 50" "Top 20")

*-------------------------------------------------------------------------------
* Regressions with financial constraints for import
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo imp_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year, a(group_id)
eststo imp_Invent_US: areg dlnprice_tr dlnRER x_Invent_US dlnrgdp i.year, a(group_id)

estfe imp_FPC_US imp_ExtFin_US imp_Tang_US imp_Invent_US, labels(group_id "Firm-product-country FE")
esttab imp_FPC_US imp_ExtFin_US imp_Tang_US imp_Invent_US using "D:\Project C\tables\matched\table_imp_fin_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("FPC" "External Finance" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

eststo imp_ExtFin_cic2: areg dlnprice_tr dlnRER x_ExtFin_cic2 dlnrgdp i.year, a(group_id)
eststo imp_Tang_cic2: areg dlnprice_tr dlnRER x_Tang_cic2 dlnrgdp i.year, a(group_id)
eststo imp_Invent_cic2: areg dlnprice_tr dlnRER x_Invent_cic2 dlnrgdp i.year, a(group_id)
eststo imp_RDint_cic2: areg dlnprice_tr dlnRER x_RDint_cic2 dlnrgdp i.year, a(group_id)

estfe imp_ExtFin_cic2 imp_Tang_cic2 imp_Invent_cic2 imp_RDint_cic2, labels(group_id "Firm-product-country FE")
esttab imp_ExtFin_cic2 imp_Tang_cic2 imp_Invent_cic2 imp_RDint_cic2 using "D:\Project C\tables\matched\table_imp_fin_CN.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "External Finance" "Tangibility" "Inventory" "R&D Intensity") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Regressions with market share
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_MS: areg dlnprice_tr dlnRER x_MS dlnrgdp MS i.year, a(group_id)
eststo imp_MS_sqr: areg dlnprice_tr dlnRER x_MS x_MS_sqr dlnrgdp MS i.year, a(group_id)
eststo imp_MS_sqr_FPC_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_FPC_US dlnrgdp MS i.year, a(group_id)
eststo imp_MS_sqr_ExtFin_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_ExtFin_US dlnrgdp MS i.year, a(group_id)
eststo imp_MS_sqr_Tang_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_Tang_US dlnrgdp MS i.year, a(group_id)

estfe imp_MS imp_MS_sqr imp_MS_sqr_FPC_US imp_MS_sqr_ExtFin_US imp_MS_sqr_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_MS imp_MS_sqr imp_MS_sqr_FPC_US imp_MS_sqr_ExtFin_US imp_MS_sqr_Tang_US using "D:\Project C\tables\matched\table_imp_MS.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("MS" "MS^2" "Add FPC" "Add ExtFin" "Add Tangibility") order(dlnRER dlnrgdp x_*)

forv i=1/4{
	eststo imp_MS4_`i': areg dlnprice_tr dlnRER dlnrgdp i.year if MS_xt4==`i', a(group_id)	
}
estfe imp_MS4_1 imp_MS4_2 imp_MS4_3 imp_MS4_4, labels(group_id "Firm-product-country FE")
esttab imp_MS4_1 imp_MS4_2 imp_MS4_3 imp_MS4_4 using "D:\Project C\tables\matched\table_imp_MS_xt4.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "1st" "2nd" "3rd" "4th")

forv i=1/4{
	eststo imp_MS4_`i'_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if MS_xt4==`i', a(group_id)
	eststo imp_MS4_`i'_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if MS_xt4==`i', a(group_id)
}
estfe imp_MS4_1_* imp_MS4_2_* imp_MS4_3_* imp_MS4_4_*, labels(group_id "Firm-product-country FE")
esttab imp_MS4_1* imp_MS4_2* imp_MS4_3* imp_MS4_4* using "D:\Project C\tables\matched\table_imp_MS_xt4_fin_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "1st" "1st" "2nd" "2nd" "3rd" "3rd" "4th" "4th") order(dlnRER dlnrgdp x_*)

gen x_FPC_US_MS_d=x_FPC_US*MS_d
gen x_ExtFin_US_MS_d=x_ExtFin_US*MS_d
gen x_Tang_US_MS_d=x_ExtFin_US*MS_d
gen x_Invent_US_MS_d=x_ExtFin_US*MS_d
eststo imp_FPC_MS_d: areg dlnprice_tr dlnRER x_FPC_US x_FPC_US_MS_d dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_MS_d: areg dlnprice_tr dlnRER x_ExtFin_US x_ExtFin_US_MS_d dlnrgdp i.year, a(group_id)
eststo imp_Tang_MS_d: areg dlnprice_tr dlnRER x_Tang_US x_Tang_US_MS_d dlnrgdp i.year, a(group_id)
eststo imp_Invent_MS_d: areg dlnprice_tr dlnRER x_Invent_US x_Invent_US_MS_d dlnrgdp i.year, a(group_id)
esttab imp_FPC_MS_d imp_ExtFin_MS_d imp_Tang_MS_d imp_Invent_MS_d using "D:\Project C\tables\matched\table_imp_MS_d.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("FPC" "ExtFin" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Regressions controlling firms' markup and TFP
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_markup: areg dlnprice_tr dlnRER x_Markup_lag dlnrgdp Markup_lag i.year, a(group_id)
eststo imp_FPC_US_markup: areg dlnprice_tr dlnRER x_FPC_US x_Markup_lag dlnrgdp Markup_lag i.year, a(group_id)
eststo imp_ExtFin_US_markup: areg dlnprice_tr dlnRER x_ExtFin_US x_Markup_lag dlnrgdp Markup_lag i.year, a(group_id)
eststo imp_Tang_US_markup: areg dlnprice_tr dlnRER x_Tang_US x_Markup_lag Markup_lag dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_markup: areg dlnprice_tr dlnRER x_Invent_US x_Markup_lag Markup_lag dlnrgdp i.year, a(group_id)

estfe imp_markup imp_FPC_US_markup imp_ExtFin_US_markup imp_Tang_US_markup imp_Invent_US_markup, labels(group_id "Firm-product-country FE")
esttab imp_markup imp_FPC_US_markup imp_ExtFin_US_markup imp_Tang_US_markup imp_Invent_US_markup using "D:\Project C\tables\matched\table_imp_markup_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*_lag x_*_US)

eststo imp_tfp: areg dlnprice_tr dlnRER x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id)
eststo imp_ExtFin_US_tfp: areg dlnprice_tr dlnRER x_ExtFin_US x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id)
eststo imp_Tang_US_tfp: areg dlnprice_tr dlnRER x_Tang_US x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id)

eststo imp_scratio: areg dlnprice_tr dlnRER x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)
eststo imp_ExtFin_US_scratio: areg dlnprice_tr dlnRER x_ExtFin_US x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)
eststo imp_Tang_US_scratio: areg dlnprice_tr dlnRER x_Tang_US x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)

estfe imp_markup imp_ExtFin_US_markup imp_Tang_US_markup imp_tfp imp_ExtFin_US_tfp imp_Tang_US_tfp imp_scratio imp_ExtFin_US_scratio imp_Tang_US_scratio, labels(group_id "Firm-product-country FE")
esttab imp_markup imp_ExtFin_US_markup imp_Tang_US_markup imp_tfp imp_ExtFin_US_tfp imp_Tang_US_tfp imp_scratio imp_ExtFin_US_scratio imp_Tang_US_scratio using "D:\Project C\tables\matched\table_imp_markup_tfp_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*_lag x_*_US)

*-------------------------------------------------------------------------------
* Two-way traders
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_twoway: areg dlnprice_tr dlnRER dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo imp_twoway_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo imp_twoway_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo imp_twoway_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo imp_oneway: areg dlnprice_tr dlnRER dlnrgdp i.year if twoway_trade==0, a(group_id)
eststo imp_oneway_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if twoway_trade==0, a(group_id)
eststo imp_oneway_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if twoway_trade==0, a(group_id)
eststo imp_oneway_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if twoway_trade==0, a(group_id)

estfe imp_twoway imp_twoway_FPC_US imp_twoway_ExtFin_US imp_twoway_Tang_US imp_oneway imp_oneway_FPC_US imp_oneway_ExtFin_US imp_oneway_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_twoway imp_twoway_FPC_US imp_twoway_ExtFin_US imp_twoway_Tang_US imp_oneway imp_oneway_FPC_US imp_oneway_ExtFin_US imp_oneway_Tang_US using "D:\Project C\tables\matched\table_imp_twoway_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Twoway" "FPC" "External Finance" "Tangibility" "Oneway" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*_US)

gen x_ExtFin_US_twoway=x_ExtFin_US*twoway_trade
gen x_Tang_US_twoway=x_Tang_US*twoway_trade
areg dlnprice_tr dlnRER x_twoway_trade dlnrgdp twoway_trade i.year, a(group_id)
areg dlnprice_tr dlnRER x_twoway_trade x_ExtFin_US x_ExtFin_US_twoway dlnrgdp i.year, a(group_id)
areg dlnprice_tr dlnRER x_twoway_trade x_Tang_US x_Tang_US_twoway dlnrgdp i.year, a(group_id)

*-------------------------------------------------------------------------------
* Import Sources
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_source: areg dlnprice_tr dlnRER x_source dlnrgdp i.year, a(group_id)

gen x_FPC_US_source=x_FPC_US*source
gen x_ExtFin_US_source=x_ExtFin_US*source
gen x_Tang_US_source=x_Tang_US*source
gen x_Invent_US_source=x_Invent_US*source

eststo imp_FPC_US_source: areg dlnprice_tr dlnRER x_source x_FPC_US_source x_FPC_US dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US_source: areg dlnprice_tr dlnRER x_source x_ExtFin_US_source x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo imp_Tang_US_source: areg dlnprice_tr dlnRER x_source x_Tang_US_source x_Tang_US dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_source: areg dlnprice_tr dlnRER x_source x_Invent_US_source x_Invent_US dlnrgdp i.year, a(group_id)

estfe imp_source imp_FPC_US_source imp_ExtFin_US_source imp_Tang_US_source imp_Invent_US_source, labels(group_id "Firm-product-country FE")
esttab imp_source imp_FPC_US_source imp_ExtFin_US_source imp_Tang_US_source imp_Invent_US_source using "D:\Project C\tables\matched\table_imp_source.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* New entrants
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_FPC_US_entrant: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if new_entrant==1, a(group_id)
eststo imp_ExtFin_US_entrant: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp if new_entrant==1 i.year, a(group_id)
eststo imp_Tang_US_entrant: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp if new_entrant==1 i.year, a(group_id)
eststo imp_Invent_US_entrant: areg dlnprice_tr dlnRER x_Invent_US dlnrgdp if new_entrant==1 i.year, a(group_id)

estfe imp_FPC_US_entrant imp_ExtFin_US_entrant imp_Tang_US_entrant imp_Invent_US_entrant labels(group_id "Firm-product-country FE")
esttab imp_FPC_US_entrant imp_ExtFin_US_entrant imp_Tang_US_entrant imp_Invent_US_entrant using "D:\Project C\tables\matched\table_imp_entrant.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Alternative FEs
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

egen group_id_fy=group(FRDM year)
egen group_id_pc=group(HS6 coun_aim)

eststo imp_FPC_US_fe1: reghdfe dlnprice_tr dlnRER x_FPC_US dlnrgdp, absorb(group_id_fy coun_aim HS6)
eststo imp_ExtFin_US_fe1: reghdfe dlnprice_tr dlnRER x_ExtFin_US dlnrgdp, absorb(group_id_fy coun_aim HS6)
eststo imp_Tang_US_fe1: reghdfe dlnprice_tr dlnRER x_Tang_US dlnrgdp, absorb(group_id_fy coun_aim HS6)
eststo imp_Invent_US_fe1: reghdfe dlnprice_tr dlnRER x_Invent_US dlnrgdp, absorb(group_id_fy coun_aim HS6)

eststo imp_FPC_US_fe2: reghdfe dlnprice_tr dlnRER x_FPC_US dlnrgdp, absorb(group_id_fy group_id_pc)
eststo imp_ExtFin_US_fe2: reghdfe dlnprice_tr dlnRER x_ExtFin_US dlnrgdp, absorb(group_id_fy group_id_pc)
eststo imp_Tang_US_fe2: reghdfe dlnprice_tr dlnRER x_Tang_US dlnrgdp, absorb(group_id_fy group_id_pc)
eststo imp_Invent_US_fe2: reghdfe dlnprice_tr dlnRER x_Invent_US dlnrgdp, absorb(group_id_fy group_id_pc)

estfe imp_FPC_US_fe1 imp_ExtFin_US_fe1 imp_Tang_US_fe1 imp_Invent_US_fe1 imp_FPC_US_fe2 imp_ExtFin_US_fe2 imp_Tang_US_fe2 imp_Invent_US_fe2, labels(group_id "Firm-product-country FE" group_id_fy "Firm-year FE" group_id_pc "Product-Country FE" coun_aim "Country FE" HS6 "Product FE")
esttab imp_FPC_US_fe1 imp_ExtFin_US_fe1 imp_Tang_US_fe1 imp_Invent_US_fe1 imp_FPC_US_fe2 imp_ExtFin_US_fe2 imp_Tang_US_fe2 imp_Invent_US_fe2 using "D:\Project C\tables\matched\table_imp_fe.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate(`r(indicate_fe)') mtitles("FPC" "External Finance" "Tangibility" "Inventory" "FPC" "External Finance" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Ownership Types
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_SOE_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="SOE", a(group_id)
eststo imp_SOE_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="SOE", a(group_id)
eststo imp_SOE_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="SOE", a(group_id)
eststo imp_SOE_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="SOE", a(group_id)

eststo imp_DPE_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="DPE", a(group_id)
eststo imp_DPE_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="DPE", a(group_id)
eststo imp_DPE_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="DPE", a(group_id)
eststo imp_DPE_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="DPE", a(group_id)

eststo imp_MNE_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="MNE", a(group_id)
eststo imp_MNE_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="MNE", a(group_id)
eststo imp_MNE_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="MNE", a(group_id)
eststo imp_MNE_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="MNE", a(group_id)

eststo imp_JV_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="JV", a(group_id)
eststo imp_JV_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="JV", a(group_id)
eststo imp_JV_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="JV", a(group_id)
eststo imp_JV_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="JV", a(group_id)

estfe imp_SOE_baseline imp_SOE_FPC_US imp_SOE_ExtFin_US imp_SOE_Tang_US imp_DPE_baseline imp_DPE_FPC_US imp_DPE_ExtFin_US imp_DPE_Tang_US imp_MNE_baseline imp_MNE_FPC_US imp_MNE_ExtFin_US imp_MNE_Tang_US imp_JV_baseline imp_JV_FPC_US imp_JV_ExtFin_US imp_JV_Tang_US,labels(group_id "Firm-product-country FE")

esttab imp_SOE_baseline imp_SOE_FPC_US imp_SOE_ExtFin_US imp_SOE_Tang_US imp_DPE_baseline imp_DPE_FPC_US imp_DPE_ExtFin_US imp_DPE_Tang_US imp_MNE_baseline imp_MNE_FPC_US imp_MNE_ExtFin_US imp_MNE_Tang_US imp_JV_baseline imp_JV_FPC_US imp_JV_ExtFin_US imp_JV_Tang_US using "D:\Project C\tables\matched\table_imp_ownership.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Excluding USD Peg
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_nopeg_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if peg_USD==0, a(group_id)
eststo imp_nopeg_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if peg_USD==0, a(group_id)
eststo imp_nopeg_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if peg_USD==0, a(group_id)
eststo imp_nopeg_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if peg_USD==0, a(group_id)

estfe imp_nopeg_baseline imp_nopeg_FPC_US imp_nopeg_ExtFin_US imp_nopeg_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_nopeg_baseline imp_nopeg_FPC_US imp_nopeg_ExtFin_US imp_nopeg_Tang_US using "D:\Project C\tables\matched\table_imp_nopeg.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Ordinary vs Processing
use sample_matched_imp_shipment,clear

eststo imp_ordinary_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if shipment_type==1, a(group_id)
eststo imp_ordinary_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if shipment_type==1, a(group_id)
eststo imp_ordinary_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if shipment_type==1, a(group_id)
eststo imp_ordinary_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if shipment_type==1, a(group_id)

eststo imp_process_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if shipment_type>=2, a(group_id)
eststo imp_process_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if shipment_type>=2, a(group_id)
eststo imp_process_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if shipment_type>=2, a(group_id)
eststo imp_process_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if shipment_type>=2, a(group_id)

eststo imp_assemble_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if shipment_type==3, a(group_id)
eststo imp_assemble_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if shipment_type==3, a(group_id)
eststo imp_assemble_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if shipment_type==3, a(group_id)
eststo imp_assemble_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if shipment_type==3, a(group_id)

estfe imp_ordinary_baseline imp_ordinary_FPC_US imp_ordinary_ExtFin_US imp_ordinary_Tang_US imp_process_baseline imp_process_FPC_US imp_process_ExtFin_US imp_process_Tang_US imp_assemble_baseline imp_assemble_FPC_US imp_assemble_ExtFin_US imp_assemble_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_ordinary_baseline imp_ordinary_FPC_US imp_ordinary_ExtFin_US imp_ordinary_Tang_US imp_process_baseline imp_process_FPC_US imp_process_ExtFin_US imp_process_Tang_US imp_assemble_baseline imp_assemble_FPC_US imp_assemble_ExtFin_US imp_assemble_Tang_US using "D:\Project C\tables\matched\table_imp_process.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Ordinary" "Ordinary" "Ordinary" "Ordinary" "Processing" "Processing" "Processing" "Processing" "Assembling" "Assembling" "Assembling" "Assembling") order(dlnRER dlnrgdp x_*)