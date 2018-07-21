cd "C:\Users\shekh\Google Drive\AAP Haryana Data\Haryana voter lists\"

local ACNo "AC1 AC3 AC4 AC5 AC6 AC7 AC8 AC9 AC10 AC11 AC12 AC13 AC14 AC15 AC16 AC17 AC18 AC19 AC20"

foreach AC in `ACNo'{

use "`AC'.dta", clear

label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=15
label values InfluentialHH InfluentialHH_values

keep if InfluentialHH==1


gsort ACno PartNo HH_NO  Gender -Age

by ACno PartNo HH_NO Gender: gen HHGenderRunningCount=_n
gen OldestMale=1 if HHGenderRunningCount==1&Gender=="M"


keep if OldestMale==1|MobileMissing==0
drop Dummy* PS_* AC_* space Age_Group HHGenderRunningCount HHSize_Group HHMemberNo CasteValues InfluentialHH

save "`AC'_InfluentialHHDetails.dta" 
export excel using "`AC'_InfluentialHHDetails.xls", firstrow(variables)
}



local ACNo "AC21 AC22 AC23 AC25 AC26 AC27 AC28 AC29 AC30 AC24"

foreach AC in `ACNo'{

use "`AC'.dta", clear

label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=15
label values InfluentialHH InfluentialHH_values

keep if InfluentialHH==1


gsort ACno PartNo HH_NO  Gender -Age

by ACno PartNo HH_NO Gender: gen HHGenderRunningCount=_n
gen OldestMale=1 if HHGenderRunningCount==1&Gender=="M"


keep if OldestMale==1|MobileMissing==0
drop Dummy* PS_* AC_* space Age_Group HHGenderRunningCount HHSize_Group HHMemberNo CasteValues InfluentialHH Relation RelationName DoB HH_NO EPICno MobileMissing OldestMale ACno

save "`AC'_InfluentialHHDetails.dta" 
export excel using "`AC'_InfluentialHHDetails.xls", firstrow(variables)
}


local ACNo "AC31 AC32 AC33 AC34" 
local ACNo "AC35 AC36 AC37 AC38 AC39 AC40 AC41 AC42 AC43 AC44 AC45 AC46 AC47 AC48 AC49 AC50"

cd "C:\Users\shekh\Google Drive\AAP Haryana Data\Haryana voter lists\"
local ACNo "AC51 AC52 AC53 AC54 AC55 AC56 AC57 AC58 AC59 AC60 AC61 AC62 AC63 AC64 AC65 AC66"
local ACNo "AC67 AC68 AC69" 
local ACNo "AC71 AC72 AC73 AC74 AC75 AC76 AC77 AC78 AC81 AC82 AC83 AC84 AC85 AC86 AC87 AC88 AC89 AC90"


foreach AC in `ACNo'{

use "`AC'.dta", clear

label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=15
label values InfluentialHH InfluentialHH_values

keep if InfluentialHH==1


gsort ACno PartNo HH_NO  Gender -Age

by ACno PartNo HH_NO Gender: gen HHGenderRunningCount=_n
gen OldestMale=1 if HHGenderRunningCount==1&Gender=="M"


keep if OldestMale==1|MobileMissing==0
drop Dummy* PS_* AC_* space Age_Group HHGenderRunningCount HHSize_Group HHMemberNo CasteValues InfluentialHH Relation RelationName DoB HH_NO EPICno MobileMissing OldestMale ACno

save "`AC'_InfluentialHHDetails.dta" 
export excel using "`AC'_InfluentialHHDetails.xls", firstrow(variables)
}

/*Analyzing influential hh's for members with 10 people*/
local ACNoUpto20 "AC1 AC3 AC4 AC5 AC6 AC7 AC8 AC9 AC10 AC11 AC12 AC13 AC14 AC15 AC16 AC17 AC18 AC19 AC20" 
local ACNo21to40 "AC21 AC22 AC23 AC25 AC26 AC27 AC28 AC29 AC30 AC24 AC31 AC32 AC33 AC34 AC35 AC36 AC37 AC38 AC39 AC40" 
local ACNo41to60 "AC41 AC42 AC43 AC44 AC45 AC46 AC47 AC48 AC49 AC50 AC51 AC52 AC53 AC54 AC55 AC56 AC57 AC58 AC59 AC60"
local ACNo61to80 "AC61 AC62 AC63 AC64 AC65 AC66 AC67 AC68 AC69 AC71 AC72 AC73 AC74 AC75 AC76 AC77 AC78"
local ACNo81to90 "AC81 AC82 AC83 AC84 AC85 AC86 AC87 AC88 AC89 AC90"
cd "C:\Users\shekh\Google Drive\AAP Haryana Data\Haryana voter lists\"



foreach AC in `ACNoUpto20' `ACNo21to40' `ACNo41to60' `ACNo61to80' `ACNo81to90'{

use "`AC'.dta", clear

label define InfluentialHH_values 0 "HH Size less than 15" 1 "HH Size greater than equal to 15"
gen InfluentialHH=0
replace InfluentialHH=1 if HH_Size>=10
label values InfluentialHH InfluentialHH_values

keep if InfluentialHH==1


gsort ACno PartNo HH_NO  Gender -Age

by ACno PartNo HH_NO Gender: gen HHGenderRunningCount=_n
gen OldestMale=1 if HHGenderRunningCount==1&Gender=="M"


keep if OldestMale==1|MobileMissing==0
drop Dummy* PS_* AC_* space Age_Group HHGenderRunningCount HHSize_Group HHMemberNo CasteValues InfluentialHH Relation RelationName DoB HH_NO EPICno MobileMissing OldestMale ACno

save "`AC'_InfluentialHHDetails_MemberSize10.dta" 
export excel using "`AC'_InfluentialHHDetails_MemberSize10.xls", firstrow(variables)
}

 