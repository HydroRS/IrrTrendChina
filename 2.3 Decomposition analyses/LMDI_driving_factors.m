% This program is used to for the decomposition analyses
clc
clear

% data locaiton
data_location='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\';

% data read
data_IRR_ET=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'ET');
data_IRR_use=xlsread([data_location, 'Irrigation_ET_China.xlsx'],'Water_use');


% read
Zhou_data_province_all=load([data_location,'Zhou_data_province_all.mat'],...
    'Zhou_data_province_all');
Zhou_data_province_all=Zhou_data_province_all.Zhou_data_province_all;


turn_point=18; % year 1999

% Decompostion for each period
P1_1982_1997=[];
P2_1997_2013=[];
P3_1982_2013=[];

for ii=1:32 % provinces+China
    
    %% Before year 1997
    
    temp_data=Zhou_data_province_all{ii}(18:end,:); % only_data 1982-2013
    
    temp_ET=data_IRR_ET(1:turn_point,ii+1); % Irrigaiton consumption,km3/year
    temp_use=data_IRR_use(1:turn_point,ii+1); % Irrigaiton water use, km3/year
    Temp_IRR_area=temp_data(1:turn_point,3)*10; % Irrigaiton area, km2,1000ha=10km2
    Temp_IRR_WUI=temp_data(1:turn_point,9)*0.000001; % water use intensity, km, 1mm=10-6 km. 
    Temp_IRR_IE=temp_ET./temp_use; % irrigaiton efficiency
%     Temp_IRR_IE(Temp_IRR_IE>1)=1; % IE<=1;
    
    % use the average value (6 years) of the begnining and end period
    w=(mean(temp_ET(end-5:end))-mean(temp_ET(1:6)))/(log(mean(temp_ET(end-5:end)))-log(mean(temp_ET(1:6))));
    
    delta_IRR_ET=mean(temp_ET(end-5:end))-mean(temp_ET(1:6));
    delta_IRR_area=w*log(mean(Temp_IRR_area(end-5:end))/mean(Temp_IRR_area(1:6)));
    delta_IRR_WUI=w*log(mean(Temp_IRR_WUI(end-5:end))/mean(Temp_IRR_WUI(1:6)));
    delta_IRR_IE=w*log(mean(Temp_IRR_IE(end-5:end))/mean(Temp_IRR_IE(1:6)));
    
    P1_1982_1997=[P1_1982_1997;[delta_IRR_ET,delta_IRR_area,delta_IRR_WUI,delta_IRR_IE]];
    
    
    %% After year 1997
    temp_ET=data_IRR_ET(turn_point:end,ii+1);
    temp_use=data_IRR_use(turn_point:end,ii+1);
    Temp_IRR_area=temp_data(turn_point:end,3); % Irrigaiton area
    Temp_IRR_WUI=temp_data(turn_point:end,9)*0.000001; % water use intensity
    Temp_IRR_IE=temp_ET./temp_use; % irrigaiton efficiency
%     Temp_IRR_IE(Temp_IRR_IE>1)=1; % IE<=1;
    
    % use the average value (6 years) of the begnining and end period
    w=(mean(temp_ET(end-5:end))-mean(temp_ET(1:6)))/(log(mean(temp_ET(end-5:end)))-log(mean(temp_ET(1:6))));
    
    delta_IRR_ET=mean(temp_ET(end-5:end))-mean(temp_ET(1:6));
    delta_IRR_area=w*log(mean(Temp_IRR_area(end-5:end))/mean(Temp_IRR_area(1:6)));
    delta_IRR_WUI=w*log(mean(Temp_IRR_WUI(end-5:end))/mean(Temp_IRR_WUI(1:6)));
    delta_IRR_IE=w*log(mean(Temp_IRR_IE(end-5:end))/mean(Temp_IRR_IE(1:6)));
    
    P2_1997_2013=[P2_1997_2013;[delta_IRR_ET,delta_IRR_area,delta_IRR_WUI,delta_IRR_IE]];
    
    %% Entire period 1982-2013
    temp_ET=data_IRR_ET(:,ii+1);
    temp_use=data_IRR_use(:,ii+1);
    Temp_IRR_area=temp_data(:,3); % Irrigaiton area
    Temp_IRR_WUI=temp_data(:,9); % water use intensity
    Temp_IRR_IE=temp_ET./temp_use*0.000001; % irrigaiton efficiency
    %     Temp_IRR_IE(Temp_IRR_IE>1)=2; % IE<=1;
    
    % use the average value (6 years) of the begnining and end period
    w=(mean(temp_ET(end-5:end))-mean(temp_ET(1:6)))/(log(mean(temp_ET(end-5:end)))-log(mean(temp_ET(1:6))));
    
    delta_IRR_ET=mean(temp_ET(end-5:end))-mean(temp_ET(1:6));
    delta_IRR_area=w*log(mean(Temp_IRR_area(end-5:end))/mean(Temp_IRR_area(1:6)));
    delta_IRR_WUI=w*log(mean(Temp_IRR_WUI(end-5:end))/mean(Temp_IRR_WUI(1:6)));
    delta_IRR_IE=w*log(mean(Temp_IRR_IE(end-5:end))/mean(Temp_IRR_IE(1:6)));
    
    P3_1982_2013=[P3_1982_2013;[delta_IRR_ET,delta_IRR_area,delta_IRR_WUI,delta_IRR_IE]];
    
end


xlswrite('Decomposition_analyses.xlsx',P1_1982_1997, '1982-1999')
xlswrite('Decomposition_analyses.xlsx',P2_1997_2013, '1999_2013')
xlswrite('Decomposition_analyses.xlsx',P3_1982_2013, '1982_2013')