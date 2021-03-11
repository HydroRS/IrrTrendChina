% This program used to exatract annual irrigation consumption of china
% and the 31 provinces

Location='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\Data\';
province=imread([Location,'Province_Grid_China.tif']);


ET_location='D:\Work_2021\Papers\Irrigation_China\Irrigaiton_Climate\基于比例的物候期提取\';

%% 生长开始期
ET_all=zeros(536,608);
id_all=zeros(536,608);
for year=2000:2015
    
    irrigation_ET=imread([ET_location,num2str(year),'灌溉农田基于作物持续比例的生长开始期.tif']); % unit: mm/year
    irrigation_ET(isnan(irrigation_ET))=0; % Convert Nan value to zero
    irrigation_ET(irrigation_ET==1)=0; 
    
    ID_grid=irrigation_ET;
    ID_grid(ID_grid>0)=1; %找到有效值的gid
    id_all=id_all+ID_grid;
ET_all=ET_all+irrigation_ET;
end
end_gird=ET_all./id_all;

% xlswrite('Irrigation_area_growth_period_China.xlsx',ET_all,'Growth_start');
data_GeoInfor=geotiffinfo([ET_location,'2000灌溉农田基于作物持续比例的生长开始期.tif']);
[temp, Ref] = geotiffread([ET_location,'2000灌溉农田基于作物持续比例的生长开始期.tif']);
geotiffwrite('Zl_mean_灌溉农田基于作物持续比例的生长开始期.tif',end_gird,Ref, 'GeoKeyDirectoryTag', data_GeoInfor.GeoTIFFTags.GeoKeyDirectoryTag);
%% 结束期

ET_all=zeros(536,608);
id_all=zeros(536,608);
for year=2000:2015
    
    irrigation_ET=imread([ET_location,num2str(year),'灌溉农田基于作物持续比例的生长结束期.tif']); % unit: mm/year
    irrigation_ET(isnan(irrigation_ET))=0; % Convert Nan value to zero
       irrigation_ET(irrigation_ET==1)=0; 
    
    ID_grid=irrigation_ET;
    ID_grid(ID_grid>0)=1; %找到有效值的gid
    id_all=id_all+ID_grid;
ET_all=ET_all+irrigation_ET;
end
end_gird=ET_all./id_all;

% xlswrite('Irrigation_area_growth_period_China.xlsx',ET_all,'Growth_start');
data_GeoInfor=geotiffinfo([ET_location,'2000灌溉农田基于作物持续比例的生长结束期.tif']);
[temp, Ref] = geotiffread([ET_location,'2000灌溉农田基于作物持续比例的生长结束期.tif']);
geotiffwrite('Zl_mean_灌溉农田基于作物持续比例的生长结束期.tif',end_gird,Ref, 'GeoKeyDirectoryTag', data_GeoInfor.GeoTIFFTags.GeoKeyDirectoryTag);

