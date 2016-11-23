% run PCA on lava lake images
% Kathi Unglert, Jan 2016

clear all
close all
clc

%%% set some parameters for individual datasets:

mypath = '~/Documents/Dokumente/Uni/PhD/Vancouver/UBC PhD/SOM/from_Einat/';
dataset_option = 8;

% dataset_option numbers
% 1 Nyiragongo 10 March 2012
% 2 Erebus Dec 02
% 3 Erebus Dec 16
% 4 Erebus Dec 30
% 5 Halemaumau Jan 16 velocity
% 6 Halemaumau Aug 22
% 7 Halemaumau Jan 16
% 8 Halemaumau Jun 18

% load data

if dataset_option == 1
    
    %%%%%%%% Nyiragongo
    
    datapath = 'Nyiragongo/data/';
    fn = strcat(mypath,datapath,'Nyiragongo_10March2012_ImagesforSOM.mat');
    load(fn);
    
    savepath = strcat(mypath,'Nyiragongo/results/Nyiragongo_full');
    
    % note: array comes as 529x34191, where
    % n_samples = 529
    % n_pixels = 34191
    % image can be re-created with 261 rows and 131 columns
    
    n_cols_data = 261;
    n_rows_data = 131;
    
    dt = 5; % s, sampling interval
    
    alldata = Nyirgongo_March10(2:size(Nyirgongo_March10,1),:);
    alltime = [datenum(2012,3,10,0,0,5):dt/(3600*24):datenum(2012,3,10,0,0,5)+(dt/(3600*24))*(size(alldata,1)-1)];
    
elseif dataset_option == 2;
    
    %%%%%%%%%% Erebus
    
    %%% Dec 02 Erebus
    
    datapath = 'Erebus/data/';
    
    n_rows_data = 101;
    n_cols_data = 121;
    fn = strcat(mypath,datapath,'Dec_2_04_Erebus_24hours.mat');
    load(fn);
    
    % note: array comes as 24x1959x12221, where
    % n_samples = 24x1959
    % n_pixels = 12221
    % image can be re-created with 101 rows and 121 columns
    
    savepath = strcat(mypath,'Erebus/results/ErebusDec02_full');
    
    dt = 1.838; % s, sampling interval
    alldata = zeros(size(Dec_02,1)*size(Dec_02,2),size(Dec_02,3));
    for ii = 1:size(Dec_02,1)
        alldata((ii-1)*size(Dec_02,2)+1:ii*size(Dec_02,2),:) = squeeze(Dec_02(ii,:,:));
    end
    
    alltime = [datenum(2004,12,2,0,0,0):dt/(3600*24):datenum(2004,12,2,0,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    % remove times with bad values
    [badrows] = find(mean(alldata,2) <= 1e-7);
    original_length = length(alltime);
    
    index = true(size(alltime));
    index(unique(badrows)) = false;
    
    alldata = alldata(index,:);
    alltime = alltime(index);
    sprintf('%d out of %d samples were discarded',length(unique(badrows)),original_length)
    
elseif dataset_option == 3;
    
    %%% Dec 16
    
    datapath = 'Erebus/data/';
    
    n_rows_data = 101;
    n_cols_data = 121;
    fn = strcat(mypath,datapath,'Dec_16_Kathi.mat');
    load(fn);
    load(strcat(mypath,datapath,'Dec_16_timesec.mat'));
    
    % note: array comes as 43701x12221, where
    % n_samples = 43701
    % n_pixels = 12221
    % image can be re-created with 101 rows and 121 columns
    
    
    dt = 2; % s, sampling interval
    alldata = double(Dec_16);
    alldata = alldata([1:4740 4742:end],:);
    
    alltime = datenum(2004,12,16,0,0,0)+timesec(1:length(timesec))./(3600*24);
    alltime = alltime([1:4740 4742:end]);
    
    savepath = strcat(mypath,'Erebus/results/ErebusDec16_full');
    
elseif dataset_option == 4;
    
    %%% Dec 30
    
    datapath = 'Erebus/data/';
    
    n_rows_data = 101;
    n_cols_data = 121;
    fn = strcat(mypath,datapath,'Dec_30_04_Erebus_1hour.mat');
    load(fn);
    
    % note: array comes as 1766x12221, where
    % n_samples = 1766
    % n_pixels = 12221
    % image can be re-created with 100 rows and 121 columns
    
    
    dt = 2.039; % s, sampling interval
    alldata = double(Dec_30_04);
    
    alltime = [datenum(2004,12,30,0,0,0):dt/(3600*24):datenum(2004,12,30,0,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    savepath = strcat(mypath,'Erebus/results/ErebusDec30_full');
    
elseif dataset_option == 5;
    
    %%%%%%% Halemaumau
    
    %%% Jan 16 velocity
    
    datapath = 'Halemaumau/data/';
    fn = strcat(mypath,datapath,'kathi_allVx_firsthalf.mat');
    load(fn)
    
    n_rows_data = 320;
    n_cols_data = 240;
    
    dt = 5; % s, sampling interval
    alldata = [allVx_firsthalf];
    alltime = [datenum(2011,1,16,17,0,0):dt/(3600*24):datenum(2011,1,16,17,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    savepath = strcat(mypath,'Halemaumau/results/HalemaumauJan16vel_full');
    
    alldata_norm = alldata;
    downsampleno = n_cols_data;
    
elseif dataset_option == 6;
    
    %%% Aug 22
    
    datapath = 'Halemaumau/data/';
    fn = strcat(mypath,datapath,'kathi_aug22nd.mat');
    load(fn);
    
    n_cols_data = 201;
    n_rows_data = 126;
    
    dt = 5; % s, sampling interval
    alldata = kathi_Aug22nd;
    alltime = [datenum(2012,8,22,0,0,0):dt/(3600*24):datenum(2012,8,22,0,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    savepath = strcat(mypath,'Halemaumau/results/HalemaumauAug22_full');
    
elseif dataset_option == 7;
    
    %%% Jan 16
    
    datapath = 'Halemaumau/data/';
    fn = strcat(mypath,datapath,'kathi_January_16th_17.mat');
    load(fn);
    fn = strcat(mypath,datapath,'kathi_January_16th_18.mat');
    load(fn);
    fn = strcat(mypath,datapath,'kathi_January_16th_19.mat');
    load(fn);
    fn = strcat(mypath,datapath,'kathi_January_16th_20.mat');
    load(fn);
    
    % note: array comes as ??x46200, where
    % n_samples = 716-719
    % n_pixels = 46200
    % image can be re-created with 200 rows and 231 columns
    
    n_rows_data = 200;
    n_cols_data = 231;
    
    dt = 5; % s, sampling interval
    alldata = [kathi_January_16th_17; kathi_January_16th_18; ...
        kathi_January_16th_19; kathi_January_16th_20];
    alltime = [datenum(2011,1,16,17,0,0):dt/(3600*24):datenum(2011,1,16,17,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    savepath = strcat(mypath,'Halemaumau/results/HalemaumauJan16_full');
    
elseif dataset_option == 8;
    
    %%% Jun 18
    
    datapath = 'Halemaumau/data/';
    fn = strcat(mypath,datapath,'HMM_18June2013_Tall.mat');
    load(fn);
    fn2 = strcat(mypath,datapath,'HMM_18June2013_times.mat');
    load(fn2);
    
    % note: array comes as 27260x17232, where
    % n_samples = 17232
    % n_pixels = 27260
    % image can be re-created with 116 rows and 235 columns
    
    n_rows_data = 116;
    n_cols_data = 235;
    
    alldata = Tall_18;
    alltime = times_18;
    
    savepath = strcat(mypath,'Halemaumau/results/HalemaumauJun18_full');
    
else
    sprintf('Please set valid dataset option')
end

%% limit to first n hours

number_of_hours = 12;

if alltime(end)-alltime(1) > number_of_hours/24
    upper_limit = find(alltime <= alltime(1)+number_of_hours/24, 1,'last');
    alltime = alltime(1:upper_limit);
    alldata = alldata(1:upper_limit,:);
end

%% normalization

alldata_norm = [];
% for ii = 1:size(alldata,1)
%     alldata_sub = (alldata(ii,:)-min(alldata(ii,:)))./sum(alldata(ii,:)-min(alldata(ii,:)));
%     alldata_norm = [alldata_norm; alldata_sub]; 
% end

alldata(isnan(alldata)) = 0;

minall = min(alldata')'*ones(1,n_rows_data*n_cols_data);
meanall = sum(alldata')'*ones(1,n_rows_data*n_cols_data);
alldata_norm = (alldata - minall)./(meanall-minall);

temp_im = vec2mat(alldata(1,:),n_rows_data);
temp_im = temp_im';
downsampleno = size(temp_im,1);
alldata_norm = alldata;

%% run pca

% if input is alldata_norm then pixels are variables

[coeff, score, latent, tsquare, explained, pca_mu] = pca(alldata_norm);
% each column of coeff contains coefficients for 1 principal component
% score: projection of data onto principal components (columns =
% components)

%% make some figures to check results

% determine number of modes necessary to explain x percent of variance
components_for_90percvar = find(cumsum(explained) >= 90,1,'first');
fprintf('%d modes needed to explain 90 percent of the variance\n',components_for_90percvar)

figure
semilogx(explained,'ko-')
xlabel('mode number')
ylabel('percentage of variance explained')
axis tight
saveas(gcf,strcat(savepath,'_variance_explained.fig'))

% plot those modes (at least 3, max 5)
plot_first_n_components_images(components_for_90percvar,explained,coeff,downsampleno)
saveas(gcf,strcat(savepath,'_components.fig'))

% plot contribution to modes in time (at least 3, max 5)
plot_contribution_to_components_in_time(components_for_90percvar,alltime,score,explained)
saveas(gcf,strcat(savepath,'_temporalevolution.fig'))

% plot data projected onto first 3 components
plot_data_in_pca_space(score,[])
saveas(gcf,strcat(savepath,'_compspace_nocolor.eps'),'eps')

%% get best k and do clustering

vector_with_cluster_numbers = 2:10;
number_of_components = 2; %% this has to be set manually every time, ...
% based on the "variance explained" figure (See some of the old examples...
% to get an idea where to cut off. Basically, I choose the number of ...
% modes up to the point where the remaining modes all explain roughly...
% an equal amount of variance)

[RMScc] = get_RMScc_values_for_clusters_images(vector_with_cluster_numbers,...
    score,coeff,pca_mu,alltime,...
    alldata_norm,downsampleno,number_of_components,savepath);

% find maximum in RMScc
[~,peakindex] = max(RMScc);

number_of_clusters = vector_with_cluster_numbers(peakindex);

[Z,my_clusters] = cluster_pca_space(score,alltime,...
    number_of_clusters,number_of_components,savepath,...
    strcat(num2str(number_of_clusters),'clusters'),'y');

[centers,reconstructed_images,pc_space_distance] = get_cluster_centers_and_reconstruct_images_distance(my_clusters,...
    number_of_clusters,score,coeff,pca_mu,number_of_components,alltime,...
    alldata_norm,downsampleno,savepath,...
    strcat(num2str(number_of_clusters),'clusters'),'y');

%% plot Euclid. distance for best cluster spectrum

no_of_points = 10;

[meandistance] = plot_cluster_distance_running_avg(number_of_clusters,...
    alltime,my_clusters,pc_space_distance,no_of_points,savepath,...
    strcat(num2str(number_of_clusters),'clusters'));


saveas(gcf,strcat(savepath,strcat(num2str(number_of_clusters),'clusters'),'best_cluster_representations.fig'),'fig')

%% save everything
save(strcat(savepath,'_pca_results.mat'),'-v7.3')

