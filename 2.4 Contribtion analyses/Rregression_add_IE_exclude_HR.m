% Regression beterrn water use/consumption and P. T. Rad, Hum.
clc; clear
% https://blog.csdn.net/weixin_39698007/article/details/112327264
% https://wenku.baidu.com/view/551fe56b1ed9ad51f01df232.html
% https://blog.csdn.net/weixin_42633850/article/details/105421717
%% Read Water use and consumption intensity data (mm/year)

Water_use_ET_data_loc='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\';

Water_use_data=xlsread([Water_use_ET_data_loc,'Irrigation_water_use_intensity_China.xlsx']);
ET_data=xlsread([Water_use_ET_data_loc,'Irrigation_ET_intensity_China.xlsx']);

%% IE
data_IRR_ET=xlsread([Water_use_ET_data_loc, 'Irrigation_ET_China.xlsx'],'ET');
data_IRR_use=xlsread([Water_use_ET_data_loc, 'Irrigation_ET_China.xlsx'],'Water_use');
IE_data=[data_IRR_ET(:,1),data_IRR_ET(:,2:end)./data_IRR_use(:,2:end)];
%% Read Climate Data
PCP_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet1');
T_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet2');
Rad_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet3');
Hum_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet4');

%% Regression
Beta_water_use=[];
R2_Ftest_sig_water_use=[];
Beta_sig_water_use=[];

Beta_water_consum=[];
R2_Ftest_sig_cosum=[];
Beta_sig_consum=[];

R_all=cell(32,1);
VIF_all=zeros(32,1);
for ii=1:32
    ii
    % First col is the year, and it was excluded for the regression
    water_use_temp=zscore(Water_use_data(:,ii+1)); % mm
    ET_data_temp=zscore(ET_data(:,ii+1)); % km (��Ϊ��׼������λû�б�ҪתΪmm)
    IE_all_temp=zscore(IE_data(:,ii+1));
    PCP_all_temp=zscore(PCP_all(:,ii+1)); %mm/year
    T_all_temp=zscore(T_all(:,ii+1)); % ��/year
    Rad_all_temp=zscore(Rad_all(:,ii+1)); % w/m2
    Hum_all_temp=zscore(Hum_all(:,ii+1)); % w/m2
    
    % ���ع�������
    R=corrcoef([PCP_all_temp,T_all_temp,IE_all_temp]);
     R_all{ii}=R;
    %     temp= diag(inv(R));
    VIF=max(diag(inv(R)));
    VIF_all(ii)=VIF;
   

    %====== water use regression========
    Y=water_use_temp;
    % X should include a column of ones so that the model contains a
    % constant term
    X=[ones(length(PCP_all_temp),1),PCP_all_temp,T_all_temp,IE_all_temp];
    [b,bint,r,rint,stats]=regress(Y,X);
    
     % significance for the coeffients. Note:The X should not include the
    % constant term. The first resulting coefficent, hower, represent the
    % constant term.
    stats_coefficents = regstats(Y,X(:,2:end),'linear');
    
    % the first valuse corresponds to the constant term
    Beta_sig=stats_coefficents.tstat.pval(2:end);
    
    Beta_water_use=[Beta_water_use;b(2:end)'];
    R2_Ftest_sig_water_use=[R2_Ftest_sig_water_use;[stats(1),stats(3)]];
    Beta_sig_water_use=[Beta_sig_water_use;Beta_sig'];
    
    %========= water consumption regresson=========
     Y=ET_data_temp;
    [b01,bint01,r01,rint01,stats01]=regress(Y,X);
    stats_coefficents = regstats(Y,X(:,2:end),'linear');
    % the first valuse corresponds to the constant term
    Beta_sig01=stats_coefficents.tstat.pval(2:end);
    
    Beta_water_consum=[Beta_water_consum;b01(2:end)'];
    R2_Ftest_sig_cosum=[R2_Ftest_sig_cosum;[stats01(1),stats01(3)]];
    Beta_sig_consum=[Beta_sig_consum;Beta_sig01'];
    
end

%%
xlswrite('Water_use_regression_Add_IE_exclude_HR.xlsx',Beta_water_use, 'Beta_water_use');
xlswrite('Water_use_regression_Add_IE_exclude_HR.xlsx',R2_Ftest_sig_water_use, 'R2_Ftest_sig_water_use');
xlswrite('Water_use_regression_Add_IE_exclude_HR.xlsx',Beta_sig_water_use, 'Beta_sig_water_use');

xlswrite('Water_use_regression_Add_IE_exclude_HR.xlsx',Beta_water_consum, 'Beta_water_consum');
xlswrite('Water_use_regression_Add_IE_exclude_HR.xlsx',R2_Ftest_sig_cosum, 'R2_Ftest_sig_cosum');
xlswrite('Water_use_regression_Add_IE_exclude_HR.xlsx',Beta_sig_consum, 'Beta_sig_consum');

%%
    
    % https://blog.csdn.net/weixin_39698007/article/details/112327264
    % https://wenku.baidu.com/view/551fe56b1ed9ad51f01df232.html
    % https://blog.csdn.net/weixin_42633850/article/details/105421717
    
%  (1)ֵΪ1��ʾ���Ա������κ������Ա���֮�䲻���ڹ�����
% 
% (2)����1��5֮���VIF�������ڽ����̶ȵĹ����ԣ����������ȡ������ʩ��
% 
% (3)����5��VIF���ڶ��ع����Ե��ٽ�ˮƽ���ع�ϵ������ò��ȶ���pֵ���ɣ�
% 
% (4)VIFֵ����10����ڽϴ�Ķ��ع��������⣬��Ҫ�������VIFֵ����20����ʾ���ع����Էǳ����ء� 
    