% This program is used to estimate the trend of the IRR_ET and IRR_use

% data locaiton
data_location='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\';

% data read
data_IRR_ET=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'ET');
data_IRR_use=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'Water_use');

% trend analyses
Trend_ET_all=[];
Trend_use_all=[];
XX=(1:32)'; % years: 198-2013
for ii=1:32 % provinces+China
    temp_ET=data_IRR_ET(:,ii+1);
    temp_use=data_IRR_use(:,ii+1);
    X=[ones(length(XX),1),XX];
    [b,bint,r,rint,stats] = regress(temp_ET,X);
    [b1,bint1,r1,rint1,stats1] = regress(temp_use,X);
    
    Trend_ET_all=[Trend_ET_all;[b(2),stats(3)]];
    Trend_use_all=[Trend_use_all;[b1(2),stats1(3)]];
   
    
end

ALL_trend=[Trend_ET_all,Trend_use_all,Trend_ET_all(:,1)./Trend_use_all(:,1)];

xlswrite('Trend_analyses.xlsx',ALL_trend');