use "C:\Users\shekh\Google Drive\AAP Data Unit\AC52_Form20_ElectoralRoll_Census_Combined_2014.dta", clear

//Omitted Category INC
local PSWinner "PSWinner_BJP PSWinner_INLD PSWinner_IND PSWinner_BSP PSWinner_HJC"

//Omitted Category Missing
local PSCaste "PS_ShareBaniya PS_ShareBrahmin PS_ShareGurjar PS_ShareJat PS_SharePunjabi PS_ShareRajput PS_ShareSC PS_ShareSikh PS_ShareYadav"

regress SwingPS DummyLokSabha `PSWinner' `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)

regress INCStrongHold_PS DummyLokSabha `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)
regress BJPStrongHold_PS DummyLokSabha  `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)
regress INLDStrongHold_PS DummyLokSabha  `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)
regress INDStrongHold_PS DummyLokSabha  `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)
regress HJCStrongHold_PS DummyLokSabha  `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)
regress OpenPS DummyLokSabha `PSWinner' `PSCaste' PS_FemaleShare PS_Mean_HHSize PS_Mean_Age if SerialCount==1, cluster(PollingStation)


sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&BJPStrongHold_PS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&INCStrongHold_PS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&INDStrongHold_PS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&INLDStrongHold_PS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&BSPStrongHold_PS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&HJCStrongHold_PS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&SwingPS==1
sum PS_Share* PS_Mean_Age PS_FemaleShare PS_Mean_HHSize if SerialCount==1&OpenPS==1
