*Task 1: Import raw customs data to annual datasets

*2000-2002 customs data
forv j=0/2{
clear
cd "D:\Project C\customs data\200`j'"
forv i=1/9{
odbc load,dsn("MS Access Database;DBQ=.\200`j'-0`i'.mdb") table("200`j'-0`i'")
drop shipment_date
gen shipment_date="200`j'0`i'"
save tradedata_200`j'_`i',replace
clear
}
forv i=0/2{
odbc load,dsn("MS Access Database;DBQ=.\200`j'-1`i'.mdb") table("200`j'-1`i'")
drop shipment_date
gen shipment_date="200`j'1`i'"
save tradedata_200`j'_1`i',replace
clear
}
use tradedata_200`j'_1,clear
forv i=2/12{
append using tradedata_200`j'_`i'
}
cd "D:\Project C\customs data"
save tradedata_200`j',replace
}

*2003-2004 customs data
forv j=3/4{
clear
cd "D:\Project C\customs data\200`j'"
forv i=1/9{
odbc load,dsn("MS Access Database;DBQ=.\data200`j'0`i'.mdb") table("data200`j'0`i'")
drop 日期
gen 日期="200`j'0`i'"
save tradedata_200`j'_`i',replace
clear
}
forv i=0/2{
odbc load,dsn("MS Access Database;DBQ=.\data200`j'1`i'.mdb") table("data200`j'1`i'")
drop 日期
gen 日期="200`j'1`i'"
save tradedata_200`j'_1`i',replace
clear
}
use tradedata_200`j'_1,clear
forv i=2/12{
append using tradedata_200`j'_`i'
}
cd "D:\Project C\customs data"
save tradedata_200`j',replace
}

*2005 customs data
clear
cd "D:\Project C\customs data\2005"
forv i=1/9{
odbc load,dsn("MS Access Database;DBQ=.\data20050`i'.mdb") table("20050`i'")
drop shipment_date
gen shipment_date="20050`i'"
save tradedata_2005_`i',replace
clear
}
forv i=0/1{
odbc load,dsn("MS Access Database;DBQ=.\data20051`i'.mdb") table("20051`i'")
drop shipment_date
gen shipment_date="20051`i'"
save tradedata_2005_1`i',replace
clear
}
use tradedata_2005_12,clear
rename (日期 进口或出口 HS编码 HS中文 金额 数量 价格 数量单位 企业编码 经营单位 单位地址 电话 传真 邮编 电子邮件 联系人 消费地或生产地 企业性质 起运国或目的国 口岸海关 贸易方式 运输方式 中转国) (shipment_date exp_or_imp hs_id hs value quantity valperunit unit party_id company paddr tel fax zip email pperson city CompanyType country port shipment transportation routing)
forv i=1/11{
append using tradedata_2005_`i'
}
cd "D:\Project C\customs data"
save tradedata_2005,replace

*2006 customs data
clear
cd "D:\Project C\customs data\2006"
forv i=1/9{
odbc load,dsn("MS Access Database;DBQ=.\20060`i'cn.mdb") table("20060`i'")
save tradedata_2006_`i',replace
clear
}
forv i=0/2{
odbc load,dsn("MS Access Database;DBQ=.\20061`i'cn.mdb") table("20061`i'")
save tradedata_2006_1`i',replace
clear
}
use tradedata_2006_1,clear
forv i=2/12{
append using tradedata_2006_`i'
}
cd "D:\Project C\customs data"
save tradedata_2006,replace

*2007 customs data
clear
cd "D:\Project C\customs data\2007"
unicode encoding set "GB18030"
unicode analyze *.dta
unicode translate *.dta, transutf8 invalid
use tradedata_2007_1.dta,clear
forv i=2/14{
append using tradedata_2007_`i'
}
cd "D:\Project C\customs data"
save tradedata_2007.dta,replace

*2008 customs data
clear
cd "D:\Project C\customs data\2008"
unicode encoding set "GB18030"
unicode analyze *.dta
unicode translate *.dta, transutf8 invalid
use tradedata_2008_1.dta,clear
forv i=2/14{
append using tradedata_2008_`i'
}
cd "D:\Project C\customs data"
save tradedata_2008.dta,replace

*2009 customs data
clear
cd "D:\Project C\customs data\2009"
unicode encoding set "GB18030"
unicode analyze *.dta
unicode translate *.dta, transutf8 invalid
use tradedata_2009_1.dta,clear
forv i=2/15{
append using tradedata_2009_`i'
}
cd "D:\Project C\customs data"
save tradedata_2009.dta,replace

*2010 customs data
clear
cd "D:\Project C\customs data\2010"
unicode encoding set "GB18030"
unicode analyze *.dta
unicode translate *.dta, transutf8 invalid
use tradedata_2010_1.dta,clear
forv i=2/17{
append using tradedata_2010_`i'
}
cd "D:\Project C\customs data"
save tradedata_2010.dta,replace

*2011 customs data
clear
cd "D:\Project C\customs data\2011"
unicode encoding set "GB18030"
unicode analyze *.dta
unicode translate *.dta, transutf8 invalid
use tradedata_2011_1.dta,clear
forv i=2/18{
append using tradedata_2011_`i'
}
cd "D:\Project C\customs data"
save tradedata_2011.dta,replace

* Task 2: Clean and combine annual datasets to a concise sample of 2000-2011
* Refer to the explanatory notes for the variables

* 2000 and 2001
cd "D:\Project C\customs data"
forv i=0/1{
use ".\tradedata_combined_00-07\tradedata_200`i'",clear
rename (hs_id company country) (HS8 EN coun_aim)
collapse (sum) value quantity, by(exp_imp party_id CompanyType EN HS8 coun_aim shipment)
replace exp_imp="imp" if exp_imp=="1"
replace exp_imp="exp" if exp_imp=="0"
gen year=200`i'
save tradedata_200`i'_concise.dta,replace
}

* 2002
cd "D:\Project C\customs data"
use ".\tradedata_combined_00-07\tradedata_2002",clear
rename (hs_id pname 国家名称_C 进出口_C companytype 贸易类型_C) (HS8 EN coun_aim exp_imp CompanyType shipment)
collapse (sum) value quantity, by(exp_imp party_id CompanyType EN HS8 coun_aim shipment)
replace exp_imp="imp" if exp_imp=="进口"
replace exp_imp="exp" if exp_imp=="出口"
gen year=2002
save tradedata_2002_concise.dta,replace

* 2003-2004
cd "D:\Project C\customs data"
forv i=3/4{
use ".\tradedata_combined_00-07\tradedata_200`i'",clear
rename (进口或出口 企业编码 经营单位 企业性质 税号编码 起运国或目的国 金额 数量 贸易方式) (exp_imp party_id EN CompanyType HS8 coun_aim value quantity shipment)
collapse (sum) value quantity, by(exp_imp party_id CompanyType EN HS8 coun_aim shipment)
replace exp_imp="imp" if exp_imp=="进口"
replace exp_imp="exp" if exp_imp=="出口"
format EN %40s
format coun_aim %20s
gen year=200`i'
save tradedata_200`i'_concise.dta,replace
}

* 2005
cd "D:\Project C\customs data"
use ".\tradedata_combined_00-07\tradedata_2005",clear
replace CompanyType=companyType if CompanyType==""
rename (exp_or_imp company hs_id country) (exp_imp EN HS8 coun_aim)
collapse (sum) value quantity, by(exp_imp party_id CompanyType EN HS8 coun_aim shipment)
replace exp_imp="imp" if exp_imp=="进口"
replace exp_imp="exp" if exp_imp=="出口"
gen year=2005
save tradedata_2005_concise.dta,replace

* 2006
cd "D:\Project C\customs data"
use ".\tradedata_combined_00-07\tradedata_2006",clear
rename (进出口 企业代码 企业名称 企业类型 商品代码 var18 金额 数量 贸易方式) (exp_imp party_id EN CompanyType HS8 coun_aim value quantity shipment)
destring value quantity,replace
collapse (sum) value quantity, by(exp_imp party_id CompanyType EN HS8 coun_aim shipment)
replace exp_imp="imp" if exp_imp=="进口"
replace exp_imp="exp" if exp_imp=="出口"
gen year=2006
save tradedata_2006_concise.dta,replace

* 2007-2011
cd "D:\Project C\customs data"
forv i=2007/2011{
use ".\tradedata_combined_00-07\tradedata_`i'",clear
rename (_进口或出口 _企业编码 _经营单位 _企业性质 _税号编码 _起运国或目的国 _金额 _数量 _贸易方式) (exp_imp party_id EN CompanyType HS8 countrynumber value quantity shipment)
merge n:1 countrynumber using country_code, nogen keep(matched)
collapse (sum) value quantity, by(exp_imp party_id CompanyType EN HS8 coun_aim shipment) 
tostring exp_imp,replace 
replace exp_imp="imp" if exp_imp=="1"
replace exp_imp="exp" if exp_imp=="0"
tostring HS8,replace
replace HS8 = "0" + HS8 if length(HS8) == 7
gen year=`i'
save tradedata_`i'_concise.dta,replace	
}