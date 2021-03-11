% Regression beterrn water use/consumption and P. T. Rad, Hum.
clc; clear

%% Read Water use and consumption intensity data (mm/year)

Water_use_ET_data_loc='D:\Work_2021\Papers\Irrigation_China\ET_irrgation\';

% Water_use_data=xlsread([Water_use_ET_data_loc,'Irrigation_water_use_intensity_China.xlsx']);
% ET_data=xlsread([Water_use_ET_data_loc,'Irrigation_ET_intensity_China.xlsx']);

%% IE
data_IRR_ET=xlsread([Water_use_ET_data_loc, 'Irrigation_ET_China.xlsx'],'ET');
data_IRR_use=xlsread([Water_use_ET_data_loc, 'Irrigation_ET_China.xlsx'],'Water_use');
IE_data=[data_IRR_ET(:,1),data_IRR_ET(:,2:end)./data_IRR_use(:,2:end)];

data_IWC_area=xlsread([Water_use_ET_data_loc, 'Irrigation_ET_area_China.xlsx']);
data_IWU_area=xlsread([Water_use_ET_data_loc, 'Irrigation_water_use_area_China.xlsx']);

% data_IWC_area=zscore(data_IWC_area);

%% Read Climate Data
% PCP_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet1');
% T_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet2');
% Rad_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet3');
% Hum_all=xlsread('Climate_Irrigated_Area_China.xlsx', 'sheet4');


%% dummy variable
N=31; % regions
T=32; % years
time_all=zeros(32,31);
for jj=1:31
    time_all(jj+1,jj)=1;
end

region_all=zeros(32*31,30);
for kk=1:30
    region_all((kk*32+1):(kk+1)*32,kk)=1;
end
%% data_all
data_all=[];
for region=2:32
    
  data_all=[data_all;[data_IWC_area(:,region),IE_data(:,region),time_all]];
  %  data_all=[data_all;[Water_use_data(:,region),ET_data(:,region),PCP_all(:,region),T_all(:,region),Rad_all(:,region),Hum_all(:,region),time_all]];
end
data_all=[data_all,region_all];
data_all_before_norm=data_all; % save the data before normilization

% for mm=1:2
%     data_all(:,mm)=zscore( data_all(:,mm));
% end

data_all_new=[];
data_all_before_norm_new=[];
for kk=1:32
    data_all_before_norm_new=[data_all_before_norm_new;data_all_before_norm(kk:T:end,:)];
    data_all_new=[data_all_new;data_all(kk:32:end,:)];
end

    
% data_all=data_all_new;

%% 组内离差法
% T=32;
% N=31;
% y=data_all(:,1);
% x=data_all(:,3:7);
% model=3; % time and individual fixed, 1: individual fixed; 2:time fixed
% 
% % demean里面的逻辑：y存储的顺序第一列应该是time，第二列是region
% % t1 region1 data1 data2
% % t1 region2 data1 data2
% % t2 region1 data1 data2
% % t2 region2 data1 data2
% [ywith,xwith,meanny,meannx,meanty,meantx]=demean(y,x,N,T,model);
% 
% results=ols(ywith,xwith);
% [b,bint,r,rint,stats]=regress(ywith,[ones(32*31,1),xwith]);
%  stats_coefficents = regstats(ywith,xwith,'linear');
%   Beta_sig=stats_coefficents.tstat.pval(2:end);
%  
% % performance
% sim=sum(repmat(b',32*31,1).* [ones(32*31,1),xwith],2);
% R2=corr(sim,ywith)^2; 
% 
% % 考虑fixed effects计算的performance与下面的传统回归方法
% en=ones(T,1);
% et=ones(N,1);
% ent=ones(T*N,1);
% ysim=sim+kron(en,meanny)+kron(meanty,et)-kron(ent,mean(y));
% R2_new=corr(ysim,y)^2;
  
%% 传统回归方法+dummy variables
   %====== water use regression========
    Y=data_all_new(:,1);
    
  %   Y=log(data_all_new(:,1));
    
    % X should include a column of ones so that the model contains a
    % constant term
    X=[ones(32*31,1),data_all_new(:,2:end)];
    [b,bint,r,rint,stats]=regress(Y,X);
    
     stats_coefficents = regstats(Y,X(:,2:end),'linear');
    
    % the first valuse corresponds to the constant term
    Beta_sig=stats_coefficents.tstat.pval(2:end);
    
%     Beta_water_use=[Beta_water_use;b(2:end)'];
%     R2_Ftest_sig_water_use=[R2_Ftest_sig_water_use;[stats(1),stats(3)]];
%     Beta_sig_water_use=[Beta_sig_water_use;Beta_sig'];
%%    
    
  %========= water consumption regresson=========
%      Y=data_all(:,2);
%     [b01,bint01,r01,rint01,stats01]=regress(Y,X);
%     stats_coefficents = regstats(Y,X(:,2:end),'linear');
%     % the first valuse corresponds to the constant term
%     Beta_sig01=stats_coefficents.tstat.pval(2:end);



%% Detrend data

N=31; % regions
T=32; % years
 mm=1;
 detrend_X=[];
for jj=1:N
    
    temp_region_data=data_all(mm:mm+T-1,:);
    mm=mm+T;
    
    temp_region_data=temp_region_data(:,1:2); 
    temp_detrend=zeros(T,2);
    for ii=1:2
        detrend_data=detrend(temp_region_data(:,ii));
%         temp_detrend(:,ii)=detrend_data;
       temp_detrend(:,ii)=detrend_data+(temp_region_data(1,ii)-detrend_data(1));
    end
    
    detrend_X=[detrend_X;temp_detrend];
    
end
detrend_X=[detrend_X,data_all(:,3:end)];

% Coversion needs to be made for the 组内离差法
% t1 region1 data1 data2
% t1 region2 data1 data2
% t2 region1 data1 data2
% t2 region2 data1 data2
detrend_X_new=[];
for kk=1:T
    detrend_X_new=[detrend_X_new;detrend_X(kk:T:end,:)];
end

%% %% calculate counterfactual IWU
% all_effect\
Y_all_effect_norm=sum(repmat(b',length(Y),1).*[ones(T*N,1),detrend_X_new(:,2:end)],2);

% Y simulation with the detrended data
% Y_all_effect=Y_all_effect_norm*std(Y_obs_new)+mean(Y_obs_new); 
Y_all_effect=Y_all_effect_norm;

% observed IWU
Y_obs_new=data_all_before_norm_new(:,1); 

% Y simulation with the original data
Y_sim=sum(repmat(b',length(Y),1).*[ones(T*N,1),data_all_new(:,2:end)],2);
% Y_sim=Y_sim*std(Y_obs_new)+mean(Y_obs_new);

% delta_Y_all_effect1_new=Y_obs_new-Y_all_effect; %相对于观测
% delta_Y_all_effect2_new=Y_sim-Y_all_effect; %相对于模拟（因为第一年数据不变，所以第一年结果应该全为0）


%% covet back to the original foramat 
% delta_Y_all_effect1=[];
Y_all_effect_China=[];
Y_sim_China=[];
Y_obs=[];
for kk=1:N
%     delta_Y_all_effect1=[delta_Y_all_effect1;delta_Y_all_effect1_new(kk:N:end,:)];
   Y_all_effect_China=[Y_all_effect_China,Y_all_effect(kk:N:end,:)];
    Y_sim_China=[Y_sim_China,Y_sim(kk:N:end,:)];
    Y_obs=[Y_obs,Y_obs_new(kk:N:end,:)];
end

% Y_all_effect_China(:,end+1)=sum(Y_all_effect_China,2);
% Y_sim_China(:,end+1)=sum(Y_sim_China,2);
Result=[sum(Y_sim_China,2),sum(Y_all_effect_China,2)];


%%




