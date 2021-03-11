% This program used to exatract annual irrigation consumption of china
% and the 31 provinces

Location='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\Data\';
province=imread([Location,'Province_Grid_China.tif']);


ET_location='D:\Work_2021\Papers\Irrigation_China\Irrigaiton_Climate\���ڱ������������ȡ\';

%% ������ʼ��
ET_all=[];
for year=2000:2015
    
    irrigation_ET=imread([ET_location,num2str(year),'���ũ������������������������ʼ��.tif']); % unit: mm/year
    irrigation_ET(isnan(irrigation_ET))=0; % Convert Nan value to zero
    
    ET_temp_year=[];
    for ii=1:31 % 31 povince in China
        
        ET_temp_id=find(province==ii);
        ET_temp=irrigation_ET(ET_temp_id);
        % ͨ���Աȣ�����ֵΪ1Ҳ����Чֵ��
        ET_temp=ET_temp(ET_temp>1);
        ET_temp_year=[ET_temp_year,mean(ET_temp)]; % unit:mean growth start period  
        
    end
     ET_temp_year=[ET_temp_year,mean(ET_temp_year(1:end))];
     ET_all=[ET_all;ET_temp_year];
end
ET_all=[(2000:2015)',ET_all];
xlswrite('Irrigation_area_growth_period_China.xlsx',ET_all,'Growth_start');

%% ������
ET_all=[];
for year=2000:2015
    
    irrigation_ET=imread([ET_location,num2str(year),'���ũ����������������������������.tif']); % unit: mm/year
    irrigation_ET(isnan(irrigation_ET))=0; % Convert Nan value to zero
    
    ET_temp_year=[];
    for ii=1:31 % 31 povince in China
        
        ET_temp_id=find(province==ii);
        ET_temp=irrigation_ET(ET_temp_id);
        % ͨ���Աȣ�����ֵΪ1Ҳ����Чֵ��
        ET_temp=ET_temp(ET_temp>1);
        ET_temp_year=[ET_temp_year,mean(ET_temp)]; % unit:mean growth end period  
    end
     ET_temp_year=[ET_temp_year,mean(ET_temp_year(1:end))];
     ET_all=[ET_all;ET_temp_year];
end
ET_all=[(2000:2015)',ET_all];
xlswrite('Irrigation_area_growth_period_China.xlsx',ET_all,'Growth_end');
