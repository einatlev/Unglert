function [all_RMScc]=get_RMScc_values_for_clusters_images(vector_with_cluster_numbers,score,coeff,pca_mu,time,original_data,downsampleno,number_of_components,savepath)
%GET RMS cross-correlation values for varying numbers of clusters
%   input: vector with numbers of clusters to be tested (e.g., 3:8),
%   core (e.g., score from PCA), time vector associated with
%   inputdata, coeff & pca_mu from PCA, station_name, half_window_length tt,
%   downsampleno, number of components to be used, savepath
%   output: figures with median RMS diff

% Kathi Unglert, Jan 2016

%% clustering

all_RMScc = zeros(length(vector_with_cluster_numbers),1);

for number_of_clusters = vector_with_cluster_numbers;
    [~,my_clusters] = cluster_pca_space(score,time,...
        number_of_clusters,number_of_components,savepath,...
        strcat(num2str(number_of_clusters),'clusters'),'n');
    
    [~,reconstructed_images,~] = get_cluster_centers_and_reconstruct_images_distance(my_clusters,...
        number_of_clusters,score,coeff,pca_mu,number_of_components,time,...
        original_data,downsampleno,savepath,...
        strcat(num2str(number_of_clusters),'clusters'),'n');
    
    % difference between cluster spectra
    
    [~,RMScc] = xcorr_cluster_images(number_of_clusters,...
        reconstructed_images,savepath,strcat(num2str(number_of_clusters),'clusters'),'n');
    
    all_RMScc(number_of_clusters-min(vector_with_cluster_numbers)+1) = RMScc;
    close all
end

figure
plot(vector_with_cluster_numbers,all_RMScc,'ko-')
xlabel('cluster number k')
ylabel('C_{RMS}')
saveas(gcf,strcat(savepath,'clusterimages_RMSEcc.fig'))


