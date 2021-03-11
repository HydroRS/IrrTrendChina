%% This program is used to estimate the trend of the IRR_ET and IRR_use

% data locaiton
data_location='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\';

% data read
data_IRR_ET=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'ET');
data_IRR_use=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'Water_use');

% trend analyses
Trend_ET_all=[];
Trend_use_all=[];
XX=(1:32)'; % years: 198-2013
period=1982:2013;
for ii=1:32 % provinces+China
    temp_ET=data_IRR_ET(:,ii+1);
    temp_use=data_IRR_use(:,ii+1);
%     X=[ones(length(XX),1),XX];
%     [b,bint,r,rint,stats] = regress(temp_ET,X);
%     [b1,bint1,r1,rint1,stats1] = regress(temp_use,X);
   temp_ET_turn_point=pettitt(temp_ET);
   temp_use_turn_point=pettitt(temp_use);
    
    Trend_ET_all=[Trend_ET_all;[period(temp_ET_turn_point(1)),temp_ET_turn_point(3)]]; % turn point-year and P value
    Trend_use_all=[Trend_use_all;[period(temp_use_turn_point(1)),temp_use_turn_point(3)]];
   
    
end

ALL_trend=[Trend_ET_all,Trend_use_all];
xlswrite('ET&WaterUse_Turnpoint_final.xlsx',ALL_trend,'all');

% 1982-1998
Trend_ET_all=[];
Trend_use_all=[];
XX=(1:32)'; % years: 198-2013
period=1982:2013;
for ii=1:32 % provinces+China
    temp_ET=data_IRR_ET(:,ii+1);
    temp_use=data_IRR_use(:,ii+1);
%     X=[ones(length(XX),1),XX];
%     [b,bint,r,rint,stats] = regress(temp_ET,X);
%     [b1,bint1,r1,rint1,stats1] = regress(temp_use,X);
   temp_ET_turn_point=pettitt(temp_ET);
   temp_use_turn_point=pettitt(temp_use);
    
    Trend_ET_all=[Trend_ET_all;[period(temp_ET_turn_point(1)),temp_ET_turn_point(3)]]; % turn point-year and P value
    Trend_use_all=[Trend_use_all;[period(temp_use_turn_point(1)),temp_use_turn_point(3)]];
   
    
end

ALL_trend=[Trend_ET_all,Trend_use_all];

%% turn point accumulated anomaly algorithm
data_location='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\';
data_IRR_ET=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'ET');
data_IRR_use=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'Water_use');

ET_China=data_IRR_ET(:,end);
use_China=data_IRR_use(:,end);

anomony_ET=ET_China-mean(ET_China);
anomony_use=use_China-mean(use_China);

anomony_ET_all=[];
anomony_use_all=[];
temp_ET=0;
temp_use=0;
for ii=1:length(anomony_use)
   temp_ET=temp_ET+anomony_ET(ii);
   temp_use=temp_use+anomony_use(ii);
   anomony_ET_all=[anomony_ET_all;temp_ET];
   anomony_use_all=[anomony_use_all;temp_use];
end
xlswrite('ET&WaterUse_accum_anomony.xlsx',[(1982:2013)',anomony_ET_all,anomony_use_all]);