set processors 16
dis c(processors)

*-------------------------------------------------------------------------------
* Use aggregate index data
cd "D:\Project C\aggregate index"
import excel ".\CN EER Index.xlsx", sheet("Sheet1") firstrow clear
save CN_EER_index,replace

use "D:\Project C\PWT10.0\pwt100.dta", clear
keep if countrycode=="CHN"
keep year xr rgdpna pl_c pl_x pl_m
merge n:1 year using CN_EER_index, nogen keep(matched)
gen pcost=NEER_index*pl_c/REER_index
gen dlnprice_exp=ln(pl_x)-ln(pl_x[_n-1]) if year==year[_n-1]+1
gen dlnprice_imp=ln(pl_m)-ln(pl_m[_n-1]) if year==year[_n-1]+1
gen dlnREER=ln(REER_index)-ln(REER_index[_n-1]) if year==year[_n-1]+1
gen dlnpcost=ln(pcost)-ln(pcost[_n-1]) if year==year[_n-1]+1
gen dlnrgdp=ln(rgdpna)-ln(rgdpna[_n-1]) if year==year[_n-1]+1
save CN_index_94_19,replace

use CN_index_94_19,clear
gen period=1 if year<=2007
replace period=2 if year>2007
reg dlnprice_exp dlnREER dlnpcost dlnrgdp
reg dlnprice_imp dlnREER dlnpcost dlnrgdp
forv i=1/2{
eststo reg_index_exp_`i': reg dlnprice_exp dlnREER dlnpcost dlnrgdp if period==`i'
eststo reg_index_imp_`i': reg dlnprice_imp dlnREER dlnpcost dlnrgdp if period==`i'
}

*-------------------------------------------------------------------------------
* IMF CPI data
cd "D:\Project C\IMF CPI"
import excel International_Financial_Statistics_CPI, firstrow clear
rename (A B C D E F G H I J K L M N) (country cpi1999 cpi2000 cpi2001 cpi2002 cpi2003 cpi2004 cpi2005 cpi2006 cpi2007 cpi2008 cpi2009 cpi2010 cpi2011)
reshape long cpi, i(country) j(year)
bys country: egen year_count=count(cpi)
keep if year_count==13
drop year_count
save CPI_99_11,replace

cd "D:\Project C\IMF CPI"
import excel "D:\Project C\IMF CPI\IFS_country_name.xls", sheet("Sheet1") firstrow clear
drop if countrycode==""
merge 1:n country using CPI_99_11,nogen keep(matched)
save CPI_99_11_code,replace

*-------------------------------------------------------------------------------
* Construct exchange rate from PWT10.0
cd "D:\Project C\PWT10.0"
use PWT100,clear
keep countrycode country currency_unit
duplicates drop
merge 1:1 countrycode using "D:\Project A\ER_GEM\country_name",nogen keep(matched master)
replace coun_aim="安圭拉" if countrycode=="AIA"
replace coun_aim="库拉索" if countrycode=="CUW"
replace coun_aim="黑山" if countrycode=="MNE"
replace coun_aim="蒙特塞拉特" if countrycode=="MSR"
replace coun_aim="巴勒斯坦" if countrycode=="PSE"
replace coun_aim="塞尔维亚" if countrycode=="SRB"
replace coun_aim="荷属圣马丁" if countrycode=="SXM"
replace coun_aim="特克斯和凯科斯群岛" if countrycode=="TCA"
replace coun_aim="土库曼斯坦" if countrycode=="TKM"
replace coun_aim="英属维尔京群岛" if countrycode=="VGB"
replace coun_aim="刚果民主共和国" if countrycode=="COD"
save pwt_country_name,replace

cd "D:\Project C\PWT10.0"
use PWT100,clear
keep if year>=1999 & year<=2011 
keep countrycode country currency_unit year xr rgdpna
merge n:1 countrycode country currency_unit using pwt_country_name,nogen
merge n:1 countrycode year using "D:\Project C\IMF CPI\CPI_99_11_code",nogen
drop if xr==.
* Bilateral nominal exchange rate relative to RMB at the same year
gen NER=1/(xr/8.27825) if year==1999
replace NER=8.2785042/xr if year==2000
replace NER=8.2770683/xr if year==2001
replace NER=8.2769575/xr if year==2002
replace NER=8.2770367/xr if year==2003
replace NER=8.2768008/xr if year==2004
replace NER=8.1943167/xr if year==2005
replace NER=7.9734383/xr if year==2006
replace NER=7.6075325/xr if year==2007
replace NER=6.948655/xr if year==2008
replace NER=6.8314161/xr if year==2009
replace NER=6.770269/xr if year==2010
replace NER=6.4614613/xr if year==2011
label var NER "Nominal exchange rate in terms of RMB at the same year"
* Bilateral real exchange rate = NER*foreign CPI/Chinese CPI
gen RER=NER*cpi/80.69 if year==1999
replace RER=NER*cpi/80.97 if year==2000
replace RER=NER*cpi/81.55 if year==2001
replace RER=NER*cpi/80.96 if year==2002
replace RER=NER*cpi/81.87 if year==2003
replace RER=NER*cpi/85.00 if year==2004
replace RER=NER*cpi/86.51 if year==2005
replace RER=NER*cpi/87.94 if year==2006
replace RER=NER*cpi/92.17 if year==2007
replace RER=NER*cpi/97.63 if year==2008
replace RER=NER*cpi/96.92 if year==2009
replace RER=NER*cpi/100.00 if year==2010
replace RER=NER*cpi/105.55 if year==2011
label var RER "Real exchange rate to China price at the same year"
sort coun_aim year
by coun_aim: gen dlnRER= ln(RER)-ln(RER[_n-1]) if year==year[_n-1]+1
by coun_aim: gen dlnrgdp=ln(rgdpna)-ln(rgdpna[_n-1]) if year==year[_n-1]+1
gen peg_USD=1 if countrycode=="ABW" | countrycode=="BHS" | countrycode=="PAN" | countrycode=="BHR"  | countrycode=="BRB" | countrycode=="BLZ" | countrycode=="BMU" | currency_unit =="East Caribbean Dollar" | currency_unit =="Netherlands Antillian Guilder"| currency_unit =="US Dollar" | countrycode=="DJI" | countrycode=="HKG" | countrycode=="JOR" | countrycode=="LBN" | countrycode=="MAC" | countrycode=="MDV" | countrycode=="OMN" | countrycode=="PAN" | countrycode=="QAT" | countrycode=="SAU" | countrycode=="ARE" | xr==1
replace peg_USD=0 if peg_USD==.
save RER_99_11.dta,replace

*-------------------------------------------------------------------------------
* Use custom full data
cd "D:\Project C\customs data"
use tradedata_2000_concise,clear
forv i=2001/2011{
append using tradedata_`i'_concise
}
drop if value==0 | quantity==0 | party_id==""
drop CompanyType
sort party_id exp_imp HS8 coun_aim year
format EN %30s
format party_id coun_aim %15s
save customs_00-11.dta,replace

cd "D:\Project C\HS Conversion"
import excel "HS 2007 to HS 2002 Correlation and conversion tables.xls", sheet("Conversion Tables") cellrange(A2:B5054) firstrow allstring clear
save HS2007to2002.dta, replace
import excel "HS 2007 to HS 1996 Correlation and conversion tables.xls", sheet("Conversion Tables") cellrange(A2:B5054) firstrow allstring clear
save HS2007to1996.dta, replace
import excel "HS2002 to HS1996 - Correlation and conversion tables.xls", sheet("Conversion Table") cellrange(A2:B5225) firstrow allstring clear
save HS2002to1996.dta, replace

cd "D:\Project C\customs data"
use ".\customs_00-11.dta",clear
* Refer to the do-file "customs_country_clean" for program details
customs_country_clean
save customs_country_name,replace

import delimited "D:\Project C\customs data\ISO-3166.csv", stringcols(4 8 9) clear
keep alpha3 countrycode
rename (alpha3 countrycode) (countrycode country)
replace country=substr("000"+country,-3,.) if country!=""
save ISO3166_alpha,replace

use customs_country_name,clear
drop coun_aim
rename country_adj coun_aim
duplicates drop
merge 1:1 countrycode using ISO3166_alpha,nogen keep(matched master)
save customs_country_code,replace

cd "D:\Project C"
use ".\customs data\customs_00-11.dta",clear
by party_id: egen EN_adj=mode(EN),maxmode
drop EN
rename EN_adj EN
merge n:1 coun_aim using ".\customs data\customs_country_name",nogen keep(matched)
drop coun_aim
rename country_adj coun_aim
drop if coun_aim==""|coun_aim=="中华人民共和国"
gen HS2007=substr(HS8,1,6) if year>=2007
merge n:1 HS2007 using "D:\Project C\HS Conversion\HS2007to1996.dta",nogen update replace
gen HS2002=substr(HS8,1,6) if year<2007 & year>=2002
merge n:1 HS2002 using "D:\Project C\HS Conversion\HS2002to1996.dta",nogen update replace
replace HS1996=substr(HS8,1,6) if year<2002
rename HS1996 HS6
drop if HS6==""
collapse (sum) value quant, by (party_id EN exp_imp HS6 coun_aim year shipment)
format EN %30s
format coun_aim %20s
cd "D:\Project C\sample_all"
save customs_all,replace

*-------------------------------------------------------------------------------
* Construct top trade partners
cd "D:\Project C\sample_all"
use customs_all,clear
collapse (sum) value, by (coun_aim exp_imp)
gen value_exp=value if exp_imp=="exp"
gen value_imp=value if exp_imp=="imp"
collapse (sum) value_exp value_imp , by (coun_aim)
gsort -value_exp, gen(rank_exp)
gsort -value_imp, gen(rank_imp)
save customs_all_top_partners,replace

*-------------------------------------------------------------------------------
* Construct export sample
cd "D:\Project C\sample_all"
use customs_all,clear
keep if exp_imp =="exp"
drop exp_imp
foreach key in 贸易 外贸 经贸 工贸 科贸 商贸 边贸 技贸 进出口 进口 出口 物流 仓储 采购 供应链 货运{
	drop if strmatch(EN, "*`key'*") 
}
merge n:1 coun_aim using "D:\Project C\sample_all\customs_all_top_partners",nogen keep(matched)
merge n:1 year using "D:\Project C\PWT10.0\US_NER_99_11",nogen keep(matched)
merge n:1 year coun_aim using "D:\Project C\PWT10.0\RER_99_11.dta",nogen keep(matched) keepus(NER RER dlnRER dlnrgdp)
sort party_id HS6 coun_aim year
gen price_RMB=value*NER_US/quant
by party_id HS6 coun_aim: gen dlnprice=ln(price_RMB)-ln(price_RMB[_n-1]) if year==year[_n-1]+1
by party_id HS6 coun_aim: egen year_count=count(year)
drop if dlnRER==. | dlnprice==.
gen HS2=substr(HS6,1,2)
drop if HS2=="93"|HS2=="97"|HS2=="98"|HS2=="99"
winsor2 dlnprice, trim by(HS2 year)
egen group_id=group(party_id HS6 coun_aim)
save sample_all_exp,replace

*-------------------------------------------------------------------------------
* Construct import sample
cd "D:\Project C\sample_all"
use customs_all,clear
keep if exp_imp =="imp"
drop exp_imp
collapse (sum) value_year quant_year, by(FRDM EN year coun_aim HS6)
foreach key in 贸易 外贸 经贸 工贸 科贸 商贸 边贸 技贸 进出口 进口 出口 物流 仓储 采购 供应链 货运{
	drop if strmatch(EN, "*`key'*") 
}
merge n:1 coun_aim using "D:\Project C\sample_all\customs_all_top_partners",nogen keep(matched)
merge n:1 year using "D:\Project C\PWT10.0\US_NER_99_11",nogen keep(matched)
merge n:1 year coun_aim using "D:\Project C\PWT10.0\RER_99_11.dta",nogen keep(matched) keepus(NER RER dlnRER dlnrgdp)
sort party_id HS6 coun_aim year
gen price_RMB=value*NER_US/quant
by party_id HS6 coun_aim: gen dlnprice=ln(price_RMB)-ln(price_RMB[_n-1]) if year==year[_n-1]+1
by party_id HS6 coun_aim: egen year_count=count(year)
drop if dlnRER==. | dlnprice==.
gen HS2=substr(HS6,1,2)
drop if HS2=="93"|HS2=="97"|HS2=="98"|HS2=="99"
winsor2 dlnprice, trim by(HS2 year)
egen group_id=group(party_id HS6 coun_aim)
save sample_all_imp,replace

*-------------------------------------------------------------------------------
* Use custom matched data
cd "D:\Project C\sample_matched"
use "D:\Project A\customs merged\cust.matched.all.dta",clear
tostring party_id,replace
bys FRDM: egen EN_adj=mode(EN),maxmode
drop EN
rename EN_adj EN
merge n:1 coun_aim using "D:\Project C\customs data\customs_country_name",nogen keep(matched)
drop coun_aim
rename country_adj coun_aim
drop if coun_aim==""|coun_aim=="中华人民共和国"
rename hs_id HS8
tostring HS8,replace
replace HS8 = "0" + HS8 if length(HS8) == 7
gen HS2007=substr(HS8,1,6) if year==2007
merge n:1 HS2007 using "D:\Project C\HS Conversion\HS2007to1996.dta",nogen update replace
gen HS2002=substr(HS8,1,6) if year<2007 & year>=2002
merge n:1 HS2002 using "D:\Project C\HS Conversion\HS2002to1996.dta",nogen update replace
replace HS1996=substr(HS8,1,6) if year<2002
rename HS1996 HS6
drop if HS6=="" | FRDM=="" | quant_year==0 | value_year==0
collapse (sum) value_year quant_year, by (FRDM EN exp_imp party_id HS6 coun_aim year shipment)
sort FRDM HS6 coun_aim year
format EN %30s
format coun_aim %20s
format shipment %20s
save customs_matched,replace

*-------------------------------------------------------------------------------
* Construct matching directory
cd "D:\Project C\sample_matched"
use "D:\Project A\customs merged\cust.matched.all.dta",clear
keep FRDM party_id year exp_imp
tostring party_id,replace
duplicates drop party_id year exp_imp,force
save customs_matched_imp_partyid,replace

*-------------------------------------------------------------------------------
* Use new custom matched data
cd "D:\Project C\sample_matched"
use "D:\Project C\sample_all\customs_all",clear
merge n:1 party_id year exp_imp using customs_matched_imp_partyid, nogen keep(matched)
collapse (sum) value quant, by (FRDM EN exp_imp party_id HS6 coun_aim year shipment)
merge 1:1 FRDM EN exp_imp party_id HS6 coun_aim year shipment using customs_matched
sort FRDM HS6 coun_aim year
format EN %30s
format coun_aim %20s
save customs_matched_new,replace

*-------------------------------------------------------------------------------
* Construct top trade partners
cd "D:\Project C\sample_matched"
use customs_matched,clear
collapse (sum) value_year, by (coun_aim exp_imp)
gen value_exp=value_year if exp_imp=="exp"
gen value_imp=value_year if exp_imp=="imp"
drop value_year
collapse (sum) value_exp value_imp, by (coun_aim)
gsort -value_exp, gen(rank_exp)
gsort -value_imp, gen(rank_imp)
save customs_matched_top_partners,replace

*-------------------------------------------------------------------------------
* Credit constraint measures
* Credit supply measures from Li, Liao, Zhao (2018)
cd "D:\Project C\credit\LLZ_Appendix"
import excel ".\Table14.xlsx", sheet("Sheet1") firstrow clear
label var Pcode "Province code"
label var EFS_all "Ratio of all credit to GDP"
label var EFS_LTL "Ratio of long-term loan to GDP"
save LLZ_Table14,replace

* US financial vulnerability measures from Manova, Wei, Zhang (2015)
cd "D:\Project C\credit\MWZ_Appendix"
import excel ".\MWZ Appendix.xlsx", sheet("Sheet1") firstrow clear
label var ExtFin "Exteral Finance Dependence"
label var Invent "Inventory Ratio"
label var Tang "Asset Tangibility"
label var TrCredit "Trade Credit Intensity"
rename ISIC ISIC2
save MWZ_Appendix,replace

use MWZ_Appendix,clear
keep if ISIC<=1000
tostring ISIC,gen(ISIC2_3d)
save MWZ_Appendix_3d,replace

use MWZ_Appendix,clear
keep if ISIC>1000
tostring ISIC,gen(ISIC2_4d)
gen ISIC2_3d=substr(ISIC2_4d,1,3)
save MWZ_Appendix_4d,replace

cd "D:\Project C\credit"
import delimited ".\LLZ_data\ISIC\ISIC3-ISIC2.csv", stringcols(1 3) clear
drop partial*
rename (isic3 isic2) (ISIC3 ISIC2_4d)
gen ISIC2_3d=substr(ISIC2_4d,1,3)
save ISIC3-ISIC2,replace

use ISIC3-ISIC2,clear
merge n:1 ISIC2_3d using ".\MWZ_Appendix\MWZ_Appendix_3d",nogen
merge n:1 ISIC2_4d using ".\MWZ_Appendix\MWZ_Appendix_4d",nogen update replace
collapse (mean) ExtFin Invent Tang TrCredit, by (ISIC3)
save ISIC3_MWZ,replace

cd "D:\Project C\credit"
use "D:\Project A\deflator\CIC_ADJ-02-03",clear
drop cic02
tostring cic_adj cic03,replace
duplicates drop
save CIC_ADJ-03,replace

cd "D:\Project C\credit"
use ".\LLZ_data\ISIC\ISIC industry code to CIC industry code",clear
rename (IND_CIC IND_ISIC_3) (cic03 ISIC3)
merge n:1 cic03 using CIC_ADJ-03,nogen keep(matched)
drop cic03
save CIC-ISIC3,replace

use CIC-ISIC3,clear
merge n:1 ISIC3 using ISIC3_MWZ,nogen keep(matched)
collapse (mean) ExtFin Invent Tang TrCredit, by (cic_adj)
rename (ExtFin Invent Tang TrCredit) (ExtFin_US Invent_US Tang_US TrCredit_US)
save CIC_MWZ,replace

* China external finance dependence measure from Fan, Lai, Li (2015)
cd "D:\Project C\credit\FLL_Appendix"
import excel "D:\Project C\credit\FLL_Appendix\Table A.1.xlsx", sheet("Sheet1") firstrow clear
tostring CIC,gen(cic2)
label var ExtFin "Exteral Finance Dependence"
save FLL_Appendix_A1,replace

*-------------------------------------------------------------------------------
* Construct new CIE data
* focus on manufacturing firms
cd "D:\Project A\CIE"
use cie1998.dta,clear
keep(FRDM EN year INDTYPE REGTYPE GIOV_CR PERSENG TOIPT SI TWC NAR STOCK FA TA CL TL CWP FN IE CFS CFC CFL CFI CPHMT CFF)
append using cie1999,keep(FRDM EN year INDTYPE REGTYPE GIOV_CR PERSENG TOIPT SI TWC NAR STOCK FA TA CL TL CWP FN IE CFS CFC CFL CFI CPHMT CFF)
rename CPHMT CFHMT
forv i = 2000/2004{
append using cie`i',keep(FRDM EN year INDTYPE REGTYPE GIOV_CR PERSENG TOIPT SI TWC NAR STOCK FA TA CL TL CWP FN IE CFS CFC CFL CFI CFHMT CFF)
}
forv i = 2005/2006{
append using cie`i',keep(FRDM EN year INDTYPE REGTYPE GIOV_CR PERSENG TOIPT SI TWC NAR STOCK FA TA CL TL F334 CWP FN IE CFS CFC CFL CFI CFHMT CFF)
}
rename F334 RND
append using cie2007,keep(FRDM EN year INDTYPE REGTYPE GIOV_CR PERSENG TOIPT SI TWC NAR STOCK FA TA CL TL RND CWP FN IE CFS CFC CFL CFI CFHMT CFF)
bys FRDM: egen EN_adj=mode(EN),maxmode
bys FRDM: egen REGTYPE_adj=mode(REGTYPE),maxmode
drop EN REGTYPE
rename (EN_adj REGTYPE_adj) (EN REGTYPE)
gen year_cic=2 if year<=2002
replace year_cic=3 if year>2002
merge n:1 INDTYPE year_cic using "D:\Project A\deflator\cic_adj",nogen keep(matched)
drop year_cic    
destring cic_adj,replace
merge n:1 cic_adj year using "D:\Project A\deflator\input_deflator",nogen keep(matched)
merge n:1 cic_adj year using "D:\Project A\deflator\output_deflator",nogen keep(matched)
merge n:1 year using "D:\Project A\deflator\inv_deflator.dta",nogen keep(matched) keepus(inv_deflator)
*add registration type
gen ownership="SOE" if (REGTYPE=="110" | REGTYPE=="141" | REGTYPE=="143" | REGTYPE=="151" )
replace ownership="DPE" if (REGTYPE=="120" | REGTYPE=="130" | REGTYPE=="142" | REGTYPE=="149" | REGTYPE=="159" | REGTYPE=="160" | REGTYPE=="170" | REGTYPE=="171" | REGTYPE=="172" | REGTYPE=="173" | REGTYPE=="174" | REGTYPE=="190")
replace ownership="JV" if (REGTYPE=="210" | REGTYPE=="220" | REGTYPE=="310" | REGTYPE=="320")
replace ownership="MNE" if (REGTYPE=="230" | REGTYPE=="240" | REGTYPE=="330" | REGTYPE=="340")
replace ownership="DPE" if ownership=="" & (CFS==0 & CFC==0 & CFHMT==0 & CFF==0)
replace ownership="SOE" if ownership=="" & (CFHMT==0 & CFF==0)
replace ownership="MNE" if ownership=="" & (CFHMT!=0 | CFF!=0)
sort FRDM year
format EN %30s
cd "D:\Project C\CIE"
save cie_98_07,replace

*-------------------------------------------------------------------------------
* Markup estimation according to DLW(2012) in DLW.do

*-------------------------------------------------------------------------------
* Check the affiliation relationship
cd "D:\Project C\parent_affiliate"
use parent_affiliate_2004.dta,clear
gsort id -parentcompany_id
duplicates drop id,force
rename id FRDM
gen affiliate=1 if parentcompany_id !=""
replace affiliate=0 if affiliate==.
keep FRDM affiliate
save affiliate_2004,replace

*-------------------------------------------------------------------------------
* Add markup and financial vulnerability measures to firm data
cd "D:\Project C\CIE"
use cie_98_07,clear
keep if year>=1999
drop CFS CFC CFHMT CFF CFL CFI
tostring cic_adj,replace
gen cic2=substr(cic_adj,1,2)
* Add markup and tfp info
merge 1:1 FRDM year using "D:\Project C\markup\cie_99_07_markup", nogen keepus(Markup_DLWTLD Markup_lag tfp_tld tfp_lag) keep(matched master)
winsor2 Markup_*, trim replace by(cic2)
winsor2 tfp_*, trim replace by(cic2)
* Calculate firm-level markup from CIE
sort FRDM year
gen rSI=SI/OutputDefl*100
gen rTOIPT=TOIPT/InputDefl*100
gen rCWP=CWP/InputDefl*100
gen rkap=FA/inv_deflator*100
gen tc=rTOIPT+rCWP+0.15*rkap
gen scratio=rSI/tc
by FRDM: gen scratio_lag=scratio[_n-1] if year==year[_n-1]+1
winsor2 scratio*, trim replace by(cic2)
* Calculate firm-level financial constraints from CIE
gen Tang=FA/TA
gen Invent=STOCK/SI
gen RDint=RND/SI
gen Cash=(TWC-NAR-STOCK)/TA
gen Liquid=(TWC-CL)/TA
gen Levg=TA/TL
drop if Tang<0 | Invent<0 | RDint<0 | Cash<0 | Levg<0
bys cic2: egen RDint_cic2=mean(RDint)
local varlist "Tang Invent Cash Liquid Levg"
foreach var of local varlist {	
bys cic2: egen `var'_cic2 = median(`var')
}
* Add FLL (2015) measures
merge n:1 cic2 using "D:\Project C\credit\FLL_Appendix\FLL_Appendix_A1",nogen keep(matched) keepus(ExtFin)
rename ExtFin ExtFin_cic2
* Add MWZ (2015) measures
merge n:1 cic_adj using "D:\Project C\credit\CIC_MWZ",nogen keep(matched)
* (PCA) FPC is the first principal component of external finance dependence and asset tangibility
pca Tang_US ExtFin_US
factor Tang_US ExtFin_US,pcf
factortest Tang_US ExtFin_US
rotate, promax(3) factors(1)
predict f1
rename f1 FPC_US
pca Tang_cic2 ExtFin_cic2
factor Tang_cic2 ExtFin_cic2,pcf
factortest Tang_cic2 ExtFin_cic2
rotate, promax(3) factors(1)
predict f1
rename f1 FPC_cic2
* Match affiliation info
merge n:1 FRDM using "D:\Project C\parent_affiliate\affiliate_2004",nogen keep(matched master)
replace affiliate=0 if affiliate==.
sort FRDM EN year
save cie_credit,replace

cd "D:\Project C\CIE"
use cie_credit,clear
sort FRDM year
by FRDM: replace cic_adj=cic_adj[_N]
collapse (mean) *_US *_cic2, by (FRDM cic_adj)
save cie_credit_list,replace

*-------------------------------------------------------------------------------
* GVC upstreamness measures (from CMY 2021)
cd "D:\Project C\GVC"
use ups_cmy_hs07_base,clear
collapse (mean) upstreamness [aw=iooutput], by (hs_6)
rename (hs_6 upstreamness) (HS6 ups_HS6)
save ups_cmy_HS6_07,replace

*-------------------------------------------------------------------------------
* Contract intensity measures (from Nunn 2007)
cd "D:\Project C\contract"
use ".\contract_intensity_isic_1997.dta_\contract_intensity_ISIC_1997.dta",clear
rename industry_code ISIC2_3d
keep ISIC2 frac_lib_diff frac_lib_not_homog
save contract_intensity_ISIC_1997,replace

use "D:\Project C\credit\ISIC3-ISIC2",clear
merge n:1 ISIC2_3d using contract_intensity_ISIC_1997,nogen
collapse (mean) frac_lib_diff frac_lib_not_homog, by (ISIC3)
keep if frac_lib_diff!=.
save ISIC3_contract,replace

use "D:\Project C\credit\CIC-ISIC3",clear
merge n:1 ISIC3 using ISIC3_contract,nogen keep(matched)
collapse (mean) frac_lib_diff frac_lib_not_homog, by (cic_adj)
rename (frac_lib_diff frac_lib_not_homog) (rs1 rs2)
label var rs1 "fraction of inputs not sold on exchange and not ref priced"
label var rs2 "fraction of inputs not sold on exchange"
save CIC_contract,replace

*-------------------------------------------------------------------------------
* Distance from CEPII Gravity
cd "D:\Project C\gravity"
use Gravity_V202211,clear
keep if country_id_d=="CHN"
save Gravity_CHN_d,replace

use Gravity_CHN_d,clear
keep year iso3_o dist distw_harmonic
keep if year>=1999 & year<=2007
rename (iso3_o distw_harmonic) (countrycode distw)
drop if dist==. | distw==.
merge n:1 countrycode using "D:\Project C\customs data\customs_country_code",nogen keep(matched)
collapse (mean) dist distw, by (countrycode coun_aim)
save distance_CHN,replace

*-------------------------------------------------------------------------------
* Trading partner base
cd "D:\Project C\sample_matched"
use customs_matched,clear
keep FRDM year exp_imp HS6
duplicates drop
bys FRDM year exp_imp: egen product_count=count(HS6)
drop HS6
duplicates drop
save customs_matched_product,replace

use customs_matched,clear
keep FRDM year exp_imp coun_aim
duplicates drop
bys FRDM year exp_imp: egen country_count=count(coun_aim)
drop coun_aim
duplicates drop
save customs_matched_country,replace

use customs_matched,clear
keep FRDM year exp_imp HS6 coun_aim
bys FRDM year exp_imp HS6: egen country_scope=count(coun_aim)
bys FRDM year exp_imp coun_aim: egen product_scope=count(HS6)
merge n:1 FRDM year exp_imp using customs_matched_product,nogen
merge n:1 FRDM year exp_imp using customs_matched_country,nogen
duplicates drop
save customs_matched_product_country,replace

cd "D:\Project C\sample_matched"
use customs_matched_product_country,clear
keep if exp_imp=="exp"
keep FRDM year HS6 country_scope
rename country_scope destination
duplicates drop
sort FRDM HS6 year
by FRDM HS6: gen destin_initial=destination[1]
by FRDM HS6: gen destin_max=destination[_n-1]
by FRDM HS6: egen destin_mean=mean(destination)
save customs_matched_destination,replace

use customs_matched_product_country,clear
keep if exp_imp=="imp"
keep FRDM year HS6 country_scope
rename country_scope source
duplicates drop
sort FRDM HS6 year
by FRDM HS6: gen source_initial=source[1]
by FRDM HS6: gen source_lag=source[_n-1]
by FRDM HS6: egen source_mean=mean(source)
save customs_matched_source,replace

*-------------------------------------------------------------------------------
* Duration
cd "D:\Project C\sample_matched"
use customs_matched,clear
keep FRDM year exp_imp coun_aim
duplicates drop
sort FRDM exp_imp coun_aim year
by FRDM exp_imp coun_aim: gen duration=_n
save customs_matched_duration,replace

*-------------------------------------------------------------------------------
* Check two-way traders
cd "D:\Project C\sample_matched"
use customs_matched,clear
collapse (sum) value_year, by(FRDM year exp_imp)
gen export_sum=value_year if exp_imp=="exp"
gen import_sum=value_year if exp_imp=="imp"
gen exp=1 if exp_imp=="exp"
replace exp=0 if exp==.
gen imp=1 if exp_imp=="imp"
replace imp=0 if imp==.
collapse (sum) export_sum import_sum exp imp, by(FRDM year)
gen twoway_trade=1 if exp==1 & imp==1
replace twoway_trade=0 if twoway_trade==.
save customs_twoway,replace

*-------------------------------------------------------------------------------
* Merge customs data with CIE data to construct export sample
cd "D:\Project C\sample_matched"
use customs_matched,clear
keep if exp_imp =="exp"
drop exp_imp
gen process = 1 if shipment=="进料加工贸易" | shipment=="来料加工装配贸易" | shipment=="来料加工装配进口的设备"
replace process=0 if process==.
gen assembly = 1 if shipment=="来料加工装配贸易" | shipment=="来料加工装配进口的设备"
replace assembly=0 if assembly==.
collapse (sum) value_year quant_year, by(FRDM EN year coun_aim HS6 process assembly)
merge n:1 FRDM year using customs_twoway,nogen keep(matched) keepus(twoway_trade)
merge n:1 FRDM year using "D:\Project C\CIE\cie_credit",nogen keep(matched) keepusing (FRDM year EN cic_adj cic2 Markup_* tfp_* rSI rTOIPT rCWP rkap tc scratio scratio_lag *_cic2 *_US ownership affiliate)
merge n:1 coun_aim using customs_matched_top_partners,nogen keep(matched)
merge n:1 FRDM year HS6 using customs_matched_destination,nogen keep(matched)
merge n:1 coun_aim using "D:\Project C\gravity\distance_CHN",nogen keep(matched)
replace dist=dist/1000
replace distw=distw/1000
foreach key in 贸易 外贸 经贸 工贸 科贸 商贸 边贸 技贸 进出口 进口 出口 物流 仓储 采购 供应链 货运{
	drop if strmatch(EN, "*`key'*") 
}
bys HS6 coun_aim year: egen MS=pc(value_year),prop
merge n:1 year using "D:\Project C\PWT10.0\US_NER_99_11",nogen keep(matched)
merge n:1 year coun_aim using "D:\Project C\PWT10.0\RER_99_11.dta",nogen keep(matched) keepus(NER RER dlnRER dlnrgdp peg_USD)
sort FRDM HS6 coun_aim year
gen price_RMB=value_year*NER_US/quant_year
by FRDM HS6 coun_aim: gen dlnprice=ln(price_RMB)-ln(price_RMB[_n-1]) if year==year[_n-1]+1
by FRDM HS6 coun_aim: gen MS_lag=MS[_n-1] if year==year[_n-1]+1
by FRDM HS6 coun_aim: egen year_count=count(year)
drop if dlnRER==. | dlnprice==.
gen HS2=substr(HS6,1,2)
drop if HS2=="93"|HS2=="97"|HS2=="98"|HS2=="99"
egen group_id=group(FRDM HS6 coun_aim)
winsor2 dlnprice, trim by(HS2 year)
local varlist "FPC_US ExtFin_US Invent_US Tang_US FPC_cic2 ExtFin_cic2 Tang_cic2 Invent_cic2 RDint_cic2"
foreach var of local varlist {
	gen x_`var' = `var'*dlnRER
}
format EN %30s
save sample_matched_exp,replace

*-------------------------------------------------------------------------------
* Use the same method to construct import sample
cd "D:\Project C\sample_matched"
use customs_matched,clear
keep if exp_imp =="imp"
drop exp_imp
gen process = 1 if shipment=="进料加工贸易" | shipment=="来料加工装配贸易" | shipment=="来料加工装配进口的设备"
replace process=0 if process==.
gen assembly = 1 if shipment=="来料加工装配贸易" | shipment=="来料加工装配进口的设备"
replace assembly=0 if assembly==.
collapse (sum) value_year quant_year, by(FRDM EN year coun_aim HS6 process assembly)
merge n:1 FRDM year using customs_twoway,nogen keep(matched) keepus(twoway_trade)
merge n:1 FRDM year using ".\CIE\cie_credit",nogen keep(matched) keepusing (FRDM year EN cic_adj cic2 Markup_* tfp_* rSI rTOIPT rCWP rkap tc scratio scratio_lag *_cic2 *_US ownership affiliate)
merge n:1 coun_aim using customs_matched_top_partners,nogen keep(matched)
merge n:1 FRDM year HS6 using customs_matched_source,nogen keep(matched)
merge n:1 coun_aim using "D:\Project C\gravity\distance_CHN",nogen keep(matched)
replace dist=dist/1000
replace distw=distw/1000
foreach key in 贸易 外贸 经贸 工贸 科贸 商贸 边贸 技贸 进出口 进口 出口 物流 仓储 采购 供应链 货运{
	drop if strmatch(EN, "*`key'*") 
}
bys HS6 coun_aim year: egen MS=pc(value_year),prop
merge n:1 year using "D:\Project C\PWT10.0\US_NER_99_11",nogen keep(matched)
merge n:1 year coun_aim using "D:\Project C\PWT10.0\RER_99_11.dta",nogen keep(matched) keepus(NER RER dlnRER dlnrgdp peg_USD)
sort FRDM HS6 coun_aim year
gen price_RMB=value_year*NER_US/quant_year
by FRDM HS6 coun_aim: gen dlnprice=ln(price_RMB)-ln(price_RMB[_n-1]) if year==year[_n-1]+1
by FRDM HS6 coun_aim: gen MS_lag=MS[_n-1] if year==year[_n-1]+1
by FRDM HS6 coun_aim: egen year_count=count(year)
drop if dlnRER==. | dlnprice==.
gen HS2=substr(HS6,1,2)
drop if HS2=="93"|HS2=="97"|HS2=="98"|HS2=="99"
egen group_id=group(FRDM HS6 coun_aim)
winsor2 dlnprice, trim by(HS2 year)
local varlist "FPC_US ExtFin_US Invent_US Tang_US FPC_cic2 ExtFin_cic2 Tang_cic2 Invent_cic2 RDint_cic2"
foreach var of local varlist {
	gen x_`var' = `var'*dlnRER
}
format EN %30s
save sample_matched_imp,replace