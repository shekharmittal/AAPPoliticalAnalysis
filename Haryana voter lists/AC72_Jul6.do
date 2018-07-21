/*Based on discussion with Jasmine on May 27, 2018*/

cd "C:\Users\shekh\Google Drive\AAP Haryana Data\Haryana voter lists\"

local SaveFileName "AC72"
import delimited "72-with-groups.csv", varnames(nonames) encoding(UTF-8) clear 

drop if v24!=""
drop v24 v25 v26

rename v1 Caste
rename v2 ACno
rename v3 PartNo
rename v4 SrNo
rename v23 District
rename v8 Relation
rename v13 Name
rename v14 RelationName
rename v20 Mobileno
rename v15 HouseNo
rename v11 Gender
rename v10 EPICno
rename v12 Age
rename v19 DoB

drop v5 v6 v7 v9 v16 v17 v18 v22 v21

drop if Gender=="SEX"

gen space=" "
egen Address=concat(HouseNo space District)
drop HouseNo District

replace Gender="M" if Gender=="m"
replace Gender="F" if Gender=="f"

gen DummyFemale=0
replace DummyFemale=1 if Gender=="F"

label define Gender 0 "Male" 1 "Female"
label values DummyFemale Gender

destring ACno, replace
destring PartNo, replace

egen HH_NO = group(ACno PartNo Address)
gsort ACno HH_NO SrNo
by ACno HH_NO: gen HHMemberNo=_n


gen byte notnumeric = real(Age)==.
drop if notnumeric==1
destring Age, replace
drop notnumeric

gen Age_Group=1 if Age<=30
replace Age_Group=2 if Age>30&Age<=40
replace Age_Group=3 if Age>40&Age<=50
replace Age_Group=4 if Age>50&Age<=60
replace Age_Group=5 if Age>60

label define Age_Group 1 "Less than eq to 30" 2 "Between 31 and 40" 3 "Between 41 and 50" 4 "Between 51 and 60" 5 "Greater than eq to 61"
label values Age_Group Age_Group


gsort ACno HH_NO
by ACno HH_NO:gen HH_Size=_N

gen HHSize_Group=1 if HH_Size<=2
replace HHSize_Group=2 if HH_Size>2&HH_Size<=5
replace HHSize_Group=3 if HH_Size>5&HH_Size<=10
replace HHSize_Group=4 if HH_Size>10&HH_Size<=20
replace HHSize_Group=5 if HH_Size>20

label define HH_Group 1 "Less than eq to 2" 2 "Between 3 and 5" 3 "Between 6 and 10" 4 "Between 11 and 20" 5 "Greater than eq to 21"
label values  HHSize_Group HH_Group

replace Caste="Missing" if Caste==""


gsort ACno PartNo HH_NO

gen DummyCasteBaniya=0
gen DummyCasteMissing=0
gen DummyCasteBrahmin=0
gen DummyCasteGurjar=0
gen DummyCasteJat=0
gen DummyCastePunjabi=0
gen DummyCasteRajput=0
gen DummyCasteSC=0
gen DummyCasteSikh=0
gen DummyCasteYadav=0

replace DummyCasteBaniya=1 if Caste=="baniya"
replace DummyCasteMissing=1 if Caste=="Missing"
replace DummyCasteBrahmin=1 if Caste=="brahmin"
replace DummyCasteGurjar=1 if Caste=="gurjar"
replace DummyCasteJat=1 if Caste=="jat"
replace DummyCastePunjabi=1 if Caste=="punjabi"
replace DummyCasteRajput=1 if Caste=="rajput"
replace DummyCasteSC=1 if Caste=="sc"
replace DummyCasteSikh=1 if Caste=="sikh"
replace DummyCasteYadav=1 if Caste=="yadav"


gen CasteValues=1 if Caste=="baniya"
replace CasteValues=0 if Caste=="Missing"
replace CasteValues=2 if Caste=="brahmin"
replace CasteValues=3 if Caste=="gurjar"
replace CasteValues=4 if Caste=="jat"
replace CasteValues=5 if Caste=="punjabi"
replace CasteValues=6 if Caste=="rajput"
replace CasteValues=7 if Caste=="sc"
replace CasteValues=8 if Caste=="sikh"
replace CasteValues=9 if Caste=="yadav"

label define Caste_Group 0 "Missing" 1 "baniya" 2 "brahmin" 3 "gurjar" 4 "jat" 5 "punjabi" 6 "rajput" 7 "sc" 8 "sikh" 9 "yadav"
label values  CasteValues Caste_Group

gen MobileMissing=1 if Mobileno=="NULL"|Mobileno=="0"|Mobileno==""
replace MobileMissing=0 if MobileMissing==.


gsort ACno PartNo HH_NO
by ACno PartNo:egen PS_ShareBaniya=mean(DummyCasteBaniya)
by ACno PartNo:egen PS_ShareMissing=mean(DummyCasteMissing)
by ACno PartNo:egen PS_ShareBrahmin=mean(DummyCasteBrahmin)
by ACno PartNo:egen PS_ShareGurjar=mean(DummyCasteGurjar)
by ACno PartNo:egen PS_ShareJat=mean(DummyCasteJat)
by ACno PartNo:egen PS_SharePunjabi=mean(DummyCastePunjabi)
by ACno PartNo:egen PS_ShareRajput=mean(DummyCasteRajput)
by ACno PartNo:egen PS_ShareSC=mean(DummyCasteSC)
by ACno PartNo:egen PS_ShareSikh=mean(DummyCasteSikh)
by ACno PartNo:egen PS_ShareYadav=mean(DummyCasteYadav)

by ACno PartNo:gen PS_TotalVoters=_N
by ACno PartNo:egen PS_FemaleShare=mean(DummyFemale)
by ACno PartNo:egen PS_Mean_HHSize=mean(HH_Size)
by ACno PartNo:egen PS_Mean_Age=mean(Age)

gsort ACno PartNo HH_NO
by ACno: egen AC_ShareBaniya=mean(DummyCasteBaniya)
by ACno: egen AC_ShareMissing=mean(DummyCasteMissing)
by ACno: egen AC_ShareBrahmin=mean(DummyCasteBrahmin)
by ACno: egen AC_ShareGurjar=mean(DummyCasteGurjar)
by ACno: egen AC_ShareJat=mean(DummyCasteJat)
by ACno: egen AC_SharePunjabi=mean(DummyCastePunjabi)
by ACno: egen AC_ShareRajput=mean(DummyCasteRajput)
by ACno: egen AC_ShareSC=mean(DummyCasteSC)
by ACno: egen AC_ShareSikh=mean(DummyCasteSikh)
by ACno: egen AC_ShareYadav=mean(DummyCasteYadav)

by ACno: egen AC_FemalShare=mean(DummyFemale)
by ACno: egen AC_Mean_HHSize=mean(HH_Size)
by ACno: egen AC_Mean_Age=mean(Age)

gsort PartNo HH_NO

local SaveFileName "AC72"
save "`SaveFileName'.dta" 

tab2xl DummyFemale using `SaveFileName', row(1) col(1) sheet(Female)
tab2xl Age_Group using `SaveFileName', row(1) col(1) sheet(AgeGroup)
tab2xl CasteValues using `SaveFileName', row(1) col(1) sheet(Caste)

label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
preserve
keep if HHMemberNo==1
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=15
label values InfluentialHH InfluentialHH_values
tab2xl InfluentialHH using `SaveFileName', row(1) col(1) sheet(InfluentialHH)
restore

drop Caste SrNo EPICno Age Name Gender RelationName Relation Address Mobileno DummyFemale Age_Group HH_Size HHSize_Group DummyCaste* CasteValues
drop AC_*
drop DoB space HH* MobileMissing
drop PS_ShareBaniya PS_ShareMissing PS_ShareBrahmin PS_ShareGurjar PS_ShareJat PS_SharePunjabi PS_ShareRajput PS_ShareYadav PS_ShareSikh PS_Mean_HHSize PS_Mean_Age

bys ACno PartNo:gen SerialCount=_n
keep if SerialCount==1
rename PartNo PollingStation
drop SerialCount
save "`SaveFileName'_AggregatedAtPS.dta" 
export excel using "`SaveFileName'_AggregatedAtPS.xls", firstrow(variables)

import excel "`SaveFileName'.xlsx", sheet("Female") firstrow clear
drop Cum
export excel using "`SaveFileName'.xlsx", sheet("Female") sheetreplace firstrow(variables)

import excel "`SaveFileName'.xlsx", sheet("AgeGroup") firstrow clear
drop Cum
export excel using "`SaveFileName'.xlsx", sheet("AgeGroup") sheetreplace firstrow(variables)


import excel "`SaveFileName'.xlsx", sheet("Caste") firstrow clear
drop Cum
export excel using "`SaveFileName'.xlsx", sheet("Caste") sheetreplace firstrow(variables)

import excel "`SaveFileName'.xlsx", sheet("InfluentialHH") firstrow clear
drop Cum
export excel using "`SaveFileName'.xlsx", sheet("InfluentialHH") sheetreplace firstrow(variables)
