cd "C:\Users\shekh\Downloads\South-Delhi\"

import delimited 36.csv, clear
import delimited 37.csv, clear
import delimited 45.csv, clear
import delimited 46.csv, clear
import delimited 47.csv, clear
import delimited 48.csv, clear
import delimited 49.csv, clear
import delimited 51.csv, clear
import delimited 52.csv, clear
import delimited 53.csv, clear

save "C:\Users\shekh\Downloads\South-Delhi\SouthDelhiVoterRolls.dta"


local ACNo "45 46 47 48 49 51 52 53"

foreach AC in `ACNo'{
import delimited "`AC'.csv", clear

rename v1 ACno
rename v2 PartNo
rename v3 SrNo
rename v4 EPICno
rename v5 Name
rename v7 Gender
rename v6 Age
rename v8 HouseNo
rename v9 Relation
rename v10 RelationName
rename v12 District

append using "C:\Users\shekh\Downloads\South-Delhi\SouthDelhiVoterRolls.dta"
save "C:\Users\shekh\Downloads\South-Delhi\SouthDelhiVoterRolls.dta", replace

}


gen space=" "
egen Address=concat(HouseNo space District)
drop HouseNo District

replace Gender="M" if Gender=="Male"
replace Gender="F" if Gender=="Female"

gen DummyFemale=0
replace DummyFemale=1 if Gender=="F"

label define Gender 0 "Male" 1 "Female"
label values DummyFemale Gender

destring ACno, replace
destring PartNo, replace

egen HH_NO = group(ACno PartNo Address)
gsort ACno HH_NO SrNo
by ACno HH_NO: gen HHMemberNo=_n


gen byte notnumeric = Age==.
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

gsort ACno PartNo
bys ACno PartNo:gen PS_TotalVoters=_N
by ACno PartNo:egen PS_FemaleShare=mean(DummyFemale)
by ACno PartNo:egen PS_Mean_HHSize=mean(HH_Size)
by ACno PartNo:egen PS_Mean_Age=mean(Age)



by ACno: egen AC_FemalShare=mean(DummyFemale)
by ACno: egen AC_Mean_HHSize=mean(HH_Size)
by ACno: egen AC_Mean_Age=mean(Age)


gsort ACno PartNo HH_NO

save "C:\Users\shekh\Downloads\South-Delhi\SouthDelhiVoterRolls.dta", replace

local ACNo "36 37 45 46 47 48 49 51 52 53"
foreach AC in `ACNo'{
preserve

keep if ACno==`AC'

tab2xl DummyFemale using `AC', row(1) col(1) sheet(Female)
tab2xl Age_Group using `AC', row(1) col(1) sheet(AgeGroup)

label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
keep if HHMemberNo==1
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=15
label values InfluentialHH InfluentialHH_values
tab2xl InfluentialHH using `AC', row(1) col(1) sheet(InfluentialHH)
restore
}

local ACNo "36 37 45 46 47 48 49 51 52 53"
foreach AC in `ACNo'{

import excel "`AC'.xlsx", sheet("Female") firstrow clear
drop Cum
export excel using "`AC'.xlsx", sheet("Female") sheetreplace firstrow(variables)

import excel "`AC'.xlsx", sheet("AgeGroup") firstrow clear
drop Cum
export excel using "`AC'.xlsx", sheet("AgeGroup") sheetreplace firstrow(variables)


import excel "`AC'.xlsx", sheet("InfluentialHH") firstrow clear
drop Cum
export excel using "`AC'.xlsx", sheet("InfluentialHH") sheetreplace firstrow(variables)
}

use "C:\Users\shekh\Downloads\South-Delhi\SouthDelhiVoterRolls.dta", clear

drop SrNo EPICno Age Name Gender RelationName Relation Address DummyFemale Age_Group HH_Size HHSize_Group 
drop space HH* 


bys ACno PartNo:gen SerialCount=_n
keep if SerialCount==1
rename PartNo PollingStation
drop SerialCount
drop v11 AC_*

local ACNo "36 37 45 46 47 48 49 51 52 53"
foreach AC in `ACNo'{
preserve

keep if ACno==`AC'
save "`AC'_AggregatedAtPS.dta", replace 
export excel using "`AC'_AggregatedAtPS.xls", firstrow(variables)
restore
}


use "C:\Users\shekh\Downloads\South-Delhi\SouthDelhiVoterRolls.dta", clear
local ACNo "36 37 45 46 47 48 49 51 52 53"
foreach AC in `ACNo'{
preserve
keep if ACno==`AC'
label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=15
label values InfluentialHH InfluentialHH_values

keep if InfluentialHH==1


gsort ACno PartNo HH_NO  Gender -Age

by ACno PartNo HH_NO Gender: gen HHGenderRunningCount=_n
gen OldestMale=1 if HHGenderRunningCount==1&Gender=="M"
replace OldestMale=0 if OldestMale==.
gen OldestFemale=1 if HHGenderRunningCount==1&Gender=="F"
replace OldestFemale=0 if OldestFemale==.


drop Dummy* PS_* AC_* space Age_Group HHGenderRunningCount HHSize_Group HHMemberNo InfluentialHH v11

save "`AC'_InfluentialHHDetails.dta",replace 
export excel using "`AC'_InfluentialHHDetails.xls", firstrow(variables)
restore
}
