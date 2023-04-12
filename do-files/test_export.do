set processors 16
dis c(processors)

*-------------------------------------------------------------------------------
* Baseline regressions for export whole customs data
cd "D:\Project C\sample_all"
use sample_all_exp,clear
eststo reg_all_exp: areg dlnprice_tr dlnRER dlnrgdp i.year, a(group_id)
eststo reg_top50_exp: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_exp<=50, a(group_id)
eststo reg_top20_exp: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_exp<=20, a(group_id)

estfe reg_all_exp reg_top50_exp reg_top20_exp, labels(group_id "Firm-product-country FE")
esttab reg_all_exp reg_top50_exp reg_top20_exp using "D:\Project C\tables\all\table_all_exp.csv", replace b(3) se(3) starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Whole" "Top 50" "Top 20")

forv i=2003/2009{
	eststo reg_all_exp_ma5_`i': areg dlnprice_tr dlnRER dlnrgdp i.year if year>=`i'-2 & year<=`i'+2, a(group_id)
}
estfe reg_all_exp_ma5_*, labels(group_id "Firm-product-country FE")
esttab reg_all_exp_ma5_* using "D:\Project C\tables\all\table_all_exp_ma5.csv", replace b(3) se(3) starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "03" "04" "05" "06" "07" "08" "09")

forv i=2002/2010{
	eststo reg_all_exp_ma3_`i': areg dlnprice_tr dlnRER dlnrgdp i.year if year>=`i'-1 & year<=`i'+1, a(group_id)
}
estfe reg_all_exp_ma3_*, labels(group_id "Firm-product-country FE")
esttab reg_all_exp_ma3_* using "D:\Project C\tables\all\table_all_exp_ma3.csv", replace b(3) se(3) starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles( "02" "03" "04" "05" "06" "07" "08" "09" "10")

*-------------------------------------------------------------------------------
* Baseline regressions for export matched sample
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year, a(group_id)
eststo exp_top50: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_exp<=50, a(group_id)
eststo exp_top20: areg dlnprice_tr dlnRER dlnrgdp i.year if rank_exp<=20, a(group_id)

estfe exp_baseline exp_top50 exp_top20, labels(group_id "Firm-product-country FE")
esttab exp_baseline exp_top50 exp_top20 using "D:\Project C\tables\matched\table_exp_baseline.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "Top 50" "Top 20")

*-------------------------------------------------------------------------------
* Regressions with financial constraints for export
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year, a(group_id)
eststo exp_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo exp_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year, a(group_id)
eststo exp_Invent_US: areg dlnprice_tr dlnRER x_Invent_US dlnrgdp i.year, a(group_id)

estfe exp_FPC_US exp_ExtFin_US exp_Tang_US exp_Invent_US, labels(group_id "Firm-product-country FE")
esttab exp_FPC_US exp_ExtFin_US exp_Tang_US exp_Invent_US using "D:\Project C\tables\matched\table_exp_fin_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("FPC" "External Finance" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

eststo exp_ExtFin_cic2: areg dlnprice_tr dlnRER x_ExtFin_cic2 dlnrgdp i.year, a(group_id)
eststo exp_Tang_cic2: areg dlnprice_tr dlnRER x_Tang_cic2 dlnrgdp i.year, a(group_id)
eststo exp_Invent_cic2: areg dlnprice_tr dlnRER x_Invent_cic2 dlnrgdp i.year, a(group_id)
eststo exp_RDint_cic2: areg dlnprice_tr dlnRER x_RDint_cic2 dlnrgdp i.year, a(group_id)

estfe exp_ExtFin_cic2 exp_Tang_cic2 exp_Invent_cic2 exp_RDint_cic2, labels(group_id "Firm-product-country FE")
esttab exp_ExtFin_cic2 exp_Tang_cic2 exp_Invent_cic2 exp_RDint_cic2 using "D:\Project C\tables\matched\table_exp_fin_CN.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("External Finance" "Tangibility" "Inventory" "R&D Intensity") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Regressions with market share
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_MS: areg dlnprice_tr dlnRER x_MS dlnrgdp MS i.year, a(group_id)
eststo exp_MS_FPC_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_FPC_US dlnrgdp MS i.year, a(group_id)
eststo exp_MS_ExtFin_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_ExtFin_US dlnrgdp MS i.year, a(group_id)
eststo exp_MS_Tang_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_Tang_US dlnrgdp MS i.year, a(group_id)

estfe exp_MS exp_MS_FPC_US exp_MS_ExtFin_US exp_MS_Tang_US, labels(group_id "Firm-product-country FE")
esttab exp_MS exp_MS_FPC_US exp_MS_ExtFin_US exp_MS_Tang_US using "D:\Project C\tables\matched\table_exp_MS.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("MS" "Add FPC" "Add ExtFin" "Add Tangibility") order(dlnRER dlnrgdp x_*)

gen x_FPC_US_MS_d=x_FPC_US*MS_d
gen x_ExtFin_US_MS_d=x_ExtFin_US*MS_d
gen x_Tang_US_MS_d=x_ExtFin_US*MS_d
gen x_Invent_US_MS_d=x_ExtFin_US*MS_d
eststo exp_FPC_MS_d: areg dlnprice_tr dlnRER x_FPC_US x_FPC_US_MS_d dlnrgdp i.year, a(group_id)
eststo exp_ExtFin_MS_d: areg dlnprice_tr dlnRER x_ExtFin_US x_ExtFin_US_MS_d dlnrgdp i.year, a(group_id)
eststo exp_Tang_MS_d: areg dlnprice_tr dlnRER x_Tang_US x_Tang_US_MS_d dlnrgdp i.year, a(group_id)
eststo exp_Invent_MS_d: areg dlnprice_tr dlnRER x_Invent_US x_Invent_US_MS_d dlnrgdp i.year, a(group_id)
esttab exp_FPC_MS_d exp_ExtFin_MS_d exp_Tang_MS_d exp_Invent_MS_d using "D:\Project C\tables\matched\table_exp_MS_d.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("FPC" "ExtFin" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Regressions controlling firms' markup and TFP
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_markup: areg dlnprice_tr dlnRER x_Markup_lag dlnrgdp Markup_lag i.year, a(group_id)
eststo exp_FPC_US_markup: areg dlnprice_tr dlnRER x_FPC_US x_Markup_lag dlnrgdp Markup_lag i.year, a(group_id)
eststo exp_ExtFin_US_markup: areg dlnprice_tr dlnRER x_ExtFin_US x_Markup_lag dlnrgdp Markup_lag i.year, a(group_id)
eststo exp_Tang_US_markup: areg dlnprice_tr dlnRER x_Tang_US x_Markup_lag Markup_lag dlnrgdp i.year, a(group_id)
eststo exp_Invent_US_markup: areg dlnprice_tr dlnRER x_Invent_US x_Markup_lag Markup_lag dlnrgdp i.year, a(group_id)

estfe exp_markup exp_FPC_US_markup exp_ExtFin_US_markup exp_Tang_US_markup exp_Invent_US_markup, labels(group_id "Firm-product-country FE")
esttab exp_markup exp_FPC_US_markup exp_ExtFin_US_markup exp_Tang_US_markup exp_Invent_US_markup using "D:\Project C\tables\matched\table_exp_markup_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*_lag x_*_US)

eststo exp_tfp: areg dlnprice_tr dlnRER x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id)
eststo exp_ExtFin_US_tfp: areg dlnprice_tr dlnRER x_ExtFin_US x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id)
eststo exp_Tang_US_tfp: areg dlnprice_tr dlnRER x_Tang_US x_tfp_lag dlnrgdp tfp_lag i.year, a(group_id)

eststo exp_scratio: areg dlnprice_tr dlnRER x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)
eststo exp_ExtFin_US_scratio: areg dlnprice_tr dlnRER x_ExtFin_US x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)
eststo exp_Tang_US_scratio: areg dlnprice_tr dlnRER x_Tang_US x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)

estfe exp_markup exp_ExtFin_US_markup exp_Tang_US_markup exp_tfp exp_ExtFin_US_tfp exp_Tang_US_tfp exp_scratio exp_ExtFin_US_scratio exp_Tang_US_scratio, labels(group_id "Firm-product-country FE")
esttab exp_markup exp_ExtFin_US_markup exp_Tang_US_markup exp_tfp exp_ExtFin_US_tfp exp_Tang_US_tfp exp_scratio exp_ExtFin_US_scratio exp_Tang_US_scratio using "D:\Project C\tables\matched\table_exp_markup_tfp_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*_lag x_*_US)

*-------------------------------------------------------------------------------
* Two-way traders
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_twoway: areg dlnprice_tr dlnRER dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo exp_twoway_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo exp_twoway_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo exp_twoway_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if twoway_trade==1, a(group_id)
eststo exp_oneway: areg dlnprice_tr dlnRER dlnrgdp i.year if twoway_trade==0, a(group_id)
eststo exp_oneway_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if twoway_trade==0, a(group_id)
eststo exp_oneway_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if twoway_trade==0, a(group_id)
eststo exp_oneway_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if twoway_trade==0, a(group_id)

estfe exp_twoway exp_twoway_FPC_US exp_twoway_ExtFin_US exp_twoway_Tang_US exp_oneway exp_oneway_FPC_US exp_oneway_ExtFin_US exp_oneway_Tang_US, labels(group_id "Firm-product-country FE")
esttab exp_twoway exp_twoway_FPC_US exp_twoway_ExtFin_US exp_twoway_Tang_US exp_oneway exp_oneway_FPC_US exp_oneway_ExtFin_US exp_oneway_Tang_US using "D:\Project C\tables\matched\table_exp_twoway_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Twoway" "FPC" "External Finance" "Tangibility" "Oneway" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*_US)

*-------------------------------------------------------------------------------
* Export Markets
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_market: areg dlnprice_tr dlnRER x_market dlnrgdp i.year, a(group_id)

gen x_FPC_US_market=x_FPC_US*market
gen x_ExtFin_US_market=x_ExtFin_US*market
gen x_Tang_US_market=x_Tang_US*market
gen x_Invent_US_market=x_Invent_US*market

eststo exp_FPC_US_market: areg dlnprice_tr dlnRER x_market x_FPC_US_market x_FPC_US dlnrgdp i.year, a(group_id)
eststo exp_ExtFin_US_market: areg dlnprice_tr dlnRER x_market x_ExtFin_US_market x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo exp_Tang_US_market: areg dlnprice_tr dlnRER x_market x_Tang_US_market x_Tang_US dlnrgdp i.year, a(group_id)
eststo exp_Invent_US_market: areg dlnprice_tr dlnRER x_market x_Invent_US_market x_Invent_US dlnrgdp i.year, a(group_id)

estfe exp_market exp_FPC_US_market exp_ExtFin_US_market exp_Tang_US_market exp_Invent_US_market, labels(group_id "Firm-product-country FE")
esttab exp_market exp_FPC_US_market exp_ExtFin_US_market exp_Tang_US_market exp_Invent_US_market using "D:\Project C\tables\matched\table_exp_market.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Alternative FEs
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

egen group_id_fy=group(FRDM year)
egen group_id_pc=group(HS6 coun_aim)

eststo exp_FPC_US_fe1: reghdfe dlnprice_tr dlnRER x_FPC_US dlnrgdp, absorb(group_id_fy coun_aim HS6)
eststo exp_ExtFin_US_fe1: reghdfe dlnprice_tr dlnRER x_ExtFin_US dlnrgdp, absorb(group_id_fy coun_aim HS6)
eststo exp_Tang_US_fe1: reghdfe dlnprice_tr dlnRER x_Tang_US dlnrgdp, absorb(group_id_fy coun_aim HS6)
eststo exp_Invent_US_fe1: reghdfe dlnprice_tr dlnRER x_Invent_US dlnrgdp, absorb(group_id_fy coun_aim HS6)

eststo exp_FPC_US_fe2: reghdfe dlnprice_tr dlnRER x_FPC_US dlnrgdp, absorb(group_id_fy group_id_pc)
eststo exp_ExtFin_US_fe2: reghdfe dlnprice_tr dlnRER x_ExtFin_US dlnrgdp, absorb(group_id_fy group_id_pc)
eststo exp_Tang_US_fe2: reghdfe dlnprice_tr dlnRER x_Tang_US dlnrgdp, absorb(group_id_fy group_id_pc)
eststo exp_Invent_US_fe2: reghdfe dlnprice_tr dlnRER x_Invent_US dlnrgdp, absorb(group_id_fy group_id_pc)

estfe exp_FPC_US_fe1 exp_ExtFin_US_fe1 exp_Tang_US_fe1 exp_Invent_US_fe1 exp_FPC_US_fe2 exp_ExtFin_US_fe2 exp_Tang_US_fe2 exp_Invent_US_fe2, labels(group_id "Firm-product-country FE" group_id_fy "Firm-year FE" group_id_pc "Product-Country FE" coun_aim "Country FE" HS6 "Product FE")
esttab exp_FPC_US_fe1 exp_ExtFin_US_fe1 exp_Tang_US_fe1 exp_Invent_US_fe1 exp_FPC_US_fe2 exp_ExtFin_US_fe2 exp_Tang_US_fe2 exp_Invent_US_fe2 using "D:\Project C\tables\matched\table_exp_fe.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate(`r(indicate_fe)') mtitles("FPC" "External Finance" "Tangibility" "Inventory" "FPC" "External Finance" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Ownership Types
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_SOE_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="SOE", a(group_id)
eststo exp_SOE_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="SOE", a(group_id)
eststo exp_SOE_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="SOE", a(group_id)
eststo exp_SOE_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="SOE", a(group_id)

eststo exp_DPE_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="DPE", a(group_id)
eststo exp_DPE_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="DPE", a(group_id)
eststo exp_DPE_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="DPE", a(group_id)
eststo exp_DPE_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="DPE", a(group_id)

eststo exp_MNE_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="MNE", a(group_id)
eststo exp_MNE_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="MNE", a(group_id)
eststo exp_MNE_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="MNE", a(group_id)
eststo exp_MNE_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="MNE", a(group_id)

eststo exp_JV_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if ownership=="JV", a(group_id)
eststo exp_JV_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if ownership=="JV", a(group_id)
eststo exp_JV_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if ownership=="JV", a(group_id)
eststo exp_JV_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if ownership=="JV", a(group_id)

estfe exp_SOE_baseline exp_SOE_FPC_US exp_SOE_ExtFin_US exp_SOE_Tang_US exp_DPE_baseline exp_DPE_FPC_US exp_DPE_ExtFin_US exp_DPE_Tang_US exp_MNE_baseline exp_MNE_FPC_US exp_MNE_ExtFin_US exp_MNE_Tang_US exp_JV_baseline exp_JV_FPC_US exp_JV_ExtFin_US exp_JV_Tang_US,labels(group_id "Firm-product-country FE")

esttab exp_SOE_baseline exp_SOE_FPC_US exp_SOE_ExtFin_US exp_SOE_Tang_US exp_DPE_baseline exp_DPE_FPC_US exp_DPE_ExtFin_US exp_DPE_Tang_US exp_MNE_baseline exp_MNE_FPC_US exp_MNE_ExtFin_US exp_MNE_Tang_US exp_JV_baseline exp_JV_FPC_US exp_JV_ExtFin_US exp_JV_Tang_US using "D:\Project C\tables\matched\table_exp_ownership.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility" "Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Excluding USD Peg
cd "D:\Project C\sample_matched"
use sample_matched_exp,clear

eststo exp_nopeg_baseline: areg dlnprice_tr dlnRER dlnrgdp i.year if peg_USD==0, a(group_id)
eststo exp_nopeg_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if peg_USD==0, a(group_id)
eststo exp_nopeg_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if peg_USD==0, a(group_id)
eststo exp_nopeg_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if peg_USD==0, a(group_id)

estfe exp_nopeg_baseline exp_nopeg_FPC_US exp_nopeg_ExtFin_US exp_nopeg_Tang_US, labels(group_id "Firm-product-country FE")
esttab exp_nopeg_baseline exp_nopeg_FPC_US exp_nopeg_ExtFin_US exp_nopeg_Tang_US using "D:\Project C\tables\matched\table_exp_nopeg.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)