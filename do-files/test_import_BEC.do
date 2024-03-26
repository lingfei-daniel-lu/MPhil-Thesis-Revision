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

areg dlnprice_tr dlnRER c.dlnRER#c.consumption dlnrgdp i.year, a(group_id) vce(cluster FRDM)
areg dlnprice_tr dlnRER c.dlnRER#c.capital dlnrgdp i.year, a(group_id) vce(cluster FRDM)
areg dlnprice_tr dlnRER c.dlnRER#c.intermediate dlnrgdp i.year, a(group_id) vce(cluster FRDM)
areg dlnprice_tr dlnRER c.dlnRER#c.consumption c.dlnRER#c.capital c.dlnRER#c.intermediate dlnrgdp i.year, a(group_id) vce(cluster FRDM)
