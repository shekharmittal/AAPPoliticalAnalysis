import excel "C:\Users\shekh\Google Drive\AAP Data Unit\Form20\AC30_Cleaned.xlsx", sheet("PollingBoothResults") firstrow clear

import excel "C:\Users\shekh\Google Drive\AAP Data Unit\Form20\AC52_Cleaned.xlsx", sheet("PollingBoothResults") firstrow clear

drop H
gen AC_No=52
gen AC_Name=""

gsort  Elections Year AC_No PollingStation -Votes
by Elections Year AC_No PollingStation: gen SerialCount=_n
by Elections Year AC_No PollingStation: gen TotalCount=_N


gsort SerialCount Elections Year AC_No -TotalBoothVotes
by SerialCount Elections Year AC_No:gen PBSizeRank=_n

label variable PBSizeRank "Rank by the total number of votes cast in the PB. Rank 1 means biggest PB"

replace Party="HJC(BL)" if Party=="HJC (BL)"

gsort  Elections Year AC_No PollingStation -Votes
//Calculating Total Votes Polled in the election in that constituency
by Elections Year AC_No:egen TotalVotes=total(TotalBoothVotes) if SerialCount==1
by Elections Year AC_No PollingStation:replace TotalVotes=TotalVotes[_n-1] if TotalVotes>=.
gsort Elections Year AC_No PollingStation Votes
by Elections Year AC_No PollingStation:replace TotalVotes=TotalVotes[_n-1] if TotalVotes>=.


//Calculating total votes polled in the election in that constituency for that canddate
bys Elections Year AC_No Party:egen TotalCandidateVotes=total(Votes)
gsort  Elections Year AC_No PollingStation -Votes

//Calculating AC Level Rank of Candidates
gsort Elections Year AC_No PollingStation -TotalCandidateVotes
by Elections Year AC_No PollingStation: gen ACLevelRank=_n

//Calculating Booth Level Rank of Candidates
gsort Elections Year AC_No PollingStation -Votes
by Elections Year AC_No PollingStation:gen BoothLevelRank=_n

//Calculating Candidate Voteshare at the AC and PS Level
by Elections Year AC_No PollingStation: gen ACVoteShare=(TotalCandidateVotes)/TotalVotes
by Elections Year AC_No PollingStation: gen PSVoteShare=(Votes)/TotalBoothVotes

//Calculating Candidate Margin at the AC Level
gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation:gen ACVoteShareMargin=ACVoteShare-ACVoteShare[_n+1] if ACLevelRank==1
by Elections Year AC_No PollingStation:replace ACVoteShareMargin=(ACVoteShare-ACVoteShare[_n-1]) if ACLevelRank==2
by Elections Year AC_No PollingStation:replace ACVoteShareMargin=(ACVoteShare-ACVoteShare[_n-2]) if ACLevelRank==3
by Elections Year AC_No PollingStation:replace ACVoteShareMargin=(ACVoteShare-ACVoteShare[_n-3]) if ACLevelRank==4

//Calculating Candidate Margin at the PS Level
gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation:gen PSVoteShareMargin=PSVoteShare-PSVoteShare[_n+1] if BoothLevelRank==1
by Elections Year AC_No PollingStation:replace PSVoteShareMargin=PSVoteShare-PSVoteShare[_n-1] if BoothLevelRank==2
by Elections Year AC_No PollingStation:replace PSVoteShareMargin=PSVoteShare-PSVoteShare[_n-2] if BoothLevelRank==3
by Elections Year AC_No PollingStation:replace PSVoteShareMargin=PSVoteShare-PSVoteShare[_n-3] if BoothLevelRank==4


//Calculating Booth and AC winners (at Party Level)
gen PSWinner_BJP=1 if BoothLevelRank==1&Party=="BJP" 
gen ACWinner_BJP=1 if ACLevelRank==1&Party=="BJP" 

gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_BJP=PSWinner_BJP[_n-1] if PSWinner_BJP>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_BJP=PSWinner_BJP[_n-1] if PSWinner_BJP>=.
replace PSWinner_BJP=0 if PSWinner_BJP==.

gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_BJP=ACWinner_BJP[_n-1] if ACWinner_BJP>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_BJP=ACWinner_BJP[_n-1] if ACWinner_BJP>=.
replace ACWinner_BJP=0 if ACWinner_BJP==.


gen PSWinner_HJC=1 if BoothLevelRank==1&Party=="HJC(BL)" 
gen ACWinner_HJC=1 if ACLevelRank==1&Party=="HJC(BL)" 

gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_HJC=PSWinner_HJC[_n-1] if PSWinner_HJC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_HJC=PSWinner_HJC[_n-1] if PSWinner_HJC>=.
replace PSWinner_HJC=0 if PSWinner_HJC==.

gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_HJC=ACWinner_HJC[_n-1] if ACWinner_HJC>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_HJC=ACWinner_HJC[_n-1] if ACWinner_HJC>=.
replace ACWinner_HJC=0 if ACWinner_HJC==.


gen PSWinner_INC=1 if BoothLevelRank==1&Party=="INC" 
gen ACWinner_INC=1 if ACLevelRank==1&Party=="INC" 


gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_INC=PSWinner_INC[_n-1] if PSWinner_INC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_INC=PSWinner_INC[_n-1] if PSWinner_INC>=.
replace PSWinner_INC=0 if PSWinner_INC==.


gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_INC=ACWinner_INC[_n-1] if ACWinner_INC>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_INC=ACWinner_INC[_n-1] if ACWinner_INC>=.
replace ACWinner_INC=0 if ACWinner_INC==.


gen PSWinner_BSP=1 if BoothLevelRank==1&Party=="BSP" 
gen ACWinner_BSP=1 if ACLevelRank==1&Party=="BSP" 

gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_BSP=PSWinner_BSP[_n-1] if PSWinner_BSP>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_BSP=PSWinner_BSP[_n-1] if PSWinner_BSP>=.
replace PSWinner_BSP=0 if PSWinner_BSP==.


gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_BSP=ACWinner_BSP[_n-1] if ACWinner_BSP>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_BSP=ACWinner_BSP[_n-1] if ACWinner_BSP>=.
replace ACWinner_BSP=0 if ACWinner_BSP==.

gen PSWinner_IND=1 if BoothLevelRank==1&Party=="IND" 
gen ACWinner_IND=1 if ACLevelRank==1&Party=="IND" 

gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_IND=PSWinner_IND[_n-1] if PSWinner_IND>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_IND=PSWinner_IND[_n-1] if PSWinner_IND>=.
replace PSWinner_IND=0 if PSWinner_IND==.


gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_IND=ACWinner_IND[_n-1] if ACWinner_IND>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_IND=ACWinner_IND[_n-1] if ACWinner_IND>=.
replace ACWinner_IND=0 if ACWinner_IND==.

gen PSWinner_INLD=1 if BoothLevelRank==1&Party=="INLD" 
gen ACWinner_INLD=1 if ACLevelRank==1&Party=="INLD" 

gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_INLD=PSWinner_INLD[_n-1] if PSWinner_INLD>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_INLD=PSWinner_INLD[_n-1] if PSWinner_INLD>=.
replace PSWinner_INLD=0 if PSWinner_INLD==.


gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_INLD=ACWinner_INLD[_n-1] if ACWinner_INLD>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_INLD=ACWinner_INLD[_n-1] if ACWinner_INLD>=.
replace ACWinner_INLD=0 if ACWinner_INLD==.

gen PSWinner_AAP=1 if BoothLevelRank==1&Party=="AAP" 
gen ACWinner_AAP=1 if ACLevelRank==1&Party=="AAP" 

gsort Elections Year AC_No PollingStation BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_AAP=PSWinner_AAP[_n-1] if PSWinner_AAP>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace PSWinner_AAP=PSWinner_AAP[_n-1] if PSWinner_AAP>=.
replace PSWinner_AAP=0 if PSWinner_AAP==.


gsort Elections Year AC_No PollingStation ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_AAP=ACWinner_AAP[_n-1] if ACWinner_AAP>=.
gsort Elections Year AC_No PollingStation -ACLevelRank
by Elections Year AC_No PollingStation: replace ACWinner_AAP=ACWinner_AAP[_n-1] if ACWinner_AAP>=.
replace ACWinner_AAP=0 if ACWinner_AAP==.



label variable TotalBoothVotes "Total Votes Cast at the Polling Station level"
label variable Votes "Votes cast for the candidate at the Polling Station Level"
label variable TotalVotes "Total Votes Cast at the AC Level"
label variable TotalCandidateVotes "Total Votes Cast for the candidate at the AC Level"
label variable ACLevelRank "Rank of the candidate at the AC Level"
label variable BoothLevelRank "Rank of the candidate at the Booth Level"
label variable ACVoteShare "VoteShare of the Candidate at the AC Level"
label variable PSVoteShare "VoteShare of the Candidate at the PS Level"
label variable ACVoteShareMargin "VoteShare Margin of the Candidate at the AC Level. Winner: Winner - 2nd. Else: Them - winner"
label variable PSVoteShareMargin "VoteShare Margin of the Candidate at the Polling Booth Level. Winner: Winner - 2nd. Else: Them - winner"
label variable PSWinner_BJP "Dummy Variable: Polling Booth won by BJP"
label variable ACWinner_BJP "Dummy Variable: AC won by BJP"
label variable PSWinner_INC "Dummy Variable: Polling Booth won by INC"
label variable ACWinner_INC "Dummy Variable: AC won by INC"
label variable PSWinner_BSP "Dummy Variable: Polling Booth won by BSP"
label variable ACWinner_BSP "Dummy Variable: AC won by BSP"
label variable PSWinner_IND "Dummy Variable: Polling Booth won by IND"
label variable ACWinner_IND "Dummy Variable: AC won by IND"
label variable PSWinner_INLD "Dummy Variable: Polling Booth won by INLD"
label variable ACWinner_INLD "Dummy Variable: AC won by INLD"
label variable PSWinner_HJC "Dummy Variable: Polling Booth won by HJC(BL)"
label variable ACWinner_HJC "Dummy Variable: AC won by HJC(BL)"
label variable PSWinner_AAP "Dummy Variable: Polling Booth won by AAP"
label variable ACWinner_AAP "Dummy Variable: AC won by AAP"


gsort Elections Year AC_No PollingStation BoothLevelRank
gen NarrowPS10=1 if PSVoteShareMargin<0.10&BoothLevelRank==1
by Elections Year AC_No PollingStation: replace NarrowPS10=NarrowPS10[_n-1] if NarrowPS10>=.
replace NarrowPS10=0 if NarrowPS10==.

label variable NarrowPS10 "Lead was by less than 10% of the total votes at the booth level"

gsort Elections Year AC_No PollingStation BoothLevelRank
gen NarrowPS5=1 if PSVoteShareMargin<0.05&BoothLevelRank==1
by Elections Year AC_No PollingStation: replace NarrowPS5=NarrowPS5[_n-1] if NarrowPS5>=.
replace NarrowPS5=0 if NarrowPS5==.

label variable NarrowPS5 "Lead was by less than 5% of the total votes at the booth level"


gsort Elections Year AC_No PollingStation BoothLevelRank
gen NarrowAC5=1 if ACVoteShareMargin<0.05&ACLevelRank==1
by Elections Year AC_No PollingStation: replace NarrowAC5=NarrowAC5[_n-1] if NarrowAC5>=.
replace NarrowAC5=0 if NarrowAC5==.
label variable NarrowAC5 "Lead was by less than 5% of the total votes at the AC level"


gsort Elections Year AC_No PollingStation BoothLevelRank
gen NarrowAC10=1 if ACVoteShareMargin<0.10&ACLevelRank==1
by Elections Year AC_No PollingStation: replace NarrowAC10=NarrowAC10[_n-1] if NarrowAC10>=.
replace NarrowAC10=0 if NarrowAC10==.
label variable NarrowAC10 "Lead was by less than 10% of the total votes at the AC level"

gsort Elections Year AC_No PollingStation BoothLevelRank
gen BJPStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_BJP&Party=="BJP")
replace BJPStrongHold_AC=. if BJPStrongHold_AC==0
by Elections Year AC_No PollingStation: replace BJPStrongHold_AC=BJPStrongHold_AC[_n-1] if BJPStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace BJPStrongHold_AC=BJPStrongHold_AC[_n-1] if BJPStrongHold_AC>=.
replace BJPStrongHold_AC=0 if BJPStrongHold_AC==.



gsort Elections Year AC_No PollingStation BoothLevelRank
gen AAPStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_AAP&Party=="AAP")
replace AAPStrongHold_AC=. if AAPStrongHold_AC==0
by Elections Year AC_No PollingStation: replace AAPStrongHold_AC=AAPStrongHold_AC[_n-1] if AAPStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace AAPStrongHold_AC=AAPStrongHold_AC[_n-1] if AAPStrongHold_AC>=.
replace AAPStrongHold_AC=0 if AAPStrongHold_AC==.



gsort Elections Year AC_No PollingStation BoothLevelRank
gen INCStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_INC&Party=="INC")
replace INCStrongHold_AC=. if INCStrongHold_AC==0
by Elections Year AC_No: replace INCStrongHold_AC=INCStrongHold_AC[_n-1] if INCStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No: replace INCStrongHold_AC=INCStrongHold_AC[_n-1] if INCStrongHold_AC>=.
replace INCStrongHold_AC=0 if INCStrongHold_AC==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen INDStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_IND&Party=="IND")
replace INDStrongHold_AC=. if INDStrongHold_AC==0
by Elections Year AC_No PollingStation: replace INDStrongHold_AC=INDStrongHold_AC[_n-1] if INDStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace INDStrongHold_AC=INDStrongHold_AC[_n-1] if INDStrongHold_AC>=.
replace INDStrongHold_AC=0 if INDStrongHold_AC==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen BSPStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_BSP&Party=="BSP")
replace BSPStrongHold_AC=. if BSPStrongHold_AC==0
by Elections Year AC_No PollingStation: replace BSPStrongHold_AC=BSPStrongHold_AC[_n-1] if BSPStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace BSPStrongHold_AC=BSPStrongHold_AC[_n-1] if BSPStrongHold_AC>=.
replace BSPStrongHold_AC=0 if BSPStrongHold_AC==.


gsort Elections Year AC_No PollingStation BoothLevelRank
gen INLDStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_INLD&Party=="INLD")
replace INLDStrongHold_AC=. if INLDStrongHold_AC==0
by Elections Year AC_No PollingStation: replace INLDStrongHold_AC=INLDStrongHold_AC[_n-1] if INLDStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace INLDStrongHold_AC=INLDStrongHold_AC[_n-1] if INLDStrongHold_AC>=.
replace INLDStrongHold_AC=0 if INLDStrongHold_AC==.


gsort Elections Year AC_No PollingStation BoothLevelRank
gen HJCStrongHold_AC=(ACVoteShareMargin>0.1&ACWinner_HJC&Party=="HJC(BL)")
replace HJCStrongHold_AC=. if HJCStrongHold_AC==0
by Elections Year AC_No PollingStation: replace HJCStrongHold_AC=HJCStrongHold_AC[_n-1] if HJCStrongHold_AC>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace HJCStrongHold_AC=HJCStrongHold_AC[_n-1] if HJCStrongHold_AC>=.
replace HJCStrongHold_AC=0 if HJCStrongHold_AC==.


label variable BJPStrongHold_AC "BJP won the AC by more than 10% of the total Votes"
label variable INCStrongHold_AC "INC won the AC by more than 10% of the total Votes"
label variable BSPStrongHold_AC "BSP won the AC by more than 10% of the total Votes"
label variable INLDStrongHold_AC "INLD won the AC by more than 10% of the total Votes"
label variable INDStrongHold_AC "INDependent won the AC by more than 10% of the total Votes"
label variable HJCStrongHold_AC "HJC won the AC by more than 10% of the total Votes"
label variable AAPStrongHold_AC "AAP won the AC by more than 10% of the total Votes"



gsort Elections Year AC_No PollingStation BoothLevelRank
gen BJPStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_BJP==1&Party=="BJP"
by Elections Year AC_No PollingStation: replace BJPStrongHold_PS=BJPStrongHold_PS[_n-1] if BJPStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace BJPStrongHold_PS=BJPStrongHold_PS[_n-1] if BJPStrongHold_PS>=.
replace BJPStrongHold_PS=0 if BJPStrongHold_PS==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen INCStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_INC==1&Party=="INC"
by Elections Year AC_No PollingStation: replace INCStrongHold_PS=INCStrongHold_PS[_n-1] if INCStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace INCStrongHold_PS=INCStrongHold_PS[_n-1] if INCStrongHold_PS>=.
replace INCStrongHold_PS=0 if INCStrongHold_PS==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen INLDStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_INLD==1&Party=="INLD"
by Elections Year AC_No PollingStation: replace INLDStrongHold_PS=INLDStrongHold_PS[_n-1] if INLDStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace INLDStrongHold_PS=INLDStrongHold_PS[_n-1] if INLDStrongHold_PS>=.
replace INLDStrongHold_PS=0 if INLDStrongHold_PS==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen BSPStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_BSP==1&Party=="BSP"
by Elections Year AC_No PollingStation: replace BSPStrongHold_PS=BSPStrongHold_PS[_n-1] if BSPStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace BSPStrongHold_PS=BSPStrongHold_PS[_n-1] if BSPStrongHold_PS>=.
replace BSPStrongHold_PS=0 if BSPStrongHold_PS==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen INDStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_IND==1&Party=="IND"
by Elections Year AC_No PollingStation: replace INDStrongHold_PS=INDStrongHold_PS[_n-1] if INDStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace INDStrongHold_PS=INDStrongHold_PS[_n-1] if INDStrongHold_PS>=.
replace INDStrongHold_PS=0 if INDStrongHold_PS==.


gsort Elections Year AC_No PollingStation BoothLevelRank
gen HJCStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_HJC==1&Party=="HJC(BL)"
by Elections Year AC_No PollingStation: replace HJCStrongHold_PS=HJCStrongHold_PS[_n-1] if HJCStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace HJCStrongHold_PS=HJCStrongHold_PS[_n-1] if HJCStrongHold_PS>=.
replace HJCStrongHold_PS=0 if HJCStrongHold_PS==.

gsort Elections Year AC_No PollingStation BoothLevelRank
gen AAPStrongHold_PS=1 if PSVoteShareMargin>0.1&PSWinner_AAP==1&Party=="AAP"
by Elections Year AC_No PollingStation: replace AAPStrongHold_PS=AAPStrongHold_PS[_n-1] if AAPStrongHold_PS>=.
gsort Elections Year AC_No PollingStation -BoothLevelRank
by Elections Year AC_No PollingStation: replace AAPStrongHold_PS=AAPStrongHold_PS[_n-1] if AAPStrongHold_PS>=.
replace AAPStrongHold_PS=0 if AAPStrongHold_PS==.



label variable BJPStrongHold_PS "BJP won the PS by more than 10% of the total Votes"
label variable INCStrongHold_PS "INC won the PS by more than 10% of the total Votes"
label variable BSPStrongHold_PS "BSP won the PS by more than 10% of the total Votes"
label variable INLDStrongHold_PS "INLD won the PS by more than 10% of the total Votes"
label variable INDStrongHold_PS "INDependent won the PS by more than 10% of the total Votes"
label variable HJCStrongHold_PS "HJC won the PS by more than 10% of the total Votes"
label variable AAPStrongHold_PS "AAP won the PS by more than 10% of the total Votes"

destring PollingStation, replace

gsort Year AC_No PollingStation BoothLevelRank Elections
by Year AC_No PollingStation:gen StrongHoldNo=_n  
by Year AC_No PollingStation: gen StrongHold=1 if BoothLevelRank==1&Party==Party[_n+1]&StrongHoldNo==1
by Year AC_No PollingStation BoothLevelRank: replace StrongHold=StrongHold[_n-1] if StrongHold>=. 
by Year AC_No PollingStation: replace StrongHold=StrongHold[_n-1] if StrongHold>=. 
replace StrongHold=0 if StrongHold==.
drop StrongHoldNo

gsort Year AC_No PollingStation BoothLevelRank Elections StrongHold

label variable StrongHold "Same Party won the polling station at both Assembly and Lok Sabha Election (in the same year)"

save "C:\Users\shekh\Google Drive\AAP Data Unit\Form20\AC52.dta", replace

log using "C:\Users\shekh\Google Drive\AAP Data Unit\Form20\Form20_Codebook.log"
codebook
log close

log using "C:\Users\shekh\Google Drive\AAP Data Unit\Form20\Form20_DescriptiveStats.log", replace
//***Number of Polling Stations in Each Election type
tab Elections Year if BoothLevelRank==1

//***Number of Polling stations with narrow margin of victory in each election type
tab Elections Year if NarrowPS10==1&BoothLevelRank==1

//***List of Polling stations with narrow margin of victory in 2014 Assembly
list PollingStation if NarrowPS10==1&Elections=="Assembly"&Year==2014&BoothLevelRank==1

//***List of Polling stations with narrow margin of victory in 2009 Assembly
list PollingStation if NarrowPS10==1&Elections=="Assembly"&Year==2009&BoothLevelRank==1

//***List of Polling stations with narrow margin of victory in 2014 Lok Sabha
list PollingStation if NarrowPS10==1&Elections=="Lok Sabha"&Year==2014&BoothLevelRank==1

//***List of Polling stations with narrow margin of victory in 2009 Assembly
list PollingStation if NarrowPS10==1&Elections=="Lok Sabha"&Year==2009&BoothLevelRank==1

//***Number of Polling Stations where the same party won both Assembly and Lok Sabha Elections
tab Elections Year if BoothLevelRank==1&StrongHold==1

//***Number of Polling Stations where the same party won both Assembly and Lok Sabha Elections, by party in 2009
tab Party Elections if BoothLevelRank==1&StrongHold==1&Year==2009

//***Number of Polling Stations where the same party won both Assembly and Lok Sabha Elections, by party in 2014
tab Party Elections if BoothLevelRank==1&StrongHold==1&Year==2014

//***List of Polling stations where the same party won both Assembly and Lok Sabha Elections in 2009 
list PollingStation if BoothLevelRank==1&StrongHold==1&Elections=="Lok Sabha"&Year==2009

//***List of Polling stations where the same party won both Assembly and Lok Sabha Elections in 2014 
list PollingStation if BoothLevelRank==1&StrongHold==1&Elections=="Lok Sabha"&Year==2014

//***Number of Polling Stations won by each party by election and year
tab Elections Year if PSWinner_INC==1&BoothLevelRank==1
tab Elections Year if PSWinner_BJP==1&BoothLevelRank==1
tab Elections Year if PSWinner_INLD==1&BoothLevelRank==1
tab Elections Year if PSWinner_IND==1&BoothLevelRank==1
tab Elections Year if PSWinner_BSP==1&BoothLevelRank==1
tab Elections Year if PSWinner_HJC==1&BoothLevelRank==1
tab Elections Year if PSWinner_AAP==1&BoothLevelRank==1

//***Turnout Analysis at the PB Level for 2014
sum Turnout if BoothLevelRank==1&Year==2014&Elections=="Lok Sabha"
sum Turnout if BoothLevelRank==1&Year==2014&Elections=="Assembly"

log close

export excel using "C:\Users\shekh\Google Drive\AAP Data Unit\Form20\AC52_Analysis.xls", firstrow(variables)
