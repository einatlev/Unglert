function [alldata, alltimes, dt, savepath, n_cols_data, n_rows_data ] = pca_loadfiles( mypath, dataset_option )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


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
    alltimes = [datenum(2012,3,10,0,0,5):dt/(3600*24):datenum(2012,3,10,0,0,5)+(dt/(3600*24))*(size(alldata,1)-1)];
    
elseif dataset_option == 2;
    
    %%%%%%%%%% Erebus
    
    %%% Dec 02 Erebus
    
    datapath = 'Erebus/UnglertData/';
    
    n_rows_data = 101;
    n_cols_data = 121;
    fn = strcat(mypath,datapath,'Dec_2nd_Kathi.mat');
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
    
    alltimes = [datenum(2004,12,2,0,0,0):dt/(3600*24):datenum(2004,12,2,0,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    % remove times with bad values
    [badrows] = find(mean(alldata,2) <= 1e-7);
    original_length = length(alltimes);
    
    index = true(size(alltimes));
    index(unique(badrows)) = false;
    
    alldata = alldata(index,:);
    alltimes = alltimes(index);
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
    
    alltimes = datenum(2004,12,16,0,0,0)+timesec(1:length(timesec))./(3600*24);
    alltimes = alltimes([1:4740 4742:end]);
    
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
    
    alltimes = [datenum(2004,12,30,0,0,0):dt/(3600*24):datenum(2004,12,30,0,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
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
    alltimes = [datenum(2011,1,16,17,0,0):dt/(3600*24):datenum(2011,1,16,17,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
    savepath = strcat(mypath,'Halemaumau/results/HalemaumauJan16vel_full');
    
    alldata_norm = alldata;
    downsampleno = n_cols_data;
    
elseif dataset_option == 6;
    
    %%% Aug 22
    
    datapath = 'Halemaumau/UnglertData/';
    fn = strcat(mypath,datapath,'kathi_aug22nd.mat');
    load(fn);
    
    n_cols_data = 201;
    n_rows_data = 126;
    
    dt = 5; % s, sampling interval
    alldata = kathi_Aug22nd;
    alltimes = [datenum(2012,8,22,0,0,0):dt/(3600*24):datenum(2012,8,22,0,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
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
    alltimes = [datenum(2011,1,16,17,0,0):dt/(3600*24):datenum(2011,1,16,17,0,0)+(dt/(3600*24))*(size(alldata,1)-1)];
    
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
    alltimes = times_18;
    
    savepath = strcat(mypath,'Halemaumau/results/HalemaumauJun18_full');
    
elseif dataset_option == 9
    datapath = 'Marum/UnglertData/';
    fn = strcat(mypath, datapath, 'AllRed_Seq47.mat');
    load (fn);
    fn2 = strcat(mypath, datapath, 'AllTimes_Seq47.mat');
    load (fn2)
    savepath = strcat(mypath,'Marum/UnglerResults/Seq47/');
    dt=0.1;
    n_rows_data = 447;
    n_cols_data = 630;
    alldata = AllRed_Seq47;
    alltimes = t;
    
elseif dataset_option == 10
    datapath = 'Marum/UnglertData/';
    fn = strcat(mypath, datapath, 'AllRed_Seq48.mat');
    load (fn);
    fn2 = strcat(mypath, datapath, 'AllTimes_Seq48.mat');
    load (fn2)
    savepath = strcat(mypath,'Marum/UnglerResults/Seq48/');
    dt=0.1;
    n_rows_data = 341;
    n_cols_data = 501;
    alldata = AllRed_Seq48;
    alltimes = t;  
elseif dataset_option == 11
    datapath = 'Marum/UnglertData/';
    fn = strcat(mypath, datapath, 'AllRed_Seq56.mat');
    load (fn);
    fn2 = strcat(mypath, datapath, 'AllTimes_Seq56.mat');
    load (fn2)
    savepath = strcat(mypath,'Marum/UnglerResults/Seq56/');
    dt=0.1;
    n_rows_data = 900;
    n_cols_data = 1401;
    alldata = AllRed_Seq56;
    alltimes = t;

    
elseif dataset_option == 12
    datapath = '/Masaya/UnglertData/';
    fn = strcat(mypath, datapath, 'Tall_Rec121.mat');
    load (fn);
    fn2 = strcat(mypath, datapath, 'times_Rec121.mat');
    load (fn2)
    savepath = strcat(mypath,'Masaya/UnglerResults/Rec121/');
    dt=0.1;
    n_rows_data = 66;
    n_cols_data = 91;
    alldata = Tall;
    alltimes = times_Rec121;
    
elseif dataset_option == 13
    datapath = '/Masaya/UnglertData/';
    fn = strcat(mypath, datapath, 'Tall_Rec122.mat');
    load (fn);
    fn2 = strcat(mypath, datapath, 'times_Rec122.mat');
    load (fn2)
    savepath = strcat(mypath,'Masaya/UnglerResults/Rec122/');
    dt=0.1;
    n_rows_data = 87;
    n_cols_data = 99;
    alldata = Tall';
    alltimes = times_Rec122;
    
elseif dataset_option == 14
    datapath = '/Masaya/UnglertData/';
    fn = strcat(mypath, datapath, 'Tall_Rec123.mat');
    load (fn);
    fn2 = strcat(mypath, datapath, 'times_Rec123.mat');
    load (fn2)
    savepath = strcat(mypath,'Masaya/UnglerResults/Rec123/');
    dt=0.1;
    n_rows_data = 61;
    n_cols_data = 81;
    alldata = Tall;
    alltimes = times_Rec123;
else
    sprintf('Please set valid dataset option')
end

fn


end

