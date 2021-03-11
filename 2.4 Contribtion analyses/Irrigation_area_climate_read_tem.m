% Read prec data from Yangkun
clc;clear

% data Location
Location_Yangkun='E:\Data_ZL\国家青藏高原数据中心\中国区域高时空分辨率地面气象要素驱动数据集\Data_forcing_01dy_010deg\';


% read Irrigation area of Yilichang
location_IRR_loc='E:\Data_ZL\ET\YinLichang\灌溉ET\';
ET_IRR_Yin_all=load([location_IRR_loc,'ET_IRR_Yin_all.mat'],...
    'ET_IRR_Yin_all');
ET_IRR_Yin_all=ET_IRR_Yin_all.ET_IRR_Yin_all;

% reading data
% ncdisp([Location_Yangkun,'Yangkun_gswp3_nobc_hist_nosoc_co2_evap_global_monthly_1971_2010.nc']);
namefile='temp_ITPCAS-CMFD_V0106_B-01_01dy_010deg_197901-197912.nc';
lon_Yangkun=ncread([Location_Yangkun,namefile],'lon');
lat_Yangkun=ncread([Location_Yangkun,namefile],'lat');
  

%% data length
start_day=[1982,1,1];
end_day=[2013,12,31];

kk=1;
Temp_Yangkun_all=cell(length( start_day(1):end_day(1)),1);

for year = start_day(1):end_day(1)
     
    year
    
    %% read data for each year over the irrigated area
    lat_IRR=ET_IRR_Yin_all{kk}(:,3); % latitude if the irrigation grids
    lon_IRR=ET_IRR_Yin_all{kk}(:,4); % longtitude if the irrigation grids
    lat_row=ET_IRR_Yin_all{kk}(:,1); % row if the irrigation grids
    lon_col=ET_IRR_Yin_all{kk}(:,2); % col if the irrigation grids
    ID_lon_all=[];
    ID_lat_all=[];
    parfor i=1:length(lat_IRR)
        lon_stat=lon_IRR(i);
        lat_stat=lat_IRR(i);
        %Extraction of the pixel closest to the selected coordinates
        ID_lon=knnsearch(lon_Yangkun,lon_stat);
        ID_lat=knnsearch(lat_Yangkun,lat_stat);
        ID_lon_all=[ID_lon_all;ID_lon];
        ID_lat_all=[ID_lat_all;ID_lat];
    end
    
    PCP_day_all=[];
    for jj=1:yeardays(year)
        
        % IMERG data for Current day
        Temp_Yangkun=ncread([Location_Yangkun,'temp_ITPCAS-CMFD_V0106_B-01_01dy_010deg_',num2str(year),'01-',num2str(year),'12.nc'],'temp',[1 1,jj],[700,400,1])-273.15; % unit:k->摄氏度
        
        
        PCP_day=[];
        parfor i=1:length(ID_lon_all)
            PCP_Temp=Temp_Yangkun(ID_lon_all(i),ID_lat_all(i)); % read data for current station
            PCP_day=[PCP_day,PCP_Temp];
        end 
        
        PCP_day_all=[PCP_day_all;PCP_day];
        
    end
    
    
  %% Growth period
 Growth_start=imread('Zl_mean_灌溉农田基于作物持续比例的生长开始期.tif'); % unit: day of year
 Growth_end=imread('Zl_mean_灌溉农田基于作物持续比例的生长结束期.tif'); % unit: day of year
    
 start_day_growth=[];
 parfor i=1:length(ID_lon_all)
     start_Temp=Growth_start(lat_row(i),lon_col(i)); % read data for current station
     start_day_growth=[start_day_growth,start_Temp];
 end
 start_day_growth=fix(start_day_growth);
 
  end_day_growth=[];
 parfor i=1:length(ID_lon_all)
     end_Temp=Growth_end(lat_row(i),lon_col(i)); % read data for current station
     end_day_growth=[end_day_growth,end_Temp];
 end
  end_day_growth=fix(end_day_growth);
  
 %% Growth period data
 data_all=zeros(length(lat_IRR),1);
 for mm=1:length(lat_IRR)
       data_temp=PCP_day_all(:,mm);
       
     current_start=start_day_growth(mm);
     if  isnan(current_start)==1;
          if mm<length(lat_IRR)-10
         current_start=fix(nanmean(start_day_growth(mm:mm+10)));
          else
          current_start=fix(nanmean(start_day_growth(mm-10:mm)));    
          end
     end
     
      current_end=end_day_growth(mm);
      if  isnan(current_end)==1;
           if mm<length(lat_IRR)-10
         current_end=fix(nanmean(end_day_growth(mm:mm+10)));
          else
          current_end=fix(nanmean(end_day_growth(mm-10:mm)));    
          end
      end
      if current_end>length(data_temp);
          current_end=length(data_temp);
      end
    
     current_data=mean(data_temp(current_start:current_end)); % mm/growth period
     data_all(mm)=current_data;  
 end
  
  %%  
    Temp_Yangkun_all{kk}=data_all;
     kk=kk+1;
end

save 'Temp_Yangkun_all.mat', 'Temp_Yangkun_all';