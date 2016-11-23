function [cluster_cc,RMScc]=xcorr_cluster_images(number_of_clusters,cluster_images,savepath,savefilename,save_y_n)
%XCORR cluster images
%   input: matrix with image vectors (rows: pixels, columns: images),
%   number_of_clusters, strings for path and filename for
%   saving, string save_y_n 'y' or 'n' for figure saving
%   output: 3D array with differences between spectra,
%   figures with difference spectrum, mean difference matrix,
%   standard deviation of difference matrix, and mean difference as
%   fraction of maximum spectral power

% Kathi Unglert, Oct 2015

%% get xcorr coeff between cluster spectra

cluster_cc = zeros(number_of_clusters,number_of_clusters);

for cluster1 = 1:number_of_clusters
    for cluster2 = 1:number_of_clusters
        cc_matrix = corrcoef(cluster_images(:,cluster1),...
            cluster_images(:,cluster2));
        cluster_cc(cluster1,cluster2) = cc_matrix(1,2);
    end
end

%% plot correlation coefficients

figure
hold on
imagesc(1:number_of_clusters,1:number_of_clusters,cluster_cc)
axis tight
xlabel('cluster number')
ylabel('cluster number')
set(gca','ytick',1:number_of_clusters)
set(gca','xtick',1:number_of_clusters)
colormap(flipud(linear_blue_5_95_c73_n256))
colorbar('Location','EastOutside')

if save_y_n == 'y'
    saveas(gcf,strcat(savepath,'clusterspectra_xcorr',savefilename,'.fig'))
end

close all

%% get only unique ii,jj pairs

vector_size = sum((1:number_of_clusters)-1);
unique_cc = zeros(vector_size,1);
counter = 0;

for column_index = 2:number_of_clusters
    for row_index = 1:(column_index-1)
        counter = counter+1;
        unique_cc(counter) = cluster_cc(row_index,column_index,:);
    end
end

RMScc = rms(unique_cc-1);