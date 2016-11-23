% run PCA on lava lake images
% Kathi Unglert, Jan 2016

close all
clc
warning off

graphics = 1;

%%% set some parameters for individual datasets:

mypath = '/local/data/lava/einatlev/Lakes/';

% dataset_option numbers
% 1 Nyiragongo 10 March 2012
% 2 Erebus Dec 02
% 3 Erebus Dec 16
% 4 Erebus Dec 30
% 5 Halemaumau Jan 16 velocity
% 6 Halemaumau Aug 22
% 7 Halemaumau Jan 16
% 8 Halemaumau Jun 18
% 9 Marum Seq 47  AllRed_Seq47
% 10 Marum Seq 48
% 11 Marum Seq 56
% 12 Masaya Tall_Rec121
% 13 Masaya Tall_Rec122
% 14 Masaya Tall_Rec123


[alldata, alltime, dt, savepath, n_cols_data, n_rows_data ] = ...
    pca_loadfiles(mypath, dataset_option );
%% limit to first n hours

number_of_hours = 12;

if alltime(end)-alltime(1) > number_of_hours*60*60
    upper_limit = find(alltime <= alltime(1)+number_of_hours*60*60, 1,'last');
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

minall = double(min(alldata')')*ones(1,n_rows_data*n_cols_data);
meanall = double(sum(alldata')')*ones(1,n_rows_data*n_cols_data);
alldata_norm = (double(alldata) - minall)./(meanall-minall);

temp_im = reshape(alldata(1,:),n_rows_data, n_cols_data);
temp_im = temp_im';
downsampleno = size(temp_im,1);
%alldata_norm = alldata;

%% run pca

% if input is alldata_norm then pixels are variables

[coeff, score, latent, tsquare, explained] = pca(alldata_norm);
% each column of coeff contains coefficients for 1 principal component
% score: projection of data onto principal components (columns =
% components)
pca_mu = mean(alldata_norm);

%% make some figures to check results

% determine number of modes necessary to explain x percent of variance
components_for_90percvar = find(cumsum(explained) >= 90,1,'first');
fprintf('%d modes needed to explain 90 percent of the variance\n',components_for_90percvar)


if (graphics)
    
    figure
    semilogx(explained,'ko-')
    xlabel('mode number')
    ylabel('percentage of variance explained')
    axis tight
    saveas(gcf,strcat(savepath,'_variance_explained.fig'))
    
    %% plot those modes (at least 3, max 5)
    plot_first_n_components_images(components_for_90percvar,explained,coeff,downsampleno)
    saveas(gcf,strcat(savepath,'_components.fig'))
    
    %% plot contribution to modes in time (at least 3, max 5)
    plot_contribution_to_components_in_time(components_for_90percvar,alltime,score,explained)
    saveas(gcf,strcat(savepath,'_temporalevolution.fig'))
    
    %% plot data projected onto first 3 components
    plot_data_in_pca_space(score,[])
    saveas(gcf,strcat(savepath,'_compspace_nocolor.eps'),'eps')
end


%% get best k and do clustering

vector_with_cluster_numbers = 2:40;
number_of_components = components_for_90percvar; %% this has to be set manually every time, ...
% based on the "variance explained" figure (See some of the old examples...
% to get an idea where to cut off. Basically, I choose the number of ...
% modes up to the point where the remaining modes all explain roughly...
% an equal amount of variance)

[RMScc] = get_RMScc_values_for_clusters_images(vector_with_cluster_numbers,...
    score,coeff,pca_mu,alltime,...
    alldata_norm,downsampleno,number_of_components,savepath, graphics);

% find maximum in RMScc
[~,peakindex] = max(RMScc);

number_of_clusters = vector_with_cluster_numbers(peakindex);

[Z,my_clusters] = cluster_pca_space(score,alltime,...
    number_of_clusters,number_of_components,savepath,...
    strcat(num2str(number_of_clusters),'clusters'),'y', graphics);

[centers,reconstructed_images,pc_space_distance] = get_cluster_centers_and_reconstruct_images_distance(my_clusters,...
    number_of_clusters,score,coeff,pca_mu,number_of_components,alltime,...
    alldata_norm,downsampleno,savepath,...
    strcat(num2str(number_of_clusters),'clusters'),'y', graphics);


%% save everything
save(strcat(savepath,'_pca_results.mat'),'-v7.3')


%% plot Euclid. distance for best cluster spectrum

no_of_points = 10;

if (graphics)
    
    [meandistance] = plot_cluster_distance_running_avg(number_of_clusters,...
        alltime,my_clusters,pc_space_distance,no_of_points,savepath,...
        strcat(num2str(number_of_clusters),'clusters'));
    
    
    saveas(gcf,strcat(savepath,strcat(num2str(number_of_clusters),'clusters'),'best_cluster_representations.fig'),'fig')
end

