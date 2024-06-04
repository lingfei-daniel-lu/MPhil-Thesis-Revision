* Product category
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear
merge n:1 HS6 using "D:\Project E\BEC classification\HS6_BEC_category",nogen keep(matched)

gen consumption=1 if BEC_category=="Consumption"
replace consumption=0 if consumption==.
gen intermediate=1 if BEC_category=="Intermediate"
replace intermediate=0 if intermediate==.
gen capital=1 if BEC_category=="Capital"
replace capital=0 if capital==.

drop if BEC_category=="Other"

eststo imp_BEC: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_BEC_FPC_US: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital x_FPC_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_BEC_ExtFin_US: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital x_ExtFin_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_BEC_Tang_US: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital x_Tang_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_BEC*, labels(group_id "Firm-product-country FE")
esttab imp_BEC* using "D:\Project C\tables\matched\table_imp_BEC.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.* x_*)

* Homogenous vs differentiated good
cd "D:\Project C\sample_matched"
use sample_matched_imp,clear
* add Rauch (1999) classification
merge m:1 HS6 using "D:\Project E\Rauch classification\HS6_Rauch", nogen keep(matched master) keepus(Rauch_*)

eststo imp_Rauch: areg dlnprice_tr dlnRER c.dlnRER#c.Rauch_con_r dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Rauch_FPC_US: areg dlnprice_tr dlnRER c.dlnRER#c.Rauch_con_r x_FPC_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Rauch_ExtFin_US: areg dlnprice_tr dlnRER c.dlnRER#c.Rauch_con_r x_ExtFin_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_Rauch_Tang_US: areg dlnprice_tr dlnRER c.dlnRER#c.Rauch_con_r x_Tang_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_Rauch*, labels(group_id "Firm-product-country FE")
esttab imp_Rauch* using "D:\Project C\tables\matched\table_imp_Rauch.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.* x_*)
