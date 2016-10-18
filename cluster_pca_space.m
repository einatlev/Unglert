function [Z,my_clusters]=cluster_pca_space(score,time,number_of_clusters,number_of_components,savepath,savefilename,save_y_n)
%GET hierarchical clustering from PCA
%   input: PCA score, time vector, desired number of clusters, 
%   number of components to be used, string
%   for path to save figure, string for saving filename, string 'y' or 'n'
%   for saving of figures
%   output: dendrogram Z and cluster membership my_clusters

% Kathi Unglert, Oct 2015

norm_score = score(:,1:number_of_components);


%% hierarchical clustering

% get cluster structure
Z = linkage(norm_score,'ward','euclidean');

figure
dendrogram(Z);
if save_y_n == 'y'
    saveas(gcf,strcat(savepath,savefilename,'dendrogram.fig'),'fig')
end

% get clusters for given number of clusters
my_clusters = cluster(Z,'maxclust',number_of_clusters);

cm = colormap(jet(number_of_clusters));

figure
scatter3(score(:,1),score(:,2),score(:,3),20,my_clusters,'filled')
xlabel('component 1')
ylabel('component 2')
zlabel('component 3')
colorbar
if save_y_n == 'y'
    saveas(gcf,strcat(savepath,savefilename,'clusters.fig'),'fig')
end

figure,
hold on
for ii = 1:length(time)
plot(time(ii),my_clusters(ii),'o','Color',cm(my_clusters(ii),:))
end
xlabel('time')
datetick('x')
set(gca,'yticklabel',[1:number_of_clusters],'ytick',[1:number_of_clusters])
grid on
if save_y_n == 'y'
    saveas(gcf,strcat(savepath,savefilename,'clusters_temporal_evolution.fig'),'fig')
end
