
%% Read climate data over the irrigated area over China

PCP_China=cell(32,1); % 1982-2013, 32 years
T_China=cell(32,1);
Rad_China=cell(32,1);
Hum_China=cell(32,1);

% read P data
prec=load('Prec_Yangkun_all.mat');
prec=prec.Prec_Yangkun_all;

% read T data
T=load('Temp_Yangkun_all.mat');
T=T.Temp_Yangkun_all;

% read Rad data
Rad=load('Srad_Yangkun_all.mat');
Rad=Rad.Srad_Yangkun_all;

% read Hum data
Hum=load('Shum_Yangkun_all.mat');
Hum=Hum.Shum_Yangkun_all;

kk=1;
for year=1982:2013
    % read Irrigaiton consumption data
    location_IRR_loc='F:\Data_ZL\ET\YinLichang\¹à¸ÈET\';
    [data_IRR, Ref] = geotiffread([location_IRR_loc,num2str(year),'Äê¹à¸ÈET.tif']);
    ID=find(data_IRR>0);
        
    data_IRR(ID)=prec{kk};
    PCP_China{kk}=data_IRR;
        
    data_IRR(ID)=T{kk};
    T_China{kk}=data_IRR;
    
    data_IRR(ID)=Rad{kk};
    Rad_China{kk}=data_IRR;
       
    data_IRR(ID)=Hum{kk};
    Hum_China{kk}=data_IRR;
    
    kk=kk+1;
end
% save('PCP_China.mat', 'PCP_China');
% save('T_China.mat', 'T_China');
% save('Rad_China.mat', 'Rad_China');
% save('Hum_China.mat', 'Hum_China');
%% Read data for each province and China

Location='D:\Work_2021\Papers\Irrigation_China\Figures\back_files\';
province=imread([Location,'agri_grid_new1.tif']);

PCP_all=[];
T_all=[];
Rad_all=[];
Hum_all=[];
jj=1;
for year=1982:2013
    year
    PCP_current=PCP_China{jj}; % mm/year
%     PCP_current(isnan(PCP_current))=0;
    T_current=T_China{jj};  % ¡æ/year
%     T_current(isnan(T_current))=0;
    Rad_current=Rad_China{jj}; % w/m2
%     Rad_current(isnan(Rad_current))=0;
    Hum_current=Hum_China{jj}; % g/kg
%     Hum_current(isnan(Hum_current))=0;
    
    
    PCP_temp_year=[];
    T_temp_year=[];
    Rad_temp_year=[];
    Hum_temp_year=[];
    for ii=1:9 % 9 subregions in China
        temp_id=find(province==ii);
        
        PCP_temp=PCP_current(temp_id);
        PCP_temp_year=[PCP_temp_year,nanmean(PCP_temp)];
        
        T_temp=T_current(temp_id);
        T_temp_year=[T_temp_year,nanmean(T_temp)];
        
        Rad_temp=Rad_current(temp_id);
        Rad_temp_year=[Rad_temp_year,nanmean(Rad_temp)];
        
        Hum_temp=Hum_current(temp_id);
        Hum_temp_year=[Hum_temp_year,nanmean(Hum_temp)];
        
    end
    PCP_temp_year=[PCP_temp_year,nanmean(PCP_current(:))];
    PCP_all=[PCP_all;PCP_temp_year];
    
    T_temp_year=[T_temp_year,nanmean(T_current(:))];
    T_all=[T_all;T_temp_year];
    
    Rad_temp_year=[Rad_temp_year,nanmean(Rad_current(:))];
    Rad_all=[Rad_all;Rad_temp_year];
    
    Hum_temp_year=[Hum_temp_year,nanmean(Hum_current(:))];
    Hum_all=[Hum_all;Hum_temp_year];
    
    jj=jj+1;
end

PCP_all=[(1982:2013)',PCP_all];
T_all=[(1982:2013)',T_all];
Rad_all=[(1982:2013)',Rad_all];
Hum_all=[(1982:2013)',Hum_all];


xlswrite('Climate_Irrigated_Area_China_AgriZone.xlsx',PCP_all, 'sheet1');
xlswrite('Climate_Irrigated_Area_China_AgriZone.xlsx',T_all, 'sheet2');
xlswrite('Climate_Irrigated_Area_China_AgriZone.xlsx',Rad_all, 'sheet3');
xlswrite('Climate_Irrigated_Area_China_AgriZone.xlsx',Hum_all, 'sheet4');
%%