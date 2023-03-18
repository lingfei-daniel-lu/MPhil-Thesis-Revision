set processors 12
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
* Import Sources
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

gen x_source=dlnRER*source
gen x_FPC_US_source=x_FPC_US*source
gen x_ExtFin_US_source=x_ExtFin_US*source
gen x_Tang_US_source=x_Tang_US*source
gen x_Invent_US_source=x_Invent_US*source

eststo imp_source: areg dlnprice_tr dlnRER x_source dlnrgdp i.year, a(group_id)
eststo imp_FPC_US_source: areg dlnprice_tr dlnRER x_source x_FPC_US_source x_FPC_US dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US_source: areg dlnprice_tr dlnRER x_source x_ExtFin_US_source x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo imp_Tang_US_source: areg dlnprice_tr dlnRER x_source x_Tang_US_source x_Tang_US dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_source: areg dlnprice_tr dlnRER x_source x_Invent_US_source x_Invent_US dlnrgdp i.year, a(group_id)

estfe imp_source imp_FPC_US_source imp_ExtFin_US_source imp_Tang_US_source imp_Invent_US_source, labels(group_id "Firm-product-country FE")
esttab imp_source imp_FPC_US_source imp_ExtFin_US_source imp_Tang_US_source imp_Invent_US_source using "D:\Project C\tables\matched\table_imp_source.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

gen x_source_initial=dlnRER*source_initial
gen x_FPC_US_source_initial=x_FPC_US*source_initial
gen x_ExtFin_US_source_initial=x_ExtFin_US*source_initial
gen x_Tang_US_source_initial=x_Tang_US*source_initial
gen x_Invent_US_source_initial=x_Invent_US*source_initial

eststo imp_source_init: areg dlnprice_tr dlnRER x_source_initial dlnrgdp i.year, a(group_id)
eststo imp_FPC_US_source_init: areg dlnprice_tr dlnRER x_source_initial x_FPC_US_source_initial x_FPC_US dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US_source_init: areg dlnprice_tr dlnRER x_source_initial x_ExtFin_US_source_initial x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo imp_Tang_US_source_init: areg dlnprice_tr dlnRER x_source_initial x_Tang_US_source_initial x_Tang_US dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_source_init: areg dlnprice_tr dlnRER x_source_initial x_Invent_US_source_initial x_Invent_US dlnrgdp i.year, a(group_id)

estfe imp_source_init imp_FPC_US_source_init imp_ExtFin_US_source_init imp_Tang_US_source_init imp_Invent_US_source_init, labels(group_id "Firm-product-country FE")
esttab imp_source_init imp_FPC_US_source_init imp_ExtFin_US_source_init imp_Tang_US_source_init imp_Invent_US_source_init using "D:\Project C\tables\matched\table_imp_source_initial.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Distance
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

gen x_dist=dlnRER*dist
gen x_FPC_US_dist=x_FPC_US*dist
gen x_ExtFin_US_dist=x_ExtFin_US*dist
gen x_Tang_US_dist=x_Tang_US*dist
gen x_Invent_US_dist=x_Invent_US*dist

eststo imp_dist: areg dlnprice_tr dlnRER x_dist dlnrgdp i.year, a(group_id)
eststo imp_FPC_US_dist: areg dlnprice_tr dlnRER x_dist x_FPC_US_dist x_FPC_US dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US_dist: areg dlnprice_tr dlnRER x_dist x_ExtFin_US_dist x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo imp_Tang_US_dist: areg dlnprice_tr dlnRER x_dist x_Tang_US_dist x_Tang_US dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_dist: areg dlnprice_tr dlnRER x_dist x_Invent_US_dist x_Invent_US dlnrgdp i.year, a(group_id)

estfe imp_dist imp_FPC_US_dist imp_ExtFin_US_dist imp_Tang_US_dist imp_Invent_US_dist, labels(group_id "Firm-product-country FE")
esttab imp_dist imp_FPC_US_dist imp_ExtFin_US_dist imp_Tang_US_dist imp_Invent_US_dist using "D:\Project C\tables\matched\table_imp_dist.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

gen x_distw=dlnRER*distw
gen x_FPC_US_distw=x_FPC_US*distw
gen x_ExtFin_US_distw=x_ExtFin_US*distw
gen x_Tang_US_distw=x_Tang_US*distw
gen x_Invent_US_distw=x_Invent_US*distw

eststo imp_distw: areg dlnprice_tr dlnRER x_distw dlnrgdp i.year, a(group_id)
eststo imp_FPC_US_distw: areg dlnprice_tr dlnRER x_distw x_FPC_US_distw x_FPC_US dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US_distw: areg dlnprice_tr dlnRER x_distw x_ExtFin_US_distw x_ExtFin_US dlnrgdp i.year, a(group_id)
eststo imp_Tang_US_distw: areg dlnprice_tr dlnRER x_distw x_Tang_US_distw x_Tang_US dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_distw: areg dlnprice_tr dlnRER x_distw x_Invent_US_distw x_Invent_US dlnrgdp i.year, a(group_id)

estfe imp_distw imp_FPC_US_distw imp_ExtFin_US_distw imp_Tang_US_distw imp_Invent_US_distw, labels(group_id "Firm-product-country FE")
esttab imp_distw imp_FPC_US_distw imp_ExtFin_US_distw imp_Tang_US_distw imp_Invent_US_distw using "D:\Project C\tables\matched\table_imp_distw.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

*-------------------------------------------------------------------------------
* Regressions with market share
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_MS: areg dlnprice_tr dlnRER x_MS dlnrgdp MS i.year, a(group_id)
eststo imp_MS_FPC_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_FPC_US dlnrgdp MS i.year, a(group_id)
eststo imp_MS_ExtFin_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_ExtFin_US dlnrgdp MS i.year, a(group_id)
eststo imp_MS_Tang_US: areg dlnprice_tr dlnRER x_MS x_MS_sqr x_Tang_US dlnrgdp MS i.year, a(group_id)

estfe imp_MS imp_MS_FPC_US imp_MS_ExtFin_US imp_MS_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_MS imp_MS_FPC_US imp_MS_ExtFin_US imp_MS_Tang_US using "D:\Project C\tables\matched\table_imp_MS.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("MS" "Add FPC" "Add ExtFin" "Add Tangibility") order(dlnRER dlnrgdp x_*)

xtile MS_xt2=MS,nq(2)
gen MS_d=MS_xt2-1
gen x_MS_d=dlnRER*MS_d
gen x_FPC_US_MS_d=x_FPC_US*MS_d
gen x_ExtFin_US_MS_d=x_ExtFin_US*MS_d
gen x_Tang_US_MS_d=x_ExtFin_US*MS_d`'
gen x_Invent_US_MS_d=x_ExtFin_US*MS_d

eststo imp_MS_d: areg dlnprice_tr dlnRER x_MS_d dlnrgdp i.year, a(group_id)
eststo imp_FPC_US_MS_d: areg dlnprice_tr dlnRER x_MS_d x_FPC_US x_FPC_US_MS_d dlnrgdp i.year, a(group_id)
eststo imp_ExtFin_US_MS_d: areg dlnprice_tr dlnRER x_MS_d x_ExtFin_US x_ExtFin_US_MS_d dlnrgdp i.year, a(group_id)
eststo imp_Tang_US_MS_d: areg dlnprice_tr dlnRER x_MS_d x_Tang_US x_Tang_US_MS_d dlnrgdp i.year, a(group_id)
eststo imp_Invent_US_MS_d: areg dlnprice_tr dlnRER x_MS_d x_Invent_US x_Invent_US_MS_d dlnrgdp i.year, a(group_id)

estfe imp_MS_d imp_FPC_US_MS_d imp_ExtFin_US_MS_d imp_Tang_US_MS_d imp_Invent_US_MS_d, labels(group_id "Firm-product-country FE")
esttab imp_MS_d imp_FPC_US_MS_d imp_ExtFin_US_MS_d imp_Tang_US_MS_d imp_Invent_US_MS_d using "D:\Project C\tables\matched\table_imp_MS_d.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "ExtFin" "Tangibility" "Inventory") order(dlnRER dlnrgdp x_*)

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

gen x_scratio_lag=dlnRER*scratio_lag

eststo imp_scratio: areg dlnprice_tr dlnRER x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)
eststo imp_ExtFin_US_scratio: areg dlnprice_tr dlnRER x_ExtFin_US x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)
eststo imp_Tang_US_scratio: areg dlnprice_tr dlnRER x_Tang_US x_scratio_lag dlnrgdp scratio_lag i.year, a(group_id)

estfe imp_markup imp_ExtFin_US_markup imp_Tang_US_markup imp_tfp imp_ExtFin_US_tfp imp_Tang_US_tfp imp_scratio imp_ExtFin_US_scratio imp_Tang_US_scratio, labels(group_id "Firm-product-country FE")
esttab imp_markup imp_ExtFin_US_markup imp_Tang_US_markup imp_tfp imp_ExtFin_US_tfp imp_Tang_US_tfp imp_scratio imp_ExtFin_US_scratio imp_Tang_US_scratio using "D:\Project C\tables\matched\table_imp_markup_tfp_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*_lag x_*_US)

*-------------------------------------------------------------------------------
* Duration
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

gen duration_d=1 if duration>=4
replace duration_d=0 if duration<=3

eststo imp_duration_old: areg dlnprice_tr dlnRER dlnrgdp i.year if duration_d==1, a(group_id)
eststo imp_duration_new: areg dlnprice_tr dlnRER dlnrgdp i.year if duration_d==0, a(group_id)
eststo imp_duration_old_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if duration_d==1, a(group_id)
eststo imp_duration_new_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.year if duration_d==0, a(group_id)
eststo imp_duration_old_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if duration_d==1, a(group_id)
eststo imp_duration_new_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.year if duration_d==0, a(group_id)
eststo imp_duration_old_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if duration_d==1, a(group_id)
eststo imp_duration_new_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.year if duration_d==0, a(group_id)

estfe imp_duration_old* imp_duration_new*, labels(group_id "Firm-product-country FE")
esttab imp_duration_old* imp_duration_new* using "D:\Project C\tables\matched\table_imp_duration_sub.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

gen x_duration_d=dlnRER*duration_d
gen x_FPC_US_duration_d=x_FPC_US*duration_d
gen x_ExtFin_US_duration_d=x_ExtFin_US*duration_d
gen x_Tang_US_duration_d=x_Tang_US*duration_d

eststo imp_duration: areg dlnprice_tr dlnRER x_duration_d dlnrgdp i.year, a(group_id)
eststo imp_duration_FPC_US: areg dlnprice_tr dlnRER x_duration_d x_FPC_US x_FPC_US_duration_d dlnrgdp i.year, a(group_id)
eststo imp_duration_ExtFin_US: areg dlnprice_tr dlnRER x_duration_d x_ExtFin_US x_ExtFin_US_duration_d dlnrgdp i.year, a(group_id)
eststo imp_duration_Tang_US: areg dlnprice_tr dlnRER x_duration_d x_Tang_US x_Tang_US_duration_d dlnrgdp i.year, a(group_id)

estfe imp_duration imp_duration_FPC_US imp_duration_ExtFin_US imp_duration_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_duration imp_duration_FPC_US imp_duration_ExtFin_US imp_duration_Tang_US using "D:\Project C\tables\matched\table_imp_duration.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp x_*)

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

gen SOE=1 if ownership=="SOE"
replace SOE=0 if SOE==.
gen MNE=1 if ownership=="MNE"
replace MNE=0 if MNE==.
gen JV=1 if ownership=="JV"
replace JV=0 if JV==.

egen group_id_pc=group(HS6 coun_aim)
eststo imp_ownership_baseline: areg dlnprice_tr dlnRER dlnrgdp SOE MNE JV rSI i.year, a(group_id_pc)
eststo imp_ownership_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp SOE MNE JV rSI i.year, a(group_id_pc)
eststo imp_ownership_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp SOE MNE JV rSI i.year, a(group_id_pc)
eststo imp_ownership_Tang_US: areg dlnprice_tr dlnRER dlnrgdp x_Tang_US SOE MNE JV rSI i.year, a(group_id_pc)

estfe imp_ownership_baseline imp_ownership_FPC_US imp_ownership_ExtFin_US imp_ownership_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_ownership_baseline imp_ownership_FPC_US imp_ownership_ExtFin_US imp_ownership_Tang_US using "D:\Project C\tables\matched\table_imp_ownership.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)

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
* Two-way traders
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear

eststo imp_twoway_baseline: areg dlnprice_tr dlnRER dlnrgdp i.twoway_trade i.year, a(group_id)
eststo imp_twoway_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.twoway_trade i.year, a(group_id)
eststo imp_twoway_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.twoway_trade i.year, a(group_id)
eststo imp_twoway_Tang_US: areg dlnprice_tr dlnRER x_Tang_US dlnrgdp i.twoway_trade i.year, a(group_id)

estfe imp_twoway_baseline imp_twoway_FPC_US imp_twoway_ExtFin_US imp_twoway_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_twoway_baseline imp_twoway_FPC_US imp_twoway_ExtFin_US imp_twoway_Tang_US using "D:\Project C\tables\matched\table_imp_twoway_US.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" "Two-way FE =*.twoway_trade" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*_US)

*-------------------------------------------------------------------------------
* Ordinary vs Processing
use sample_matched_imp_shipment,clear

eststo imp_process_baseline: areg dlnprice_tr dlnRER dlnrgdp i.shipment_type i.year, a(group_id)
eststo imp_process_FPC_US: areg dlnprice_tr dlnRER x_FPC_US dlnrgdp i.shipment_type i.year, a(group_id)
eststo imp_process_ExtFin_US: areg dlnprice_tr dlnRER x_ExtFin_US dlnrgdp i.shipment_type i.year, a(group_id)
eststo imp_process_Tang_US: areg dlnprice_tr dlnRER dlnrgdp x_Tang_US i.shipment_type i.year, a(group_id)

estfe imp_process_baseline imp_process_FPC_US imp_process_ExtFin_US imp_process_Tang_US, labels(group_id "Firm-product-country FE")
esttab imp_process_baseline imp_process_FPC_US imp_process_ExtFin_US imp_process_Tang_US using "D:\Project C\tables\matched\table_imp_processing.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" "Processing FE =*.shipment_type" `r(indicate_fe)') mtitles("Baseline" "FPC" "External Finance" "Tangibility") order(dlnRER dlnrgdp x_*)