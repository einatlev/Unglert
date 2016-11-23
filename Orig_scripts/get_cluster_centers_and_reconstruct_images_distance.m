function [centers,reconstructed_images,pc_space_distance] = get_cluster_centers_and_reconstruct_images_distance(my_clusters,number_of_clusters,score,coeff,pca_mu,maxpc,time_vector,original_data,downsampleno,savepath,savefilename,save_y_n)
%GET cluster centers for hierarchical clusters and reconstruct spectra
%   input: cluster membership my_clusters, score and coeff from PCA,
%    maximum number of principal components
%   to be used, time vector, original_data, downsampleno for matrix
%   string save_y_n 'y' or 'n' for saving of figures
%   output: figure with reconstructed spectra, variables centers and
%   reconstructed_spectrum, projections of observations onto reconstr.
%   spectra

% Kathi Unglert, Jan 2016, updated Sep 2016

%% get cluster centers

centers = zeros(number_of_clusters,maxpc);

for cluster = 1:number_of_clusters
    centers(cluster,:) = median(score(my_clusters == cluster,1:maxpc),1);
end

%% reconstruct images based on cluster centers

for cluster_index = 1:number_of_clusters
    summed_spectrum = zeros(size(coeff(:,1)));
    for pc_index = 1:maxpc
        temp_spectrum = coeff(:,pc_index).*centers(cluster_index,pc_index);
        summed_spectrum = summed_spectrum + temp_spectrum;
    end
    reconstructed_images(:,cluster_index) = summed_spectrum + pca_mu';
end

figure
hold on
set(gcf,'Colormap',feval('linear_kry_5_98_c75_n256'))
h = [];
for ii = 1:number_of_clusters
    h(ii)=subtightplot(number_of_clusters,1,ii,[],[],0.1);
    imagesc(vec2mat(reconstructed_images(:,ii),downsampleno))
    set(gca,'xtick',[])
    set(gca,'ytick',[])
end
if save_y_n == 'y'
    saveas(gcf,strcat(savepath,savefilename,'reconstructed_images.fig'),'fig')
end


%% get distance between observations and cluster centres

pc_space_distance = zeros(length(my_clusters),number_of_clusters);

for cluster_index = 1:number_of_clusters
    for observation = 1:length(my_clusters)
        pc_space_distance(observation,cluster_index) = sqrt(sum((score(observation,1:maxpc)-centers(cluster_index,:)).^2));
    end
end