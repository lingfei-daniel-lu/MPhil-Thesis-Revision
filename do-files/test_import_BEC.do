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

eststo imp_intermediate: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_intermediate_FPC_US: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital x_FPC_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_intermediate_ExtFin_US: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital x_ExtFin_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)
eststo imp_intermediate_Tang_US: areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital x_Tang_US dlnrgdp i.year, a(group_id) vce(cluster FRDM)

estfe imp_intermediate*, labels(group_id "Firm-product-country FE")
esttab imp_intermediate* using "D:\Project C\tables\matched\table_imp_intermediate.csv", replace b(3) se(3) noconstant starlevels(* 0.1 ** 0.05 *** 0.01) indicate("Year FE =*.year" `r(indicate_fe)') order(dlnRER dlnrgdp c.* x_*)